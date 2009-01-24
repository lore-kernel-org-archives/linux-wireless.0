Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:35806 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752988AbZAXOFf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Jan 2009 09:05:35 -0500
Subject: [PATCH 1/7 v2] airo: clean up and clarify interrupt-time task
	handling
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1232748914.447.2.camel@localhost.localdomain>
References: <1232748914.447.2.camel@localhost.localdomain>
Content-Type: text/plain
Date: Sat, 24 Jan 2009 09:04:12 -0500
Message-Id: <1232805852.2870.0.camel@localhost.localdomain> (sfid-20090124_150545_922572_0E96A64B)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Split each specific interrupt-time task out into its own function to
make airo_interrupt() actually readable.

Signed-off-by: Dan Williams <dcbw@redhat.com>

diff --git a/drivers/net/wireless/airo.c b/drivers/net/wireless/airo.c
index 2ff588b..a192c44 100644
--- a/drivers/net/wireless/airo.c
+++ b/drivers/net/wireless/airo.c
@@ -981,6 +981,14 @@ typedef struct {
 	dma_addr_t host_addr;
 } TxFid;
 
+struct rx_hdr {
+	__le16 status, len;
+	u8 rssi[2];
+	u8 rate;
+	u8 freq;
+	__le16 tmp[4];
+} __attribute__ ((packed));
+
 typedef struct {
 	unsigned int  ctl: 15;
 	unsigned int  rdy: 1;
@@ -3123,314 +3131,354 @@ static int header_len(__le16 ctl)
 	return 24;
 }
 
-static irqreturn_t airo_interrupt(int irq, void *dev_id)
+static void airo_handle_cisco_mic(struct airo_info *ai)
 {
-	struct net_device *dev = dev_id;
+	if (test_bit(FLAG_MIC_CAPABLE, &ai->flags)) {
+		set_bit(JOB_MIC, &ai->jobs);
+		wake_up_interruptible(&ai->thr_wait);
+	}
+}
+
+/* Airo Status codes */
+#define STAT_NOBEACON	0x8000 /* Loss of sync - missed beacons */
+#define STAT_MAXRETRIES	0x8001 /* Loss of sync - max retries */
+#define STAT_MAXARL	0x8002 /* Loss of sync - average retry level exceeded*/
+#define STAT_FORCELOSS	0x8003 /* Loss of sync - host request */
+#define STAT_TSFSYNC	0x8004 /* Loss of sync - TSF synchronization */
+#define STAT_DEAUTH	0x8100 /* low byte is 802.11 reason code */
+#define STAT_DISASSOC	0x8200 /* low byte is 802.11 reason code */
+#define STAT_ASSOC_FAIL	0x8400 /* low byte is 802.11 reason code */
+#define STAT_AUTH_FAIL	0x0300 /* low byte is 802.11 reason code */
+#define STAT_ASSOC	0x0400 /* Associated */
+#define STAT_REASSOC    0x0600 /* Reassociated?  Only on firmware >= 5.30.17 */
+
+static void airo_print_status(const char *devname, u16 status)
+{
+	u8 reason = status & 0xFF;
+
+	switch (status) {
+	case STAT_NOBEACON:
+		airo_print_dbg(devname, "link lost (missed beacons)");
+		break;
+	case STAT_MAXRETRIES:
+	case STAT_MAXARL:
+		airo_print_dbg(devname, "link lost (max retries)");
+		break;
+	case STAT_FORCELOSS:
+		airo_print_dbg(devname, "link lost (local choice)");
+		break;
+	case STAT_TSFSYNC:
+		airo_print_dbg(devname, "link lost (TSF sync lost)");
+		break;
+	case STAT_DEAUTH:
+		airo_print_dbg(devname, "deauthenticated (reason: %d)", reason);
+		break;
+	case STAT_DISASSOC:
+		airo_print_dbg(devname, "disassociated (reason: %d)", reason);
+		break;
+	case STAT_ASSOC_FAIL:
+		airo_print_dbg(devname, "association failed (reason: %d)",
+			       reason);
+		break;
+	case STAT_AUTH_FAIL:
+		airo_print_dbg(devname, "authentication failed (reason: %d)",
+			       reason);
+		break;
+	default:
+		break;
+	}
+}
+
+static void airo_handle_link(struct airo_info *ai)
+{
+	union iwreq_data wrqu;
+	int scan_forceloss = 0;
 	u16 status;
-	u16 fid;
-	struct airo_info *apriv = dev->ml_priv;
-	u16 savedInterrupts = 0;
-	int handled = 0;
 
-	if (!netif_device_present(dev))
-		return IRQ_NONE;
+	/* Get new status and acknowledge the link change */
+	status = le16_to_cpu(IN4500(ai, LINKSTAT));
+	OUT4500(ai, EVACK, EV_LINK);
 
-	for (;;) {
-		status = IN4500( apriv, EVSTAT );
-		if ( !(status & STATUS_INTS) || status == 0xffff ) break;
+	if ((status == STAT_FORCELOSS) && (ai->scan_timeout > 0))
+		scan_forceloss = 1;
 
-		handled = 1;
+	airo_print_status(ai->dev->name, status);
 
-		if ( status & EV_AWAKE ) {
-			OUT4500( apriv, EVACK, EV_AWAKE );
-			OUT4500( apriv, EVACK, EV_AWAKE );
-		}
+	if ((status == STAT_ASSOC) || (status == STAT_REASSOC)) {
+		if (auto_wep)
+			ai->expires = 0;
+		if (ai->list_bss_task)
+			wake_up_process(ai->list_bss_task);
+		set_bit(FLAG_UPDATE_UNI, &ai->flags);
+		set_bit(FLAG_UPDATE_MULTI, &ai->flags);
 
-		if (!savedInterrupts) {
-			savedInterrupts = IN4500( apriv, EVINTEN );
-			OUT4500( apriv, EVINTEN, 0 );
+		if (down_trylock(&ai->sem) != 0) {
+			set_bit(JOB_EVENT, &ai->jobs);
+			wake_up_interruptible(&ai->thr_wait);
+		} else
+			airo_send_event(ai->dev);
+	} else if (!scan_forceloss) {
+		if (auto_wep && !ai->expires) {
+			ai->expires = RUN_AT(3*HZ);
+			wake_up_interruptible(&ai->thr_wait);
 		}
 
-		if ( status & EV_MIC ) {
-			OUT4500( apriv, EVACK, EV_MIC );
-			if (test_bit(FLAG_MIC_CAPABLE, &apriv->flags)) {
-				set_bit(JOB_MIC, &apriv->jobs);
-				wake_up_interruptible(&apriv->thr_wait);
-			}
-		}
-		if ( status & EV_LINK ) {
-			union iwreq_data	wrqu;
-			int scan_forceloss = 0;
-			/* The link status has changed, if you want to put a
-			   monitor hook in, do it here.  (Remember that
-			   interrupts are still disabled!)
-			*/
-			u16 newStatus = IN4500(apriv, LINKSTAT);
-			OUT4500( apriv, EVACK, EV_LINK);
-			/* Here is what newStatus means: */
-#define NOBEACON 0x8000 /* Loss of sync - missed beacons */
-#define MAXRETRIES 0x8001 /* Loss of sync - max retries */
-#define MAXARL 0x8002 /* Loss of sync - average retry level exceeded*/
-#define FORCELOSS 0x8003 /* Loss of sync - host request */
-#define TSFSYNC 0x8004 /* Loss of sync - TSF synchronization */
-#define DEAUTH 0x8100 /* Deauthentication (low byte is reason code) */
-#define DISASS 0x8200 /* Disassociation (low byte is reason code) */
-#define ASSFAIL 0x8400 /* Association failure (low byte is reason
-			  code) */
-#define AUTHFAIL 0x0300 /* Authentication failure (low byte is reason
-			   code) */
-#define ASSOCIATED 0x0400 /* Associated */
-#define REASSOCIATED 0x0600 /* Reassociated?  Only on firmware >= 5.30.17 */
-#define RC_RESERVED 0 /* Reserved return code */
-#define RC_NOREASON 1 /* Unspecified reason */
-#define RC_AUTHINV 2 /* Previous authentication invalid */
-#define RC_DEAUTH 3 /* Deauthenticated because sending station is
-		       leaving */
-#define RC_NOACT 4 /* Disassociated due to inactivity */
-#define RC_MAXLOAD 5 /* Disassociated because AP is unable to handle
-			all currently associated stations */
-#define RC_BADCLASS2 6 /* Class 2 frame received from
-			  non-Authenticated station */
-#define RC_BADCLASS3 7 /* Class 3 frame received from
-			  non-Associated station */
-#define RC_STATLEAVE 8 /* Disassociated because sending station is
-			  leaving BSS */
-#define RC_NOAUTH 9 /* Station requesting (Re)Association is not
-		       Authenticated with the responding station */
-			if (newStatus == FORCELOSS && apriv->scan_timeout > 0)
-				scan_forceloss = 1;
-			if(newStatus == ASSOCIATED || newStatus == REASSOCIATED) {
-				if (auto_wep)
-					apriv->expires = 0;
-				if (apriv->list_bss_task)
-					wake_up_process(apriv->list_bss_task);
-				set_bit(FLAG_UPDATE_UNI, &apriv->flags);
-				set_bit(FLAG_UPDATE_MULTI, &apriv->flags);
-
-				if (down_trylock(&apriv->sem) != 0) {
-					set_bit(JOB_EVENT, &apriv->jobs);
-					wake_up_interruptible(&apriv->thr_wait);
-				} else
-					airo_send_event(dev);
-			} else if (!scan_forceloss) {
-				if (auto_wep && !apriv->expires) {
-					apriv->expires = RUN_AT(3*HZ);
-					wake_up_interruptible(&apriv->thr_wait);
-				}
+		/* Send event to user space */
+		memset(wrqu.ap_addr.sa_data, '\0', ETH_ALEN);
+		wrqu.ap_addr.sa_family = ARPHRD_ETHER;
+		wireless_send_event(ai->dev, SIOCGIWAP, &wrqu, NULL);
+	}
+}
 
-				/* Send event to user space */
-				memset(wrqu.ap_addr.sa_data, '\0', ETH_ALEN);
-				wrqu.ap_addr.sa_family = ARPHRD_ETHER;
-				wireless_send_event(dev, SIOCGIWAP, &wrqu,NULL);
-			}
-		}
+static void airo_handle_rx(struct airo_info *ai)
+{
+	struct sk_buff *skb = NULL;
+	__le16 fc, v, *buffer, tmpbuf[4];
+	u16 len, hdrlen = 0, gap, fid;
+	struct rx_hdr hdr;
+	int success = 0;
 
-		/* Check to see if there is something to receive */
-		if ( status & EV_RX  ) {
-			struct sk_buff *skb = NULL;
-			__le16 fc, v;
-			u16 len, hdrlen = 0;
-#pragma pack(1)
-			struct {
-				__le16 status, len;
-				u8 rssi[2];
-				u8 rate;
-				u8 freq;
-				__le16 tmp[4];
-			} hdr;
-#pragma pack()
-			u16 gap;
-			__le16 tmpbuf[4];
-			__le16 *buffer;
-
-			if (test_bit(FLAG_MPI,&apriv->flags)) {
-				if (test_bit(FLAG_802_11, &apriv->flags))
-					mpi_receive_802_11(apriv);
-				else
-					mpi_receive_802_3(apriv);
-				OUT4500(apriv, EVACK, EV_RX);
-				goto exitrx;
-			}
+	if (test_bit(FLAG_MPI, &ai->flags)) {
+		if (test_bit(FLAG_802_11, &ai->flags))
+			mpi_receive_802_11(ai);
+		else
+			mpi_receive_802_3(ai);
+		OUT4500(ai, EVACK, EV_RX);
+		return;
+	}
 
-			fid = IN4500( apriv, RXFID );
-
-			/* Get the packet length */
-			if (test_bit(FLAG_802_11, &apriv->flags)) {
-				bap_setup (apriv, fid, 4, BAP0);
-				bap_read (apriv, (__le16*)&hdr, sizeof(hdr), BAP0);
-				/* Bad CRC. Ignore packet */
-				if (le16_to_cpu(hdr.status) & 2)
-					hdr.len = 0;
-				if (apriv->wifidev == NULL)
-					hdr.len = 0;
-			} else {
-				bap_setup (apriv, fid, 0x36, BAP0);
-				bap_read (apriv, &hdr.len, 2, BAP0);
-			}
-			len = le16_to_cpu(hdr.len);
+	fid = IN4500(ai, RXFID);
 
-			if (len > AIRO_DEF_MTU) {
-				airo_print_err(apriv->dev->name, "Bad size %d", len);
-				goto badrx;
-			}
-			if (len == 0)
-				goto badrx;
+	/* Get the packet length */
+	if (test_bit(FLAG_802_11, &ai->flags)) {
+		bap_setup (ai, fid, 4, BAP0);
+		bap_read (ai, (__le16*)&hdr, sizeof(hdr), BAP0);
+		/* Bad CRC. Ignore packet */
+		if (le16_to_cpu(hdr.status) & 2)
+			hdr.len = 0;
+		if (ai->wifidev == NULL)
+			hdr.len = 0;
+	} else {
+		bap_setup(ai, fid, 0x36, BAP0);
+		bap_read(ai, &hdr.len, 2, BAP0);
+	}
+	len = le16_to_cpu(hdr.len);
 
-			if (test_bit(FLAG_802_11, &apriv->flags)) {
-				bap_read (apriv, &fc, sizeof(fc), BAP0);
-				hdrlen = header_len(fc);
-			} else
-				hdrlen = ETH_ALEN * 2;
+	if (len > AIRO_DEF_MTU) {
+		airo_print_err(ai->dev->name, "Bad size %d", len);
+		goto done;
+	}
+	if (len == 0)
+		goto done;
 
-			skb = dev_alloc_skb( len + hdrlen + 2 + 2 );
-			if ( !skb ) {
-				dev->stats.rx_dropped++;
-				goto badrx;
-			}
-			skb_reserve(skb, 2); /* This way the IP header is aligned */
-			buffer = (__le16*)skb_put (skb, len + hdrlen);
-			if (test_bit(FLAG_802_11, &apriv->flags)) {
-				buffer[0] = fc;
-				bap_read (apriv, buffer + 1, hdrlen - 2, BAP0);
-				if (hdrlen == 24)
-					bap_read (apriv, tmpbuf, 6, BAP0);
-
-				bap_read (apriv, &v, sizeof(v), BAP0);
-				gap = le16_to_cpu(v);
-				if (gap) {
-					if (gap <= 8) {
-						bap_read (apriv, tmpbuf, gap, BAP0);
-					} else {
-						airo_print_err(apriv->dev->name, "gaplen too "
-							"big. Problems will follow...");
-					}
-				}
-				bap_read (apriv, buffer + hdrlen/2, len, BAP0);
+	if (test_bit(FLAG_802_11, &ai->flags)) {
+		bap_read(ai, &fc, sizeof (fc), BAP0);
+		hdrlen = header_len(fc);
+	} else
+		hdrlen = ETH_ALEN * 2;
+
+	skb = dev_alloc_skb(len + hdrlen + 2 + 2);
+	if (!skb) {
+		ai->dev->stats.rx_dropped++;
+		goto done;
+	}
+
+	skb_reserve(skb, 2); /* This way the IP header is aligned */
+	buffer = (__le16 *) skb_put(skb, len + hdrlen);
+	if (test_bit(FLAG_802_11, &ai->flags)) {
+		buffer[0] = fc;
+		bap_read(ai, buffer + 1, hdrlen - 2, BAP0);
+		if (hdrlen == 24)
+			bap_read(ai, tmpbuf, 6, BAP0);
+
+		bap_read(ai, &v, sizeof(v), BAP0);
+		gap = le16_to_cpu(v);
+		if (gap) {
+			if (gap <= 8) {
+				bap_read(ai, tmpbuf, gap, BAP0);
 			} else {
-				MICBuffer micbuf;
-				bap_read (apriv, buffer, ETH_ALEN*2, BAP0);
-				if (apriv->micstats.enabled) {
-					bap_read (apriv,(__le16*)&micbuf,sizeof(micbuf),BAP0);
-					if (ntohs(micbuf.typelen) > 0x05DC)
-						bap_setup (apriv, fid, 0x44, BAP0);
-					else {
-						if (len <= sizeof(micbuf))
-							goto badmic;
-
-						len -= sizeof(micbuf);
-						skb_trim (skb, len + hdrlen);
-					}
-				}
-				bap_read(apriv,buffer+ETH_ALEN,len,BAP0);
-				if (decapsulate(apriv,&micbuf,(etherHead*)buffer,len)) {
-badmic:
-					dev_kfree_skb_irq (skb);
-badrx:
-					OUT4500( apriv, EVACK, EV_RX);
-					goto exitrx;
+				airo_print_err(ai->dev->name, "gaplen too "
+					"big. Problems will follow...");
+			}
+		}
+		bap_read(ai, buffer + hdrlen/2, len, BAP0);
+	} else {
+		MICBuffer micbuf;
+
+		bap_read(ai, buffer, ETH_ALEN * 2, BAP0);
+		if (ai->micstats.enabled) {
+			bap_read(ai, (__le16 *) &micbuf, sizeof (micbuf), BAP0);
+			if (ntohs(micbuf.typelen) > 0x05DC)
+				bap_setup(ai, fid, 0x44, BAP0);
+			else {
+				if (len <= sizeof (micbuf)) {
+					dev_kfree_skb_irq(skb);
+					goto done;
 				}
+
+				len -= sizeof(micbuf);
+				skb_trim(skb, len + hdrlen);
 			}
+		}
+
+		bap_read(ai, buffer + ETH_ALEN, len, BAP0);
+		if (decapsulate(ai, &micbuf, (etherHead*) buffer, len))
+			dev_kfree_skb_irq (skb);
+		else
+			success = 1;
+	}
+
 #ifdef WIRELESS_SPY
-			if (apriv->spy_data.spy_number > 0) {
-				char *sa;
-				struct iw_quality wstats;
-				/* Prepare spy data : addr + qual */
-				if (!test_bit(FLAG_802_11, &apriv->flags)) {
-					sa = (char*)buffer + 6;
-					bap_setup (apriv, fid, 8, BAP0);
-					bap_read (apriv, (__le16*)hdr.rssi, 2, BAP0);
-				} else
-					sa = (char*)buffer + 10;
-				wstats.qual = hdr.rssi[0];
-				if (apriv->rssi)
-					wstats.level = 0x100 - apriv->rssi[hdr.rssi[1]].rssidBm;
-				else
-					wstats.level = (hdr.rssi[1] + 321) / 2;
-				wstats.noise = apriv->wstats.qual.noise;
-				wstats.updated = IW_QUAL_LEVEL_UPDATED
-					| IW_QUAL_QUAL_UPDATED
-					| IW_QUAL_DBM;
-				/* Update spy records */
-				wireless_spy_update(dev, sa, &wstats);
-			}
+	if (success && (ai->spy_data.spy_number > 0)) {
+		char *sa;
+		struct iw_quality wstats;
+
+		/* Prepare spy data : addr + qual */
+		if (!test_bit(FLAG_802_11, &ai->flags)) {
+			sa = (char *) buffer + 6;
+			bap_setup(ai, fid, 8, BAP0);
+			bap_read(ai, (__le16 *) hdr.rssi, 2, BAP0);
+		} else
+			sa = (char *) buffer + 10;
+		wstats.qual = hdr.rssi[0];
+		if (ai->rssi)
+			wstats.level = 0x100 - ai->rssi[hdr.rssi[1]].rssidBm;
+		else
+			wstats.level = (hdr.rssi[1] + 321) / 2;
+		wstats.noise = ai->wstats.qual.noise;
+		wstats.updated =  IW_QUAL_LEVEL_UPDATED
+				| IW_QUAL_QUAL_UPDATED
+				| IW_QUAL_DBM;
+		/* Update spy records */
+		wireless_spy_update(ai->dev, sa, &wstats);
+	}
 #endif /* WIRELESS_SPY */
-			OUT4500( apriv, EVACK, EV_RX);
 
-			if (test_bit(FLAG_802_11, &apriv->flags)) {
-				skb_reset_mac_header(skb);
-				skb->pkt_type = PACKET_OTHERHOST;
-				skb->dev = apriv->wifidev;
-				skb->protocol = htons(ETH_P_802_2);
-			} else
-				skb->protocol = eth_type_trans(skb,dev);
-			skb->ip_summed = CHECKSUM_NONE;
+done:
+	OUT4500(ai, EVACK, EV_RX);
+
+	if (success) {
+		if (test_bit(FLAG_802_11, &ai->flags)) {
+			skb_reset_mac_header(skb);
+			skb->pkt_type = PACKET_OTHERHOST;
+			skb->dev = ai->wifidev;
+			skb->protocol = htons(ETH_P_802_2);
+		} else
+			skb->protocol = eth_type_trans(skb, ai->dev);
+		skb->ip_summed = CHECKSUM_NONE;
+
+		netif_rx(skb);
+	}
+}
+
+static void airo_handle_tx(struct airo_info *ai, u16 status)
+{
+	int i, len = 0, index = -1;
+	u16 fid;
 
-			netif_rx( skb );
+	if (test_bit(FLAG_MPI, &ai->flags)) {
+		unsigned long flags;
+
+		if (status & EV_TXEXC)
+			get_tx_error(ai, -1);
+
+		spin_lock_irqsave(&ai->aux_lock, flags);
+		if (!skb_queue_empty(&ai->txq)) {
+			spin_unlock_irqrestore(&ai->aux_lock,flags);
+			mpi_send_packet(ai->dev);
+		} else {
+			clear_bit(FLAG_PENDING_XMIT, &ai->flags);
+			spin_unlock_irqrestore(&ai->aux_lock,flags);
+			netif_wake_queue(ai->dev);
 		}
-exitrx:
+		OUT4500(ai, EVACK, status & (EV_TX | EV_TXCPY | EV_TXEXC));
+		return;
+	}
 
-		/* Check to see if a packet has been transmitted */
-		if (  status & ( EV_TX|EV_TXCPY|EV_TXEXC ) ) {
-			int i;
-			int len = 0;
-			int index = -1;
-
-			if (test_bit(FLAG_MPI,&apriv->flags)) {
-				unsigned long flags;
-
-				if (status & EV_TXEXC)
-					get_tx_error(apriv, -1);
-				spin_lock_irqsave(&apriv->aux_lock, flags);
-				if (!skb_queue_empty(&apriv->txq)) {
-					spin_unlock_irqrestore(&apriv->aux_lock,flags);
-					mpi_send_packet (dev);
-				} else {
-					clear_bit(FLAG_PENDING_XMIT, &apriv->flags);
-					spin_unlock_irqrestore(&apriv->aux_lock,flags);
-					netif_wake_queue (dev);
-				}
-				OUT4500( apriv, EVACK,
-					status & (EV_TX|EV_TXCPY|EV_TXEXC));
-				goto exittx;
-			}
+	fid = IN4500(ai, TXCOMPLFID);
+
+	for(i = 0; i < MAX_FIDS; i++) {
+		if ((ai->fids[i] & 0xffff) == fid) {
+			len = ai->fids[i] >> 16;
+			index = i;
+		}
+	}
 
-			fid = IN4500(apriv, TXCOMPLFID);
+	if (index != -1) {
+		if (status & EV_TXEXC)
+			get_tx_error(ai, index);
 
-			for( i = 0; i < MAX_FIDS; i++ ) {
-				if ( ( apriv->fids[i] & 0xffff ) == fid ) {
-					len = apriv->fids[i] >> 16;
-					index = i;
-				}
-			}
-			if (index != -1) {
-				if (status & EV_TXEXC)
-					get_tx_error(apriv, index);
-				OUT4500( apriv, EVACK, status & (EV_TX | EV_TXEXC));
-				/* Set up to be used again */
-				apriv->fids[index] &= 0xffff;
-				if (index < MAX_FIDS / 2) {
-					if (!test_bit(FLAG_PENDING_XMIT, &apriv->flags))
-						netif_wake_queue(dev);
-				} else {
-					if (!test_bit(FLAG_PENDING_XMIT11, &apriv->flags))
-						netif_wake_queue(apriv->wifidev);
-				}
-			} else {
-				OUT4500( apriv, EVACK, status & (EV_TX | EV_TXCPY | EV_TXEXC));
-				airo_print_err(apriv->dev->name, "Unallocated FID was "
-					"used to xmit" );
-			}
+		OUT4500(ai, EVACK, status & (EV_TX | EV_TXEXC));
+
+		/* Set up to be used again */
+		ai->fids[index] &= 0xffff;
+		if (index < MAX_FIDS / 2) {
+			if (!test_bit(FLAG_PENDING_XMIT, &ai->flags))
+				netif_wake_queue(ai->dev);
+		} else {
+			if (!test_bit(FLAG_PENDING_XMIT11, &ai->flags))
+				netif_wake_queue(ai->wifidev);
 		}
-exittx:
-		if ( status & ~STATUS_INTS & ~IGNORE_INTS )
-			airo_print_warn(apriv->dev->name, "Got weird status %x",
+	} else {
+		OUT4500(ai, EVACK, status & (EV_TX | EV_TXCPY | EV_TXEXC));
+		airo_print_err(ai->dev->name, "Unallocated FID was used to xmit");
+	}
+}
+
+static irqreturn_t airo_interrupt(int irq, void *dev_id)
+{
+	struct net_device *dev = dev_id;
+	u16 status, savedInterrupts = 0;
+	struct airo_info *ai = dev->ml_priv;
+	int handled = 0;
+
+	if (!netif_device_present(dev))
+		return IRQ_NONE;
+
+	for (;;) {
+		status = IN4500(ai, EVSTAT);
+		if (!(status & STATUS_INTS) || (status == 0xffff))
+			break;
+
+		handled = 1;
+
+		if (status & EV_AWAKE) {
+			OUT4500(ai, EVACK, EV_AWAKE);
+			OUT4500(ai, EVACK, EV_AWAKE);
+		}
+
+		if (!savedInterrupts) {
+			savedInterrupts = IN4500(ai, EVINTEN);
+			OUT4500(ai, EVINTEN, 0);
+		}
+
+		if (status & EV_MIC) {
+			OUT4500(ai, EVACK, EV_MIC);
+			airo_handle_cisco_mic(ai);
+		}
+
+		if (status & EV_LINK) {
+			/* Link status changed */
+			airo_handle_link(ai);
+		}
+
+		/* Check to see if there is something to receive */
+		if (status & EV_RX)
+			airo_handle_rx(ai);
+
+		/* Check to see if a packet has been transmitted */
+		if (status & (EV_TX | EV_TXCPY | EV_TXEXC))
+			airo_handle_tx(ai, status);
+
+		if ( status & ~STATUS_INTS & ~IGNORE_INTS ) {
+			airo_print_warn(ai->dev->name, "Got weird status %x",
 				status & ~STATUS_INTS & ~IGNORE_INTS );
+		}
 	}
 
 	if (savedInterrupts)
-		OUT4500( apriv, EVINTEN, savedInterrupts );
+		OUT4500(ai, EVINTEN, savedInterrupts);
 
-	/* done.. */
 	return IRQ_RETVAL(handled);
 }
 
@@ -3609,18 +3657,10 @@ static void mpi_receive_802_11(struct airo_info *ai)
 	struct sk_buff *skb = NULL;
 	u16 len, hdrlen = 0;
 	__le16 fc;
-#pragma pack(1)
-	struct {
-		__le16 status, len;
-		u8 rssi[2];
-		u8 rate;
-		u8 freq;
-		__le16 tmp[4];
-	} hdr;
-#pragma pack()
+	struct rx_hdr hdr;
 	u16 gap;
 	u16 *buffer;
-	char *ptr = ai->rxfids[0].virtual_host_addr+4;
+	char *ptr = ai->rxfids[0].virtual_host_addr + 4;
 
 	memcpy_fromio(&rxd, ai->rxfids[0].card_ram_off, sizeof(rxd));
 	memcpy ((char *)&hdr, ptr, sizeof(hdr));
@@ -3687,6 +3727,7 @@ static void mpi_receive_802_11(struct airo_info *ai)
 	skb->protocol = htons(ETH_P_802_2);
 	skb->ip_summed = CHECKSUM_NONE;
 	netif_rx( skb );
+
 badrx:
 	if (rxd.valid == 0) {
 		rxd.valid = 1;


