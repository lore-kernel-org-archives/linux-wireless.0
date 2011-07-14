Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4341 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932399Ab1GNV35 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jul 2011 17:29:57 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 27/35] staging: brcm80211: fix for 'remove unnecessary
 braces' checkpatch warning
Date: Thu, 14 Jul 2011 14:29:23 -0700
Message-ID: <1310678971-28952-28-git-send-email-frankyl@broadcom.com> (sfid-20110714_233309_183424_4870FC27)
In-Reply-To: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
References: <1310678971-28952-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Henry Ptasinski <henryp@broadcom.com>

Removed unnecessary braces in single-statement blocks. Used the tools
'uncrustify' and 'coccinelle' to accomplish this.

Signed-off-by: Henry Ptasinski <henryp@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c  |   20 +-
 drivers/staging/brcm80211/brcmfmac/dhd_common.c    |   45 +-
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |   13 +-
 drivers/staging/brcm80211/brcmfmac/dhd_sdio.c      |   64 +-
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c   |   26 +-
 drivers/staging/brcm80211/brcmsmac/aiutils.c       |   30 +-
 drivers/staging/brcm80211/brcmsmac/alloc.c         |    9 +-
 drivers/staging/brcm80211/brcmsmac/ampdu.c         |   29 +-
 drivers/staging/brcm80211/brcmsmac/antsel.c        |    9 +-
 drivers/staging/brcm80211/brcmsmac/channel.c       |  121 +--
 drivers/staging/brcm80211/brcmsmac/dma.c           |   27 +-
 drivers/staging/brcm80211/brcmsmac/mac80211_if.c   |   51 +-
 drivers/staging/brcm80211/brcmsmac/main.c          |  351 +++---
 drivers/staging/brcm80211/brcmsmac/nicpci.c        |    2 +
 drivers/staging/brcm80211/brcmsmac/otp.c           |   14 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c   |  187 +--
 drivers/staging/brcm80211/brcmsmac/phy/phy_int.h   |    2 +-
 drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c   |  145 +--
 drivers/staging/brcm80211/brcmsmac/phy/phy_n.c     | 1326 +++++++------------
 drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.c |   36 +-
 drivers/staging/brcm80211/brcmsmac/rate.c          |    5 +-
 drivers/staging/brcm80211/brcmsmac/srom.c          |   17 +-
 drivers/staging/brcm80211/brcmsmac/stf.c           |   35 +-
 drivers/staging/brcm80211/brcmutil/utils.c         |   17 +-
 drivers/staging/brcm80211/brcmutil/wifi.c          |   10 +-
 25 files changed, 986 insertions(+), 1605 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
index e345af7..bfe73ee 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc.c
@@ -218,10 +218,9 @@ static int brcmf_sdioh_enablefuncs(struct sdioh_info *sd)
 	sdio_claim_host(gInstance->func[1]);
 	err_ret = sdio_enable_func(gInstance->func[1]);
 	sdio_release_host(gInstance->func[1]);
-	if (err_ret) {
+	if (err_ret)
 		sd_err(("brcmf_sdioh_enablefuncs: Failed to enable F1 "
 			"Err: 0x%08x\n", err_ret));
-	}
 
 	return false;
 }
@@ -763,35 +762,32 @@ brcmf_sdioh_request_word(struct sdioh_info *sd, uint cmd_type, uint rw,
 	sdio_claim_host(gInstance->func[func]);
 
 	if (rw) {		/* CMD52 Write */
-		if (nbytes == 4) {
+		if (nbytes == 4)
 			sdio_writel(gInstance->func[func], *word, addr,
 				    &err_ret);
-		} else if (nbytes == 2) {
+		else if (nbytes == 2)
 			sdio_writew(gInstance->func[func], (*word & 0xFFFF),
 				    addr, &err_ret);
-		} else {
+		else
 			sd_err(("%s: Invalid nbytes: %d\n", __func__, nbytes));
-		}
 	} else {		/* CMD52 Read */
-		if (nbytes == 4) {
+		if (nbytes == 4)
 			*word =
 			    sdio_readl(gInstance->func[func], addr, &err_ret);
-		} else if (nbytes == 2) {
+		else if (nbytes == 2)
 			*word =
 			    sdio_readw(gInstance->func[func], addr,
 				       &err_ret) & 0xFFFF;
-		} else {
+		else
 			sd_err(("%s: Invalid nbytes: %d\n", __func__, nbytes));
-		}
 	}
 
 	/* Release host controller */
 	sdio_release_host(gInstance->func[func]);
 
-	if (err_ret) {
+	if (err_ret)
 		sd_err(("brcmf: Failed to %s word, Err: 0x%08x\n",
 			rw ? "Write" : "Read", err_ret));
-	}
 
 	return err_ret;
 }
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_common.c b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
index 62b7591..d5648f8 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_common.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_common.c
@@ -284,18 +284,17 @@ bool brcmf_c_prec_enq(struct brcmf_pub *drvr, struct pktq *q,
 		/* Evict packet according to discard policy */
 		p = discard_oldest ? brcmu_pktq_pdeq(q, eprec) :
 			brcmu_pktq_pdeq_tail(q, eprec);
-		if (p == NULL) {
+		if (p == NULL)
 			BRCMF_ERROR(("%s: brcmu_pktq_penq() failed, oldest %d.",
 				     __func__, discard_oldest));
-		}
+
 		brcmu_pkt_buf_free_skb(p);
 	}
 
 	/* Enqueue */
 	p = brcmu_pktq_penq(q, prec, pkt);
-	if (p == NULL) {
+	if (p == NULL)
 		BRCMF_ERROR(("%s: brcmu_pktq_penq() failed.", __func__));
-	}
 
 	return p != NULL;
 }
@@ -542,20 +541,19 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 
 	case BRCMF_E_ASSOC:
 	case BRCMF_E_REASSOC:
-		if (status == BRCMF_E_STATUS_SUCCESS) {
+		if (status == BRCMF_E_STATUS_SUCCESS)
 			BRCMF_EVENT(("MACEVENT: %s, MAC %s, SUCCESS\n",
 				     event_name, eabuf));
-		} else if (status == BRCMF_E_STATUS_TIMEOUT) {
+		else if (status == BRCMF_E_STATUS_TIMEOUT)
 			BRCMF_EVENT(("MACEVENT: %s, MAC %s, TIMEOUT\n",
 				     event_name, eabuf));
-		} else if (status == BRCMF_E_STATUS_FAIL) {
+		else if (status == BRCMF_E_STATUS_FAIL)
 			BRCMF_EVENT(("MACEVENT: %s, MAC %s, FAILURE,"
 				     " reason %d\n", event_name, eabuf,
 				     (int)reason));
-		} else {
+		else
 			BRCMF_EVENT(("MACEVENT: %s, MAC %s, unexpected status "
 				     "%d\n", event_name, eabuf, (int)status));
-		}
 		break;
 
 	case BRCMF_E_DEAUTH_IND:
@@ -574,16 +572,16 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 			sprintf(err_msg, "AUTH unknown: %d", (int)auth_type);
 			auth_str = err_msg;
 		}
-		if (event_type == BRCMF_E_AUTH_IND) {
+		if (event_type == BRCMF_E_AUTH_IND)
 			BRCMF_EVENT(("MACEVENT: %s, MAC %s, %s\n", event_name,
 				     eabuf, auth_str));
-		} else if (status == BRCMF_E_STATUS_SUCCESS) {
+		else if (status == BRCMF_E_STATUS_SUCCESS)
 			BRCMF_EVENT(("MACEVENT: %s, MAC %s, %s, SUCCESS\n",
 				     event_name, eabuf, auth_str));
-		} else if (status == BRCMF_E_STATUS_TIMEOUT) {
+		else if (status == BRCMF_E_STATUS_TIMEOUT)
 			BRCMF_EVENT(("MACEVENT: %s, MAC %s, %s, TIMEOUT\n",
 				     event_name, eabuf, auth_str));
-		} else if (status == BRCMF_E_STATUS_FAIL) {
+		else if (status == BRCMF_E_STATUS_FAIL) {
 			BRCMF_EVENT(("MACEVENT: %s, MAC %s, %s, FAILURE, "
 				     "reason %d\n",
 				     event_name, eabuf, auth_str, (int)reason));
@@ -594,29 +592,27 @@ brcmf_c_show_host_event(struct brcmf_event_msg *event, void *event_data)
 	case BRCMF_E_JOIN:
 	case BRCMF_E_ROAM:
 	case BRCMF_E_SET_SSID:
-		if (status == BRCMF_E_STATUS_SUCCESS) {
+		if (status == BRCMF_E_STATUS_SUCCESS)
 			BRCMF_EVENT(("MACEVENT: %s, MAC %s\n", event_name,
 				     eabuf));
-		} else if (status == BRCMF_E_STATUS_FAIL) {
+		else if (status == BRCMF_E_STATUS_FAIL)
 			BRCMF_EVENT(("MACEVENT: %s, failed\n", event_name));
-		} else if (status == BRCMF_E_STATUS_NO_NETWORKS) {
+		else if (status == BRCMF_E_STATUS_NO_NETWORKS)
 			BRCMF_EVENT(("MACEVENT: %s, no networks found\n",
 				     event_name));
-		} else {
+		else
 			BRCMF_EVENT(("MACEVENT: %s, unexpected status %d\n",
 				     event_name, (int)status));
-		}
 		break;
 
 	case BRCMF_E_BEACON_RX:
-		if (status == BRCMF_E_STATUS_SUCCESS) {
+		if (status == BRCMF_E_STATUS_SUCCESS)
 			BRCMF_EVENT(("MACEVENT: %s, SUCCESS\n", event_name));
-		} else if (status == BRCMF_E_STATUS_FAIL) {
+		else if (status == BRCMF_E_STATUS_FAIL)
 			BRCMF_EVENT(("MACEVENT: %s, FAIL\n", event_name));
-		} else {
+		else
 			BRCMF_EVENT(("MACEVENT: %s, status %d\n", event_name,
 				     status));
-		}
 		break;
 
 	case BRCMF_E_LINK:
@@ -1111,11 +1107,10 @@ int brcmf_c_preinit_ioctls(struct brcmf_pub *drvr)
 	/* Set Country code */
 	if (drvr->country_code[0] != 0) {
 		if (brcmf_proto_cdc_set_ioctl(drvr, 0, BRCMF_C_SET_COUNTRY,
-				     drvr->country_code,
-				     sizeof(drvr->country_code)) < 0) {
+					      drvr->country_code,
+					      sizeof(drvr->country_code)) < 0)
 			BRCMF_ERROR(("%s: country code setting failed\n",
 				     __func__));
-		}
 	}
 
 	/* query for 'ver' to get version info from firmware */
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index 9ee566c..9c79e05 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -411,12 +411,11 @@ static int _brcmf_set_mac_address(struct brcmf_info *drvr_priv, int ifidx, u8 *a
 	ioc.set = true;
 
 	ret = brcmf_proto_ioctl(&drvr_priv->pub, ifidx, &ioc, ioc.buf, ioc.len);
-	if (ret < 0) {
+	if (ret < 0)
 		BRCMF_ERROR(("%s: set cur_etheraddr failed\n",
 			     brcmf_ifname(&drvr_priv->pub, ifidx)));
-	} else {
+	else
 		memcpy(drvr_priv->iflist[ifidx]->net->dev_addr, addr, ETH_ALEN);
-	}
 
 	return ret;
 }
@@ -770,9 +769,9 @@ void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx, struct sk_buff *skb,
 		drvr->dstats.rx_bytes += skb->len;
 		drvr->rx_packets++;	/* Local count */
 
-		if (in_interrupt()) {
+		if (in_interrupt())
 			netif_rx(skb);
-		} else {
+		else
 			/* If the receive is not processed inside an ISR,
 			 * the softirqd must be woken explicitly to service
 			 * the NET_RX_SOFTIRQ.  In 2.6 kernels, this is handled
@@ -780,7 +779,6 @@ void brcmf_rx_frame(struct brcmf_pub *drvr, int ifidx, struct sk_buff *skb,
 			 * to do it manually.
 			 */
 			netif_rx_ni(skb);
-		}
 	}
 }
 
@@ -815,10 +813,9 @@ static struct net_device_stats *brcmf_netdev_get_stats(struct net_device *net)
 
 	ifp = drvr_priv->iflist[ifidx];
 
-	if (drvr_priv->pub.up) {
+	if (drvr_priv->pub.up)
 		/* Use the protocol to get dongle stats */
 		brcmf_proto_dstats(&drvr_priv->pub);
-	}
 
 	/* Copy dongle stats to net device stats */
 	ifp->stats.rx_packets = drvr_priv->pub.dstats.rx_packets;
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
index ddd781e..705b57c 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_sdio.c
@@ -1127,10 +1127,9 @@ static int brcmf_sdbrcm_htclk(struct brcmf_bus *bus, bool on, bool pendok)
 
 #if defined(BCMDBG)
 		if (bus->alp_only != true) {
-			if (SBSDIO_ALPONLY(clkctl)) {
+			if (SBSDIO_ALPONLY(clkctl))
 				BRCMF_ERROR(("%s: HT Clock should be on.\n",
 					     __func__));
-			}
 		}
 #endif				/* defined (BCMDBG) */
 
@@ -1428,9 +1427,8 @@ static int brcmf_sdbrcm_txpkt(struct brcmf_bus *bus, struct sk_buff *pkt, uint c
 	}
 
 	/* Some controllers have trouble with odd bytes -- round to even */
-	if (forcealign && (len & (ALIGNMENT - 1))) {
+	if (forcealign && (len & (ALIGNMENT - 1)))
 			len = roundup(len, ALIGNMENT);
-	}
 
 	do {
 		ret = brcmf_sdbrcm_send_buf(bus, brcmf_sdcard_cur_sbwad(card),
@@ -1782,10 +1780,10 @@ brcmf_sdbrcm_bus_txctl(struct brcmf_bus *bus, unsigned char *msg, uint msglen)
 				}
 
 			}
-			if (ret == 0) {
+			if (ret == 0)
 				bus->tx_seq =
 				    (bus->tx_seq + 1) % SDPCM_SEQUENCE_WRAP;
-			}
+
 		} while ((ret < 0) && retries++ < TXRETRIES);
 	}
 
@@ -2181,10 +2179,9 @@ brcmf_sdbrcm_membytes(struct brcmf_bus *bus, bool write, u32 address, u8 *data,
 xfer_done:
 	/* Return the window to backplane enumeration space for core access */
 	if (brcmf_sdbrcm_set_siaddr_window(bus,
-					   brcmf_sdcard_cur_sbwad(bus->card))) {
+					   brcmf_sdcard_cur_sbwad(bus->card)))
 		BRCMF_ERROR(("%s: FAILED to set window back to 0x%x\n",
 			     __func__, brcmf_sdcard_cur_sbwad(bus->card)));
-	}
 
 	return bcmerror;
 }
@@ -2287,13 +2284,12 @@ static int brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, u8 *data, uint size)
 		    "msgtrace address : 0x%08X\nconsole address  : 0x%08X\n",
 		    sdpcm_shared.msgtrace_addr, sdpcm_shared.console_addr);
 
-	if ((sdpcm_shared.flags & SDPCM_SHARED_ASSERT_BUILT) == 0) {
+	if ((sdpcm_shared.flags & SDPCM_SHARED_ASSERT_BUILT) == 0)
 		/* NOTE: Misspelled assert is intentional - DO NOT FIX.
 		 * (Avoids conflict with real asserts for programmatic
 		 * parsing of output.)
 		 */
 		brcmu_bprintf(&strbuf, "Assrt not built in dongle\n");
-	}
 
 	if ((sdpcm_shared.flags & (SDPCM_SHARED_ASSERT | SDPCM_SHARED_TRAP)) ==
 	    0) {
@@ -2358,10 +2354,10 @@ static int brcmf_sdbrcm_checkdied(struct brcmf_bus *bus, u8 *data, uint size)
 		BRCMF_ERROR(("%s: %s\n", __func__, strbuf.origbuf));
 
 #ifdef BCMDBG
-	if (sdpcm_shared.flags & SDPCM_SHARED_TRAP) {
+	if (sdpcm_shared.flags & SDPCM_SHARED_TRAP)
 		/* Mem dump to a file on device */
 		brcmf_sdbrcm_mem_dump(bus);
-	}
+
 #endif				/* BCMDBG */
 
 done:
@@ -2591,11 +2587,10 @@ brcmf_sdbrcm_doiovar(struct brcmf_bus *bus, const struct brcmu_iovar *vi, u32 ac
 		if (bus->drvr->up) {
 			BRCMF_INTR(("%s: %s SDIO interrupts\n", __func__,
 				    bus->intr ? "enable" : "disable"));
-			if (bus->intr) {
+			if (bus->intr)
 				brcmf_sdcard_intr_enable(bus->card);
-			} else {
+			else
 				brcmf_sdcard_intr_disable(bus->card);
-			}
 		}
 		break;
 
@@ -3016,10 +3011,10 @@ static int brcmf_sdbrcm_write_vars(struct brcmf_bus *bus)
 				     varsize, varaddr));
 		}
 		/* Compare the org NVRAM with the one read from RAM */
-		if (memcmp(vbuffer, nvram_ularray, varsize)) {
+		if (memcmp(vbuffer, nvram_ularray, varsize))
 			BRCMF_ERROR(("%s: Downloaded NVRAM image is "
 				     "corrupted.\n", __func__));
-		} else
+		else
 			BRCMF_ERROR(("%s: Download/Upload/Compare of"
 				     " NVRAM ok.\n", __func__));
 
@@ -3249,10 +3244,9 @@ void brcmf_sdbrcm_bus_stop(struct brcmf_bus *bus, bool enforce_mutex)
 				       SBSDIO_FUNC1_CHIPCLKCSR,
 				       (saveclk | SBSDIO_FORCE_HT), &err);
 	}
-	if (err) {
+	if (err)
 		BRCMF_ERROR(("%s: Failed to force clock for F2: err %d\n",
 			     __func__, err));
-	}
 
 	/* Turn off the bus (F2), free any pending packets */
 	BRCMF_INTR(("%s: disable SDIO interrupts\n", __func__));
@@ -3456,13 +3450,12 @@ static void brcmf_sdbrcm_rxfail(struct brcmf_bus *bus, bool abort, bool rtx)
 		lastrbc = (hi << 8) + lo;
 	}
 
-	if (!retries) {
+	if (!retries)
 		BRCMF_ERROR(("%s: count never zeroed: last 0x%04x\n",
 			     __func__, lastrbc));
-	} else {
+	else
 		BRCMF_INFO(("%s: flush took %d iterations\n", __func__,
 			    (0xffff - retries)));
-	}
 
 	if (rtx) {
 		bus->rxrtx++;
@@ -3936,11 +3929,11 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 
 			if (pfirst->len == 0) {
 				brcmu_pkt_buf_free_skb(pfirst);
-				if (plast) {
+				if (plast)
 					plast->next = pnext;
-				} else {
+				else
 					save_pfirst = pnext;
-				}
+
 				continue;
 			} else if (brcmf_proto_hdrpull(bus->drvr, &ifidx, pfirst)
 					!= 0) {
@@ -3948,11 +3941,11 @@ static u8 brcmf_sdbrcm_rxglom(struct brcmf_bus *bus, u8 rxseq)
 					     __func__));
 				bus->drvr->rx_errors++;
 				brcmu_pkt_buf_free_skb(pfirst);
-				if (plast) {
+				if (plast)
 					plast->next = pnext;
-				} else {
+				else
 					save_pfirst = pnext;
-				}
+
 				continue;
 			}
 
@@ -4647,10 +4640,9 @@ static u32 brcmf_sdbrcm_hostmail(struct brcmf_bus *bus)
 			 HMB_DATA_NAKHANDLED |
 			 HMB_DATA_FC |
 			 HMB_DATA_FWREADY |
-			 HMB_DATA_FCDATA_MASK | HMB_DATA_VERSION_MASK)) {
+			 HMB_DATA_FCDATA_MASK | HMB_DATA_VERSION_MASK))
 		BRCMF_ERROR(("Unknown mailbox data content: 0x%02x\n",
 			     hmb_data));
-	}
 
 	return intstatus;
 }
@@ -5773,13 +5765,13 @@ static bool brcmf_sdbrcm_probe_init(struct brcmf_bus *bus, void *card)
 		 default to use if supported */
 	if (brcmf_sdcard_iovar_op(card, "sd_rxchain", NULL, 0,
 			    &bus->sd_rxchain, sizeof(s32),
-			    false) != 0) {
+			    false) != 0)
 		bus->sd_rxchain = false;
-	} else {
+	else
 		BRCMF_INFO(("%s: bus module (through sdiocard API) %s"
 			    " chaining\n", __func__, bus->sd_rxchain
 			    ? "supports" : "does not support"));
-	}
+
 	bus->use_rxchain = (bool) bus->sd_rxchain;
 
 	return true;
@@ -5864,9 +5856,8 @@ static void brcmf_sdbrcm_disconnect(void *ptr)
 
 	BRCMF_TRACE(("%s: Enter\n", __func__));
 
-	if (bus) {
+	if (bus)
 		brcmf_sdbrcm_release(bus);
-	}
 
 	BRCMF_TRACE(("%s: Disconnected\n", __func__));
 }
@@ -6085,10 +6076,9 @@ static int _brcmf_sdbrcm_download_firmware(struct brcmf_bus *bus)
 	}
 
 	/* External nvram takes precedence if specified */
-	if (brcmf_sdbrcm_download_nvram(bus)) {
+	if (brcmf_sdbrcm_download_nvram(bus))
 		BRCMF_ERROR(("%s: dongle nvram file download failed\n",
 			     __func__));
-	}
 
 	/* Take arm out of reset */
 	if (brcmf_sdbrcm_download_state(bus, false)) {
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 2e8fd6e..8423aad 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -677,12 +677,12 @@ brcmf_run_iscan(struct brcmf_cfg80211_iscan_ctrl *iscan,
 	err = brcmf_dev_iovar_setbuf(iscan->dev, "iscan", params, params_size,
 				iscan->ioctl_buf, BRCMF_C_IOCTL_SMLEN);
 	if (unlikely(err)) {
-		if (err == -EBUSY) {
+		if (err == -EBUSY)
 			WL_INFO("system busy : iscan canceled\n");
-		} else {
+		else
 			WL_ERR("error (%d)\n", err);
-		}
 	}
+
 	kfree(params);
 	return err;
 }
@@ -790,12 +790,12 @@ __brcmf_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
 		err = brcmf_dev_ioctl(ndev, BRCMF_C_SCAN, &sr->ssid,
 				sizeof(sr->ssid));
 		if (err) {
-			if (err == -EBUSY) {
+			if (err == -EBUSY)
 				WL_INFO("system busy : scan for \"%s\" canceled\n",
 					sr->ssid.SSID);
-			} else {
+			else
 				WL_ERR("WLC_SCAN error (%d)\n", err);
-			}
+
 			brcmf_set_mpc(ndev, 1);
 			goto scan_out;
 		}
@@ -1049,6 +1049,7 @@ brcmf_cfg80211_join_ibss(struct wiphy *wiphy, struct net_device *dev,
 	} else {
 		memcpy(join_params.params.bssid, ether_bcast, ETH_ALEN);
 	}
+
 	brcmf_update_prof(cfg_priv, NULL,
 			  &join_params.params.bssid, WL_PROF_BSSID);
 
@@ -1430,10 +1431,9 @@ brcmf_cfg80211_connect(struct wiphy *wiphy, struct net_device *dev,
 
 	memcpy(join_params.params.bssid, ether_bcast, ETH_ALEN);
 
-	if (join_params.ssid.SSID_len < IEEE80211_MAX_SSID_LEN) {
+	if (join_params.ssid.SSID_len < IEEE80211_MAX_SSID_LEN)
 		WL_CONN("ssid \"%s\", len (%d)\n",
 		       join_params.ssid.SSID, join_params.ssid.SSID_len);
-	}
 
 	brcmf_ch_to_chanspec(cfg_priv->channel,
 			     &join_params, &join_params_size);
@@ -1946,9 +1946,9 @@ brcmf_cfg80211_get_station(struct wiphy *wiphy, struct net_device *dev,
 		scb_val.val = 0;
 		err = brcmf_dev_ioctl(dev, BRCMF_C_GET_RSSI, &scb_val,
 				sizeof(struct brcmf_scb_val));
-		if (unlikely(err)) {
+		if (unlikely(err))
 			WL_ERR("Could not get rssi (%d)\n", err);
-		}
+
 		rssi = le32_to_cpu(scb_val.val);
 		sinfo->filled |= STATION_INFO_SIGNAL;
 		sinfo->signal = rssi;
@@ -3523,13 +3523,13 @@ static s32 brcmf_event_handler(void *data)
 			BUG();
 		}
 		WL_INFO("event type (%d)\n", e->etype);
-		if (cfg_priv->el.handler[e->etype]) {
+		if (cfg_priv->el.handler[e->etype])
 			cfg_priv->el.handler[e->etype](cfg_priv,
 						       cfg_to_ndev(cfg_priv),
 						       &e->emsg, e->edata);
-		} else {
+		else
 			WL_INFO("Unknown Event (%d): ignoring\n", e->etype);
-		}
+
 		brcmf_put_event(e);
 	}
 	WL_INFO("was terminated\n");
diff --git a/drivers/staging/brcm80211/brcmsmac/aiutils.c b/drivers/staging/brcm80211/brcmsmac/aiutils.c
index 58a5cfc..bc4e2e1 100644
--- a/drivers/staging/brcm80211/brcmsmac/aiutils.c
+++ b/drivers/staging/brcm80211/brcmsmac/aiutils.c
@@ -387,10 +387,10 @@ get_erom_ent(struct si_pub *sih, u32 **eromptr, u32 mask, u32 match)
 	}
 
 	SI_VMSG(("%s: Returning ent 0x%08x\n", __func__, ent));
-	if (inv + nom) {
+	if (inv + nom)
 		SI_VMSG(("  after %d invalid and %d non-matching entries\n",
 			 inv, nom));
-	}
+
 	return ent;
 }
 
@@ -511,9 +511,8 @@ void ai_scan(struct si_pub *sih, void *regs)
 			if (cid == OOB_ROUTER_CORE_ID) {
 				asd = get_asd(sih, &eromptr, 0, 0, AD_ST_SLAVE,
 					      &addrl, &addrh, &sizel, &sizeh);
-				if (asd != 0) {
+				if (asd != 0)
 					sii->oob_router = addrl;
-				}
 			}
 			continue;
 		}
@@ -650,13 +649,13 @@ void *ai_setcoreidx(struct si_pub *sih, uint coreidx)
 	switch (sih->bustype) {
 	case SI_BUS:
 		/* map new one */
-		if (!sii->regs[coreidx]) {
+		if (!sii->regs[coreidx])
 			sii->regs[coreidx] = REG_MAP(addr, SI_CORE_SIZE);
-		}
+
 		sii->curmap = regs = sii->regs[coreidx];
-		if (!sii->wrappers[coreidx]) {
+		if (!sii->wrappers[coreidx])
 			sii->wrappers[coreidx] = REG_MAP(wrap, SI_CORE_SIZE);
-		}
+
 		sii->curwrap = sii->wrappers[coreidx];
 		break;
 
@@ -1063,9 +1062,8 @@ static __used void ai_nvram_process(struct si_info *sii, char *pvars)
 		break;
 	}
 
-	if (sii->pub.boardtype == 0) {
+	if (sii->pub.boardtype == 0)
 		SI_ERROR(("si_doattach: unknown board type\n"));
-	}
 
 	sii->pub.boardflags = getintvar(pvars, "boardflags");
 }
@@ -1195,9 +1193,8 @@ static struct si_info *ai_doattach(struct si_info *sii,
 	ai_corereg(sih, SI_CC_IDX, offsetof(struct chipcregs, gpiotimerval),
 		   ~0, w);
 
-	if (PCIE(sii)) {
+	if (PCIE(sii))
 		pcicore_attach(sii->pch, pvars, SI_DOATTACH);
-	}
 
 	if (sih->chip == BCM43224_CHIP_ID) {
 		/*
@@ -1435,10 +1432,10 @@ uint ai_corereg(struct si_pub *sih, uint coreidx, uint regoff, uint mask,
 		/* If internal bus, we can always get at everything */
 		fast = true;
 		/* map if does not exist */
-		if (!sii->regs[coreidx]) {
+		if (!sii->regs[coreidx])
 			sii->regs[coreidx] = REG_MAP(sii->coresba[coreidx],
 						     SI_CORE_SIZE);
-		}
+
 		r = (u32 *) ((unsigned char *) sii->regs[coreidx] + regoff);
 	} else if (sih->bustype == PCI_BUS) {
 		/*
@@ -2187,16 +2184,15 @@ void ai_chipcontrl_epa4331(struct si_pub *sih, bool on)
 	val = R_REG(&cc->chipcontrol);
 
 	if (on) {
-		if (sih->chippkg == 9 || sih->chippkg == 0xb) {
+		if (sih->chippkg == 9 || sih->chippkg == 0xb)
 			/* Ext PA Controls for 4331 12x9 Package */
 			W_REG(&cc->chipcontrol, val |
 			      (CCTRL4331_EXTPA_EN |
 			       CCTRL4331_EXTPA_ON_GPIO2_5));
-		} else {
+		else
 			/* Ext PA Controls for 4331 12x12 Package */
 			W_REG(&cc->chipcontrol,
 			      val | (CCTRL4331_EXTPA_EN));
-		}
 	} else {
 		val &= ~(CCTRL4331_EXTPA_EN | CCTRL4331_EXTPA_ON_GPIO2_5);
 		W_REG(&cc->chipcontrol, val);
diff --git a/drivers/staging/brcm80211/brcmsmac/alloc.c b/drivers/staging/brcm80211/brcmsmac/alloc.c
index 7f8dd7b..7dc2875 100644
--- a/drivers/staging/brcm80211/brcmsmac/alloc.c
+++ b/drivers/staging/brcm80211/brcmsmac/alloc.c
@@ -161,11 +161,10 @@ struct brcms_c_info *brcms_c_attach_malloc(uint unit, uint *err, uint devid)
 	} else {
 		int i;
 
-		for (i = 1; i < MAXBANDS; i++) {
+		for (i = 1; i < MAXBANDS; i++)
 			wlc->hw->bandstate[i] = (struct brcms_hw_band *)
 			    ((unsigned long)wlc->hw->bandstate[0] +
 			     (sizeof(struct brcms_hw_band) * i));
-		}
 	}
 
 	wlc->modulecb =
@@ -196,11 +195,10 @@ struct brcms_c_info *brcms_c_attach_malloc(uint unit, uint *err, uint devid)
 		goto fail;
 	} else {
 		int i;
-		for (i = 1; i < BRCMS_DEFAULT_KEYS; i++) {
+		for (i = 1; i < BRCMS_DEFAULT_KEYS; i++)
 			wlc->wsec_def_keys[i] = (struct wsec_key *)
 			    ((unsigned long)wlc->wsec_def_keys[0] +
 			     (sizeof(struct wsec_key) * i));
-		}
 	}
 
 	wlc->protection = kzalloc(sizeof(struct brcms_protection),
@@ -224,11 +222,10 @@ struct brcms_c_info *brcms_c_attach_malloc(uint unit, uint *err, uint devid)
 	} else {
 		int i;
 
-		for (i = 1; i < MAXBANDS; i++) {
+		for (i = 1; i < MAXBANDS; i++)
 			wlc->bandstate[i] = (struct brcms_band *)
 				((unsigned long)wlc->bandstate[0]
 				+ (sizeof(struct brcms_band)*i));
-		}
 	}
 
 	wlc->corestate = kzalloc(sizeof(struct brcms_core), GFP_ATOMIC);
diff --git a/drivers/staging/brcm80211/brcmsmac/ampdu.c b/drivers/staging/brcm80211/brcmsmac/ampdu.c
index 5d09038..b462fc8 100644
--- a/drivers/staging/brcm80211/brcmsmac/ampdu.c
+++ b/drivers/staging/brcm80211/brcmsmac/ampdu.c
@@ -195,9 +195,8 @@ void brcms_c_ampdu_detach(struct ampdu_info *ampdu)
 		return;
 
 	/* free all ini's which were to be freed on callbacks which were never called */
-	for (i = 0; i < AMPDU_INI_FREE; i++) {
+	for (i = 0; i < AMPDU_INI_FREE; i++)
 		kfree(ampdu->ini_free[i]);
-	}
 
 	brcms_c_module_unregister(ampdu->wlc->pub, "ampdu", ampdu);
 	kfree(ampdu);
@@ -317,9 +316,9 @@ static int brcms_c_ffpld_check_txfunfl(struct brcms_c_info *wlc, int fid)
 	txunfl_ratio = current_ampdu_cnt / fifo->accum_txfunfl;
 
 	if (txunfl_ratio > ampdu->tx_max_funl) {
-		if (current_ampdu_cnt >= FFPLD_MAX_AMPDU_CNT) {
+		if (current_ampdu_cnt >= FFPLD_MAX_AMPDU_CNT)
 			fifo->accum_txfunfl = 0;
-		}
+
 		return 0;
 	}
 	max_mpdu =
@@ -486,10 +485,9 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 	/* Let pressure continue to build ... */
 	qlen = pktq_plen(&qi->q, prec);
 	if (ini->tx_in_transit > 0 &&
-	    qlen < min(scb_ampdu->max_pdu, ini->ba_wsize)) {
+	    qlen < min(scb_ampdu->max_pdu, ini->ba_wsize))
 		/* Collect multiple MPDU's to be sent in the next AMPDU */
 		return -EBUSY;
-	}
 
 	/* at this point we intend to transmit an AMPDU */
 	rr_retry_limit = ampdu->rr_retry_limit_tid[tid];
@@ -665,9 +663,8 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 			break;
 		}
 
-		if (count == scb_ampdu->max_pdu) {
+		if (count == scb_ampdu->max_pdu)
 			break;
-		}
 
 		/* check to see if the next pkt is a candidate for aggregation */
 		p = pktq_ppeek(&qi->q, prec);
@@ -797,10 +794,10 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
 
 		/* inform rate_sel if it this is a rate probe pkt */
 		frameid = le16_to_cpu(txh->TxFrameID);
-		if (frameid & TXFID_RATE_PROBE_MASK) {
+		if (frameid & TXFID_RATE_PROBE_MASK)
 			wiphy_err(wiphy, "%s: XXX what to do with "
 				  "TXFID_RATE_PROBE_MASK!?\n", __func__);
-		}
+
 		for (i = 0; i < count; i++)
 			brcms_c_txfifo(wlc, fifo, pkt[i], i == (count - 1),
 				   ampdu->txpkt_weight);
@@ -833,9 +830,8 @@ brcms_c_ampdu_dotxstatus(struct ampdu_info *ampdu, struct scb *scb,
 		while (((s1 = R_REG(&wlc->regs->frmtxstatus)) & TXS_V) == 0) {
 			udelay(1);
 			status_delay++;
-			if (status_delay > 10) {
+			if (status_delay > 10)
 				return; /* error condition */
-			}
 		}
 
 		s2 = R_REG(&wlc->regs->frmtxstatus2);
@@ -923,9 +919,8 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 	supr_status = txs->status & TX_STATUS_SUPR_MASK;
 
 	if (txs->status & TX_STATUS_ACK_RCV) {
-		if (TX_STATUS_SUPR_UF == supr_status) {
+		if (TX_STATUS_SUPR_UF == supr_status)
 			update_rate = false;
-		}
 
 		WARN_ON(!(txs->status & TX_STATUS_INTERMEDIATE));
 		start_seq = txs->sequence >> SEQNUM_SHIFT;
@@ -973,9 +968,8 @@ brcms_c_ampdu_dotxstatus_complete(struct ampdu_info *ampdu, struct scb *scb,
 				   notify rate adaptation.
 				 */
 				if (brcms_c_ffpld_check_txfunfl(wlc,
-							prio2fifo[tid]) > 0) {
+					prio2fifo[tid]) > 0)
 					tx_error = true;
-				}
 			}
 		} else if (txs->phyerr) {
 			update_rate = false;
@@ -1211,9 +1205,8 @@ void brcms_c_ampdu_flush(struct brcms_c_info *wlc,
 
 	ampdu_pars.sta = sta;
 	ampdu_pars.tid = tid;
-	for (prec = 0; prec < pq->num_prec; prec++) {
+	for (prec = 0; prec < pq->num_prec; prec++)
 		brcmu_pktq_pflush(pq, prec, true, cb_del_ampdu_pkt,
 			    (void *)&ampdu_pars);
-	}
 	brcms_c_inval_dma_pkts(wlc->hw, sta, dma_cb_fn_ampdu);
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/antsel.c b/drivers/staging/brcm80211/brcmsmac/antsel.c
index 1d6c398..5a5d5d6 100644
--- a/drivers/staging/brcm80211/brcmsmac/antsel.c
+++ b/drivers/staging/brcm80211/brcmsmac/antsel.c
@@ -110,17 +110,16 @@ struct antsel_info *brcms_c_antsel_attach(struct brcms_c_info *wlc)
 			if (((u16) getintvar(asi->pub->vars, "aa2g") == 7) ||
 			    ((u16) getintvar(asi->pub->vars, "aa5g") == 7)) {
 				asi->antsel_avail = true;
-			} else
-			    if (((u16) getintvar(asi->pub->vars, "aa2g") ==
-				 3)
-				|| ((u16) getintvar(asi->pub->vars, "aa5g")
-				    == 3)) {
+			} else if (
+				(u16) getintvar(asi->pub->vars, "aa2g") == 3 ||
+				(u16) getintvar(asi->pub->vars, "aa5g") == 3) {
 				asi->antsel_avail = false;
 			} else {
 				asi->antsel_avail = false;
 				wiphy_err(wlc->wiphy, "antsel_attach: 2o3 "
 					  "board cfg invalid\n");
 			}
+
 			break;
 		default:
 			break;
diff --git a/drivers/staging/brcm80211/brcmsmac/channel.c b/drivers/staging/brcm80211/brcmsmac/channel.c
index 807df6a..a738e3b 100644
--- a/drivers/staging/brcm80211/brcmsmac/channel.c
+++ b/drivers/staging/brcm80211/brcmsmac/channel.c
@@ -409,10 +409,9 @@ static void brcms_c_locale_get_channels(const struct locale_info *locale,
 	memset(channels, 0, sizeof(struct brcms_chanvec));
 
 	for (i = 0; i < ARRAY_SIZE(g_table_locale_base); i++) {
-		if (locale->valid_channels & (1 << i)) {
+		if (locale->valid_channels & (1 << i))
 			brcms_c_locale_add_channels(channels,
 						g_table_locale_base[i]);
-		}
 	}
 }
 
@@ -590,33 +589,33 @@ struct chan20_info chan20_info[] = {
 
 static const struct locale_info *brcms_c_get_locale_2g(u8 locale_idx)
 {
-	if (locale_idx >= ARRAY_SIZE(g_locale_2g_table)) {
+	if (locale_idx >= ARRAY_SIZE(g_locale_2g_table))
 		return NULL; /* error condition */
-	}
+
 	return g_locale_2g_table[locale_idx];
 }
 
 static const struct locale_info *brcms_c_get_locale_5g(u8 locale_idx)
 {
-	if (locale_idx >= ARRAY_SIZE(g_locale_5g_table)) {
+	if (locale_idx >= ARRAY_SIZE(g_locale_5g_table))
 		return NULL; /* error condition */
-	}
+
 	return g_locale_5g_table[locale_idx];
 }
 
 static const struct locale_mimo_info *brcms_c_get_mimo_2g(u8 locale_idx)
 {
-	if (locale_idx >= ARRAY_SIZE(g_mimo_2g_table)) {
+	if (locale_idx >= ARRAY_SIZE(g_mimo_2g_table))
 		return NULL;
-	}
+
 	return g_mimo_2g_table[locale_idx];
 }
 
 static const struct locale_mimo_info *brcms_c_get_mimo_5g(u8 locale_idx)
 {
-	if (locale_idx >= ARRAY_SIZE(g_mimo_5g_table)) {
+	if (locale_idx >= ARRAY_SIZE(g_mimo_5g_table))
 		return NULL;
-	}
+
 	return g_mimo_5g_table[locale_idx];
 }
 
@@ -642,9 +641,8 @@ struct brcms_cm_info *brcms_c_channel_mgr_attach(struct brcms_c_info *wlc)
 
 	/* store the country code for passing up as a regulatory hint */
 	ccode = getvar(wlc->pub->vars, "ccode");
-	if (ccode) {
+	if (ccode)
 		strncpy(wlc->pub->srom_ccode, ccode, BRCM_CNTRY_BUF_SZ - 1);
-	}
 
 	/* internal country information which must match regulatory constraints in firmware */
 	memset(country_abbrev, 0, BRCM_CNTRY_BUF_SZ);
@@ -759,11 +757,10 @@ brcms_c_set_country_common(struct brcms_cm_info *wlc_cm,
 	brcms_c_stf_ss_update(wlc, wlc->bandstate[BAND_5G_INDEX]);
 	/* set or restore gmode as required by regulatory */
 	locale = brcms_c_get_locale_2g(country->locale_2G);
-	if (locale && (locale->flags & BRCMS_NO_OFDM)) {
+	if (locale && (locale->flags & BRCMS_NO_OFDM))
 		brcms_c_set_gmode(wlc, GMODE_LEGACY_B, false);
-	} else {
+	else
 		brcms_c_set_gmode(wlc, wlc->protection->gmode_user, false);
-	}
 
 	brcms_c_channels_init(wlc_cm, country);
 
@@ -860,9 +857,8 @@ brcms_c_country_lookup_direct(const char *ccode, uint regrev)
 	/* find matched table entry from country code */
 	size = ARRAY_SIZE(cntry_locales);
 	for (i = 0; i < size; i++) {
-		if (strcmp(ccode, cntry_locales[i].abbrev) == 0) {
+		if (strcmp(ccode, cntry_locales[i].abbrev) == 0)
 			return &cntry_locales[i].country;
-		}
 	}
 	return NULL;
 }
@@ -929,9 +925,8 @@ static void brcms_c_channels_commit(struct brcms_cm_info *wlc_cm)
 
 	/* search for the existence of any valid channel */
 	for (chan = 0; chan < MAXCHANNEL; chan++) {
-		if (VALID_CHANNEL20_DB(wlc, chan)) {
+		if (VALID_CHANNEL20_DB(wlc, chan))
 			break;
-		}
 	}
 	if (chan == MAXCHANNEL)
 		chan = INVCHANNEL;
@@ -944,9 +939,8 @@ static void brcms_c_channels_commit(struct brcms_cm_info *wlc_cm)
 			  "nbands %d bandlocked %d\n", wlc->pub->unit,
 			  __func__, wlc_cm->country_abbrev, NBANDS(wlc),
 			  wlc->bandlocked);
-	} else
-	    if (mboolisset(wlc->pub->radio_disabled,
-		WL_RADIO_COUNTRY_DISABLE)) {
+	} else if (mboolisset(wlc->pub->radio_disabled,
+			      WL_RADIO_COUNTRY_DISABLE)) {
 		/* country/locale with valid channel, clear the radio disable bit */
 		mboolclr(wlc->pub->radio_disabled, WL_RADIO_COUNTRY_DISABLE);
 	}
@@ -954,11 +948,10 @@ static void brcms_c_channels_commit(struct brcms_cm_info *wlc_cm)
 	/* Now that the country abbreviation is set, if the radio supports 2G, then
 	 * set channel 14 restrictions based on the new locale.
 	 */
-	if (NBANDS(wlc) > 1 || BAND_2G(wlc->band->bandtype)) {
+	if (NBANDS(wlc) > 1 || BAND_2G(wlc->band->bandtype))
 		wlc_phy_chanspec_ch14_widefilter_set(wlc->band->pi,
 						     brcms_c_japan(wlc) ? true :
 						     false);
-	}
 
 	if (wlc->pub->up && chan != INVCHANNEL) {
 		brcms_c_channel_reg_limits(wlc_cm, wlc->chanspec, &txpwr);
@@ -1043,50 +1036,42 @@ brcms_c_channel_min_txpower_limits_with_local_constraint(
 	int j;
 
 	/* CCK Rates */
-	for (j = 0; j < WL_TX_POWER_CCK_NUM; j++) {
+	for (j = 0; j < WL_TX_POWER_CCK_NUM; j++)
 		txpwr->cck[j] = min(txpwr->cck[j], local_constraint_qdbm);
-	}
 
 	/* 20 MHz Legacy OFDM SISO */
-	for (j = 0; j < WL_TX_POWER_OFDM_NUM; j++) {
+	for (j = 0; j < WL_TX_POWER_OFDM_NUM; j++)
 		txpwr->ofdm[j] = min(txpwr->ofdm[j], local_constraint_qdbm);
-	}
 
 	/* 20 MHz Legacy OFDM CDD */
-	for (j = 0; j < BRCMS_NUM_RATES_OFDM; j++) {
+	for (j = 0; j < BRCMS_NUM_RATES_OFDM; j++)
 		txpwr->ofdm_cdd[j] =
 		    min(txpwr->ofdm_cdd[j], local_constraint_qdbm);
-	}
 
 	/* 40 MHz Legacy OFDM SISO */
-	for (j = 0; j < BRCMS_NUM_RATES_OFDM; j++) {
+	for (j = 0; j < BRCMS_NUM_RATES_OFDM; j++)
 		txpwr->ofdm_40_siso[j] =
 		    min(txpwr->ofdm_40_siso[j], local_constraint_qdbm);
-	}
 
 	/* 40 MHz Legacy OFDM CDD */
-	for (j = 0; j < BRCMS_NUM_RATES_OFDM; j++) {
+	for (j = 0; j < BRCMS_NUM_RATES_OFDM; j++)
 		txpwr->ofdm_40_cdd[j] =
 		    min(txpwr->ofdm_40_cdd[j], local_constraint_qdbm);
-	}
 
 	/* 20MHz MCS 0-7 SISO */
-	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++) {
+	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++)
 		txpwr->mcs_20_siso[j] =
 		    min(txpwr->mcs_20_siso[j], local_constraint_qdbm);
-	}
 
 	/* 20MHz MCS 0-7 CDD */
-	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++) {
+	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++)
 		txpwr->mcs_20_cdd[j] =
 		    min(txpwr->mcs_20_cdd[j], local_constraint_qdbm);
-	}
 
 	/* 20MHz MCS 0-7 STBC */
-	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++) {
+	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++)
 		txpwr->mcs_20_stbc[j] =
 		    min(txpwr->mcs_20_stbc[j], local_constraint_qdbm);
-	}
 
 	/* 20MHz MCS 8-15 MIMO */
 	for (j = 0; j < BRCMS_NUM_RATES_MCS_2_STREAM; j++)
@@ -1094,22 +1079,19 @@ brcms_c_channel_min_txpower_limits_with_local_constraint(
 		    min(txpwr->mcs_20_mimo[j], local_constraint_qdbm);
 
 	/* 40MHz MCS 0-7 SISO */
-	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++) {
+	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++)
 		txpwr->mcs_40_siso[j] =
 		    min(txpwr->mcs_40_siso[j], local_constraint_qdbm);
-	}
 
 	/* 40MHz MCS 0-7 CDD */
-	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++) {
+	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++)
 		txpwr->mcs_40_cdd[j] =
 		    min(txpwr->mcs_40_cdd[j], local_constraint_qdbm);
-	}
 
 	/* 40MHz MCS 0-7 STBC */
-	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++) {
+	for (j = 0; j < BRCMS_NUM_RATES_MCS_1_STREAM; j++)
 		txpwr->mcs_40_stbc[j] =
 		    min(txpwr->mcs_40_stbc[j], local_constraint_qdbm);
-	}
 
 	/* 40MHz MCS 8-15 MIMO */
 	for (j = 0; j < BRCMS_NUM_RATES_MCS_2_STREAM; j++)
@@ -1146,112 +1128,100 @@ static void wlc_phy_txpower_limits_dump(struct txpwr_limits *txpwr)
 	char fraction[4][4] = { "   ", ".25", ".5 ", ".75" };
 
 	sprintf(buf, "CCK                ");
-	for (i = 0; i < BRCMS_NUM_RATES_CCK; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_CCK; i++)
 		sprintf(buf[strlen(buf)], " %2d%s",
 			txpwr->cck[i] / BRCMS_TXPWR_DB_FACTOR,
 			fraction[txpwr->cck[i] % BRCMS_TXPWR_DB_FACTOR]);
-	}
 	printk(KERN_DEBUG "%s\n", buf);
 
 	sprintf(buf, "20 MHz OFDM SISO   ");
-	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++)
 		sprintf(buf[strlen(buf)], " %2d%s",
 			txpwr->ofdm[i] / BRCMS_TXPWR_DB_FACTOR,
 			fraction[txpwr->ofdm[i] % BRCMS_TXPWR_DB_FACTOR]);
-	}
 	printk(KERN_DEBUG "%s\n", buf);
 
 	sprintf(buf, "20 MHz OFDM CDD    ");
-	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++)
 		sprintf(buf[strlen(buf)], " %2d%s",
 			txpwr->ofdm_cdd[i] / BRCMS_TXPWR_DB_FACTOR,
 			fraction[txpwr->ofdm_cdd[i] % BRCMS_TXPWR_DB_FACTOR]);
-	}
 	printk(KERN_DEBUG "%s\n", buf);
 
 	sprintf(buf, "40 MHz OFDM SISO   ");
-	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++)
 		sprintf(buf[strlen(buf)], " %2d%s",
 			txpwr->ofdm_40_siso[i] / BRCMS_TXPWR_DB_FACTOR,
 			fraction[txpwr->ofdm_40_siso[i] %
 							BRCMS_TXPWR_DB_FACTOR]);
-	}
 	printk(KERN_DEBUG "%s\n", buf);
 
 	sprintf(buf, "40 MHz OFDM CDD    ");
-	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_OFDM; i++)
 		sprintf(buf[strlen(buf)], " %2d%s",
 			txpwr->ofdm_40_cdd[i] / BRCMS_TXPWR_DB_FACTOR,
 			fraction[txpwr->ofdm_40_cdd[i] %
 							BRCMS_TXPWR_DB_FACTOR]);
-	}
 	printk(KERN_DEBUG "%s\n", buf);
 
 	sprintf(buf, "20 MHz MCS0-7 SISO ");
-	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++)
 		sprintf(buf[strlen(buf)], " %2d%s",
 			txpwr->mcs_20_siso[i] / BRCMS_TXPWR_DB_FACTOR,
 			fraction[txpwr->mcs_20_siso[i] %
 							BRCMS_TXPWR_DB_FACTOR]);
-	}
 	printk(KERN_DEBUG "%s\n", buf);
 
 	sprintf(buf, "20 MHz MCS0-7 CDD  ");
-	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++)
 		sprintf(buf[strlen(buf)], " %2d%s",
 			txpwr->mcs_20_cdd[i] / BRCMS_TXPWR_DB_FACTOR,
 			fraction[txpwr->mcs_20_cdd[i] %
 							BRCMS_TXPWR_DB_FACTOR]);
-	}
 	printk(KERN_DEBUG "%s\n", buf);
 
 	sprintf(buf, "20 MHz MCS0-7 STBC ");
-	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++)
 		sprintf(buf[strlen(buf)], " %2d%s",
 			txpwr->mcs_20_stbc[i] / BRCMS_TXPWR_DB_FACTOR,
 			fraction[txpwr->mcs_20_stbc[i] %
 							BRCMS_TXPWR_DB_FACTOR]);
-	}
 	printk(KERN_DEBUG "%s\n", buf);
 
 	sprintf(buf, "20 MHz MCS8-15 SDM ");
-	for (i = 0; i < BRCMS_NUM_RATES_MCS_2_STREAM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_MCS_2_STREAM; i++)
 		sprintf(buf[strlen(buf)], " %2d%s",
 			txpwr->mcs_20_mimo[i] / BRCMS_TXPWR_DB_FACTOR,
 			fraction[txpwr->mcs_20_mimo[i] %
 							BRCMS_TXPWR_DB_FACTOR]);
-	}
 	printk(KERN_DEBUG "%s\n", buf);
 
 	sprintf(buf, "40 MHz MCS0-7 SISO ");
-	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++)
 		sprintf(buf[strlen(buf)], " %2d%s",
 			txpwr->mcs_40_siso[i] / BRCMS_TXPWR_DB_FACTOR,
 			fraction[txpwr->mcs_40_siso[i] %
 							BRCMS_TXPWR_DB_FACTOR]);
-	}
 	printk(KERN_DEBUG "%s\n", buf);
 
 	sprintf(buf, "40 MHz MCS0-7 CDD  ");
-	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++)
 		sprintf(buf[strlen(buf)], " %2d%s",
 			txpwr->mcs_40_cdd[i] / BRCMS_TXPWR_DB_FACTOR,
 			fraction[txpwr->mcs_40_cdd[i] %
 							BRCMS_TXPWR_DB_FACTOR]);
-	}
 	printk(KERN_DEBUG "%s\n", buf);
 
 	sprintf(buf, "40 MHz MCS0-7 STBC ");
-	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++)
 		sprintf(buf[strlen(buf)], " %2d%s",
 			txpwr->mcs_40_stbc[i] / BRCMS_TXPWR_DB_FACTOR,
 			fraction[txpwr->mcs_40_stbc[i] %
 							BRCMS_TXPWR_DB_FACTOR]);
-	}
 	printk(KERN_DEBUG "%s\n", buf);
 
 	sprintf(buf, "40 MHz MCS8-15 SDM ");
-	for (i = 0; i < BRCMS_NUM_RATES_MCS_2_STREAM; i++) {
+	for (i = 0; i < BRCMS_NUM_RATES_MCS_2_STREAM; i++)
 		sprintf(buf[strlen(buf)], " %2d%s",
 			txpwr->mcs_40_mimo[i] / BRCMS_TXPWR_DB_FACTOR,
 			fraction[txpwr->mcs_40_mimo[i] %
@@ -1330,12 +1300,10 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 	}
 
 	/* OFDM txpwr limits for 2.4G or 5G bands */
-	if (BAND_2G(band->bandtype)) {
+	if (BAND_2G(band->bandtype))
 		maxpwr = li->maxpwr[CHANNEL_POWER_IDX_2G_OFDM(chan)];
-
-	} else {
+	else
 		maxpwr = li->maxpwr[CHANNEL_POWER_IDX_5G(chan)];
-	}
 
 	maxpwr = maxpwr - delta;
 	maxpwr = max(maxpwr, 0);
@@ -1405,9 +1373,8 @@ brcms_c_channel_reg_limits(struct brcms_cm_info *wlc_cm, u16 chanspec,
 			maxpwr20 = QDB(16);
 			maxpwr40 = 0;
 
-			if (chan >= 3 && chan <= 11) {
+			if (chan >= 3 && chan <= 11)
 				maxpwr40 = QDB(16);
-			}
 		}
 
 		for (i = 0; i < BRCMS_NUM_RATES_MCS_1_STREAM; i++) {
diff --git a/drivers/staging/brcm80211/brcmsmac/dma.c b/drivers/staging/brcm80211/brcmsmac/dma.c
index 6fabb09..31a4728 100644
--- a/drivers/staging/brcm80211/brcmsmac/dma.c
+++ b/drivers/staging/brcm80211/brcmsmac/dma.c
@@ -533,12 +533,12 @@ struct dma_pub *dma_attach(char *name, struct si_pub *sih,
 	di->aligndesc_4k = _dma_descriptor_align(di);
 	if (di->aligndesc_4k) {
 		di->dmadesc_align = D64RINGALIGN_BITS;
-		if ((ntxd < D64MAXDD / 2) && (nrxd < D64MAXDD / 2)) {
+		if ((ntxd < D64MAXDD / 2) && (nrxd < D64MAXDD / 2))
 			/* for smaller dd table, HW relax alignment reqmnt */
 			di->dmadesc_align = D64RINGALIGN_BITS - 1;
-		}
-	} else
+	} else {
 		di->dmadesc_align = 4;	/* 16 byte alignment */
+	}
 
 	DMA_NONE(("DMA descriptor align_needed %d, align %d\n",
 		  di->aligndesc_4k, di->dmadesc_align));
@@ -662,10 +662,9 @@ dma64_dd_upd(struct dma_info *di, struct dma64desc *ddring,
 		W_SM(&ddring[outidx].ctrl2, BUS_SWAP32(ctrl2));
 	}
 	if (di->dma.dmactrlflags & DMA_CTRL_PEN) {
-		if (DMA64_DD_PARITY(&ddring[outidx])) {
+		if (DMA64_DD_PARITY(&ddring[outidx]))
 			W_SM(&ddring[outidx].ctrl2,
 			     BUS_SWAP32(ctrl2 | D64_CTRL2_PARITY));
-		}
 	}
 }
 
@@ -743,18 +742,17 @@ static bool _dma_isaddrext(struct dma_info *di)
 
 	/* not all tx or rx channel are available */
 	if (di->d64txregs != NULL) {
-		if (!_dma64_addrext(di->d64txregs)) {
+		if (!_dma64_addrext(di->d64txregs))
 			DMA_ERROR(("%s: _dma_isaddrext: DMA64 tx doesn't have "
 				   "AE set\n", di->name));
-		}
 		return true;
 	} else if (di->d64rxregs != NULL) {
-		if (!_dma64_addrext(di->d64rxregs)) {
+		if (!_dma64_addrext(di->d64rxregs))
 			DMA_ERROR(("%s: _dma_isaddrext: DMA64 rx doesn't have "
 				   "AE set\n", di->name));
-		}
 		return true;
 	}
+
 	return false;
 }
 
@@ -1157,16 +1155,15 @@ static uint _dma_ctrlflags(struct dma_info *di, uint mask, uint flags)
 		control = R_REG(&di->d64txregs->control);
 		W_REG(&di->d64txregs->control,
 		      control | D64_XC_PD);
-		if (R_REG(&di->d64txregs->control) & D64_XC_PD) {
+		if (R_REG(&di->d64txregs->control) & D64_XC_PD)
 			/* We *can* disable it so it is supported,
 			 * restore control register
 			 */
 			W_REG(&di->d64txregs->control,
 			control);
-		} else {
+		else
 			/* Not supported, don't allow it to be enabled */
 			dmactrlflags &= ~DMA_CTRL_PEN;
-		}
 	}
 
 	di->dma.dmactrlflags = dmactrlflags;
@@ -1186,9 +1183,8 @@ static
 u8 dma_align_sizetobits(uint size)
 {
 	u8 bitpos = 0;
-	while (size >>= 1) {
+	while (size >>= 1)
 		bitpos++;
-	}
 	return bitpos;
 }
 
@@ -1521,10 +1517,9 @@ dma64_txunframed(struct dma_info *di, void *buf, uint len, bool commit)
 	di->txout = txout;
 
 	/* kick the chip */
-	if (commit) {
+	if (commit)
 		W_REG(&di->d64txregs->ptr,
 		      di->xmtptrbase + I2B(txout, struct dma64desc));
-	}
 
 	/* tx flow control */
 	di->dma.txavail = di->ntxd - NTXDACTIVE(di->txin, di->txout) - 1;
diff --git a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
index ccbd9d7..3987ccf 100644
--- a/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
+++ b/drivers/staging/brcm80211/brcmsmac/mac80211_if.c
@@ -216,10 +216,10 @@ brcms_ops_add_interface(struct ieee80211_hw *hw, struct ieee80211_vif *vif)
 	err = brcms_up(wl);
 	UNLOCK(wl);
 
-	if (err != 0) {
+	if (err != 0)
 		wiphy_err(hw->wiphy, "%s: brcms_up() returned %d\n", __func__,
 			  err);
-	}
+
 	return err;
 }
 
@@ -306,9 +306,9 @@ static int brcms_ops_config(struct ieee80211_hw *hw, u32 changed)
 				  "\n", __func__, conf->power_level * 4,
 				  new_int);
 	}
-	if (changed & IEEE80211_CONF_CHANGE_CHANNEL) {
+	if (changed & IEEE80211_CONF_CHANGE_CHANNEL)
 		err = ieee_set_channel(hw, conf->channel, conf->channel_type);
-	}
+
 	if (changed & IEEE80211_CONF_CHANGE_RETRY_LIMITS) {
 		if (brcms_c_set
 		    (wl->wlc, BRCM_SET_SRL,
@@ -419,32 +419,36 @@ brcms_ops_bss_info_changed(struct ieee80211_hw *hw,
 				  info->bssid);
 		UNLOCK(wl);
 	}
-	if (changed & BSS_CHANGED_BEACON) {
+	if (changed & BSS_CHANGED_BEACON)
 		/* Beacon data changed, retrieve new beacon (beaconing modes) */
 		wiphy_err(wiphy, "%s: beacon changed\n", __func__);
-	}
+
 	if (changed & BSS_CHANGED_BEACON_ENABLED) {
 		/* Beaconing should be enabled/disabled (beaconing modes) */
 		wiphy_err(wiphy, "%s: Beacon enabled: %s\n", __func__,
 			  info->enable_beacon ? "true" : "false");
 	}
+
 	if (changed & BSS_CHANGED_CQM) {
 		/* Connection quality monitor config changed */
 		wiphy_err(wiphy, "%s: cqm change: threshold %d, hys %d "
 			  " (implement)\n", __func__, info->cqm_rssi_thold,
 			  info->cqm_rssi_hyst);
 	}
+
 	if (changed & BSS_CHANGED_IBSS) {
 		/* IBSS join status changed */
 		wiphy_err(wiphy, "%s: IBSS joined: %s (implement)\n", __func__,
 			  info->ibss_joined ? "true" : "false");
 	}
+
 	if (changed & BSS_CHANGED_ARP_FILTER) {
 		/* Hardware ARP filter address list or state changed */
 		wiphy_err(wiphy, "%s: arp filtering: enabled %s, count %d"
 			  " (implement)\n", __func__, info->arp_filter_enabled ?
 			  "true" : "false", info->arp_addr_cnt);
 	}
+
 	if (changed & BSS_CHANGED_QOS) {
 		/*
 		 * QoS for this association was enabled/disabled.
@@ -756,9 +760,8 @@ static struct brcms_info *brcms_attach(u16 vendor, u16 device,
 	unit = n_adapters_found;
 	err = 0;
 
-	if (unit < 0) {
+	if (unit < 0)
 		return NULL;
-	}
 
 	/* allocate private info */
 	hw = pci_get_drvdata(btparam);	/* btparam == pdev */
@@ -815,10 +818,9 @@ static struct brcms_info *brcms_attach(u16 vendor, u16 device,
 
 	wl->pub->ieee_hw = hw;
 
-	if (brcms_c_set_par(wl->wlc, IOV_MPC, 0) < 0) {
+	if (brcms_c_set_par(wl->wlc, IOV_MPC, 0) < 0)
 		wiphy_err(wl->wiphy, "wl%d: Error setting MPC variable to 0\n",
 			  unit);
-	}
 
 	/* register our interrupt handler */
 	if (request_irq(irq, brcms_isr, IRQF_SHARED, KBUILD_MODNAME, wl)) {
@@ -842,19 +844,17 @@ static struct brcms_info *brcms_attach(u16 vendor, u16 device,
 	SET_IEEE80211_PERM_ADDR(hw, perm);
 
 	err = ieee80211_register_hw(hw);
-	if (err) {
+	if (err)
 		wiphy_err(wl->wiphy, "%s: ieee80211_register_hw failed, status"
 			  "%d\n", __func__, err);
-	}
 
 	if (wl->pub->srom_ccode[0])
 		err = brcms_set_hint(wl, wl->pub->srom_ccode);
 	else
 		err = brcms_set_hint(wl, "US");
-	if (err) {
+	if (err)
 		wiphy_err(wl->wiphy, "%s: regulatory_hint failed, status %d\n",
 			  __func__, err);
-	}
 
 	n_adapters_found++;
 	return wl;
@@ -1063,12 +1063,11 @@ static int ieee_hw_rate_init(struct ieee80211_hw *hw)
 	/* Assume all bands use the same phy.  True for 11n devices. */
 	if (NBANDS_PUB(wl->pub) > 1) {
 		has_5g++;
-		if (phy_list[0] == 'n' || phy_list[0] == 'c') {
+		if (phy_list[0] == 'n' || phy_list[0] == 'c')
 			hw->wiphy->bands[IEEE80211_BAND_5GHZ] =
 			    &brcms_band_5GHz_nphy;
-		} else {
+		else
 			return -EPERM;
-		}
 	}
 	return 0;
 }
@@ -1336,9 +1335,8 @@ static void brcms_free(struct brcms_info *wl)
 	/* kill dpc */
 	tasklet_kill(&wl->tasklet);
 
-	if (wl->pub) {
+	if (wl->pub)
 		brcms_c_module_unregister(wl->pub, "linux", wl);
-	}
 
 	/* free common resources */
 	if (wl->wlc) {
@@ -1367,9 +1365,9 @@ static void brcms_free(struct brcms_info *wl)
 	 * so we cannot unmap the chip registers until after calling unregister_netdev() .
 	 */
 	if (wl->regsva && wl->bcm_bustype != SDIO_BUS &&
-	    wl->bcm_bustype != JTAG_BUS) {
+	    wl->bcm_bustype != JTAG_BUS)
 		iounmap((void *)wl->regsva);
-	}
+
 	wl->regsva = NULL;
 }
 
@@ -1557,10 +1555,9 @@ static void brcms_dpc(unsigned long data)
 	/* re-schedule dpc */
 	if (wl->resched)
 		tasklet_schedule(&wl->tasklet);
-	else {
+	else
 		/* re-enable interrupts */
 		brcms_intrson(wl);
-	}
 
  done:
 	UNLOCK(wl);
@@ -1644,10 +1641,10 @@ void brcms_add_timer(struct brcms_info *wl, struct brcms_timer *t, uint ms,
 		     int periodic)
 {
 #ifdef BCMDBG
-	if (t->set) {
+	if (t->set)
 		wiphy_err(wl->wiphy, "%s: Already set. Name: %s, per %d\n",
 			  __func__, t->name, periodic);
-	}
+
 #endif
 	t->ms = ms;
 	t->periodic = (bool) periodic;
@@ -1667,9 +1664,9 @@ bool brcms_del_timer(struct brcms_info *wl, struct brcms_timer *t)
 {
 	if (t->set) {
 		t->set = false;
-		if (!del_timer(&t->timer)) {
+		if (!del_timer(&t->timer))
 			return false;
-		}
+
 		atomic_dec(&wl->callbacks);
 	}
 
diff --git a/drivers/staging/brcm80211/brcmsmac/main.c b/drivers/staging/brcm80211/brcmsmac/main.c
index ebcb7e8..0d80e59 100644
--- a/drivers/staging/brcm80211/brcmsmac/main.c
+++ b/drivers/staging/brcm80211/brcmsmac/main.c
@@ -545,19 +545,18 @@ static void brcms_c_ucode_bsinit(struct brcms_hardware *wlc_hw)
 
 	/* do band-specific ucode IHR, SHM, and SCR inits */
 	if (D11REV_IS(wlc_hw->corerev, 23)) {
-		if (BRCMS_ISNPHY(wlc_hw->band)) {
+		if (BRCMS_ISNPHY(wlc_hw->band))
 			brcms_c_write_inits(wlc_hw, d11n0bsinitvals16);
-		} else {
+		else
 			wiphy_err(wiphy, "%s: wl%d: unsupported phy in corerev"
 				  " %d\n", __func__, wlc_hw->unit,
 				  wlc_hw->corerev);
-		}
 	} else {
 		if (D11REV_IS(wlc_hw->corerev, 24)) {
-			if (BRCMS_ISLCNPHY(wlc_hw->band)) {
+			if (BRCMS_ISLCNPHY(wlc_hw->band))
 				brcms_c_write_inits(wlc_hw,
 						    d11lcn0bsinitvals24);
-			} else
+			else
 				wiphy_err(wiphy, "%s: wl%d: unsupported phy in"
 					  " core rev %d\n", __func__,
 					  wlc_hw->unit, wlc_hw->corerev);
@@ -651,9 +650,8 @@ brcms_b_dotxstatus(struct brcms_hardware *wlc_hw, struct tx_status *txs,
 	 *   transmission count)
 	 */
 	if (!(txs->status & TX_STATUS_AMPDU)
-	    && (txs->status & TX_STATUS_INTERMEDIATE)) {
+	    && (txs->status & TX_STATUS_INTERMEDIATE))
 		return false;
-	}
 
 	return brcms_c_dotxstatus(wlc_hw->wlc, txs, s2);
 }
@@ -747,9 +745,8 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 	/* BCN template is available */
 	/* ZZZ: Use AP_ACTIVE ? */
 	if (AP_ENAB(wlc->pub) && (!APSTA_ENAB(wlc->pub))
-	    && (macintstatus & MI_BCNTPL)) {
+	    && (macintstatus & MI_BCNTPL))
 		brcms_c_update_beacon(wlc);
-	}
 
 	/* tx status */
 	if (macintstatus & MI_TFS) {
@@ -781,9 +778,8 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 		brcms_b_tx_fifo_suspended(wlc_hw, TX_DATA_FIFO);
 
 	/* noise sample collected */
-	if (macintstatus & MI_BG_NOISE) {
+	if (macintstatus & MI_BG_NOISE)
 		wlc_phy_noise_sample_intr(wlc_hw->band->pi);
-	}
 
 	if (macintstatus & MI_GP0) {
 		wiphy_err(wiphy, "wl%d: PSM microcode watchdog fired at %d "
@@ -797,9 +793,8 @@ bool brcms_c_dpc(struct brcms_c_info *wlc, bool bounded)
 	}
 
 	/* gptimer timeout */
-	if (macintstatus & MI_TO) {
+	if (macintstatus & MI_TO)
 		W_REG(&regs->gptimer, 0);
-	}
 
 	if (macintstatus & MI_RFDISABLE) {
 		BCMMSG(wlc->wiphy, "wl%d: BMAC Detected a change on the"
@@ -1142,9 +1137,8 @@ static void brcms_c_write_mhf(struct brcms_hardware *wlc_hw, u16 *mhfs)
 		M_HOST_FLAGS5
 	};
 
-	for (idx = 0; idx < MHFMAX; idx++) {
+	for (idx = 0; idx < MHFMAX; idx++)
 		brcms_b_write_shm(wlc_hw, addr[idx], mhfs[idx]);
-	}
 }
 
 /* set the maccontrol register to desired reset state and
@@ -1400,13 +1394,12 @@ static void brcms_b_upd_synthpu(struct brcms_hardware *wlc_hw)
 	struct brcms_c_info *wlc = wlc_hw->wlc;
 	/* update SYNTHPU_DLY */
 
-	if (BRCMS_ISLCNPHY(wlc->band)) {
+	if (BRCMS_ISLCNPHY(wlc->band))
 		v = SYNTHPU_DLY_LPPHY_US;
-	} else if (BRCMS_ISNPHY(wlc->band) && (NREV_GE(wlc->band->phyrev, 3))) {
+	else if (BRCMS_ISNPHY(wlc->band) && (NREV_GE(wlc->band->phyrev, 3)))
 		v = SYNTHPU_DLY_NPHY_US;
-	} else {
+	else
 		v = SYNTHPU_DLY_BPHY_US;
-	}
 
 	brcms_b_write_shm(wlc_hw, M_SYNTHPU_DLY, v);
 }
@@ -1540,7 +1533,6 @@ void brcms_b_phy_reset(struct brcms_hardware *wlc_hw)
 			       (SICF_PRST | SICF_PCLKE));
 		phy_in_reset = true;
 	} else {
-
 		ai_core_cflags(wlc_hw->sih,
 			       (SICF_PRST | SICF_PCLKE | SICF_BWMASK),
 			       (SICF_PRST | SICF_PCLKE | phy_bw_clkbits));
@@ -1602,10 +1594,9 @@ void brcms_c_setxband(struct brcms_hardware *wlc_hw, uint bandunit)
 	wlc_hw->wlc->band = wlc_hw->wlc->bandstate[bandunit];
 
 	/* set gmode core flag */
-	if (wlc_hw->sbclk && !wlc_hw->noreset) {
+	if (wlc_hw->sbclk && !wlc_hw->noreset)
 		ai_core_cflags(wlc_hw->sih, SICF_GMODE,
 			       ((bandunit == 0) ? SICF_GMODE : 0));
-	}
 }
 
 static bool brcms_c_isgoodchip(struct brcms_hardware *wlc_hw)
@@ -1666,10 +1657,9 @@ static char *brcms_c_get_macaddr(struct brcms_hardware *wlc_hw)
 		varname = "il0macaddr";
 
 	macaddr = getvar(wlc_hw->vars, varname);
-	if (macaddr == NULL) {
+	if (macaddr == NULL)
 		wiphy_err(wlc_hw->wlc->wiphy, "wl%d: wlc_get_macaddr: macaddr "
 			  "getvar(%s) not found\n", wlc_hw->unit, varname);
-	}
 
 	return macaddr;
 }
@@ -1756,18 +1746,16 @@ void brcms_b_corereset(struct brcms_hardware *wlc_hw, u32 flags)
 	/* reset the dma engines except first time thru */
 	if (ai_iscoreup(wlc_hw->sih)) {
 		for (i = 0; i < NFIFO; i++)
-			if ((wlc_hw->di[i]) && (!dma_txreset(wlc_hw->di[i]))) {
+			if ((wlc_hw->di[i]) && (!dma_txreset(wlc_hw->di[i])))
 				wiphy_err(wlc_hw->wlc->wiphy, "wl%d: %s: "
 					  "dma_txreset[%d]: cannot stop dma\n",
 					   wlc_hw->unit, __func__, i);
-			}
 
 		if ((wlc_hw->di[RX_FIFO])
-		    && (!wlc_dma_rxreset(wlc_hw, RX_FIFO))) {
+		    && (!wlc_dma_rxreset(wlc_hw, RX_FIFO)))
 			wiphy_err(wlc_hw->wlc->wiphy, "wl%d: %s: dma_rxreset"
 				  "[%d]: cannot stop dma\n",
 				  wlc_hw->unit, __func__, RX_FIFO);
-		}
 	}
 	/* if noreset, just stop the psm and return */
 	if (wlc_hw->noreset) {
@@ -2120,10 +2108,9 @@ void brcms_b_fifoerrors(struct brcms_hardware *wlc_hw)
 			fatal = true;
 		}
 
-		if (intstatus & I_RU) {
+		if (intstatus & I_RU)
 			wiphy_err(wiphy, "wl%d: fifo %d: receive descriptor "
 				  "underflow\n", idx, unit);
-		}
 
 		if (intstatus & I_XU) {
 			wiphy_err(wiphy, "wl%d: fifo %d: transmit fifo "
@@ -2246,9 +2233,9 @@ static void brcms_b_mute(struct brcms_hardware *wlc_hw, bool on, u32 flags)
 				       null_ether_addr);
 	} else {
 		/* resume tx fifos */
-		if (!wlc_hw->wlc->tx_suspended) {
+		if (!wlc_hw->wlc->tx_suspended)
 			brcms_b_tx_fifo_resume(wlc_hw, TX_DATA_FIFO);
-		}
+
 		brcms_b_tx_fifo_resume(wlc_hw, TX_CTL_FIFO);
 		brcms_b_tx_fifo_resume(wlc_hw, TX_AC_BK_FIFO);
 		brcms_b_tx_fifo_resume(wlc_hw, TX_AC_VI_FIFO);
@@ -2367,7 +2354,7 @@ static inline u32 wlc_intstatus(struct brcms_c_info *wlc, bool in_isr)
 	W_REG(&regs->macintstatus, macintstatus);
 
 	/* MI_DMAINT is indication of non-zero intstatus */
-	if (macintstatus & MI_DMAINT) {
+	if (macintstatus & MI_DMAINT)
 		/*
 		 * only fifo interrupt enabled is I_RI in
 		 * RX_FIFO. If MI_DMAINT is set, assume it
@@ -2375,7 +2362,6 @@ static inline u32 wlc_intstatus(struct brcms_c_info *wlc, bool in_isr)
 		 */
 		W_REG(&regs->intctrlregs[RX_FIFO].intstatus,
 		      DEF_RXINTMASK);
-	}
 
 	return macintstatus;
 }
@@ -2702,10 +2688,9 @@ void brcms_b_core_phypll_ctl(struct brcms_hardware *wlc_hw, bool on)
 
 			tmp = R_REG(&regs->clk_ctl_st);
 			if ((tmp & (CCS_ERSRC_AVAIL_HT)) !=
-			    (CCS_ERSRC_AVAIL_HT)) {
+			    (CCS_ERSRC_AVAIL_HT))
 				wiphy_err(wlc_hw->wlc->wiphy, "%s: turn on PHY"
 					  " PLL failed\n", __func__);
-			}
 		} else {
 			OR_REG(&regs->clk_ctl_st,
 			       (CCS_ERSRC_REQ_D11PLL | CCS_ERSRC_REQ_PHYPLL));
@@ -2719,10 +2704,9 @@ void brcms_b_core_phypll_ctl(struct brcms_hardware *wlc_hw, bool on)
 			if ((tmp &
 			     (CCS_ERSRC_AVAIL_D11PLL | CCS_ERSRC_AVAIL_PHYPLL))
 			    !=
-			    (CCS_ERSRC_AVAIL_D11PLL | CCS_ERSRC_AVAIL_PHYPLL)) {
+			    (CCS_ERSRC_AVAIL_D11PLL | CCS_ERSRC_AVAIL_PHYPLL))
 				wiphy_err(wlc_hw->wlc->wiphy, "%s: turn on "
 					  "PHY PLL failed\n", __func__);
-			}
 		}
 	} else {
 		/* Since the PLL may be shared, other cores can still be requesting it;
@@ -2829,11 +2813,10 @@ brcms_b_read_objmem(struct brcms_hardware *wlc_hw, uint offset, u32 sel)
 
 	W_REG(&regs->objaddr, sel | (offset >> 2));
 	(void)R_REG(&regs->objaddr);
-	if (offset & 2) {
+	if (offset & 2)
 		v = R_REG(objdata_hi);
-	} else {
+	else
 		v = R_REG(objdata_lo);
-	}
 
 	return v;
 }
@@ -2848,11 +2831,10 @@ brcms_b_write_objmem(struct brcms_hardware *wlc_hw, uint offset, u16 v,
 
 	W_REG(&regs->objaddr, sel | (offset >> 2));
 	(void)R_REG(&regs->objaddr);
-	if (offset & 2) {
+	if (offset & 2)
 		W_REG(objdata_hi, v);
-	} else {
+	else
 		W_REG(objdata_lo, v);
-	}
 }
 
 /* Copy a buffer to shared memory of specified type .
@@ -2937,9 +2919,8 @@ void brcms_b_pllreq(struct brcms_hardware *wlc_hw, bool set, u32 req_bit)
 		mboolset(wlc_hw->pllreq, req_bit);
 
 		if (mboolisset(wlc_hw->pllreq, BRCMS_PLLREQ_FLIP)) {
-			if (!wlc_hw->sbclk) {
+			if (!wlc_hw->sbclk)
 				brcms_b_xtal(wlc_hw, ON);
-			}
 		}
 	} else {
 		if (!mboolisset(wlc_hw->pllreq, req_bit))
@@ -2948,9 +2929,8 @@ void brcms_b_pllreq(struct brcms_hardware *wlc_hw, bool set, u32 req_bit)
 		mboolclr(wlc_hw->pllreq, req_bit);
 
 		if (mboolisset(wlc_hw->pllreq, BRCMS_PLLREQ_FLIP)) {
-			if (wlc_hw->sbclk) {
+			if (wlc_hw->sbclk)
 				brcms_b_xtal(wlc_hw, OFF);
-			}
 		}
 	}
 
@@ -3111,22 +3091,20 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
 				  " %d\n", __func__, wlc_hw->unit,
 				  wlc_hw->corerev);
 	} else if (D11REV_IS(wlc_hw->corerev, 24)) {
-		if (BRCMS_ISLCNPHY(wlc_hw->band)) {
+		if (BRCMS_ISLCNPHY(wlc_hw->band))
 			brcms_c_write_inits(wlc_hw, d11lcn0initvals24);
-		} else {
+		else
 			wiphy_err(wiphy, "%s: wl%d: unsupported phy in corerev"
 				  " %d\n", __func__, wlc_hw->unit,
 				  wlc_hw->corerev);
-		}
 	} else {
 		wiphy_err(wiphy, "%s: wl%d: unsupported corerev %d\n",
 			  __func__, wlc_hw->unit, wlc_hw->corerev);
 	}
 
 	/* For old ucode, txfifo sizes needs to be modified(increased) */
-	if (fifosz_fixup == true) {
+	if (fifosz_fixup == true)
 		brcms_b_corerev_fifofixup(wlc_hw);
-	}
 
 	/* check txfifo allocations match between ucode and driver */
 	buf[TX_AC_BE_FIFO] = brcms_b_read_shm(wlc_hw, M_FIFOSIZE0);
@@ -3161,11 +3139,10 @@ static void brcms_b_coreinit(struct brcms_c_info *wlc)
 		i = TX_ATIM_FIFO;
 		err = -1;
 	}
-	if (err != 0) {
+	if (err != 0)
 		wiphy_err(wiphy, "wlc_coreinit: txfifo mismatch: ucode size %d"
 			  " driver size %d index %d\n", buf[i],
 			  wlc_hw->xmtfifo_sz[i], i);
-	}
 
 	/* make sure we can still talk to the mac */
 	WARN_ON(R_REG(&regs->maccontrol) == 0xffffffff);
@@ -3409,10 +3386,9 @@ void brcms_c_init(struct brcms_c_info *wlc)
 		/* Uninitialized; read from HW */
 		int ac;
 
-		for (ac = 0; ac < AC_COUNT; ac++) {
+		for (ac = 0; ac < AC_COUNT; ac++)
 			wlc->wme_retries[ac] =
 			    brcms_c_read_shm(wlc, M_AC_TXLMT_ADDR(ac));
-		}
 	}
 }
 
@@ -3487,10 +3463,9 @@ int brcms_c_set_mac(struct brcms_bss_cfg *cfg)
 	int err = 0;
 	struct brcms_c_info *wlc = cfg->wlc;
 
-	if (cfg == wlc->cfg) {
+	if (cfg == wlc->cfg)
 		/* enter the MAC addr into the RXE match registers */
 		brcms_c_set_addrmatch(wlc, RCM_MAC_OFFSET, cfg->cur_etheraddr);
-	}
 
 	brcms_c_ampdu_macaddr_upd(wlc);
 
@@ -3505,13 +3480,12 @@ void brcms_c_set_bssid(struct brcms_bss_cfg *cfg)
 	struct brcms_c_info *wlc = cfg->wlc;
 
 	/* if primary config, we need to update BSSID in RXE match registers */
-	if (cfg == wlc->cfg) {
+	if (cfg == wlc->cfg)
 		brcms_c_set_addrmatch(wlc, RCM_BSSID_OFFSET, cfg->BSSID);
-	}
 #ifdef SUPPORT_HWKEYS
-	else if (BSSCFG_STA(cfg) && cfg->BSS) {
+	else if (BSSCFG_STA(cfg) && cfg->BSS)
 		brcms_c_rcmta_add_bssid(wlc, cfg);
-	}
+
 #endif
 }
 
@@ -3741,9 +3715,9 @@ u32 brcms_c_lowest_basic_rspec(struct brcms_c_info *wlc,
 	}
 #if NCONF
 	/* pick siso/cdd as default for OFDM (note no basic rate MCSs are supported yet) */
-	if (IS_OFDM(lowest_basic_rspec)) {
+	if (IS_OFDM(lowest_basic_rspec))
 		lowest_basic_rspec |= (wlc->stf->ss_opmode << RSPEC_STF_SHIFT);
-	}
+
 #endif
 
 	return lowest_basic_rspec;
@@ -3865,10 +3839,9 @@ static void brcms_c_ucode_mac_upd(struct brcms_c_info *wlc)
 			 * to set up a beacon for testing, the test routines should write it down,
 			 * not expect the inits to populate a bogus beacon.
 			 */
-			if (BRCMS_PHY_11N_CAP(wlc->band)) {
+			if (BRCMS_PHY_11N_CAP(wlc->band))
 				brcms_c_write_shm(wlc, M_BCN_TXTSF_OFFSET,
 					      wlc->band->bcntsfoff);
-			}
 		}
 	} else {
 		/* disable an active IBSS if we are not on the home channel */
@@ -4403,10 +4376,10 @@ int brcms_b_attach(struct brcms_c_info *wlc, u16 vendor, u16 device, uint unit,
 
 	/* check device id(srom, nvram etc.) to set bands */
 	if (wlc_hw->deviceid == BCM43224_D11N_ID ||
-	    wlc_hw->deviceid == BCM43224_D11N_ID_VEN1) {
+	    wlc_hw->deviceid == BCM43224_D11N_ID_VEN1)
 		/* Dualband boards */
 		wlc_hw->_nbands = 2;
-	} else
+	else
 		wlc_hw->_nbands = 1;
 
 	if ((wlc_hw->sih->chip == BCM43225_CHIP_ID))
@@ -5070,11 +5043,10 @@ static void brcms_c_radio_hwdisable_upd(struct brcms_c_info *wlc)
 	if (wlc->pub->wlfeatureflag & WL_SWFL_NOHWRADIO || wlc->pub->hw_off)
 		return;
 
-	if (brcms_b_radio_read_hwdisabled(wlc->hw)) {
+	if (brcms_b_radio_read_hwdisabled(wlc->hw))
 		mboolset(wlc->pub->radio_disabled, WL_RADIO_HW_DISABLE);
-	} else {
+	else
 		mboolclr(wlc->pub->radio_disabled, WL_RADIO_HW_DISABLE);
-	}
 }
 
 /* return true if Minimum Power Consumption should be entered, false otherwise */
@@ -5134,9 +5106,9 @@ void brcms_c_radio_mpc_upd(struct brcms_c_info *wlc)
 	 * wlc->mpc_delay_off to wlc->mpc_dlycnt, so that we restart the countdown of mpc_delay_off
 	 */
 	if ((wlc->prev_non_delay_mpc == false) &&
-	    (brcms_c_is_non_delay_mpc(wlc) == true) && wlc->mpc_delay_off) {
+	    (brcms_c_is_non_delay_mpc(wlc) == true) && wlc->mpc_delay_off)
 		wlc->mpc_delay_off = wlc->mpc_dlycnt;
-	}
+
 	wlc->prev_non_delay_mpc = brcms_c_is_non_delay_mpc(wlc);
 }
 
@@ -5146,11 +5118,10 @@ void brcms_c_radio_mpc_upd(struct brcms_c_info *wlc)
  */
 static void brcms_c_radio_upd(struct brcms_c_info *wlc)
 {
-	if (wlc->pub->radio_disabled) {
+	if (wlc->pub->radio_disabled)
 		brcms_c_radio_disable(wlc);
-	} else {
+	else
 		brcms_c_radio_enable(wlc);
-	}
 }
 
 /* maintain LED behavior in down state */
@@ -5316,12 +5287,10 @@ static void brcms_c_watchdog(void *arg)
 
 	/* Manage TKIP countermeasures timers */
 	FOREACH_BSS(wlc, i, cfg)
-		if (cfg->tk_cm_dt) {
+		if (cfg->tk_cm_dt)
 			cfg->tk_cm_dt--;
-		}
-		if (cfg->tk_cm_bt) {
+		if (cfg->tk_cm_bt)
 			cfg->tk_cm_bt--;
-		}
 	END_FOREACH_BSS
 
 	/* Call any registered watchdog handlers */
@@ -5453,13 +5422,12 @@ int brcms_c_up(struct brcms_c_info *wlc)
 	if ((wlc->pub->boardflags & BFL_FEM)
 	    && (wlc->pub->sih->chip == BCM4313_CHIP_ID)) {
 		if (wlc->pub->boardrev >= 0x1250
-		    && (wlc->pub->boardflags & BFL_FEM_BT)) {
+		    && (wlc->pub->boardflags & BFL_FEM_BT))
 			brcms_c_mhf(wlc, MHF5, MHF5_4313_GPIOCTRL,
 				MHF5_4313_GPIOCTRL, BRCM_BAND_ALL);
-		} else {
+		else
 			brcms_c_mhf(wlc, MHF4, MHF4_EXTPA_ENABLE,
 				    MHF4_EXTPA_ENABLE, BRCM_BAND_ALL);
-		}
 	}
 
 	/*
@@ -5504,11 +5472,10 @@ int brcms_c_up(struct brcms_c_info *wlc)
 	brcms_c_radio_monitor_stop(wlc);
 
 	/* Set EDCF hostflags */
-	if (EDCF_ENAB(wlc->pub)) {
+	if (EDCF_ENAB(wlc->pub))
 		brcms_c_mhf(wlc, MHF1, MHF1_EDCF, MHF1_EDCF, BRCM_BAND_ALL);
-	} else {
+	else
 		brcms_c_mhf(wlc, MHF1, MHF1_EDCF, 0, BRCM_BAND_ALL);
-	}
 
 	if (BRCMS_WAR16165(wlc))
 		brcms_c_mhf(wlc, MHF2, MHF2_PCISLOWCLKWAR, MHF2_PCISLOWCLKWAR,
@@ -5699,9 +5666,8 @@ uint brcms_c_down(struct brcms_c_info *wlc)
 	brcms_c_txflowcontrol_reset(wlc);
 
 	/* flush tx queues */
-	for (qi = wlc->tx_queues; qi != NULL; qi = qi->next) {
+	for (qi = wlc->tx_queues; qi != NULL; qi = qi->next)
 		brcmu_pktq_flush(&qi->q, true, NULL, NULL);
-	}
 
 	callbacks += brcms_b_down_finish(wlc->hw);
 
@@ -5813,21 +5779,19 @@ int brcms_c_set_gmode(struct brcms_c_info *wlc, u8 gmode, bool config)
 			band->rspec_override = 0;
 			brcms_c_reprate_init(wlc);
 		}
-		if (band->mrspec_override && !IS_CCK(band->mrspec_override)) {
+		if (band->mrspec_override && !IS_CCK(band->mrspec_override))
 			band->mrspec_override = 0;
-		}
 	}
 
 	band->gmode = gmode;
 
 	wlc->shortslot_override = shortslot;
 
-	if (AP_ENAB(wlc->pub)) {
+	if (AP_ENAB(wlc->pub))
 		/* wlc->ap->shortslot_restrict = shortslot_restrict; */
 		wlc->PLCPHdr_override =
 		    (preamble !=
 		     BRCMS_PLCP_LONG) ? BRCMS_PLCP_SHORT : BRCMS_PLCP_AUTO;
-	}
 
 	if ((AP_ENAB(wlc->pub) && preamble != BRCMS_PLCP_LONG)
 	    || preamble == BRCMS_PLCP_SHORT)
@@ -6115,9 +6079,9 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 
 			brcms_b_retrylimit_upd(wlc->hw, wlc->SRL, wlc->LRL);
 
-			for (ac = 0; ac < AC_COUNT; ac++) {
+			for (ac = 0; ac < AC_COUNT; ac++)
 				BRCMS_WME_RETRY_SHORT_SET(wlc, ac, wlc->SRL);
-			}
+
 			brcms_c_wme_retries_write(wlc);
 		} else
 			bcmerror = -EINVAL;
@@ -6130,9 +6094,9 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 
 			brcms_b_retrylimit_upd(wlc->hw, wlc->SRL, wlc->LRL);
 
-			for (ac = 0; ac < AC_COUNT; ac++) {
+			for (ac = 0; ac < AC_COUNT; ac++)
 				BRCMS_WME_RETRY_LONG_SET(wlc, ac, wlc->LRL);
-			}
+
 			brcms_c_wme_retries_write(wlc);
 		} else
 			bcmerror = -EINVAL;
@@ -6250,13 +6214,12 @@ _brcms_c_ioctl(struct brcms_c_info *wlc, int cmd, void *arg, int len,
 		} else {
 			/* driver is down, so just update the brcms_c_info
 			 * value */
-			if (wlc->shortslot_override == BRCMS_SHORTSLOT_AUTO) {
+			if (wlc->shortslot_override == BRCMS_SHORTSLOT_AUTO)
 				wlc->shortslot = false;
-			} else {
+			else
 				wlc->shortslot =
 				    (wlc->shortslot_override ==
 				     BRCMS_SHORTSLOT_ON);
-			}
 		}
 
 		break;
@@ -6326,10 +6289,9 @@ static void brcms_c_wme_retries_write(struct brcms_c_info *wlc)
 	if (!wlc->clk)
 		return;
 
-	for (ac = 0; ac < AC_COUNT; ac++) {
+	for (ac = 0; ac < AC_COUNT; ac++)
 		brcms_c_write_shm(wlc, M_AC_TXLMT_ADDR(ac),
 				  wlc->wme_retries[ac]);
-	}
 }
 
 #ifdef BCMDBG
@@ -6431,9 +6393,8 @@ void brcms_c_statsupd(struct brcms_c_info *wlc)
 
 	/* merge counters from dma module */
 	for (i = 0; i < NFIFO; i++) {
-		if (wlc->hw->di[i]) {
+		if (wlc->hw->di[i])
 			dma_counterreset(wlc->hw->di[i]);
-		}
 	}
 }
 
@@ -6705,14 +6666,12 @@ void brcms_c_txq_enq(void *ctx, struct scb *scb, struct sk_buff *sdu,
 	 */
 	if (!EDCF_ENAB(wlc->pub)
 	    || (wlc->pub->wlfeatureflag & WL_SWFL_FLOWCONTROL)) {
-		if (pktq_len(q) >= wlc->pub->tunables->datahiwat) {
+		if (pktq_len(q) >= wlc->pub->tunables->datahiwat)
 			brcms_c_txflowcontrol(wlc, qi, ON, ALLPRIO);
-		}
 	} else if (wlc->pub->_priofc) {
 		if (pktq_plen(q, wlc_prio2prec_map[prio]) >=
-		    wlc->pub->tunables->datahiwat) {
+		    wlc->pub->tunables->datahiwat)
 			brcms_c_txflowcontrol(wlc, qi, ON, prio);
-		}
 	}
 }
 
@@ -6769,10 +6728,9 @@ void brcms_c_send_q(struct brcms_c_info *wlc)
 			count = 1;
 			err = brcms_c_prep_pdu(wlc, pkt[0], &fifo);
 			if (!err) {
-				for (i = 0; i < count; i++) {
+				for (i = 0; i < count; i++)
 					brcms_c_txfifo(wlc, fifo, pkt[i], true,
 						       1);
-				}
 			}
 		}
 
@@ -6791,17 +6749,15 @@ void brcms_c_send_q(struct brcms_c_info *wlc)
 	if (!EDCF_ENAB(wlc->pub)
 	    || (wlc->pub->wlfeatureflag & WL_SWFL_FLOWCONTROL)) {
 		if (brcms_c_txflowcontrol_prio_isset(wlc, qi, ALLPRIO)
-		    && (pktq_len(q) < wlc->pub->tunables->datahiwat / 2)) {
+		    && (pktq_len(q) < wlc->pub->tunables->datahiwat / 2))
 			brcms_c_txflowcontrol(wlc, qi, OFF, ALLPRIO);
-		}
 	} else if (wlc->pub->_priofc) {
 		int prio;
 		for (prio = MAXPRIO; prio >= 0; prio--) {
 			if (brcms_c_txflowcontrol_prio_isset(wlc, qi, prio) &&
 			    (pktq_plen(q, wlc_prio2prec_map[prio]) <
-			     wlc->pub->tunables->datahiwat / 2)) {
+			    wlc->pub->tunables->datahiwat / 2))
 				brcms_c_txflowcontrol(wlc, qi, OFF, prio);
-			}
 		}
 	}
 	in_send_q = false;
@@ -6840,11 +6796,9 @@ brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
 	/* When a BC/MC frame is being committed to the BCMC fifo via DMA (NOT PIO), update
 	 * ucode or BSS info as appropriate.
 	 */
-	if (fifo == TX_BCMC_FIFO) {
+	if (fifo == TX_BCMC_FIFO)
 		frameid = le16_to_cpu(txh->TxFrameID);
 
-	}
-
 	if (BRCMS_WAR16165(wlc))
 		brcms_c_war16165(wlc, true);
 
@@ -6862,22 +6816,20 @@ brcms_c_txfifo(struct brcms_c_info *wlc, uint fifo, struct sk_buff *p,
 	if (frameid != INVALIDFID)
 		BCMCFID(wlc, frameid);
 
-	if (dma_txfast(wlc->hw->di[fifo], p, commit) < 0) {
+	if (dma_txfast(wlc->hw->di[fifo], p, commit) < 0)
 		wiphy_err(wlc->wiphy, "txfifo: fatal, toss frames !!!\n");
-	}
 }
 
 void
 brcms_c_compute_plcp(struct brcms_c_info *wlc, u32 rspec,
 		     uint length, u8 *plcp)
 {
-	if (IS_MCS(rspec)) {
+	if (IS_MCS(rspec))
 		brcms_c_compute_mimo_plcp(rspec, length, plcp);
-	} else if (IS_OFDM(rspec)) {
+	else if (IS_OFDM(rspec))
 		brcms_c_compute_ofdm_plcp(rspec, length, plcp);
-	} else {
+	else
 		brcms_c_compute_cck_plcp(wlc, rspec, length, plcp);
-	}
 	return;
 }
 
@@ -7032,12 +6984,14 @@ brcms_c_compute_rtscts_dur(struct brcms_c_info *wlc, bool cts_only,
 
 	sifs = SIFS(wlc->band);
 
-	if (!cts_only) {	/* RTS/CTS */
+	if (!cts_only) {
+		/* RTS/CTS */
 		dur = 3 * sifs;
 		dur +=
 		    (u16) brcms_c_calc_cts_time(wlc, rts_rate,
 					       rts_preamble_type);
-	} else {		/* CTS-TO-SELF */
+	} else {
+		/* CTS-TO-SELF */
 		dur = 2 * sifs;
 	}
 
@@ -7108,11 +7062,10 @@ brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc, u32 rspec,
 {
 	u32 rts_rspec = 0;
 
-	if (use_rspec) {
+	if (use_rspec)
 		/* use frame rate as rts rate */
 		rts_rspec = rspec;
-
-	} else if (wlc->band->gmode && wlc->protection->_g && !IS_CCK(rspec)) {
+	else if (wlc->band->gmode && wlc->protection->_g && !IS_CCK(rspec))
 		/* Use 11Mbps as the g protection RTS target rate and fallback.
 		 * Use the BRCMS_BASIC_RATE() lookup to find the best basic rate
 		 * under the target in case 11 Mbps is not Basic.
@@ -7120,13 +7073,12 @@ brcms_c_rspec_to_rts_rspec(struct brcms_c_info *wlc, u32 rspec,
 		 * if the OFDM rate we are protecting is 6 or 9 Mbps, 11 is more robust.
 		 */
 		rts_rspec = BRCMS_BASIC_RATE(wlc, BRCM_RATE_11M);
-	} else {
+	else
 		/* calculate RTS rate and fallback rate based on the frame rate
 		 * RTS must be sent at a basic rate since it is a
 		 * control frame, sec 9.6 of 802.11 spec
 		 */
 		rts_rspec = BRCMS_BASIC_RATE(wlc, rspec);
-	}
 
 	if (BRCMS_PHY_11N_CAP(wlc->band)) {
 		/* set rts txbw to correct side band */
@@ -7210,9 +7162,8 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	 * the packet itself, thus phylen = packet length + ICV_LEN + FCS_LEN
 	 * in this case
 	 */
-	if (key) {
+	if (key)
 		phylen += key->icv_len;
-	}
 
 	/* Get tx_info */
 	tx_info = IEEE80211_SKB_CB(p);
@@ -7233,9 +7184,8 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 			frameid = bcmc_fid_generate(wlc, NULL, txh);
 		} else {
 			/* Increment the counter for first fragment */
-			if (tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT) {
+			if (tx_info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
 				SCB_SEQNUM(scb, p->priority)++;
-			}
 
 			/* extract fragment number from frame first */
 			seq = le16_to_cpu(seq) & FRAGNUM_MASK;
@@ -7256,9 +7206,8 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 	txrate[1] = txrate[0] + 1;
 
 	/* if rate control algorithm didn't give us a fallback rate, use the primary rate */
-	if (txrate[1]->idx < 0) {
+	if (txrate[1]->idx < 0)
 		txrate[1] = txrate[0];
-	}
 
 	for (k = 0; k < hw->max_rates; k++) {
 		is_mcs[k] =
@@ -7280,6 +7229,7 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 		} else {
 			rate_val[k] = txrate[k]->idx;
 		}
+
 		/* Currently only support same setting for primay and fallback rates.
 		 * Unify flags for each rate into a single value for the frame
 		 */
@@ -7355,18 +7305,17 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 				} else if (IS_OFDM(rspec[k])) {
 					if (wlc->ofdm_40txbw != AUTO)
 						mimo_txbw = wlc->ofdm_40txbw;
-				} else {
-					if (wlc->cck_40txbw != AUTO)
-						mimo_txbw = wlc->cck_40txbw;
+				} else if (wlc->cck_40txbw != AUTO) {
+					mimo_txbw = wlc->cck_40txbw;
 				}
 			} else {
 				/* mcs32 is 40 b/w only.
 				 * This is possible for probe packets on a STA during SCAN
 				 */
-				if ((rspec[k] & RSPEC_RATE_MASK) == 32) {
+				if ((rspec[k] & RSPEC_RATE_MASK) == 32)
 					/* mcs 0 */
 					rspec[k] = RSPEC_MIMORATE;
-				}
+
 				mimo_txbw = PHY_TXC1_BW_20MHZ;
 			}
 
@@ -7405,9 +7354,8 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 				/* if SGI is selected, then forced mm for single stream */
 				if ((rspec[k] & RSPEC_SHORT_GI)
 				    && IS_SINGLE_STREAM(rspec[k] &
-							RSPEC_RATE_MASK)) {
+							RSPEC_RATE_MASK))
 					preamble_type[k] = BRCMS_MM_PREAMBLE;
-				}
 			}
 
 			/* should be better conditionalized */
@@ -7635,10 +7583,10 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 
 #ifdef SUPPORT_40MHZ
 	/* add null delimiter count */
-	if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && IS_MCS(rspec)) {
+	if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && IS_MCS(rspec))
 		txh->RTSPLCPFallback[AMPDU_FBR_NULL_DELIM] =
 		   brcm_c_ampdu_null_delim_cnt(wlc->ampdu, scb, rspec, phylen);
-	}
+
 #endif
 
 	/* Now that RTS/RTS FB preamble types are updated, write the final value */
@@ -7751,34 +7699,32 @@ brcms_c_d11hdrs_mac80211(struct brcms_c_info *wlc, struct ieee80211_hw *hw,
 
 			/* update txop byte threshold (txop minus intraframe overhead) */
 			if (wlc->edcf_txop[ac] >= (dur - frag_dur)) {
-				{
-					uint newfragthresh;
-
+				uint newfragthresh;
+
+				newfragthresh =
+				    brcms_c_calc_frame_len(wlc,
+					rspec[0], preamble_type[0],
+					(wlc->edcf_txop[ac] -
+						(dur - frag_dur)));
+				/* range bound the fragthreshold */
+				if (newfragthresh < DOT11_MIN_FRAG_LEN)
 					newfragthresh =
-					    brcms_c_calc_frame_len(wlc,
-						rspec[0], preamble_type[0],
-						(wlc->edcf_txop[ac] -
-							(dur - frag_dur)));
-					/* range bound the fragthreshold */
-					if (newfragthresh < DOT11_MIN_FRAG_LEN)
-						newfragthresh =
-						    DOT11_MIN_FRAG_LEN;
-					else if (newfragthresh >
-						 wlc->usr_fragthresh)
-						newfragthresh =
-						    wlc->usr_fragthresh;
-					/* update the fragthresh and do txc update */
-					if (wlc->fragthresh[queue] !=
-					    (u16) newfragthresh) {
-						wlc->fragthresh[queue] =
-						    (u16) newfragthresh;
-					}
-				}
-			} else
+					    DOT11_MIN_FRAG_LEN;
+				else if (newfragthresh >
+					 wlc->usr_fragthresh)
+					newfragthresh =
+					    wlc->usr_fragthresh;
+				/* update the fragthresh and do txc update */
+				if (wlc->fragthresh[queue] !=
+				    (u16) newfragthresh)
+					wlc->fragthresh[queue] =
+					    (u16) newfragthresh;
+			} else {
 				wiphy_err(wlc->wiphy, "wl%d: %s txop invalid "
 					  "for rate %d\n",
 					  wlc->pub->unit, fifo_names[queue],
 					  RSPEC2RATE(rspec[0]));
+			}
 
 			if (dur > wlc->edcf_txop[ac])
 				wiphy_err(wlc->wiphy, "wl%d: %s: %s txop "
@@ -7797,10 +7743,9 @@ void brcms_c_tbtt(struct brcms_c_info *wlc)
 {
 	struct brcms_bss_cfg *cfg = wlc->cfg;
 
-	if (!cfg->BSS) {
+	if (!cfg->BSS)
 		/* DirFrmQ is now valid...defer setting until end of ATIM window */
 		wlc->qvalid |= MCMD_DIRFRMQVAL;
-	}
 }
 
 static void brcms_c_war16165(struct brcms_c_info *wlc, bool tx)
@@ -7991,9 +7936,8 @@ brcms_c_txfifo_complete(struct brcms_c_info *wlc, uint fifo, s8 txpktpend)
 
 	/* Clear MHF2_TXBCMC_NOW flag if BCMC fifo has drained */
 	if (AP_ENAB(wlc->pub) &&
-	    !TXPKTPENDGET(wlc, TX_BCMC_FIFO)) {
+	    !TXPKTPENDGET(wlc, TX_BCMC_FIFO))
 		brcms_c_mhf(wlc, MHF2, MHF2_TXBCMC_NOW, 0, BRCM_BAND_AUTO);
-	}
 
 	/* figure out which bsscfg is being worked on... */
 }
@@ -8252,9 +8196,8 @@ void brcms_c_recv(struct brcms_c_info *wlc, struct sk_buff *p)
 	}
 
 	/* check received pkt has at least frame control field */
-	if (len < D11_PHY_HDR_LEN + sizeof(h->frame_control)) {
+	if (len < D11_PHY_HDR_LEN + sizeof(h->frame_control))
 		goto toss;
-	}
 
 	is_amsdu = rxh->RxStatus2 & RXS_AMSDU_MASK;
 
@@ -8659,12 +8602,11 @@ void brcms_c_set_ratetable(struct brcms_c_info *wlc)
 		 * which a response ACK/CTS should be sent.
 		 */
 		basic_rate = BRCMS_BASIC_RATE(wlc, rate);
-		if (basic_rate == 0) {
+		if (basic_rate == 0)
 			/* This should only happen if we are using a
 			 * restricted rateset.
 			 */
 			basic_rate = rs.rates[0] & BRCMS_RATE_MASK;
-		}
 
 		brcms_c_write_rate_shm(wlc, rate, basic_rate);
 	}
@@ -8680,14 +8622,13 @@ bool brcms_c_valid_rate(struct brcms_c_info *wlc, u32 rspec, int band,
 	struct brcms_c_rateset *hw_rateset;
 	uint i;
 
-	if ((band == BRCM_BAND_AUTO) || (band == wlc->band->bandtype)) {
+	if ((band == BRCM_BAND_AUTO) || (band == wlc->band->bandtype))
 		hw_rateset = &wlc->band->hw_rateset;
-	} else if (NBANDS(wlc) > 1) {
+	else if (NBANDS(wlc) > 1)
 		hw_rateset = &wlc->bandstate[OTHERBANDUNIT(wlc)]->hw_rateset;
-	} else {
+	else
 		/* other band specified and we are a single band device */
 		return false;
-	}
 
 	/* check if this is a mimo rate */
 	if (IS_MCS(rspec)) {
@@ -8701,10 +8642,9 @@ bool brcms_c_valid_rate(struct brcms_c_info *wlc, u32 rspec, int band,
 		if (hw_rateset->rates[i] == RSPEC2RATE(rspec))
 			return true;
  error:
-	if (verbose) {
+	if (verbose)
 		wiphy_err(wlc->wiphy, "wl%d: valid_rate: rate spec 0x%x "
 			  "not in hw_rateset\n", wlc->pub->unit, rspec);
-	}
 
 	return false;
 }
@@ -8809,13 +8749,12 @@ brcms_c_bcn_prb_template(struct brcms_c_info *wlc, u16 type,
 	plcp = (struct cck_phy_hdr *) buf;
 
 	/* PLCP for Probe Response frames are filled in from core's rate table */
-	if (type == IEEE80211_STYPE_BEACON && !MBSS_BCN_ENAB(cfg)) {
+	if (type == IEEE80211_STYPE_BEACON && !MBSS_BCN_ENAB(cfg))
 		/* fill in PLCP */
 		brcms_c_compute_plcp(wlc, bcn_rspec,
 				 (DOT11_MAC_HDR_LEN + body_len + FCS_LEN),
 				 (u8 *) plcp);
 
-	}
 	/* "Regular" and 16 MBSS but not for 4 MBSS */
 	/* Update the phytxctl for the beacon based on the rspec */
 	if (!SOFTBCN_ENAB(cfg))
@@ -8880,9 +8819,9 @@ void brcms_c_bss_update_beacon(struct brcms_c_info *wlc,
 	/* Clear the soft intmask */
 	wlc->defmacintmask &= ~MI_BCNTPL;
 
-	if (!cfg->up) {		/* Only allow updates on an UP bss */
+	if (!cfg->up)
+		/* Only allow updates on an UP bss */
 		return;
-	}
 
 	/* Optimize:  Some of if/else could be combined */
 	if (!MBSS_BCN_ENAB(cfg) && HWBCN_ENAB(cfg)) {
@@ -8894,10 +8833,10 @@ void brcms_c_bss_update_beacon(struct brcms_c_info *wlc,
 		/* Check if both templates are in use, if so sched. an interrupt
 		 *      that will call back into this routine
 		 */
-		if ((R_REG(&regs->maccommand) & both_valid) == both_valid) {
+		if ((R_REG(&regs->maccommand) & both_valid) == both_valid)
 			/* clear any previous status */
 			W_REG(&regs->macintstatus, MI_BCNTPL);
-		}
+
 		/* Check that after scheduling the interrupt both of the
 		 *      templates are still busy. if not clear the int. & remask
 		 */
@@ -9103,9 +9042,8 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 				  == NRATE_OVERRIDE_MCS_ONLY);
 	int bcmerror = 0;
 
-	if (!ismcs) {
+	if (!ismcs)
 		return (u32) rate;
-	}
 
 	/* validate the combination of rate/mcs/stf is allowed */
 	if (N_ENAB(wlc->pub) && ismcs) {
@@ -9196,9 +9134,8 @@ mac80211_wlc_set_nrate(struct brcms_c_info *wlc, struct brcms_band *cur_band,
 		rspec |= RSPEC_SHORT_GI;
 
 	if ((rate != 0)
-	    && !brcms_c_valid_rate(wlc, rspec, cur_band->bandtype, true)) {
+	    && !brcms_c_valid_rate(wlc, rspec, cur_band->bandtype, true))
 		return rate;
-	}
 
 	return rspec;
 done:
@@ -9329,11 +9266,10 @@ brcms_c_txflowcontrol_prio_isset(struct brcms_c_info *wlc,
 {
 	uint prio_mask;
 
-	if (prio == ALLPRIO) {
+	if (prio == ALLPRIO)
 		prio_mask = TXQ_STOP_FOR_PRIOFC_MASK;
-	} else {
+	else
 		prio_mask = NBITVAL(prio);
-	}
 
 	return (q->stopped & prio_mask) == prio_mask;
 }
@@ -9348,11 +9284,10 @@ void brcms_c_txflowcontrol(struct brcms_c_info *wlc,
 
 	BCMMSG(wlc->wiphy, "flow control kicks in\n");
 
-	if (prio == ALLPRIO) {
+	if (prio == ALLPRIO)
 		prio_bits = TXQ_STOP_FOR_PRIOFC_MASK;
-	} else {
+	else
 		prio_bits = NBITVAL(prio);
-	}
 
 	cur_bits = qi->stopped & prio_bits;
 
@@ -9360,23 +9295,22 @@ void brcms_c_txflowcontrol(struct brcms_c_info *wlc,
 	 * Otherwise update the bit and continue
 	 */
 	if (on) {
-		if (cur_bits == prio_bits) {
+		if (cur_bits == prio_bits)
 			return;
-		}
+
 		mboolset(qi->stopped, prio_bits);
 	} else {
-		if (cur_bits == 0) {
+		if (cur_bits == 0)
 			return;
-		}
+
 		mboolclr(qi->stopped, prio_bits);
 	}
 
 	/* If there is a flow control override we will not change the external
 	 * flow control state.
 	 */
-	if (qi->stopped & ~TXQ_STOP_FOR_PRIOFC_MASK) {
+	if (qi->stopped & ~TXQ_STOP_FOR_PRIOFC_MASK)
 		return;
-	}
 
 	brcms_c_txflowcontrol_signal(wlc, qi, on, prio);
 }
@@ -9398,9 +9332,8 @@ brcms_c_txflowcontrol_override(struct brcms_c_info *wlc,
 		/* if there was a previous override bit on, then setting this
 		 * makes no difference.
 		 */
-		if (prev_override) {
+		if (prev_override)
 			return;
-		}
 
 		brcms_c_txflowcontrol_signal(wlc, qi, ON, ALLPRIO);
 	} else {
@@ -9409,9 +9342,8 @@ brcms_c_txflowcontrol_override(struct brcms_c_info *wlc,
 		 * flow control if it was the only bit set. For any other
 		 * override setting, just return
 		 */
-		if (prev_override != override) {
+		if (prev_override != override)
 			return;
-		}
 
 		if (qi->stopped == 0) {
 			brcms_c_txflowcontrol_signal(wlc, qi, OFF, ALLPRIO);
@@ -9555,9 +9487,8 @@ void brcms_c_wait_for_tx_completion(struct brcms_c_info *wlc, bool drop)
 
 	/* wait for queue and DMA fifos to run dry */
 	while (!pktq_empty(&wlc->pkt_queue->q) ||
-	       TXPKTPENDTOT(wlc) > 0) {
+	       TXPKTPENDTOT(wlc) > 0)
 		brcms_msleep(wlc->wl, 1);
-	}
 }
 
 int brcms_c_set_par(struct brcms_c_info *wlc, enum wlc_par_id par_id,
diff --git a/drivers/staging/brcm80211/brcmsmac/nicpci.c b/drivers/staging/brcm80211/brcmsmac/nicpci.c
index 6d6e7d3..ab67546 100644
--- a/drivers/staging/brcm80211/brcmsmac/nicpci.c
+++ b/drivers/staging/brcm80211/brcmsmac/nicpci.c
@@ -399,6 +399,7 @@ static bool pcie_mdiosetblock(struct pcicore_info *pi, uint blk)
 	while (i < pcie_serdes_spinwait) {
 		if (R_REG(&pcieregs->mdiocontrol) & MDIOCTL_ACCESS_DONE)
 			break;
+
 		udelay(1000);
 		i++;
 	}
@@ -823,6 +824,7 @@ void pcicore_fixcfg(void *pch, void *regs)
 		reg16 = &pcieregs->sprom[SRSH_PI_OFFSET];
 	else if (sii->pub.buscoretype == PCI_CORE_ID)
 		reg16 = &pciregs->sprom[SRSH_PI_OFFSET];
+
 	pciidx = ai_coreidx(&sii->pub);
 	val16 = R_REG(reg16);
 	if (((val16 & SRSH_PI_MASK) >> SRSH_PI_SHIFT) != (u16)pciidx) {
diff --git a/drivers/staging/brcm80211/brcmsmac/otp.c b/drivers/staging/brcm80211/brcmsmac/otp.c
index d09424d..03f9856 100644
--- a/drivers/staging/brcm80211/brcmsmac/otp.c
+++ b/drivers/staging/brcm80211/brcmsmac/otp.c
@@ -184,12 +184,12 @@ static u16 ipxotp_read_bit(void *oh, struct chipcregs *cc, uint off)
 	     ((st = R_REG(&cc->otpprog)) & OTPP_START_BUSY)
 	     && (k < OTPP_TRIES); k++)
 		;
-	if (k >= OTPP_TRIES) {
+	if (k >= OTPP_TRIES)
 		return 0xffff;
-	}
-	if (st & OTPP_READERR) {
+
+	if (st & OTPP_READERR)
 		return 0xffff;
-	}
+
 	st = (st & OTPP_VALUE_MASK) >> OTPP_VALUE_SHIFT;
 
 	return (int)st;
@@ -245,9 +245,8 @@ static void _ipxotp_init(struct otpinfo *oi, struct chipcregs *cc)
 	     ((st = R_REG(&cc->otpprog)) & OTPP_START_BUSY)
 	     && (k < OTPP_TRIES); k++)
 		;
-	if (k >= OTPP_TRIES) {
+	if (k >= OTPP_TRIES)
 		return;
-	}
 
 	/* Read OTP lock bits and subregion programmed indication bits */
 	oi->status = R_REG(&cc->otpstatus);
@@ -493,9 +492,8 @@ void *otp_init(struct si_pub *sih)
 	if (OTPTYPE_IPX(oi->ccrev))
 		oi->fn = &ipxotp_fn;
 
-	if (oi->fn == NULL) {
+	if (oi->fn == NULL)
 		return NULL;
-	}
 
 	oi->sih = sih;
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
index c6c5287..2636114 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_cmn.c
@@ -466,9 +466,8 @@ static void wlc_set_phy_uninitted(struct brcms_phy *pi)
 	}
 	pi->radiopwr = 0xffff;
 	for (i = 0; i < STATIC_NUM_RF; i++) {
-		for (j = 0; j < STATIC_NUM_BB; j++) {
+		for (j = 0; j < STATIC_NUM_BB; j++)
 			pi->stats_11b_txpower[i][j] = -1;
-		}
 	}
 }
 
@@ -477,9 +476,8 @@ struct shared_phy *wlc_phy_shared_attach(struct shared_phy_params *shp)
 	struct shared_phy *sh;
 
 	sh = kzalloc(sizeof(struct shared_phy), GFP_ATOMIC);
-	if (sh == NULL) {
+	if (sh == NULL)
 		return NULL;
-	}
 
 	sh->sih = shp->sih;
 	sh->physhim = shp->physhim;
@@ -525,23 +523,20 @@ wlc_phy_attach(struct shared_phy *sh, void *regs, int bandtype,
 		sflags = ai_core_sflags(sh->sih, 0, 0);
 
 	if (BAND_5G(bandtype)) {
-		if ((sflags & (SISF_5G_PHY | SISF_DB_PHY)) == 0) {
+		if ((sflags & (SISF_5G_PHY | SISF_DB_PHY)) == 0)
 			return NULL;
-		}
 	}
 
 	pi = sh->phy_head;
 	if ((sflags & SISF_DB_PHY) && pi) {
-
 		wlapi_bmac_corereset(pi->sh->physhim, pi->pubpi.coreflags);
 		pi->refcnt++;
 		return &pi->pubpi_ro;
 	}
 
 	pi = kzalloc(sizeof(struct brcms_phy), GFP_ATOMIC);
-	if (pi == NULL) {
+	if (pi == NULL)
 		return NULL;
-	}
 	pi->wiphy = wiphy;
 	pi->regs = (struct d11regs *) regs;
 	pi->sh = sh;
@@ -556,10 +551,8 @@ wlc_phy_attach(struct shared_phy *sh, void *regs, int bandtype,
 
 	pi->phycal_tempdelta = 0;
 
-	if (BAND_2G(bandtype) && (sflags & SISF_2G_PHY)) {
-
+	if (BAND_2G(bandtype) && (sflags & SISF_2G_PHY))
 		pi->pubpi.coreflags = SICF_GMODE;
-	}
 
 	wlapi_bmac_corereset(pi->sh->physhim, pi->pubpi.coreflags);
 	phyversion = R_REG(&pi->regs->phyversion);
@@ -574,17 +567,14 @@ wlc_phy_attach(struct shared_phy *sh, void *regs, int bandtype,
 	pi->pubpi.phy_corenum = PHY_CORE_NUM_2;
 	pi->pubpi.ana_rev = (phyversion & PV_AV_MASK) >> PV_AV_SHIFT;
 
-	if (!VALID_PHYTYPE(pi->pubpi.phy_type)) {
+	if (!VALID_PHYTYPE(pi->pubpi.phy_type))
 		goto err;
-	}
+
 	if (BAND_5G(bandtype)) {
-		if (!ISNPHY(pi)) {
-			goto err;
-		}
-	} else {
-		if (!ISNPHY(pi) && !ISLCNPHY(pi)) {
+		if (!ISNPHY(pi))
 			goto err;
-		}
+	} else if (!ISNPHY(pi) && !ISLCNPHY(pi)) {
+		goto err;
 	}
 
 	wlc_phy_anacore((struct brcms_phy_pub *) pi, ON);
@@ -652,9 +642,8 @@ wlc_phy_attach(struct shared_phy *sh, void *regs, int bandtype,
 		pi->phycal_timer = wlapi_init_timer(pi->sh->physhim,
 							  wlc_phy_timercb_phycal,
 							  pi, "phycal");
-		if (!pi->phycal_timer) {
+		if (!pi->phycal_timer)
 			goto err;
-		}
 
 		if (!wlc_phy_attach_nphy(pi))
 			goto err;
@@ -663,8 +652,6 @@ wlc_phy_attach(struct shared_phy *sh, void *regs, int bandtype,
 		if (!wlc_phy_attach_lcnphy(pi))
 			goto err;
 
-	} else {
-
 	}
 
 	pi->refcnt++;
@@ -687,9 +674,8 @@ void wlc_phy_detach(struct brcms_phy_pub *pih)
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
 	if (pih) {
-		if (--pi->refcnt) {
+		if (--pi->refcnt)
 			return;
-		}
 
 		if (pi->phycal_timer) {
 			wlapi_free_timer(pi->sh->physhim, pi->phycal_timer);
@@ -881,9 +867,8 @@ void wlc_phy_init(struct brcms_phy_pub *pih, u16 chanspec)
 	if (WARN(mc & MCTL_EN_MAC, "HW error MAC running on init"))
 		return;
 
-	if (!(pi->measure_hold & PHY_HOLD_FOR_SCAN)) {
+	if (!(pi->measure_hold & PHY_HOLD_FOR_SCAN))
 		pi->measure_hold |= PHY_HOLD_FOR_NOT_ASSOC;
-	}
 
 	if (WARN(!(ai_core_sflags(pi->sh->sih, 0, 0) & SISF_FCLKA),
 		 "HW error SISF_FCLKA\n"))
@@ -891,9 +876,8 @@ void wlc_phy_init(struct brcms_phy_pub *pih, u16 chanspec)
 
 	phy_init = pi->pi_fptr.init;
 
-	if (phy_init == NULL) {
+	if (phy_init == NULL)
 		return;
-	}
 
 	wlc_phy_anacore(pih, ON);
 
@@ -992,11 +976,9 @@ void wlc_phy_table_data_write(struct brcms_phy *pi, uint width, u32 val)
 	}
 
 	if (width == 32) {
-
 		write_phy_reg(pi, pi->tbl_data_hi, (u16) (val >> 16));
 		write_phy_reg(pi, pi->tbl_data_lo, (u16) val);
 	} else {
-
 		write_phy_reg(pi, pi->tbl_data_lo, (u16) val);
 	}
 }
@@ -1027,15 +1009,12 @@ wlc_phy_write_table(struct brcms_phy *pi, const struct phytbl_info *ptbl_info,
 		}
 
 		if (tbl_width == 32) {
-
 			write_phy_reg(pi, tblDataHi,
 				      (u16) (ptbl_32b[idx] >> 16));
 			write_phy_reg(pi, tblDataLo, (u16) ptbl_32b[idx]);
 		} else if (tbl_width == 16) {
-
 			write_phy_reg(pi, tblDataLo, ptbl_16b[idx]);
 		} else {
-
 			write_phy_reg(pi, tblDataLo, ptbl_8b[idx]);
 		}
 	}
@@ -1066,14 +1045,11 @@ wlc_phy_read_table(struct brcms_phy *pi, const struct phytbl_info *ptbl_info,
 		}
 
 		if (tbl_width == 32) {
-
 			ptbl_32b[idx] = read_phy_reg(pi, tblDataLo);
 			ptbl_32b[idx] |= (read_phy_reg(pi, tblDataHi) << 16);
 		} else if (tbl_width == 16) {
-
 			ptbl_16b[idx] = read_phy_reg(pi, tblDataLo);
 		} else {
-
 			ptbl_8b[idx] = (u8) read_phy_reg(pi, tblDataLo);
 		}
 	}
@@ -1086,10 +1062,9 @@ wlc_phy_init_radio_regs_allbands(struct brcms_phy *pi,
 	uint i = 0;
 
 	do {
-		if (radioregs[i].do_init) {
+		if (radioregs[i].do_init)
 			write_radio_reg(pi, radioregs[i].address,
 					(u16) radioregs[i].init);
-		}
 
 		i++;
 	} while (radioregs[i].address != 0xffff);
@@ -1158,9 +1133,8 @@ void wlc_phy_do_dummy_tx(struct brcms_phy *pi, bool ofdm, bool pa_on)
 		W_REG(&regs->wepctl, 0);
 
 	W_REG(&regs->txe_phyctl, (ofdm ? 1 : 0) | PHY_TXC_ANT_0);
-	if (ISNPHY(pi) || ISLCNPHY(pi)) {
+	if (ISNPHY(pi) || ISLCNPHY(pi))
 		W_REG(&regs->txe_phyctl1, 0x1A02);
-	}
 
 	W_REG(&regs->txe_wm_0, 0);
 	W_REG(&regs->txe_wm_1, 0);
@@ -1187,16 +1161,14 @@ void wlc_phy_do_dummy_tx(struct brcms_phy *pi, bool ofdm, bool pa_on)
 	i = 0;
 	count = ofdm ? 30 : 250;
 	while ((i++ < count)
-	       && (R_REG(&regs->txe_status) & (1 << 7))) {
+	       && (R_REG(&regs->txe_status) & (1 << 7)))
 		udelay(10);
-	}
 
 	i = 0;
 
 	while ((i++ < 10)
-	       && ((R_REG(&regs->txe_status) & (1 << 10)) == 0)) {
+	       && ((R_REG(&regs->txe_status) & (1 << 10)) == 0))
 		udelay(10);
-	}
 
 	i = 0;
 
@@ -1213,11 +1185,10 @@ void wlc_phy_hold_upd(struct brcms_phy_pub *pih, u32 id, bool set)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
-	if (set) {
+	if (set)
 		mboolset(pi->measure_hold, id);
-	} else {
+	else
 		mboolclr(pi->measure_hold, id);
-	}
 
 	return;
 }
@@ -1226,11 +1197,10 @@ void wlc_phy_mute_upd(struct brcms_phy_pub *pih, bool mute, u32 flags)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) pih;
 
-	if (mute) {
+	if (mute)
 		mboolset(pi->measure_hold, PHY_HOLD_FOR_MUTE);
-	} else {
+	else
 		mboolclr(pi->measure_hold, PHY_HOLD_FOR_MUTE);
-	}
 
 	if (!mute && (flags & PHY_MUTE_FOR_PREISM))
 		pi->nphy_perical_last = pi->sh->now - pi->sh->glacial_timer;
@@ -1271,7 +1241,6 @@ void wlc_phy_switch_radio(struct brcms_phy_pub *pih, bool on)
 
 	if (ISNPHY(pi)) {
 		wlc_phy_switch_radio_nphy(pi, on);
-
 	} else if (ISLCNPHY(pi)) {
 		if (on) {
 			and_phy_reg(pi, 0x44c,
@@ -1367,11 +1336,10 @@ int wlc_phy_chanspec_bandrange_get(struct brcms_phy *pi, u16 chanspec)
 	uint channel = CHSPEC_CHANNEL(chanspec);
 	uint freq = wlc_phy_channel2freq(channel);
 
-	if (ISNPHY(pi)) {
+	if (ISNPHY(pi))
 		range = wlc_phy_get_chan_freq_range_nphy(pi, channel);
-	} else if (ISLCNPHY(pi)) {
+	else if (ISLCNPHY(pi))
 		range = wlc_phy_chanspec_freq2bandrange_lpssn(freq);
-	}
 
 	return range;
 }
@@ -1585,9 +1553,8 @@ wlc_phy_txpower_sromlimit(struct brcms_phy_pub *ppi, uint channel, u8 *min_pwr,
 			txp_rate_idx = TXP_FIRST_OFDM;
 
 		for (i = 0; i < ARRAY_SIZE(chan_info_all); i++) {
-			if (channel == chan_info_all[i].chan) {
+			if (channel == chan_info_all[i].chan)
 				break;
-			}
 		}
 
 		if (pi->hwtxpwr) {
@@ -1720,11 +1687,10 @@ void wlc_phy_txpower_recalc_target(struct brcms_phy *pi)
 
 		tx_pwr_target[rate] = pi->tx_user_target[rate];
 
-		if (pi->user_txpwr_at_rfport) {
+		if (pi->user_txpwr_at_rfport)
 			tx_pwr_target[rate] +=
 			    wlc_user_txpwr_antport_to_rfport(pi, target_chan,
 							     band, rate);
-		}
 
 		{
 
@@ -1765,13 +1731,12 @@ void wlc_phy_txpower_recalc_target(struct brcms_phy *pi)
 
 		pi->tx_power_target[rate] = tx_pwr_target[rate];
 
-		if (!pi->hwpwrctrl || ISNPHY(pi)) {
+		if (!pi->hwpwrctrl || ISNPHY(pi))
 			pi->tx_power_offset[rate] =
 			    pi->tx_power_max - pi->tx_power_target[rate];
-		} else {
+		else
 			pi->tx_power_offset[rate] =
 			    pi->tx_power_target[rate] - pi->tx_power_min;
-		}
 	}
 
 	txpwr_recalc_fn = pi->pi_fptr.txpwrrecalc;
@@ -2017,9 +1982,8 @@ void wlc_phy_bf_preempt_enable(struct brcms_phy_pub *pih, bool bf_preempt)
 void wlc_phy_txpower_update_shm(struct brcms_phy *pi)
 {
 	int j;
-	if (ISNPHY(pi)) {
+	if (ISNPHY(pi))
 		return;
-	}
 
 	if (!pi->sh->clk)
 		return;
@@ -2069,22 +2033,19 @@ bool wlc_phy_txpower_hw_ctrl_get(struct brcms_phy_pub *ppi)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
 
-	if (ISNPHY(pi)) {
+	if (ISNPHY(pi))
 		return pi->nphy_txpwrctrl;
-	} else {
+	else
 		return pi->hwpwrctrl;
-	}
 }
 
 void wlc_phy_txpower_hw_ctrl_set(struct brcms_phy_pub *ppi, bool hwpwrctrl)
 {
 	struct brcms_phy *pi = (struct brcms_phy *) ppi;
-	bool cur_hwpwrctrl = pi->hwpwrctrl;
 	bool suspend;
 
-	if (!pi->hwpwrctrl_capable) {
+	if (!pi->hwpwrctrl_capable)
 		return;
-	}
 
 	pi->hwpwrctrl = hwpwrctrl;
 	pi->nphy_txpwrctrl = hwpwrctrl;
@@ -2098,19 +2059,14 @@ void wlc_phy_txpower_hw_ctrl_set(struct brcms_phy_pub *ppi, bool hwpwrctrl)
 			wlapi_suspend_mac_and_wait(pi->sh->physhim);
 
 		wlc_phy_txpwrctrl_enable_nphy(pi, pi->nphy_txpwrctrl);
-		if (pi->nphy_txpwrctrl == PHY_TPC_HW_OFF) {
+		if (pi->nphy_txpwrctrl == PHY_TPC_HW_OFF)
 			wlc_phy_txpwr_fixpower_nphy(pi);
-		} else {
-
+		else
 			mod_phy_reg(pi, 0x1e7, (0x7f << 0),
 				    pi->saved_txpwr_idx);
-		}
 
 		if (!suspend)
 			wlapi_enable_mac(pi->sh->physhim);
-	} else if (hwpwrctrl != cur_hwpwrctrl) {
-
-		return;
 	}
 }
 
@@ -2126,8 +2082,6 @@ void wlc_phy_txpower_ipa_upd(struct brcms_phy *pi)
 	}
 }
 
-static u32 wlc_phy_txpower_est_power_nphy(struct brcms_phy *pi);
-
 static u32 wlc_phy_txpower_est_power_nphy(struct brcms_phy *pi)
 {
 	s16 tx0_status, tx1_status;
@@ -2139,38 +2093,34 @@ static u32 wlc_phy_txpower_est_power_nphy(struct brcms_phy *pi)
 	estPower2 = read_phy_reg(pi, 0x119);
 
 	if ((estPower1 & (0x1 << 8))
-	    == (0x1 << 8)) {
+	    == (0x1 << 8))
 		pwr0 = (u8) (estPower1 & (0xff << 0))
 		    >> 0;
-	} else {
+	else
 		pwr0 = 0x80;
-	}
 
 	if ((estPower2 & (0x1 << 8))
-	    == (0x1 << 8)) {
+	    == (0x1 << 8))
 		pwr1 = (u8) (estPower2 & (0xff << 0))
 		    >> 0;
-	} else {
+	else
 		pwr1 = 0x80;
-	}
 
 	tx0_status = read_phy_reg(pi, 0x1ed);
 	tx1_status = read_phy_reg(pi, 0x1ee);
 
 	if ((tx0_status & (0x1 << 15))
-	    == (0x1 << 15)) {
+	    == (0x1 << 15))
 		adj_pwr0 = (u8) (tx0_status & (0xff << 0))
 		    >> 0;
-	} else {
+	else
 		adj_pwr0 = 0x80;
-	}
 	if ((tx1_status & (0x1 << 15))
-	    == (0x1 << 15)) {
+	    == (0x1 << 15))
 		adj_pwr1 = (u8) (tx1_status & (0xff << 0))
 		    >> 0;
-	} else {
+	else
 		adj_pwr1 = 0x80;
-	}
 
 	est_pwr =
 	    (u32) ((pwr0 << 24) | (pwr1 << 16) | (adj_pwr0 << 8) | adj_pwr1);
@@ -2305,10 +2255,8 @@ void wlc_phy_ant_rxdiv_set(struct brcms_phy_pub *ppi, u8 val)
 				       BRCM_BAND_ALL);
 	}
 
-	if (ISNPHY(pi)) {
-
+	if (ISNPHY(pi))
 		return;
-	}
 
 	if (!pi->sh->clk)
 		return;
@@ -2370,20 +2318,16 @@ wlc_phy_noise_sample_request(struct brcms_phy_pub *pih, u8 reason, u8 ch)
 	bool sampling_in_progress = (pi->phynoise_state != 0);
 	bool wait_for_intr = true;
 
-	if (NORADIO_ENAB(pi->pubpi)) {
+	if (NORADIO_ENAB(pi->pubpi))
 		return;
-	}
 
 	switch (reason) {
 	case PHY_NOISE_SAMPLE_MON:
-
 		pi->phynoise_chan_watchdog = ch;
 		pi->phynoise_state |= PHY_NOISE_STATE_MON;
-
 		break;
 
 	case PHY_NOISE_SAMPLE_EXTERNAL:
-
 		pi->phynoise_state |= PHY_NOISE_STATE_EXTERNAL;
 		break;
 
@@ -2407,7 +2351,6 @@ wlc_phy_noise_sample_request(struct brcms_phy_pub *pih, u8 reason, u8 ch)
 
 			noise_dbm = PHY_NOISE_FIXED_VAL_NPHY;
 		} else {
-
 			noise_dbm = PHY_NOISE_FIXED_VAL;
 		}
 
@@ -2521,9 +2464,8 @@ static void wlc_phy_noise_cb(struct brcms_phy *pi, u8 channel, s8 noise_dbm)
 		pi->phynoise_state &= ~PHY_NOISE_STATE_MON;
 	}
 
-	if (pi->phynoise_state & PHY_NOISE_STATE_EXTERNAL) {
+	if (pi->phynoise_state & PHY_NOISE_STATE_EXTERNAL)
 		pi->phynoise_state &= ~PHY_NOISE_STATE_EXTERNAL;
-	}
 
 }
 
@@ -2545,9 +2487,9 @@ static s8 wlc_phy_noise_read_shmem(struct brcms_phy *pi)
 					 M_PWRIND_MAP(idx + 1));
 		cmplx_pwr[core] = (hi << 16) + lo;
 		cmplx_pwr_tot += cmplx_pwr[core];
-		if (cmplx_pwr[core] == 0) {
+		if (cmplx_pwr[core] == 0)
 			noise_dbm_ant[core] = PHY_NOISE_FIXED_VAL_NPHY;
-		} else
+		else
 			cmplx_pwr[core] >>= PHY_NOISE_SAMPLE_LOG_NUM_UCODE;
 	}
 
@@ -2716,7 +2658,6 @@ void wlc_phy_rssi_compute(struct brcms_phy_pub *pih, void *ctx)
 	}
 
 	if (ISLCNPHY(pi)) {
-
 		if (rssi > 127)
 			rssi -= 256;
 	} else if (radioid == BCM2055_ID || radioid == BCM2056_ID
@@ -2758,23 +2699,20 @@ void wlc_phy_watchdog(struct brcms_phy_pub *pih)
 	if (!pi->watchdog_override)
 		return;
 
-	if (!(SCAN_RM_IN_PROGRESS(pi) || PLT_INPROG_PHY(pi))) {
+	if (!(SCAN_RM_IN_PROGRESS(pi) || PLT_INPROG_PHY(pi)))
 		wlc_phy_noise_sample_request((struct brcms_phy_pub *) pi,
 					     PHY_NOISE_SAMPLE_MON,
 					     CHSPEC_CHANNEL(pi->
 							    radio_chanspec));
-	}
 
-	if (pi->phynoise_state && (pi->sh->now - pi->phynoise_now) > 5) {
+	if (pi->phynoise_state && (pi->sh->now - pi->phynoise_now) > 5)
 		pi->phynoise_state = 0;
-	}
 
 	if ((!pi->phycal_txpower) ||
 	    ((pi->sh->now - pi->phycal_txpower) >= pi->sh->fast_timer)) {
 
-		if (!SCAN_INPROG_PHY(pi) && wlc_phy_cal_txpower_recalc_sw(pi)) {
+		if (!SCAN_INPROG_PHY(pi) && wlc_phy_cal_txpower_recalc_sw(pi))
 			pi->phycal_txpower = pi->sh->now;
-		}
 	}
 
 	if (NORADIO_ENAB(pi->pubpi))
@@ -2820,9 +2758,8 @@ void wlc_phy_BSSinit(struct brcms_phy_pub *pih, bool bonlyap, int rssi)
 	uint i;
 	uint k;
 
-	for (i = 0; i < MA_WINDOW_SZ; i++) {
+	for (i = 0; i < MA_WINDOW_SZ; i++)
 		pi->sh->phy_noise_window[i] = (s8) (rssi & 0xff);
-	}
 	if (ISLCNPHY(pi)) {
 		for (i = 0; i < MA_WINDOW_SZ; i++)
 			pi->sh->phy_noise_window[i] =
@@ -2955,9 +2892,9 @@ void wlc_phy_cal_perical(struct brcms_phy_pub *pih, u8 reason)
 
 	case PHY_PERICAL_PHYINIT:
 		if (pi->nphy_perical == PHY_PERICAL_MPHASE) {
-			if (PHY_PERICAL_MPHASE_PENDING(pi)) {
+			if (PHY_PERICAL_MPHASE_PENDING(pi))
 				wlc_phy_cal_perical_mphase_reset(pi);
-			}
+
 			wlc_phy_cal_perical_mphase_schedule(pi,
 							    PHY_PERICAL_INIT_DELAY);
 		}
@@ -2967,17 +2904,16 @@ void wlc_phy_cal_perical(struct brcms_phy_pub *pih, u8 reason)
 	case PHY_PERICAL_START_IBSS:
 	case PHY_PERICAL_UP_BSS:
 		if ((pi->nphy_perical == PHY_PERICAL_MPHASE) &&
-		    PHY_PERICAL_MPHASE_PENDING(pi)) {
+		    PHY_PERICAL_MPHASE_PENDING(pi))
 			wlc_phy_cal_perical_mphase_reset(pi);
-		}
 
 		pi->first_cal_after_assoc = true;
 
 		pi->cal_type_override = PHY_PERICAL_FULL;
 
-		if (pi->phycal_tempdelta) {
+		if (pi->phycal_tempdelta)
 			pi->nphy_lastcal_temp = wlc_phy_tempsense_nphy(pi);
-		}
+
 		wlc_phy_cal_perical_nphy_run(pi, PHY_PERICAL_FULL);
 		break;
 
@@ -2991,17 +2927,14 @@ void wlc_phy_cal_perical(struct brcms_phy_pub *pih, u8 reason)
 
 			if ((delta_temp < (s16) pi->phycal_tempdelta) &&
 			    (pi->nphy_txiqlocal_chanspec ==
-			     pi->radio_chanspec)) {
+			     pi->radio_chanspec))
 				do_periodic_cal = false;
-			} else {
+			else
 				pi->nphy_lastcal_temp = nphy_currtemp;
-			}
 		}
 
 		if (do_periodic_cal) {
-
 			if (pi->nphy_perical == PHY_PERICAL_MPHASE) {
-
 				if (!PHY_PERICAL_MPHASE_PENDING(pi))
 					wlc_phy_cal_perical_mphase_schedule(pi,
 									    PHY_PERICAL_WDOG_DELAY);
@@ -3050,9 +2983,9 @@ void wlc_phy_stf_chain_set(struct brcms_phy_pub *pih, u8 txchain, u8 rxchain)
 
 	pi->sh->phytxchain = txchain;
 
-	if (ISNPHY(pi)) {
+	if (ISNPHY(pi))
 		wlc_phy_rxcore_setstate_nphy(pih, rxchain);
-	}
+
 	pi->pubpi.phy_corenum = (u8) PHY_BITSCNT(pi->sh->phyrxchain);
 }
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
index 1276084..e580420 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_int.h
@@ -246,7 +246,7 @@ enum phy_cal_mode {
 
 #define MOD_PHY_REG(pi, phy_type, reg_name, field, value) \
 	mod_phy_reg(pi, phy_type##_##reg_name, phy_type##_##reg_name##_##field##_MASK, \
-	(value) << phy_type##_##reg_name##_##field##_##SHIFT);
+	(value) << phy_type##_##reg_name##_##field##_##SHIFT)
 #define READ_PHY_REG(pi, phy_type, reg_name, field) \
 	((read_phy_reg(pi, phy_type##_##reg_name) & phy_type##_##reg_name##_##field##_##MASK)\
 	>> phy_type##_##reg_name##_##field##_##SHIFT)
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
index c232f50..d64a98f 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_lcn.c
@@ -1092,12 +1092,12 @@ static int wlc_lcnphy_calc_floor(s16 coeff_x, int type)
 	int k;
 	k = 0;
 	if (type == 0) {
-		if (coeff_x < 0) {
+		if (coeff_x < 0)
 			k = (coeff_x - 1) / 2;
-		} else {
+		else
 			k = coeff_x / 2;
-		}
 	}
+
 	if (type == 1) {
 		if ((coeff_x + 1) < 0)
 			k = (coeff_x) / 2;
@@ -1531,10 +1531,9 @@ static void wlc_lcnphy_tssi_setup(struct brcms_phy *pi)
 
 	mod_radio_reg(pi, RADIO_2064_REG005, 0x8, 1 << 3);
 
-	if (!wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi)) {
+	if (!wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi))
 		mod_phy_reg(pi, 0x4d7,
 			    (0x1 << 3) | (0x7 << 12), 0 << 3 | 2 << 12);
-	}
 
 	rfseq = wlc_lcnphy_rfseq_tbl_adc_pwrup(pi);
 	tab.tbl_id = LCNPHY_TBL_ID_RFSEQ;
@@ -1697,24 +1696,21 @@ static s8 wlc_lcnphy_tempcompensated_txpwrctrl(struct brcms_phy *pi)
 	if (NORADIO_ENAB(pi->pubpi))
 		return index;
 
-	if (pi_lcn->lcnphy_tempsense_slope == 0) {
+	if (pi_lcn->lcnphy_tempsense_slope == 0)
 		return index;
-	}
+
 	temp = (u16) wlc_lcnphy_tempsense(pi, 0);
 	meas_temp = LCNPHY_TEMPSENSE(temp);
 
-	if (pi->tx_power_min != 0) {
+	if (pi->tx_power_min != 0)
 		delta_brd = (pi_lcn->lcnphy_measPower - pi->tx_power_min);
-	} else {
+	else
 		delta_brd = 0;
-	}
 
 	manp = LCNPHY_TEMPSENSE(pi_lcn->lcnphy_rawtempsense);
 	temp_diff = manp - meas_temp;
 	if (temp_diff < 0) {
-
 		neg = 1;
-
 		temp_diff = -temp_diff;
 	}
 
@@ -1740,9 +1736,10 @@ static s8 wlc_lcnphy_tempcompensated_txpwrctrl(struct brcms_phy *pi)
 
 	if (LCNREV_IS(pi->pubpi.phy_rev, 1))
 		index = 127;
-	if (new_index < 0 || new_index > 126) {
+
+	if (new_index < 0 || new_index > 126)
 		return index;
-	}
+
 	return new_index;
 }
 
@@ -1866,9 +1863,8 @@ wlc_lcnphy_tx_iqlo_cal(struct brcms_phy *pi,
 		return;
 
 	values_to_save = kmalloc(sizeof(u16) * 20, GFP_ATOMIC);
-	if (NULL == values_to_save) {
+	if (NULL == values_to_save)
 		return;
-	}
 
 	save_sslpnRxFeClkEnCtrl = read_phy_reg(pi, 0x6db);
 	save_sslpnCalibClkEnCtrl = read_phy_reg(pi, 0x6da);
@@ -1991,7 +1987,6 @@ wlc_lcnphy_tx_iqlo_cal(struct brcms_phy *pi,
 		write_phy_reg(pi, 0x452, command_num);
 
 		if ((cal_type == 3) || (cal_type == 4)) {
-
 			wlc_lcnphy_common_read_table(pi, LCNPHY_TBL_ID_IQLOCAL,
 						     &diq_start, 1, 16, 69);
 
@@ -2001,10 +1996,8 @@ wlc_lcnphy_tx_iqlo_cal(struct brcms_phy *pi,
 
 		write_phy_reg(pi, 0x451, cal_cmds[i]);
 
-		if (!wlc_lcnphy_iqcal_wait(pi)) {
-
+		if (!wlc_lcnphy_iqcal_wait(pi))
 			goto cleanup;
-		}
 
 		wlc_lcnphy_common_read_table(pi, LCNPHY_TBL_ID_IQLOCAL,
 					     best_coeffs,
@@ -2013,10 +2006,9 @@ wlc_lcnphy_tx_iqlo_cal(struct brcms_phy *pi,
 					      best_coeffs,
 					      ARRAY_SIZE(best_coeffs), 16, 64);
 
-		if ((cal_type == 3) || (cal_type == 4)) {
+		if ((cal_type == 3) || (cal_type == 4))
 			wlc_lcnphy_common_write_table(pi, LCNPHY_TBL_ID_IQLOCAL,
 						      &diq_start, 1, 16, 69);
-		}
 		wlc_lcnphy_common_read_table(pi, LCNPHY_TBL_ID_IQLOCAL,
 					     pi_lcn->lcnphy_cal_results.
 					     txiqlocal_bestcoeffs,
@@ -2878,7 +2870,6 @@ static void wlc_lcnphy_txpwrtbl_iqlo_cal(struct brcms_phy *pi)
 					lcnphy_recal ? LCNPHY_CAL_RECAL :
 					LCNPHY_CAL_FULL), false);
 	} else {
-
 		wlc_lcnphy_tx_iqlo_soft_cal_full(pi);
 	}
 
@@ -2905,10 +2896,8 @@ static void wlc_lcnphy_txpwrtbl_iqlo_cal(struct brcms_phy *pi)
 			wlc_lcnphy_tx_iqlo_cal(pi, &target_gains,
 					       LCNPHY_CAL_FULL, false);
 		} else {
-
 			wlc_lcnphy_tx_iqlo_soft_cal_full(pi);
 		}
-
 	}
 
 	wlc_lcnphy_get_tx_iqcc(pi, &a, &b);
@@ -3205,30 +3194,26 @@ static bool wlc_lcnphy_calc_rx_iq_comp(struct brcms_phy *pi, u16 num_samps)
 	if (arsh >= 0) {
 		a = (-(iq << (30 - iq_nbits)) + (ii >> (1 + arsh)));
 		temp = (s32) (ii >> arsh);
-		if (temp == 0) {
+		if (temp == 0)
 			return false;
-		}
 	} else {
 		a = (-(iq << (30 - iq_nbits)) + (ii << (-1 - arsh)));
 		temp = (s32) (ii << -arsh);
-		if (temp == 0) {
+		if (temp == 0)
 			return false;
-		}
 	}
 	a /= temp;
 	brsh = qq_nbits - 31 + 20;
 	if (brsh >= 0) {
 		b = (qq << (31 - qq_nbits));
 		temp = (s32) (ii >> brsh);
-		if (temp == 0) {
+		if (temp == 0)
 			return false;
-		}
 	} else {
 		b = (qq << (31 - qq_nbits));
 		temp = (s32) (ii << -brsh);
-		if (temp == 0) {
+		if (temp == 0)
 			return false;
-		}
 	}
 	b /= temp;
 	b -= a * a;
@@ -3272,14 +3257,12 @@ wlc_lcnphy_rx_iq_cal(struct brcms_phy *pi,
 	struct brcms_phy_lcnphy *pi_lcn = pi->u.pi_lcnphy;
 
 	ptr = kmalloc(sizeof(s16) * 131, GFP_ATOMIC);
-	if (NULL == ptr) {
+	if (NULL == ptr)
 		return false;
-	}
 	if (module == 2) {
 		while (iqcomp_sz--) {
 			if (iqcomp[iqcomp_sz].chan ==
 			    CHSPEC_CHANNEL(pi->radio_chanspec)) {
-
 				wlc_lcnphy_set_rx_iq_comp(pi,
 							  (u16)
 							  iqcomp[iqcomp_sz].a,
@@ -3297,10 +3280,9 @@ wlc_lcnphy_rx_iq_cal(struct brcms_phy *pi,
 		tx_pwr_ctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
 		wlc_lcnphy_set_tx_pwr_ctrl(pi, LCNPHY_TX_PWR_CTRL_OFF);
 
-		for (i = 0; i < 11; i++) {
+		for (i = 0; i < 11; i++)
 			values_to_save[i] =
 			    read_radio_reg(pi, rxiq_cal_rf_reg[i]);
-		}
 		Core1TxControl_old = read_phy_reg(pi, 0x631);
 
 		or_phy_reg(pi, 0x631, 0x0015);
@@ -3401,17 +3383,16 @@ wlc_lcnphy_rx_iq_cal(struct brcms_phy *pi,
 
 		mod_phy_reg(pi, 0x44c, (0x1 << 2), 0 << 2);
 
-		for (i = 0; i < 11; i++) {
+		for (i = 0; i < 11; i++)
 			write_radio_reg(pi, rxiq_cal_rf_reg[i],
 					values_to_save[i]);
-		}
 
-		if (tx_gain_override_old) {
+		if (tx_gain_override_old)
 			wlc_lcnphy_set_tx_pwr_by_index(pi, tx_gain_index_old);
-		} else
+		else
 			wlc_lcnphy_disable_tx_gain_override(pi);
-		wlc_lcnphy_set_tx_pwr_ctrl(pi, tx_pwr_ctrl);
 
+		wlc_lcnphy_set_tx_pwr_ctrl(pi, tx_pwr_ctrl);
 		wlc_lcnphy_rx_gain_override_enable(pi, false);
 	}
 
@@ -3477,10 +3458,10 @@ static void wlc_lcnphy_periodic_cal(struct brcms_phy *pi)
 	suspend =
 	    (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
 	if (!suspend) {
-
 		wlapi_bmac_write_shm(pi->sh->physhim, M_CTS_DURATION, 10000);
 		wlapi_suspend_mac_and_wait(pi->sh->physhim);
 	}
+
 	wlc_lcnphy_deaf_mode(pi, true);
 
 	wlc_lcnphy_txpwrtbl_iqlo_cal(pi);
@@ -3531,7 +3512,6 @@ void wlc_lcnphy_calib_modes(struct brcms_phy *pi, uint mode)
 
 	switch (mode) {
 	case PHY_PERICAL_CHAN:
-
 		break;
 	case PHY_FULLCAL:
 		wlc_lcnphy_periodic_cal(pi);
@@ -3600,13 +3580,11 @@ wlc_lcnphy_set_chanspec_tweaks(struct brcms_phy *pi, u16 chanspec)
 	if (NORADIO_ENAB(pi->pubpi))
 		return;
 
-	if (channel == 14) {
+	if (channel == 14)
 		mod_phy_reg(pi, 0x448, (0x3 << 8), (2) << 8);
-
-	} else {
+	else
 		mod_phy_reg(pi, 0x448, (0x3 << 8), (1) << 8);
 
-	}
 	pi_lcn->lcnphy_bandedge_corr = 2;
 	if (channel == 1)
 		pi_lcn->lcnphy_bandedge_corr = 4;
@@ -3731,10 +3709,9 @@ wlc_lcnphy_tx_iqlo_loopback(struct brcms_phy *pi, u16 *values_to_save)
 {
 	u16 vmid;
 	int i;
-	for (i = 0; i < 20; i++) {
+	for (i = 0; i < 20; i++)
 		values_to_save[i] =
 		    read_radio_reg(pi, iqlo_loopback_rf_regs[i]);
-	}
 
 	mod_phy_reg(pi, 0x44c, (0x1 << 12), 1 << 12);
 	mod_phy_reg(pi, 0x44d, (0x1 << 14), 1 << 14);
@@ -3872,22 +3849,24 @@ wlc_lcnphy_samp_cap(struct brcms_phy *pi, int clip_detect_algo, u16 thresh,
 		val = R_REG(&pi->regs->tplatewrdata);
 		imag = ((val >> 16) & 0x3ff);
 		real = ((val) & 0x3ff);
-		if (imag > 511) {
+		if (imag > 511)
 			imag -= 1024;
-		}
-		if (real > 511) {
+
+		if (real > 511)
 			real -= 1024;
-		}
+
 		if (pi_lcn->lcnphy_iqcal_swp_dis)
 			ptr[(strptr - 0x7E00) / 4] = real;
 		else
 			ptr[(strptr - 0x7E00) / 4] = imag;
+
 		if (clip_detect_algo) {
 			if (imag > thresh || imag < -thresh) {
 				strptr = 0x8000;
 				ptr[130] = 1;
 			}
 		}
+
 		strptr += 4;
 	}
 
@@ -4019,9 +3998,8 @@ wlc_lcnphy_a1(struct brcms_phy *pi, int cal_type, int num_levels,
 	phy_c21 = 0;
 	phy_c10 = phy_c13 = phy_c14 = phy_c8 = 0;
 	ptr = kmalloc(sizeof(s16) * 131, GFP_ATOMIC);
-	if (NULL == ptr) {
+	if (NULL == ptr)
 		return;
-	}
 
 	phy_c32 = kmalloc(sizeof(u16) * 20, GFP_ATOMIC);
 	if (NULL == phy_c32) {
@@ -4054,18 +4032,16 @@ wlc_lcnphy_a1(struct brcms_phy *pi, int cal_type, int num_levels,
 	phy_c4 = 32;
 
 	if (num_levels == 0) {
-		if (cal_type != 0) {
+		if (cal_type != 0)
 			num_levels = 4;
-		} else {
+		else
 			num_levels = 9;
-		}
 	}
 	if (step_size_lg2 == 0) {
-		if (cal_type != 0) {
+		if (cal_type != 0)
 			step_size_lg2 = 3;
-		} else {
+		else
 			step_size_lg2 = 8;
-		}
 	}
 
 	phy_c7 = (1 << step_size_lg2);
@@ -4150,11 +4126,11 @@ wlc_lcnphy_a1(struct brcms_phy *pi, int cal_type, int num_levels,
 				phy_c18 = 0;
 				phy_c19 = 0;
 				for (j = 0; j < 128; j++) {
-					if (cal_type != 0) {
+					if (cal_type != 0)
 						phy_c6 = j % phy_c4;
-					} else {
+					else
 						phy_c6 = (2 * j) % phy_c4;
-					}
+
 					phy_c2.re = phy_c1[phy_c6].re;
 					phy_c2.im = phy_c1[phy_c6].im;
 					phy_c17 = ptr[j];
@@ -4206,10 +4182,9 @@ wlc_lcnphy_tx_iqlo_loopback_cleanup(struct brcms_phy *pi, u16 *values_to_save)
 
 	and_phy_reg(pi, 0x43b, 0xC);
 
-	for (i = 0; i < 20; i++) {
+	for (i = 0; i < 20; i++)
 		write_radio_reg(pi, iqlo_loopback_rf_regs[i],
 				values_to_save[i]);
-	}
 }
 
 static void
@@ -4306,9 +4281,8 @@ static void wlc_lcnphy_tbl_init(struct brcms_phy *pi)
 
 	phybw40 = CHSPEC_IS40(pi->radio_chanspec);
 
-	for (idx = 0; idx < dot11lcnphytbl_info_sz_rev0; idx++) {
+	for (idx = 0; idx < dot11lcnphytbl_info_sz_rev0; idx++)
 		wlc_lcnphy_write_table(pi, &dot11lcnphytbl_info_rev0[idx]);
-	}
 
 	if (pi->sh->boardflags & BFL_FEM_BT) {
 		tab.tbl_id = LCNPHY_TBL_ID_RFSEQ;
@@ -4443,7 +4417,6 @@ static void wlc_lcnphy_rev2_baseband_init(struct brcms_phy *pi)
 {
 	if (CHSPEC_IS5G(pi->radio_chanspec)) {
 		mod_phy_reg(pi, 0x416, (0xff << 0), 80 << 0);
-
 		mod_phy_reg(pi, 0x416, (0xff << 8), 80 << 8);
 	}
 }
@@ -4763,9 +4736,8 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 
 			opo = (u8) PHY_GETINTVAR(pi, "opo");
 
-			for (i = TXP_FIRST_CCK; i <= TXP_LAST_CCK; i++) {
+			for (i = TXP_FIRST_CCK; i <= TXP_LAST_CCK; i++)
 				pi->tx_srom_max_rate_2g[i] = txpwr;
-			}
 
 			offset_ofdm = (u32) PHY_GETINTVAR(pi, "ofdm2gpo");
 
@@ -4811,9 +4783,8 @@ static bool wlc_phy_txpwr_srom_read_lcnphy(struct brcms_phy *pi)
 	if (PHY_GETVAR(pi, "cckdigfilttype")) {
 		s16 temp;
 		temp = (s16) PHY_GETINTVAR(pi, "cckdigfilttype");
-		if (temp >= 0) {
+		if (temp >= 0)
 			pi_lcn->lcnphy_cck_dig_filt_type = temp;
-		}
 	}
 
 	return true;
@@ -4866,9 +4837,8 @@ wlc_lcnphy_radio_2064_channel_tune_4313(struct brcms_phy *pi, u8 channel)
 			if (chan_info_2064_lcnphy[i].chan == channel)
 				break;
 
-		if (i >= ARRAY_SIZE(chan_info_2064_lcnphy)) {
+		if (i >= ARRAY_SIZE(chan_info_2064_lcnphy))
 			return;
-		}
 
 		ci = &chan_info_2064_lcnphy[i];
 	}
@@ -5015,14 +4985,11 @@ void wlc_phy_txpower_recalc_target_lcnphy(struct brcms_phy *pi)
 	if (wlc_lcnphy_tempsense_based_pwr_ctrl_enabled(pi)) {
 		wlc_lcnphy_calib_modes(pi, LCNPHY_PERICAL_TEMPBASED_TXPWRCTRL);
 	} else if (wlc_lcnphy_tssi_based_pwr_ctrl_enabled(pi)) {
-
 		pwr_ctrl = wlc_lcnphy_get_tx_pwr_ctrl(pi);
 		wlc_lcnphy_set_tx_pwr_ctrl(pi, LCNPHY_TX_PWR_CTRL_OFF);
 		wlc_lcnphy_txpower_recalc_target(pi);
-
 		wlc_lcnphy_set_tx_pwr_ctrl(pi, pwr_ctrl);
-	} else
-		return;
+	}
 }
 
 void wlc_phy_detach_lcnphy(struct brcms_phy *pi)
@@ -5035,9 +5002,8 @@ bool wlc_phy_attach_lcnphy(struct brcms_phy *pi)
 	struct brcms_phy_lcnphy *pi_lcn;
 
 	pi->u.pi_lcnphy = kzalloc(sizeof(struct brcms_phy_lcnphy), GFP_ATOMIC);
-	if (pi->u.pi_lcnphy == NULL) {
+	if (pi->u.pi_lcnphy == NULL)
 		return false;
-	}
 
 	pi_lcn = pi->u.pi_lcnphy;
 
@@ -5196,18 +5162,17 @@ s32 wlc_lcnphy_rx_signal_power(struct brcms_phy *pi, s32 gain_index)
 
 	temperature = pi_lcn->lcnphy_lastsensed_temperature;
 
-	if ((temperature - 15) < -30) {
+	if ((temperature - 15) < -30)
 		input_power_db =
 		    input_power_db + (((temperature - 10 - 25) * 286) >> 12) -
 		    7;
-	} else if ((temperature - 15) < 4) {
+	else if ((temperature - 15) < 4)
 		input_power_db =
 		    input_power_db + (((temperature - 10 - 25) * 286) >> 12) -
 		    3;
-	} else {
+	else
 		input_power_db =
 		    input_power_db + (((temperature - 10 - 25) * 286) >> 12);
-	}
 
 	wlc_lcnphy_rx_gain_override_enable(pi, 0);
 
@@ -5267,11 +5232,10 @@ wlc_lcnphy_load_tx_iir_filter(struct brcms_phy *pi, bool is_ofdm, s16 filt_type)
 		}
 
 		if (filt_index != -1) {
-			for (j = 0; j < LCNPHY_NUM_DIG_FILT_COEFFS; j++) {
+			for (j = 0; j < LCNPHY_NUM_DIG_FILT_COEFFS; j++)
 				write_phy_reg(pi, addr[j],
 					      LCNPHY_txdigfiltcoeffs_cck
 					      [filt_index][j + 1]);
-			}
 		}
 	} else {
 		for (j = 0; j < LCNPHY_NUM_TX_DIG_FILTERS_OFDM; j++) {
@@ -5282,11 +5246,10 @@ wlc_lcnphy_load_tx_iir_filter(struct brcms_phy *pi, bool is_ofdm, s16 filt_type)
 		}
 
 		if (filt_index != -1) {
-			for (j = 0; j < LCNPHY_NUM_DIG_FILT_COEFFS; j++) {
+			for (j = 0; j < LCNPHY_NUM_DIG_FILT_COEFFS; j++)
 				write_phy_reg(pi, addr_ofdm[j],
 					      LCNPHY_txdigfiltcoeffs_ofdm
 					      [filt_index][j + 1]);
-			}
 		}
 	}
 
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
index f758812..ee1fe58 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_n.c
@@ -33,22 +33,23 @@
 	((core == PHY_CORE_0) ? radio_type##_##jspace##0 : radio_type##_##jspace##1))
 #define	WRITE_RADIO_REG2(pi, radio_type, jspace, core, reg_name, value) \
 	write_radio_reg(pi, radio_type##_##jspace##_##reg_name | \
-	((core == PHY_CORE_0) ? radio_type##_##jspace##0 : radio_type##_##jspace##1), value);
+	((core == PHY_CORE_0) ? radio_type##_##jspace##0 : \
+	radio_type##_##jspace##1), value)
 #define	WRITE_RADIO_SYN(pi, radio_type, reg_name, value) \
-	write_radio_reg(pi, radio_type##_##SYN##_##reg_name, value);
+	write_radio_reg(pi, radio_type##_##SYN##_##reg_name, value)
 
 #define	READ_RADIO_REG3(pi, radio_type, jspace, core, reg_name) \
 	read_radio_reg(pi, ((core == PHY_CORE_0) ? radio_type##_##jspace##0##_##reg_name : \
-	radio_type##_##jspace##1##_##reg_name));
+	radio_type##_##jspace##1##_##reg_name))
 #define	WRITE_RADIO_REG3(pi, radio_type, jspace, core, reg_name, value) \
 	write_radio_reg(pi, ((core == PHY_CORE_0) ? radio_type##_##jspace##0##_##reg_name : \
-	radio_type##_##jspace##1##_##reg_name), value);
+	radio_type##_##jspace##1##_##reg_name), value)
 #define	READ_RADIO_REG4(pi, radio_type, jspace, core, reg_name) \
 	read_radio_reg(pi, ((core == PHY_CORE_0) ? radio_type##_##reg_name##_##jspace##0 : \
-	radio_type##_##reg_name##_##jspace##1));
+	radio_type##_##reg_name##_##jspace##1))
 #define	WRITE_RADIO_REG4(pi, radio_type, jspace, core, reg_name, value) \
 	write_radio_reg(pi, ((core == PHY_CORE_0) ? radio_type##_##reg_name##_##jspace##0 : \
-	radio_type##_##reg_name##_##jspace##1), value);
+	radio_type##_##reg_name##_##jspace##1), value)
 
 #define NPHY_ACI_MAX_UNDETECT_WINDOW_SZ 40
 #define NPHY_ACI_CHANNEL_DELTA 5
@@ -14209,9 +14210,8 @@ bool wlc_phy_bist_check_phy(struct brcms_phy_pub *pih)
 	phybist4 = read_phy_reg(pi, 0x156);
 
 	if ((phybist0 == 0) && (phybist1 == 0x4000) && (phybist2 == 0x1fe0) &&
-	    (phybist3 == 0) && (phybist4 == 0)) {
+	    (phybist3 == 0) && (phybist4 == 0))
 		return true;
-	}
 
 	return false;
 }
@@ -14239,7 +14239,6 @@ static void wlc_phy_bphy_init_nphy(struct brcms_phy *pi)
 		or_phy_reg(pi, NPHY_TO_BPHY_OFF + BPHY_LNA_GAIN_RANGE, 0x1a);
 
 	} else {
-
 		write_phy_reg(pi, NPHY_TO_BPHY_OFF + BPHY_STEP, 0x668);
 	}
 }
@@ -14316,20 +14315,19 @@ static void wlc_phy_tbl_init_nphy(struct brcms_phy *pi)
 
 		case 1:
 
-			if (pi->aa2g == 7) {
-
+			if (pi->aa2g == 7)
 				wlc_phy_table_write_nphy(pi,
 							 NPHY_TBL_ID_ANTSWCTRLLUT,
 							 2, 0x21, 8,
 							 &ant_sw_ctrl_tbl_rev8_2o3
 							 [0]);
-			} else {
+			else
 				wlc_phy_table_write_nphy(pi,
 							 NPHY_TBL_ID_ANTSWCTRLLUT,
 							 2, 0x21, 8,
 							 &ant_sw_ctrl_tbl_rev8
 							 [0]);
-			}
+
 			wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_ANTSWCTRLLUT,
 						 2, 0x25, 8,
 						 &ant_sw_ctrl_tbl_rev8[2]);
@@ -14409,11 +14407,10 @@ static void wlc_phy_tbl_init_nphy(struct brcms_phy *pi)
 			}
 		}
 	} else {
-		for (idx = 0; idx < mimophytbl_info_sz_rev0_volatile; idx++) {
+		for (idx = 0; idx < mimophytbl_info_sz_rev0_volatile; idx++)
 			wlc_phy_write_table_nphy(pi,
 						 &mimophytbl_info_rev0_volatile
 						 [idx]);
-		}
 	}
 }
 
@@ -14440,32 +14437,25 @@ void wlc_phy_nphy_tkip_rifs_war(struct brcms_phy *pi, u8 rifs)
 
 	wlc_phy_write_txmacreg_nphy(pi, holdoff, delay);
 
-	if (pi && pi->sh && (pi->sh->_rifs_phy != rifs)) {
+	if (pi && pi->sh && (pi->sh->_rifs_phy != rifs))
 		pi->sh->_rifs_phy = rifs;
-	}
 }
 
 bool wlc_phy_attach_nphy(struct brcms_phy *pi)
 {
 	uint i;
 
-	if (NREV_GE(pi->pubpi.phy_rev, 3) && NREV_LT(pi->pubpi.phy_rev, 6)) {
+	if (NREV_GE(pi->pubpi.phy_rev, 3) && NREV_LT(pi->pubpi.phy_rev, 6))
 		pi->phyhang_avoid = true;
-	}
 
 	if (NREV_GE(pi->pubpi.phy_rev, 3) && NREV_LT(pi->pubpi.phy_rev, 7)) {
-
 		pi->nphy_gband_spurwar_en = true;
-
-		if (pi->sh->boardflags2 & BFL2_SPUR_WAR) {
+		if (pi->sh->boardflags2 & BFL2_SPUR_WAR)
 			pi->nphy_aband_spurwar_en = true;
-		}
 	}
 	if (NREV_GE(pi->pubpi.phy_rev, 6) && NREV_LT(pi->pubpi.phy_rev, 7)) {
-
-		if (pi->sh->boardflags2 & BFL2_2G_SPUR_WAR) {
+		if (pi->sh->boardflags2 & BFL2_2G_SPUR_WAR)
 			pi->nphy_gband_spurwar2_en = true;
-		}
 	}
 
 	pi->n_preamble_override = AUTO;
@@ -14485,9 +14475,8 @@ bool wlc_phy_attach_nphy(struct brcms_phy *pi)
 	pi->nphy_elna_gain_config = false;
 	pi->radio_is_on = false;
 
-	for (i = 0; i < pi->pubpi.phy_corenum; i++) {
+	for (i = 0; i < pi->pubpi.phy_corenum; i++)
 		pi->nphy_txpwrindex[i].index = AUTO;
-	}
 
 	wlc_phy_txpwrctrl_config_nphy(pi);
 	if (pi->nphy_txpwrctrl == PHY_TPC_HW_ON)
@@ -14538,19 +14527,17 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 
 	core = 0;
 
-	if (!(pi->measure_hold & PHY_HOLD_FOR_SCAN)) {
+	if (!(pi->measure_hold & PHY_HOLD_FOR_SCAN))
 		pi->measure_hold |= PHY_HOLD_FOR_NOT_ASSOC;
-	}
 
 	if ((ISNPHY(pi)) && (NREV_GE(pi->pubpi.phy_rev, 5)) &&
 	    ((pi->sh->chippkg == BCM4717_PKG_ID) ||
 	     (pi->sh->chippkg == BCM4718_PKG_ID))) {
 		if ((pi->sh->boardflags & BFL_EXTLNA) &&
-		    (CHSPEC_IS2G(pi->radio_chanspec))) {
+		    (CHSPEC_IS2G(pi->radio_chanspec)))
 			ai_corereg(pi->sh->sih, SI_CC_IDX,
 				   offsetof(struct chipcregs, chipcontrol),
 				   0x40, 0x40);
-		}
 	}
 
 	if ((pi->nphy_gband_spurwar2_en) && CHSPEC_IS2G(pi->radio_chanspec) &&
@@ -14632,9 +14619,8 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 
 	write_phy_reg(pi, 0x1ff, 48);
 
-	if (NREV_LT(pi->pubpi.phy_rev, 8)) {
+	if (NREV_LT(pi->pubpi.phy_rev, 8))
 		wlc_phy_update_mimoconfig_nphy(pi, pi->n_preamble_override);
-	}
 
 	wlc_phy_stf_chain_upd_nphy(pi);
 
@@ -14656,11 +14642,8 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 		}
 
 		wlc_phy_ipa_set_tx_digi_filts_nphy(pi);
-	} else {
-
-		if (NREV_GE(pi->pubpi.phy_rev, 5)) {
-			wlc_phy_extpa_set_tx_digi_filts_nphy(pi);
-		}
+	} else if (NREV_GE(pi->pubpi.phy_rev, 5)) {
+		wlc_phy_extpa_set_tx_digi_filts_nphy(pi);
 	}
 
 	wlc_phy_workarounds_nphy(pi);
@@ -14705,38 +14688,33 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 			tx_pwrctrl_tbl = wlc_phy_get_ipa_gaintbl_nphy(pi);
 		} else {
 			if (CHSPEC_IS5G(pi->radio_chanspec)) {
-				if (NREV_IS(pi->pubpi.phy_rev, 3)) {
+				if (NREV_IS(pi->pubpi.phy_rev, 3))
 					tx_pwrctrl_tbl =
 					    nphy_tpc_5GHz_txgain_rev3;
-				} else if (NREV_IS(pi->pubpi.phy_rev, 4)) {
+				else if (NREV_IS(pi->pubpi.phy_rev, 4))
 					tx_pwrctrl_tbl =
 					    (pi->srom_fem5g.extpagain == 3) ?
 					    nphy_tpc_5GHz_txgain_HiPwrEPA :
 					    nphy_tpc_5GHz_txgain_rev4;
-				} else {
+				else
 					tx_pwrctrl_tbl =
 					    nphy_tpc_5GHz_txgain_rev5;
-				}
-
 			} else {
 				if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-					if (pi->pubpi.radiorev == 5) {
+					if (pi->pubpi.radiorev == 5)
 						tx_pwrctrl_tbl =
 						    nphy_tpc_txgain_epa_2057rev5;
-					} else if (pi->pubpi.radiorev == 3) {
+					else if (pi->pubpi.radiorev == 3)
 						tx_pwrctrl_tbl =
 						    nphy_tpc_txgain_epa_2057rev3;
-					}
-
 				} else {
 					if (NREV_GE(pi->pubpi.phy_rev, 5) &&
-					    (pi->srom_fem2g.extpagain == 3)) {
+					    (pi->srom_fem2g.extpagain == 3))
 						tx_pwrctrl_tbl =
 						    nphy_tpc_txgain_HiPwrEPA;
-					} else {
+					else
 						tx_pwrctrl_tbl =
 						    nphy_tpc_txgain_rev3;
-					}
 				}
 			}
 		}
@@ -14757,35 +14735,33 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 				if (CHSPEC_IS2G(pi->radio_chanspec)) {
 					if ((pi->pubpi.radiorev == 3) ||
 					    (pi->pubpi.radiorev == 4) ||
-					    (pi->pubpi.radiorev == 6)) {
+					    (pi->pubpi.radiorev == 6))
 						rfpwr_offset = (s16)
 						    nphy_papd_padgain_dlt_2g_2057rev3n4
 						    [pad_gn];
-					} else if (pi->pubpi.radiorev == 5) {
+					else if (pi->pubpi.radiorev == 5)
 						rfpwr_offset = (s16)
 						    nphy_papd_padgain_dlt_2g_2057rev5
 						    [pad_gn];
-					} else if ((pi->pubpi.radiorev == 7)
+					else if ((pi->pubpi.radiorev == 7)
 						   || (pi->pubpi.radiorev ==
-						       8)) {
+						       8))
 						rfpwr_offset = (s16)
 						    nphy_papd_padgain_dlt_2g_2057rev7
 						    [pad_gn];
-					}
 				} else {
 					if ((pi->pubpi.radiorev == 3) ||
 					    (pi->pubpi.radiorev == 4) ||
-					    (pi->pubpi.radiorev == 6)) {
+					    (pi->pubpi.radiorev == 6))
 						rfpwr_offset = (s16)
 						    nphy_papd_pgagain_dlt_5g_2057
 						    [pga_gn];
-					} else if ((pi->pubpi.radiorev == 7)
+					else if ((pi->pubpi.radiorev == 7)
 						   || (pi->pubpi.radiorev ==
-						       8)) {
+						       8))
 						rfpwr_offset = (s16)
 						    nphy_papd_pgagain_dlt_5g_2057rev7
 						    [pga_gn];
-					}
 				}
 				wlc_phy_table_write_nphy(pi,
 							 NPHY_TBL_ID_CORE1TXPWRCTL,
@@ -14800,15 +14776,14 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 
 			for (idx = 0; idx < 128; idx++) {
 				pga_gn = (tx_pwrctrl_tbl[idx] >> 24) & 0xf;
-				if (CHSPEC_IS2G(pi->radio_chanspec)) {
+				if (CHSPEC_IS2G(pi->radio_chanspec))
 					rfpwr_offset = (s16)
 					    nphy_papd_pga_gain_delta_ipa_2g
 					    [pga_gn];
-				} else {
+				else
 					rfpwr_offset = (s16)
 					    nphy_papd_pga_gain_delta_ipa_5g
 					    [pga_gn];
-				}
 
 				wlc_phy_table_write_nphy(pi,
 							 NPHY_TBL_ID_CORE1TXPWRCTL,
@@ -14829,14 +14804,12 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 					 192, 32, nphy_tpc_txgain);
 	}
 
-	if (pi->sh->phyrxchain != 0x3) {
+	if (pi->sh->phyrxchain != 0x3)
 		wlc_phy_rxcore_setstate_nphy((struct brcms_phy_pub *) pi,
 					     pi->sh->phyrxchain);
-	}
 
-	if (PHY_PERICAL_MPHASE_PENDING(pi)) {
+	if (PHY_PERICAL_MPHASE_PENDING(pi))
 		wlc_phy_cal_perical_mphase_restart(pi);
-	}
 
 	if (!NORADIO_ENAB(pi->pubpi)) {
 		bool do_rssi_cal = false;
@@ -14846,20 +14819,18 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 			    (pi->nphy_rssical_chanspec_2G == 0) :
 			    (pi->nphy_rssical_chanspec_5G == 0);
 
-			if (do_rssi_cal) {
+			if (do_rssi_cal)
 				wlc_phy_rssi_cal_nphy(pi);
-			} else {
+			else
 				wlc_phy_restore_rssical_nphy(pi);
-			}
 		} else {
 			wlc_phy_rssi_cal_nphy(pi);
 		}
 
-		if (!SCAN_RM_IN_PROGRESS(pi)) {
+		if (!SCAN_RM_IN_PROGRESS(pi))
 			do_nphy_cal = (CHSPEC_IS2G(pi->radio_chanspec)) ?
 			    (pi->nphy_iqcal_chanspec_2G == 0) :
 			    (pi->nphy_iqcal_chanspec_5G == 0);
-		}
 
 		if (!pi->do_initcal)
 			do_nphy_cal = false;
@@ -14892,14 +14863,12 @@ void wlc_phy_init_nphy(struct brcms_phy *pi)
 				    (pi, target_gain, true, false) == 0) {
 					if (wlc_phy_cal_rxiq_nphy
 					    (pi, target_gain, 2,
-					     false) == 0) {
+					    false) == 0)
 						wlc_phy_savecal_nphy(pi);
 
-					}
 				}
 			} else if (pi->mphase_cal_phase_id ==
 				   MPHASE_CAL_STATE_IDLE) {
-
 				wlc_phy_cal_perical((struct brcms_phy_pub *) pi,
 						    PHY_PERICAL_PHYINIT);
 			}
@@ -14967,20 +14936,18 @@ void wlc_phy_pa_override_nphy(struct brcms_phy *pi, bool en)
 		pi->rfctrlIntc1_save = read_phy_reg(pi, 0x91);
 		pi->rfctrlIntc2_save = read_phy_reg(pi, 0x92);
 
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		if (NREV_GE(pi->pubpi.phy_rev, 7))
 			rfctrlintc_override_val = 0x1480;
-		} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		else if (NREV_GE(pi->pubpi.phy_rev, 3))
 			rfctrlintc_override_val =
 			    CHSPEC_IS5G(pi->radio_chanspec) ? 0x600 : 0x480;
-		} else {
+		else
 			rfctrlintc_override_val =
 			    CHSPEC_IS5G(pi->radio_chanspec) ? 0x180 : 0x120;
-		}
 
 		write_phy_reg(pi, 0x91, rfctrlintc_override_val);
 		write_phy_reg(pi, 0x92, rfctrlintc_override_val);
 	} else {
-
 		write_phy_reg(pi, 0x91, pi->rfctrlIntc1_save);
 		write_phy_reg(pi, 0x92, pi->rfctrlIntc2_save);
 	}
@@ -14998,22 +14965,19 @@ void wlc_phy_stf_chain_upd_nphy(struct brcms_phy *pi)
 		txrx_chain = NPHY_RfseqCoreActv_TxRxChain0;
 		CoreActv_override = true;
 
-		if (NREV_LE(pi->pubpi.phy_rev, 2)) {
+		if (NREV_LE(pi->pubpi.phy_rev, 2))
 			and_phy_reg(pi, 0xa0, ~0x20);
-		}
 	} else if (pi->nphy_txrx_chain == BRCMS_N_TXRX_CHAIN1) {
 		txrx_chain = NPHY_RfseqCoreActv_TxRxChain1;
 		CoreActv_override = true;
 
-		if (NREV_LE(pi->pubpi.phy_rev, 2)) {
+		if (NREV_LE(pi->pubpi.phy_rev, 2))
 			or_phy_reg(pi, 0xa0, 0x20);
-		}
 	}
 
 	mod_phy_reg(pi, 0xa2, ((0xf << 0) | (0xf << 4)), txrx_chain);
 
 	if (CoreActv_override) {
-
 		pi->nphy_perical = PHY_PERICAL_DISABLE;
 		or_phy_reg(pi, 0xa1, NPHY_RfseqMode_CoreActv_override);
 	} else {
@@ -15073,9 +15037,8 @@ void wlc_phy_rxcore_setstate_nphy(struct brcms_phy_pub *pih, u8 rxcore_bitmask)
 									 &tbl_opcode);
 						break;
 					} else if (tbl_buf[i] ==
-						   NPHY_REV3_RFSEQ_CMD_END) {
+						   NPHY_REV3_RFSEQ_CMD_END)
 						break;
-					}
 				}
 			}
 		}
@@ -15123,9 +15086,8 @@ static void wlc_phy_txpwr_limit_to_tbl_nphy(struct brcms_phy *pi)
 {
 	u8 idx, idx2, i, delta_ind;
 
-	for (idx = TXP_FIRST_CCK; idx <= TXP_LAST_CCK; idx++) {
+	for (idx = TXP_FIRST_CCK; idx <= TXP_LAST_CCK; idx++)
 		pi->adj_pwr_tbl_nphy[idx] = pi->tx_power_offset[idx];
-	}
 
 	for (i = 0; i < 4; i++) {
 		idx2 = 0;
@@ -15222,18 +15184,16 @@ wlc_phy_war_force_trsw_to_R_cliplo_nphy(struct brcms_phy *pi, u8 core)
 {
 	if (core == PHY_CORE_0) {
 		write_phy_reg(pi, 0x38, 0x4);
-		if (CHSPEC_IS2G(pi->radio_chanspec)) {
+		if (CHSPEC_IS2G(pi->radio_chanspec))
 			write_phy_reg(pi, 0x37, 0x0060);
-		} else {
+		else
 			write_phy_reg(pi, 0x37, 0x1080);
-		}
 	} else if (core == PHY_CORE_1) {
 		write_phy_reg(pi, 0x2ae, 0x4);
-		if (CHSPEC_IS2G(pi->radio_chanspec)) {
+		if (CHSPEC_IS2G(pi->radio_chanspec))
 			write_phy_reg(pi, 0x2ad, 0x0060);
-		} else {
+		else
 			write_phy_reg(pi, 0x2ad, 0x1080);
-		}
 	}
 }
 
@@ -15243,13 +15203,11 @@ static void wlc_phy_war_txchain_upd_nphy(struct brcms_phy *pi, u8 txchain)
 
 	txchain0 = txchain & 0x1;
 	txchain1 = (txchain & 0x2) >> 1;
-	if (!txchain0) {
+	if (!txchain0)
 		wlc_phy_war_force_trsw_to_R_cliplo_nphy(pi, PHY_CORE_0);
-	}
 
-	if (!txchain1) {
+	if (!txchain1)
 		wlc_phy_war_force_trsw_to_R_cliplo_nphy(pi, PHY_CORE_1);
-	}
 }
 
 static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
@@ -15362,11 +15320,10 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 	u16 freq;
 	int coreNum;
 
-	if (CHSPEC_IS5G(pi->radio_chanspec)) {
+	if (CHSPEC_IS5G(pi->radio_chanspec))
 		wlc_phy_classifier_nphy(pi, NPHY_ClassifierCtrl_cck_en, 0);
-	} else {
+	else
 		wlc_phy_classifier_nphy(pi, NPHY_ClassifierCtrl_cck_en, 1);
-	}
 
 	if (pi->phyhang_avoid)
 		wlc_phy_stay_in_carriersearch_nphy(pi, true);
@@ -15401,9 +15358,8 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 			write_phy_reg(pi, 0x240, 0x1b0);
 		}
 
-		if (NREV_GE(pi->pubpi.phy_rev, 8)) {
+		if (NREV_GE(pi->pubpi.phy_rev, 8))
 			mod_phy_reg(pi, 0xbd, (0xff << 0), (114 << 0));
-		}
 
 		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_AFECTRL, 1, 0x00, 16,
 					 &dac_control);
@@ -15422,7 +15378,7 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 		wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x16e, 16,
 					 rfseq_rx2tx_dacbufpu_rev7);
 
-		if (PHY_IPA(pi)) {
+		if (PHY_IPA(pi))
 			wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_RX2TX,
 					       rfseq_rx2tx_events_rev3_ipa,
 					       rfseq_rx2tx_dlys_rev3_ipa,
@@ -15431,7 +15387,6 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 					       sizeof
 					       (rfseq_rx2tx_events_rev3_ipa
 						[0]));
-		}
 
 		mod_phy_reg(pi, 0x299, (0x3 << 14), (0x1 << 14));
 		mod_phy_reg(pi, 0x29d, (0x3 << 14), (0x1 << 14));
@@ -15572,15 +15527,13 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 							  NPHY_REV7_RFCTRLOVERRIDE_ID2);
 		}
 
-		if (!NORADIO_ENAB(pi->pubpi)) {
+		if (!NORADIO_ENAB(pi->pubpi))
 			write_phy_reg(pi, 0x32f, 0x3);
-		}
 
-		if ((pi->pubpi.radiorev == 4) || (pi->pubpi.radiorev == 6)) {
+		if ((pi->pubpi.radiorev == 4) || (pi->pubpi.radiorev == 6))
 			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 2),
 							  1, 0x3, 0,
 							  NPHY_REV7_RFCTRLOVERRIDE_ID0);
-		}
 
 		if ((pi->pubpi.radiorev == 3) || (pi->pubpi.radiorev == 4) ||
 		    (pi->pubpi.radiorev == 6)) {
@@ -15635,10 +15588,8 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 			if (CHSPEC_IS2G(pi->radio_chanspec)) {
 				if ((pi->pubpi.radiorev == 3)
 				    || (pi->pubpi.radiorev == 4)
-				    || (pi->pubpi.radiorev == 6)) {
-
+				    || (pi->pubpi.radiorev == 6))
 					txgm_idac_bleed = 0x7f;
-				}
 
 				for (coreNum = 0; coreNum <= 1; coreNum++) {
 					if (txgm_idac_bleed != 0)
@@ -15918,7 +15869,7 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 				       sizeof(rfseq_tx2rx_events_rev3) /
 				       sizeof(rfseq_tx2rx_events_rev3[0]));
 
-		if (PHY_IPA(pi)) {
+		if (PHY_IPA(pi))
 			wlc_phy_set_rfseq_nphy(pi, NPHY_RFSEQ_RX2TX,
 					       rfseq_rx2tx_events_rev3_ipa,
 					       rfseq_rx2tx_dlys_rev3_ipa,
@@ -15927,7 +15878,6 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 					       sizeof
 					       (rfseq_rx2tx_events_rev3_ipa
 						[0]));
-		}
 
 		if ((pi->sh->hw_phyrxchain != 0x3) &&
 		    (pi->sh->hw_phyrxchain != pi->sh->hw_phytxchain)) {
@@ -15947,11 +15897,10 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 						      [0]));
 		}
 
-		if (CHSPEC_IS2G(pi->radio_chanspec)) {
+		if (CHSPEC_IS2G(pi->radio_chanspec))
 			write_phy_reg(pi, 0x6a, 0x2);
-		} else {
+		else
 			write_phy_reg(pi, 0x6a, 0x9c40);
-		}
 
 		mod_phy_reg(pi, 0x294, (0xf << 8), (7 << 8));
 
@@ -16212,11 +16161,10 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 
 		if (NREV_GE(pi->pubpi.phy_rev, 6)) {
 
-			if (pi->sh->boardflags2 & BFL2_SINGLEANT_CCK) {
+			if (pi->sh->boardflags2 & BFL2_SINGLEANT_CCK)
 				wlapi_bmac_mhf(pi->sh->physhim, MHF4,
 					MHF4_BPHY_TXCORE0,
 					MHF4_BPHY_TXCORE0, BRCM_BAND_ALL);
-			}
 		}
 	} else {
 
@@ -16314,11 +16262,10 @@ static void wlc_phy_workarounds_nphy(struct brcms_phy *pi)
 			write_phy_reg(pi, 0x194, 0x0);
 		}
 
-		if (NREV_IS(pi->pubpi.phy_rev, 2)) {
+		if (NREV_IS(pi->pubpi.phy_rev, 2))
 			mod_phy_reg(pi, 0x221,
 				    NPHY_FORCESIG_DECODEGATEDCLKS,
 				    NPHY_FORCESIG_DECODEGATEDCLKS);
-		}
 	}
 
 	if (pi->phyhang_avoid)
@@ -16485,7 +16432,6 @@ static void wlc_phy_workarounds_nphy_gainctrl(struct brcms_phy *pi)
 
 	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 		if (pi->pubpi.radiorev == 5) {
-
 			wlc_phy_workarounds_nphy_gainctrl_2057_rev5(pi);
 		} else if (pi->pubpi.radiorev == 7) {
 			wlc_phy_workarounds_nphy_gainctrl_2057_rev6(pi);
@@ -16697,11 +16643,11 @@ static void wlc_phy_workarounds_nphy_gainctrl(struct brcms_phy *pi)
 				crsmin_th = crsminA_th_rev6;
 				crsminl_th = crsminlA_th_rev6;
 				if ((pi->pubpi.radiorev == 11) &&
-				    (CHSPEC_IS40(pi->radio_chanspec) == 0)) {
+				    (CHSPEC_IS40(pi->radio_chanspec) == 0))
 					crsminu_th = crsminuA_th_rev6_224B0;
-				} else {
+				else
 					crsminu_th = crsminuA_th_rev6;
-				}
+
 				nbclip_th = nbclipA_th_rev6;
 				rssi_gain = rssiA_gain_rev6;
 			} else if (NREV_IS(pi->pubpi.phy_rev, 5)) {
@@ -16895,9 +16841,8 @@ static void wlc_phy_workarounds_nphy_gainctrl(struct brcms_phy *pi)
 		mod_phy_reg(pi, 0x20, (0x1f << 7), (hpf_code << 7));
 		mod_phy_reg(pi, 0x36, (0x1f << 7), (hpf_code << 7));
 
-		for (ctr = 0; ctr < 4; ctr++) {
+		for (ctr = 0; ctr < 4; ctr++)
 			regval[ctr] = (hpf_code << 8) | 0x7c;
-		}
 		wlc_phy_table_write_nphy(pi, 7, 4, 0x106, 16, regval);
 
 		wlc_phy_adjust_lnagaintbl_nphy(pi);
@@ -16910,22 +16855,19 @@ static void wlc_phy_workarounds_nphy_gainctrl(struct brcms_phy *pi)
 			wlc_phy_table_write_nphy(pi, 2, 4, 8, 16, regval);
 			wlc_phy_table_write_nphy(pi, 3, 4, 8, 16, regval);
 
-			for (ctr = 0; ctr < 4; ctr++) {
+			for (ctr = 0; ctr < 4; ctr++)
 				regval[ctr] = (hpf_code << 8) | 0x74;
-			}
 			wlc_phy_table_write_nphy(pi, 7, 4, 0x106, 16, regval);
 		}
 
 		if (NREV_IS(pi->pubpi.phy_rev, 2)) {
-			for (ctr = 0; ctr < 21; ctr++) {
+			for (ctr = 0; ctr < 21; ctr++)
 				regval[ctr] = 3 * ctr;
-			}
 			wlc_phy_table_write_nphy(pi, 0, 21, 32, 16, regval);
 			wlc_phy_table_write_nphy(pi, 1, 21, 32, 16, regval);
 
-			for (ctr = 0; ctr < 21; ctr++) {
+			for (ctr = 0; ctr < 21; ctr++)
 				regval[ctr] = (u16) ctr;
-			}
 			wlc_phy_table_write_nphy(pi, 2, 21, 32, 16, regval);
 			wlc_phy_table_write_nphy(pi, 3, 21, 32, 16, regval);
 		}
@@ -17201,9 +17143,7 @@ static void wlc_phy_workarounds_nphy_gainctrl_2057_rev6(struct brcms_phy *pi)
 		} else {
 			mod_phy_reg(pi, 0x280, (0xff << 0), (crsminl_th << 0));
 		}
-
 	}
-
 }
 
 static void wlc_phy_adjust_lnagaintbl_nphy(struct brcms_phy *pi)
@@ -17251,10 +17191,9 @@ static void wlc_phy_adjust_lnagaintbl_nphy(struct brcms_phy *pi)
 			regval[2] = nphy_def_lnagains[3] + gain_delta[core];
 			regval[3] = nphy_def_lnagains[3] + gain_delta[core];
 		} else {
-			for (ctr = 0; ctr < 4; ctr++) {
+			for (ctr = 0; ctr < 4; ctr++)
 				regval[ctr] =
 				    nphy_def_lnagains[ctr] + gain_delta[core];
-			}
 		}
 		wlc_phy_table_write_nphy(pi, core, 4, 8, 16, regval);
 
@@ -17515,19 +17454,15 @@ static void wlc_phy_radio_postinit_2056(struct brcms_phy *pi)
 	mod_radio_reg(pi, RADIO_2056_SYN_COM_RESET, 0x2, 0x0);
 
 	if ((pi->sh->boardflags2 & BFL2_LEGACY)
-	    || (pi->sh->boardflags2 & BFL2_XTALBUFOUTEN)) {
-
+	    || (pi->sh->boardflags2 & BFL2_XTALBUFOUTEN))
 		mod_radio_reg(pi, RADIO_2056_SYN_PLL_MAST2, 0xf4, 0x0);
-	} else {
-
+	else
 		mod_radio_reg(pi, RADIO_2056_SYN_PLL_MAST2, 0xfc, 0x0);
-	}
 
 	mod_radio_reg(pi, RADIO_2056_SYN_RCCAL_CTRL0, 0x1, 0x0);
 
-	if (pi->phy_init_por) {
+	if (pi->phy_init_por)
 		wlc_phy_radio205x_rcal(pi);
-	}
 }
 
 static void wlc_phy_radio_init_2057(struct brcms_phy *pi)
@@ -17535,23 +17470,18 @@ static void wlc_phy_radio_init_2057(struct brcms_phy *pi)
 	struct radio_20xx_regs *regs_2057_ptr = NULL;
 
 	if (NREV_IS(pi->pubpi.phy_rev, 7)) {
-
 		regs_2057_ptr = regs_2057_rev4;
 	} else if (NREV_IS(pi->pubpi.phy_rev, 8)
 		   || NREV_IS(pi->pubpi.phy_rev, 9)) {
 		switch (pi->pubpi.radiorev) {
 		case 5:
 
-			if (pi->pubpi.radiover == 0x0) {
-
+			if (pi->pubpi.radiover == 0x0)
 				regs_2057_ptr = regs_2057_rev5;
-
-			} else if (pi->pubpi.radiover == 0x1) {
-
+			else if (pi->pubpi.radiover == 0x1)
 				regs_2057_ptr = regs_2057_rev5v1;
-			} else {
+			else
 				break;
-			}
 
 		case 7:
 
@@ -17652,9 +17582,9 @@ wlc_phy_chan2freq_nphy(struct brcms_phy *pi, uint channel, int *f,
 				break;
 
 			default:
-				if (NORADIO_ENAB(pi->pubpi)) {
+				if (NORADIO_ENAB(pi->pubpi))
 					goto fail;
-				}
+
 				break;
 			}
 		} else if (NREV_IS(pi->pubpi.phy_rev, 16)) {
@@ -17677,9 +17607,9 @@ wlc_phy_chan2freq_nphy(struct brcms_phy *pi, uint channel, int *f,
 			}
 		}
 
-		if (i >= tbl_len) {
+		if (i >= tbl_len)
 			goto fail;
-		}
+
 		if (pi->pubpi.radiorev == 5) {
 			*t2 = &chan_info_tbl_p_2[i];
 			freq = chan_info_tbl_p_2[i].freq;
@@ -17721,9 +17651,9 @@ wlc_phy_chan2freq_nphy(struct brcms_phy *pi, uint channel, int *f,
 				tbl_len = ARRAY_SIZE(chan_info_nphyrev6_2056v11);
 				break;
 			default:
-				if (NORADIO_ENAB(pi->pubpi)) {
+				if (NORADIO_ENAB(pi->pubpi))
 					goto fail;
-				}
+
 				break;
 			}
 		}
@@ -17733,9 +17663,9 @@ wlc_phy_chan2freq_nphy(struct brcms_phy *pi, uint channel, int *f,
 				break;
 		}
 
-		if (i >= tbl_len) {
+		if (i >= tbl_len)
 			goto fail;
-		}
+
 		*t1 = &chan_info_tbl_p_1[i];
 		freq = chan_info_tbl_p_1[i].freq;
 
@@ -17744,9 +17674,9 @@ wlc_phy_chan2freq_nphy(struct brcms_phy *pi, uint channel, int *f,
 			if (chan_info_nphy_2055[i].chan == channel)
 				break;
 
-		if (i >= ARRAY_SIZE(chan_info_nphy_2055)) {
+		if (i >= ARRAY_SIZE(chan_info_nphy_2055))
 			goto fail;
-		}
+
 		*t3 = &chan_info_nphy_2055[i];
 		freq = chan_info_nphy_2055[i].freq;
 	}
@@ -17778,13 +17708,12 @@ u8 wlc_phy_get_chan_freq_range_nphy(struct brcms_phy *pi, uint channel)
 	if (CHSPEC_IS2G(pi->radio_chanspec))
 		return WL_CHAN_FREQ_RANGE_2G;
 
-	if ((freq >= BASE_LOW_5G_CHAN) && (freq < BASE_MID_5G_CHAN)) {
+	if ((freq >= BASE_LOW_5G_CHAN) && (freq < BASE_MID_5G_CHAN))
 		return WL_CHAN_FREQ_RANGE_5GL;
-	} else if ((freq >= BASE_MID_5G_CHAN) && (freq < BASE_HIGH_5G_CHAN)) {
+	else if ((freq >= BASE_MID_5G_CHAN) && (freq < BASE_HIGH_5G_CHAN))
 		return WL_CHAN_FREQ_RANGE_5GM;
-	} else {
+	else
 		return WL_CHAN_FREQ_RANGE_5GH;
-	}
 }
 
 static void
@@ -17960,15 +17889,14 @@ wlc_phy_chanspec_radio2056_setup(struct brcms_phy *pi,
 			break;
 		}
 	}
-	if (CHSPEC_IS2G(pi->radio_chanspec)) {
+	if (CHSPEC_IS2G(pi->radio_chanspec))
 		write_radio_reg(pi, RADIO_2056_SYN_PLL_CP2 |
 				RADIO_2056_SYN,
 				(u16) regs_SYN_2056_ptr[0x49 - 2].init_g);
-	} else {
+	else
 		write_radio_reg(pi, RADIO_2056_SYN_PLL_CP2 |
 				RADIO_2056_SYN,
 				(u16) regs_SYN_2056_ptr[0x49 - 2].init_a);
-	}
 
 	if (pi->sh->boardflags2 & BFL2_GPLL_WAR) {
 		if (CHSPEC_IS2G(pi->radio_chanspec)) {
@@ -18116,11 +18044,11 @@ wlc_phy_chanspec_radio2056_setup(struct brcms_phy *pi,
 
 			paa_boost_tune = 0x0;
 			pada_boost_tune = 0x77;
-			if (freq != 5825) {
+			if (freq != 5825)
 				pgaa_boost_tune = -(int)(freq - 18) / 36 + 168;
-			} else {
+			else
 				pgaa_boost_tune = 6;
-			}
+
 			mixa_boost_tune = 0xf;
 		}
 
@@ -18146,9 +18074,8 @@ wlc_phy_chanspec_radio2056_setup(struct brcms_phy *pi,
 
 			if ((pi->sh->chip == BCM43224_CHIP_ID) ||
 			    (pi->sh->chip == BCM43225_CHIP_ID)) {
-				if (pi->sh->chippkg == BCM43224_FAB_SMIC) {
+				if (pi->sh->chippkg == BCM43224_FAB_SMIC)
 					cascbias = 0x35;
-				}
 			}
 
 			pabias = (pi->phy_pabias == 0) ? 0x30 : pi->phy_pabias;
@@ -18213,9 +18140,9 @@ static u16 wlc_phy_radio205x_rcal(struct brcms_phy *pi)
 
 		for (i = 0; i < MAX_205x_RCAL_WAITLOOPS; i++) {
 			rcal_reg = read_radio_reg(pi, RADIO_2057_RCAL_STATUS);
-			if (rcal_reg & 0x1) {
+			if (rcal_reg & 0x1)
 				break;
-			}
+
 			udelay(100);
 		}
 
@@ -18264,9 +18191,9 @@ static u16 wlc_phy_radio205x_rcal(struct brcms_phy *pi)
 			rcal_reg = read_radio_reg(pi,
 						  RADIO_2056_SYN_RCAL_CODE_OUT |
 						  RADIO_2056_SYN);
-			if (rcal_reg & 0x80) {
+			if (rcal_reg & 0x80)
 				break;
-			}
+
 			udelay(100);
 		}
 
@@ -18455,9 +18382,8 @@ wlc_phy_chanspec_radio2057_setup(struct brcms_phy *pi,
 
 	if (CHSPEC_IS2G(pi->radio_chanspec)) {
 		if (PHY_IPA(pi)) {
-			if (pi->pubpi.radiorev == 3) {
+			if (pi->pubpi.radiorev == 3)
 				txmix2g_tune_boost_pu = 0x6b;
-			}
 
 			if (pi->pubpi.radiorev == 5)
 				pad2g_tune_pus = 0x73;
@@ -18513,9 +18439,9 @@ static u16 wlc_phy_radio2057_rccal(struct brcms_phy *pi)
 
 	for (i = 0; i < MAX_205x_RCAL_WAITLOOPS; i++) {
 		rccal_valid = read_radio_reg(pi, RADIO_2057_RCCAL_DONE_OSCCAP);
-		if (rccal_valid & 0x2) {
+		if (rccal_valid & 0x2)
 			break;
-		}
+
 		udelay(500);
 	}
 
@@ -18535,9 +18461,9 @@ static u16 wlc_phy_radio2057_rccal(struct brcms_phy *pi)
 
 	for (i = 0; i < MAX_205x_RCAL_WAITLOOPS; i++) {
 		rccal_valid = read_radio_reg(pi, RADIO_2057_RCCAL_DONE_OSCCAP);
-		if (rccal_valid & 0x2) {
+		if (rccal_valid & 0x2)
 			break;
-		}
+
 		udelay(500);
 	}
 
@@ -18558,9 +18484,9 @@ static u16 wlc_phy_radio2057_rccal(struct brcms_phy *pi)
 
 	for (i = 0; i < MAX_205x_RCAL_WAITLOOPS; i++) {
 		rccal_valid = read_radio_reg(pi, RADIO_2057_RCCAL_DONE_OSCCAP);
-		if (rccal_valid & 0x2) {
+		if (rccal_valid & 0x2)
 			break;
-		}
+
 		udelay(500);
 	}
 
@@ -18706,19 +18632,18 @@ static void wlc_phy_txlpfbw_nphy(struct brcms_phy *pi)
 	u8 tx_lpf_bw = 0;
 
 	if (NREV_GE(pi->pubpi.phy_rev, 3) && NREV_LT(pi->pubpi.phy_rev, 7)) {
-		if (CHSPEC_IS40(pi->radio_chanspec)) {
+		if (CHSPEC_IS40(pi->radio_chanspec))
 			tx_lpf_bw = 3;
-		} else {
+		else
 			tx_lpf_bw = 1;
-		}
 
 		if (PHY_IPA(pi)) {
-			if (CHSPEC_IS40(pi->radio_chanspec)) {
+			if (CHSPEC_IS40(pi->radio_chanspec))
 				tx_lpf_bw = 5;
-			} else {
+			else
 				tx_lpf_bw = 4;
-			}
 		}
+
 		write_phy_reg(pi, 0xe8,
 			      (tx_lpf_bw << 0) |
 			      (tx_lpf_bw << 3) |
@@ -18726,11 +18651,10 @@ static void wlc_phy_txlpfbw_nphy(struct brcms_phy *pi)
 
 		if (PHY_IPA(pi)) {
 
-			if (CHSPEC_IS40(pi->radio_chanspec)) {
+			if (CHSPEC_IS40(pi->radio_chanspec))
 				tx_lpf_bw = 4;
-			} else {
+			else
 				tx_lpf_bw = 1;
-			}
 
 			write_phy_reg(pi, 0xe9,
 				      (tx_lpf_bw << 0) |
@@ -18762,18 +18686,16 @@ static void wlc_phy_spurwar_nphy(struct brcms_phy *pi)
 
 			if (CHSPEC_IS2G(pi->radio_chanspec)) {
 				if ((cur_channel == 11)
-				    && CHSPEC_IS40(pi->radio_chanspec)) {
-
+				    && CHSPEC_IS40(pi->radio_chanspec))
 					wlc_phy_adjust_min_noisevar_nphy(pi, 2,
 									 nphy_adj_tone_id_buf,
 									 nphy_adj_noise_var_buf);
-				} else {
-
+				else
 					wlc_phy_adjust_min_noisevar_nphy(pi, 0,
 									 NULL,
 									 NULL);
-				}
 			}
+
 			wlc_phy_adjust_crsminpwr_nphy(pi,
 						      NPHY_ADJUSTED_MINCRSPOWER);
 		}
@@ -18857,7 +18779,6 @@ static void wlc_phy_spurwar_nphy(struct brcms_phy *pi)
 				tempval = 0;
 
 			} else {
-
 				wlc_phy_adjust_min_noisevar_nphy(pi, 0, NULL,
 								 NULL);
 			}
@@ -18896,14 +18817,13 @@ static void wlc_phy_spurwar_nphy(struct brcms_phy *pi)
 			}
 
 			if (nphy_adj_tone_id_buf[0]
-			    && nphy_adj_noise_var_buf[0]) {
+			    && nphy_adj_noise_var_buf[0])
 				wlc_phy_adjust_min_noisevar_nphy(pi, 1,
 								 nphy_adj_tone_id_buf,
 								 nphy_adj_noise_var_buf);
-			} else {
+			else
 				wlc_phy_adjust_min_noisevar_nphy(pi, 0, NULL,
 								 NULL);
-			}
 		}
 
 		if (pi->phyhang_avoid)
@@ -18964,14 +18884,11 @@ wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, u16 chanspec,
 			and_phy_reg(pi, NPHY_TO_BPHY_OFF + BPHY_TEST, ~0x840);
 	}
 
-	if (pi->nphy_txpwrctrl == PHY_TPC_HW_OFF) {
+	if (pi->nphy_txpwrctrl == PHY_TPC_HW_OFF)
 		wlc_phy_txpwr_fixpower_nphy(pi);
-	}
-
-	if (NREV_LT(pi->pubpi.phy_rev, 3)) {
 
+	if (NREV_LT(pi->pubpi.phy_rev, 3))
 		wlc_phy_adjust_lnagaintbl_nphy(pi);
-	}
 
 	wlc_phy_txlpfbw_nphy(pi);
 
@@ -18982,28 +18899,20 @@ wlc_phy_chanspec_nphy_setup(struct brcms_phy *pi, u16 chanspec,
 		val = CHSPEC_CHANNEL(chanspec);
 		if (!CHSPEC_IS40(pi->radio_chanspec)) {
 			if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-				if ((val == 13) || (val == 14) || (val == 153)) {
+				if ((val == 13) || (val == 14) || (val == 153))
 					spuravoid = 1;
-				}
-			} else {
-
-				if (((val >= 5) && (val <= 8)) || (val == 13)
+			} else if (((val >= 5) && (val <= 8)) || (val == 13)
 				    || (val == 14)) {
 					spuravoid = 1;
-				}
 			}
+		} else if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+			if (val == 54)
+				spuravoid = 1;
 		} else {
-			if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-				if (val == 54) {
-					spuravoid = 1;
-				}
-			} else {
-
-				if (pi->nphy_aband_spurwar_en &&
-				    ((val == 38) || (val == 102)
-				     || (val == 118)))
-					spuravoid = 1;
-			}
+			if (pi->nphy_aband_spurwar_en &&
+			    ((val == 38) || (val == 102)
+			     || (val == 118)))
+				spuravoid = 1;
 		}
 
 		if (pi->phy_spuravoid == SPURAVOID_FORCEON)
@@ -19055,9 +18964,8 @@ void wlc_phy_chanspec_set_nphy(struct brcms_phy *pi, u16 chanspec)
 	struct chan_info_nphy_radio2057_rev5 *t2 = NULL;
 	struct chan_info_nphy_2055 *t3 = NULL;
 
-	if (NORADIO_ENAB(pi->pubpi)) {
+	if (NORADIO_ENAB(pi->pubpi))
 		return;
-	}
 
 	if (!wlc_phy_chan2freq_nphy
 	    (pi, CHSPEC_CHANNEL(chanspec), &freq, &t0, &t1, &t2, &t3))
@@ -19071,15 +18979,13 @@ void wlc_phy_chanspec_set_nphy(struct brcms_phy *pi, u16 chanspec)
 	if (CHSPEC_IS40(chanspec)) {
 		if (CHSPEC_SB_UPPER(chanspec)) {
 			or_phy_reg(pi, 0xa0, BPHY_BAND_SEL_UP20);
-			if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+			if (NREV_GE(pi->pubpi.phy_rev, 7))
 				or_phy_reg(pi, 0x310, PRIM_SEL_UP20);
-			}
 		} else {
 			and_phy_reg(pi, 0xa0, ~BPHY_BAND_SEL_UP20);
-			if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+			if (NREV_GE(pi->pubpi.phy_rev, 7))
 				and_phy_reg(pi, 0x310,
 					    (~PRIM_SEL_UP20 & 0xffff));
-			}
 		}
 	}
 
@@ -19657,11 +19563,10 @@ static u16 wlc_phy_read_lpf_bw_ctl_nphy(struct brcms_phy *pi, u16 offset)
 	u16 rx2tx_lpf_rc_lut_offset = 0;
 
 	if (offset == 0) {
-		if (CHSPEC_IS40(pi->radio_chanspec)) {
+		if (CHSPEC_IS40(pi->radio_chanspec))
 			rx2tx_lpf_rc_lut_offset = 0x159;
-		} else {
+		else
 			rx2tx_lpf_rc_lut_offset = 0x154;
-		}
 	} else {
 		rx2tx_lpf_rc_lut_offset = offset;
 	}
@@ -19932,12 +19837,11 @@ wlc_phy_rfctrl_override_nphy_rev7(struct brcms_phy *pi, u16 field, u16 value,
 				    || (core_mask & (1 << core_num))) {
 					or_phy_reg(pi, en_addr, en_mask);
 
-					if (addr != 0xffff) {
+					if (addr != 0xffff)
 						mod_phy_reg(pi, val_addr,
 							    val_mask,
 							    (value <<
 							     val_shift));
-					}
 				}
 			}
 		}
@@ -20066,12 +19970,11 @@ wlc_phy_rfctrl_override_nphy(struct brcms_phy *pi, u16 field, u16 value,
 				    || (core_mask & (1 << core_num))) {
 					or_phy_reg(pi, en_addr, en_mask);
 
-					if (addr != 0xffff) {
+					if (addr != 0xffff)
 						mod_phy_reg(pi, val_addr,
 							    val_mask,
 							    (value <<
 							     val_shift));
-					}
 				}
 			}
 		}
@@ -20178,9 +20081,8 @@ wlc_phy_rfctrl_override_nphy(struct brcms_phy *pi, u16 field, u16 value,
 				break;
 			}
 
-			if ((addr != 0xffff) && (core_mask & (1 << core_num))) {
+			if ((addr != 0xffff) && (core_mask & (1 << core_num)))
 				mod_phy_reg(pi, addr, mask, (value << shift));
-			}
 		}
 
 		or_phy_reg(pi, 0xec, (0x1 << 0));
@@ -20291,130 +20193,118 @@ wlc_phy_scale_offset_rssi_nphy(struct brcms_phy *pi, u16 scale, s8 offset,
 
 	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
 	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_NB)) {
+	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_NB))
 		write_phy_reg(pi, 0x1a6, valuetostuff);
-	}
+
 	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
 	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_NB)) {
+	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_NB))
 		write_phy_reg(pi, 0x1ac, valuetostuff);
-	}
+
 	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
 	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_NB)) {
+	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_NB))
 		write_phy_reg(pi, 0x1b2, valuetostuff);
-	}
+
 	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
 	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_NB)) {
+	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_NB))
 		write_phy_reg(pi, 0x1b8, valuetostuff);
-	}
 
 	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
 	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_W1)) {
+	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_W1))
 		write_phy_reg(pi, 0x1a4, valuetostuff);
-	}
+
 	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
 	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_W1)) {
+	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_W1))
 		write_phy_reg(pi, 0x1aa, valuetostuff);
-	}
+
 	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
 	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_W1)) {
+	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_W1))
 		write_phy_reg(pi, 0x1b0, valuetostuff);
-	}
+
 	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
 	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_W1)) {
+	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_W1))
 		write_phy_reg(pi, 0x1b6, valuetostuff);
-	}
 
 	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
 	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_W2)) {
+	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_W2))
 		write_phy_reg(pi, 0x1a5, valuetostuff);
-	}
 	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
 	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_W2)) {
+	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_W2))
 		write_phy_reg(pi, 0x1ab, valuetostuff);
-	}
+
 	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
 	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_W2)) {
+	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_W2))
 		write_phy_reg(pi, 0x1b1, valuetostuff);
-	}
+
 	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
 	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_W2)) {
+	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_W2))
 		write_phy_reg(pi, 0x1b7, valuetostuff);
-	}
 
 	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
 	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_TBD)) {
+	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_TBD))
 		write_phy_reg(pi, 0x1a7, valuetostuff);
-	}
 	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
 	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_TBD)) {
+	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_TBD))
 		write_phy_reg(pi, 0x1ad, valuetostuff);
-	}
 	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
 	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_TBD)) {
+	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_TBD))
 		write_phy_reg(pi, 0x1b3, valuetostuff);
-	}
 	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
 	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_TBD)) {
+	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_TBD))
 		write_phy_reg(pi, 0x1b9, valuetostuff);
-	}
 
 	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
 	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_IQ)) {
+	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_IQ))
 		write_phy_reg(pi, 0x1a8, valuetostuff);
-	}
+
 	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
 	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_IQ)) {
+	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_IQ))
 		write_phy_reg(pi, 0x1ae, valuetostuff);
-	}
+
 	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
 	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_IQ)) {
+	    (rail == NPHY_RAIL_I) && (rssi_type == NPHY_RSSI_SEL_IQ))
 		write_phy_reg(pi, 0x1b4, valuetostuff);
-	}
+
 	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
 	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_IQ)) {
+	    (rail == NPHY_RAIL_Q) && (rssi_type == NPHY_RSSI_SEL_IQ))
 		write_phy_reg(pi, 0x1ba, valuetostuff);
-	}
 
 	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
 	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rssi_type == NPHY_RSSI_SEL_TSSI_2G)) {
+	    (rssi_type == NPHY_RSSI_SEL_TSSI_2G))
 		write_phy_reg(pi, 0x1a9, valuetostuff);
-	}
 	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
 	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rssi_type == NPHY_RSSI_SEL_TSSI_2G)) {
+	    (rssi_type == NPHY_RSSI_SEL_TSSI_2G))
 		write_phy_reg(pi, 0x1b5, valuetostuff);
-	}
 
 	if (((coresel == RADIO_MIMO_CORESEL_CORE1) ||
 	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rssi_type == NPHY_RSSI_SEL_TSSI_5G)) {
+	    (rssi_type == NPHY_RSSI_SEL_TSSI_5G))
 		write_phy_reg(pi, 0x1af, valuetostuff);
-	}
+
 	if (((coresel == RADIO_MIMO_CORESEL_CORE2) ||
 	     (coresel == RADIO_MIMO_CORESEL_ALLRX)) &&
-	    (rssi_type == NPHY_RSSI_SEL_TSSI_5G)) {
+	    (rssi_type == NPHY_RSSI_SEL_TSSI_5G))
 		write_phy_reg(pi, 0x1bb, valuetostuff);
-	}
 }
 
 void wlc_phy_rssisel_nphy(struct brcms_phy *pi, u8 core_code, u8 rssi_type)
@@ -20459,7 +20349,6 @@ void wlc_phy_rssisel_nphy(struct brcms_phy *pi, u8 core_code, u8 rssi_type)
 				if (rssi_type == NPHY_RSSI_SEL_W1 ||
 				    rssi_type == NPHY_RSSI_SEL_W2 ||
 				    rssi_type == NPHY_RSSI_SEL_NB) {
-
 					mod_phy_reg(pi,
 						    (core ==
 						     PHY_CORE_0) ? 0xa6 : 0xa7,
@@ -20501,7 +20390,6 @@ void wlc_phy_rssisel_nphy(struct brcms_phy *pi, u8 core_code, u8 rssi_type)
 						    0xe5 : 0xe6, mask, val);
 				} else {
 					if (rssi_type == NPHY_RSSI_SEL_TBD) {
-
 						mask = (0x3 << 8);
 						val = 1 << 8;
 						mod_phy_reg(pi,
@@ -20516,7 +20404,6 @@ void wlc_phy_rssisel_nphy(struct brcms_phy *pi, u8 core_code, u8 rssi_type)
 							    : 0xa7, mask, val);
 					} else if (rssi_type ==
 						   NPHY_RSSI_SEL_IQ) {
-
 						mask = (0x3 << 8);
 						val = 2 << 8;
 						mod_phy_reg(pi,
@@ -20530,7 +20417,6 @@ void wlc_phy_rssisel_nphy(struct brcms_phy *pi, u8 core_code, u8 rssi_type)
 							     PHY_CORE_0) ? 0xa6
 							    : 0xa7, mask, val);
 					} else {
-
 						mask = (0x3 << 8);
 						val = 3 << 8;
 						mod_phy_reg(pi,
@@ -20547,8 +20433,7 @@ void wlc_phy_rssisel_nphy(struct brcms_phy *pi, u8 core_code, u8 rssi_type)
 						if (PHY_IPA(pi)) {
 							if (NREV_GE
 							    (pi->pubpi.phy_rev,
-							     7)) {
-
+							     7))
 								write_radio_reg
 								    (pi,
 								     ((core ==
@@ -20562,7 +20447,7 @@ void wlc_phy_rssisel_nphy(struct brcms_phy *pi, u8 core_code, u8 rssi_type)
 								       radio_chanspec)
 								      ? 0xc :
 								      0xe));
-							} else {
+							else
 								write_radio_reg
 								    (pi,
 								     RADIO_2056_TX_TX_SSI_MUX
@@ -20578,7 +20463,6 @@ void wlc_phy_rssisel_nphy(struct brcms_phy *pi, u8 core_code, u8 rssi_type)
 								       radio_chanspec)
 								      ? 0xc :
 								      0xe));
-							}
 						} else {
 
 							if (NREV_GE
@@ -20631,19 +20515,15 @@ void wlc_phy_rssisel_nphy(struct brcms_phy *pi, u8 core_code, u8 rssi_type)
 
 		if ((rssi_type == NPHY_RSSI_SEL_W1) ||
 		    (rssi_type == NPHY_RSSI_SEL_W2) ||
-		    (rssi_type == NPHY_RSSI_SEL_NB)) {
-
+		    (rssi_type == NPHY_RSSI_SEL_NB))
 			val = 0x0;
-		} else if (rssi_type == NPHY_RSSI_SEL_TBD) {
-
+		else if (rssi_type == NPHY_RSSI_SEL_TBD)
 			val = 0x1;
-		} else if (rssi_type == NPHY_RSSI_SEL_IQ) {
-
+		else if (rssi_type == NPHY_RSSI_SEL_IQ)
 			val = 0x2;
-		} else {
-
+		else
 			val = 0x3;
-		}
+
 		mask = ((0x3 << 12) | (0x3 << 14));
 		val = (val << 12) | (val << 14);
 		mod_phy_reg(pi, 0xa6, mask, val);
@@ -20652,15 +20532,13 @@ void wlc_phy_rssisel_nphy(struct brcms_phy *pi, u8 core_code, u8 rssi_type)
 		if ((rssi_type == NPHY_RSSI_SEL_W1) ||
 		    (rssi_type == NPHY_RSSI_SEL_W2) ||
 		    (rssi_type == NPHY_RSSI_SEL_NB)) {
-			if (rssi_type == NPHY_RSSI_SEL_W1) {
+			if (rssi_type == NPHY_RSSI_SEL_W1)
 				val = 0x1;
-			}
-			if (rssi_type == NPHY_RSSI_SEL_W2) {
+			if (rssi_type == NPHY_RSSI_SEL_W2)
 				val = 0x2;
-			}
-			if (rssi_type == NPHY_RSSI_SEL_NB) {
+			if (rssi_type == NPHY_RSSI_SEL_NB)
 				val = 0x3;
-			}
+
 			mask = (0x3 << 4);
 			val = (val << 4);
 			mod_phy_reg(pi, 0x7a, mask, val);
@@ -20762,13 +20640,11 @@ wlc_phy_poll_rssi_nphy(struct brcms_phy *pi, u8 rssi_type, s32 *rssi_buf,
 	wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_ALLRX, rssi_type);
 
 	gpiosel_orig = read_phy_reg(pi, 0xca);
-	if (NREV_LT(pi->pubpi.phy_rev, 2)) {
+	if (NREV_LT(pi->pubpi.phy_rev, 2))
 		write_phy_reg(pi, 0xca, 5);
-	}
 
-	for (ctr = 0; ctr < 4; ctr++) {
+	for (ctr = 0; ctr < 4; ctr++)
 		rssi_buf[ctr] = 0;
-	}
 
 	for (samp = 0; samp < nsamps; samp++) {
 		if (NREV_LT(pi->pubpi.phy_rev, 2)) {
@@ -20785,9 +20661,8 @@ wlc_phy_poll_rssi_nphy(struct brcms_phy *pi, u8 rssi_type, s32 *rssi_buf,
 		tmp_buf[ctr++] = ((s8) ((rssi1 & 0x3f) << 2)) >> 2;
 		tmp_buf[ctr++] = ((s8) (((rssi1 >> 8) & 0x3f) << 2)) >> 2;
 
-		for (ctr = 0; ctr < 4; ctr++) {
+		for (ctr = 0; ctr < 4; ctr++)
 			rssi_buf[ctr] += tmp_buf[ctr];
-		}
 
 	}
 
@@ -20796,9 +20671,8 @@ wlc_phy_poll_rssi_nphy(struct brcms_phy *pi, u8 rssi_type, s32 *rssi_buf,
 	rssi_out_val |= (rssi_buf[1] & 0xff) << 16;
 	rssi_out_val |= (rssi_buf[0] & 0xff) << 24;
 
-	if (NREV_LT(pi->pubpi.phy_rev, 2)) {
+	if (NREV_LT(pi->pubpi.phy_rev, 2))
 		write_phy_reg(pi, 0xca, gpiosel_orig);
-	}
 
 	write_phy_reg(pi, 0xa6, afectrlCore1_save);
 	write_phy_reg(pi, 0xa7, afectrlCore2_save);
@@ -20997,11 +20871,10 @@ s16 wlc_phy_tempsense_nphy(struct brcms_phy *pi)
 			write_radio_reg(pi, RADIO_2056_SYN_TEMPPROCSENSE, 0x05);
 
 		wlc_phy_poll_rssi_nphy(pi, NPHY_RSSI_SEL_IQ, radio_temp2, 1);
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		if (NREV_GE(pi->pubpi.phy_rev, 7))
 			write_radio_reg(pi, RADIO_2057_TEMPSENSE_CONFIG, 0x01);
-		} else {
+		else
 			write_radio_reg(pi, RADIO_2056_SYN_TEMPPROCSENSE, 0x01);
-		}
 
 		radio_temp[0] =
 		    (126 * (radio_temp[1] + radio_temp2[1]) + 3987) / 64;
@@ -21126,22 +20999,20 @@ wlc_phy_set_rssi_2055_vcm(struct brcms_phy *pi, u8 rssi_type, u8 *vcm_buf)
 					      RADIO_2055_NBRSSI_VCM_Q_SHIFT);
 			}
 		} else {
-
-			if (core == PHY_CORE_0) {
+			if (core == PHY_CORE_0)
 				mod_radio_reg(pi,
 					      RADIO_2055_CORE1_RXBB_RSSI_CTRL5,
 					      RADIO_2055_WBRSSI_VCM_IQ_MASK,
 					      vcm_buf[2 *
 						      core] <<
 					      RADIO_2055_WBRSSI_VCM_IQ_SHIFT);
-			} else {
+			else
 				mod_radio_reg(pi,
 					      RADIO_2055_CORE2_RXBB_RSSI_CTRL5,
 					      RADIO_2055_WBRSSI_VCM_IQ_MASK,
 					      vcm_buf[2 *
 						      core] <<
 					      RADIO_2055_WBRSSI_VCM_IQ_SHIFT);
-			}
 		}
 	}
 }
@@ -21149,7 +21020,6 @@ wlc_phy_set_rssi_2055_vcm(struct brcms_phy *pi, u8 rssi_type, u8 *vcm_buf)
 void wlc_phy_rssi_cal_nphy(struct brcms_phy *pi)
 {
 	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-
 		wlc_phy_rssi_cal_nphy_rev3(pi);
 	} else {
 		wlc_phy_rssi_cal_nphy_rev2(pi, NPHY_RSSI_SEL_NB);
@@ -21246,20 +21116,18 @@ static void wlc_phy_rssi_cal_nphy_rev2(struct brcms_phy *pi, u8 rssi_type)
 	for (vcm = 0; vcm < 4; vcm++) {
 
 		vcm_tmp[0] = vcm_tmp[1] = vcm_tmp[2] = vcm_tmp[3] = vcm;
-		if (rssi_type != NPHY_RSSI_SEL_W2) {
+		if (rssi_type != NPHY_RSSI_SEL_W2)
 			wlc_phy_set_rssi_2055_vcm(pi, rssi_type, vcm_tmp);
-		}
 
 		wlc_phy_poll_rssi_nphy(pi, rssi_type, &poll_results[vcm][0],
 				       NPHY_RSSICAL_NPOLL);
 
 		if ((rssi_type == NPHY_RSSI_SEL_W1)
 		    || (rssi_type == NPHY_RSSI_SEL_W2)) {
-			for (ctr = 0; ctr < 2; ctr++) {
+			for (ctr = 0; ctr < 2; ctr++)
 				poll_miniq[vcm][ctr] =
 				    min(poll_results[vcm][ctr * 2 + 0],
 					poll_results[vcm][ctr * 2 + 1]);
-			}
 		}
 	}
 
@@ -21276,17 +21144,15 @@ static void wlc_phy_rssi_cal_nphy_rev2(struct brcms_phy *pi, u8 rssi_type)
 				min_d = curr_d;
 				min_vcm = vcm;
 			}
-			if (poll_results[vcm][result_idx] < min_poll) {
+			if (poll_results[vcm][result_idx] < min_poll)
 				min_poll = poll_results[vcm][result_idx];
-			}
 		}
 		vcm_final[result_idx] = min_vcm;
 		poll_results_min[result_idx] = min_poll;
 	}
 
-	if (rssi_type != NPHY_RSSI_SEL_W2) {
+	if (rssi_type != NPHY_RSSI_SEL_W2)
 		wlc_phy_set_rssi_2055_vcm(pi, rssi_type, vcm_final);
-	}
 
 	for (result_idx = 0; result_idx < 4; result_idx++) {
 		fine_digital_offset[result_idx] =
@@ -21307,10 +21173,9 @@ static void wlc_phy_rssi_cal_nphy_rev2(struct brcms_phy *pi, u8 rssi_type)
 		}
 
 		if (poll_results_min[result_idx] ==
-		    NPHY_RSSICAL_MAXREAD * NPHY_RSSICAL_NPOLL) {
+		    NPHY_RSSICAL_MAXREAD * NPHY_RSSICAL_NPOLL)
 			fine_digital_offset[result_idx] =
 			    (target_code - NPHY_RSSICAL_MAXREAD - 1);
-		}
 
 		wlc_phy_scale_offset_rssi_nphy(pi, 0x0,
 					       (s8)
@@ -21325,32 +21190,30 @@ static void wlc_phy_rssi_cal_nphy_rev2(struct brcms_phy *pi, u8 rssi_type)
 
 	mod_radio_reg(pi, RADIO_2055_PD_CORE1_RSSI_MISC, pd_mask, pd_state[0]);
 	mod_radio_reg(pi, RADIO_2055_PD_CORE2_RSSI_MISC, pd_mask, pd_state[1]);
-	if (rssi_ctrl_state[0] == RADIO_2055_NBRSSI_SEL) {
+	if (rssi_ctrl_state[0] == RADIO_2055_NBRSSI_SEL)
 		wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_CORE1,
 				     NPHY_RSSI_SEL_NB);
-	} else if (rssi_ctrl_state[0] == RADIO_2055_WBRSSI_G1_SEL) {
+	else if (rssi_ctrl_state[0] == RADIO_2055_WBRSSI_G1_SEL)
 		wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_CORE1,
 				     NPHY_RSSI_SEL_W1);
-	} else if (rssi_ctrl_state[0] == RADIO_2055_WBRSSI_G2_SEL) {
+	else if (rssi_ctrl_state[0] == RADIO_2055_WBRSSI_G2_SEL)
 		wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_CORE1,
 				     NPHY_RSSI_SEL_W2);
-	} else {
+	else
 		wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_CORE1,
 				     NPHY_RSSI_SEL_W2);
-	}
-	if (rssi_ctrl_state[1] == RADIO_2055_NBRSSI_SEL) {
+	if (rssi_ctrl_state[1] == RADIO_2055_NBRSSI_SEL)
 		wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_CORE2,
 				     NPHY_RSSI_SEL_NB);
-	} else if (rssi_ctrl_state[1] == RADIO_2055_WBRSSI_G1_SEL) {
+	else if (rssi_ctrl_state[1] == RADIO_2055_WBRSSI_G1_SEL)
 		wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_CORE2,
 				     NPHY_RSSI_SEL_W1);
-	} else if (rssi_ctrl_state[1] == RADIO_2055_WBRSSI_G2_SEL) {
+	else if (rssi_ctrl_state[1] == RADIO_2055_WBRSSI_G2_SEL)
 		wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_CORE2,
 				     NPHY_RSSI_SEL_W2);
-	} else {
+	else
 		wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_CORE2,
 				     NPHY_RSSI_SEL_W2);
-	}
 
 	wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_OFF, rssi_type);
 
@@ -21500,11 +21363,10 @@ wlc_phy_rfctrlintc_override_nphy(struct brcms_phy *pi, u8 field, u16 value,
 
 					mask = (0x1 << 4) | (0x1 << 5);
 
-					if (CHSPEC_IS5G(pi->radio_chanspec)) {
+					if (CHSPEC_IS5G(pi->radio_chanspec))
 						val = value << 5;
-					} else {
+					else
 						val = value << 4;
-					}
 
 					mod_phy_reg(pi,
 						    (core ==
@@ -21636,8 +21498,6 @@ wlc_phy_rfctrlintc_override_nphy(struct brcms_phy *pi, u8 field, u16 value,
 				}
 			}
 		}
-	} else {
-		return;
 	}
 }
 
@@ -21726,21 +21586,19 @@ static void wlc_phy_rssi_cal_nphy_rev3(struct brcms_phy *pi)
 	wlc_phy_rfctrlintc_override_nphy(pi, NPHY_RfctrlIntc_override_TRSW, 1,
 					 RADIO_MIMO_CORESEL_ALLRXTX);
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
 		wlc_phy_rfctrl_override_1tomany_nphy(pi,
 						     NPHY_REV7_RfctrlOverride_cmd_rxrf_pu,
 						     0, 0, 0);
-	} else {
+	else
 		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 0), 0, 0, 0);
-	}
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
 		wlc_phy_rfctrl_override_1tomany_nphy(pi,
 						     NPHY_REV7_RfctrlOverride_cmd_rx_pu,
 						     1, 0, 0);
-	} else {
+	else
 		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 1), 1, 0, 0);
-	}
 
 	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 7),
@@ -21804,21 +21662,18 @@ static void wlc_phy_rssi_cal_nphy_rev3(struct brcms_phy *pi)
 					       NPHY_RAIL_Q, NPHY_RSSI_SEL_NB);
 
 		for (vcm = 0; vcm < vcm_level_max; vcm++) {
-			if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-
+			if (NREV_GE(pi->pubpi.phy_rev, 7))
 				mod_radio_reg(pi, (core == PHY_CORE_0) ?
 					      RADIO_2057_NB_MASTER_CORE0 :
 					      RADIO_2057_NB_MASTER_CORE1,
 					      RADIO_2057_VCM_MASK, vcm);
-			} else {
-
+			else
 				mod_radio_reg(pi, RADIO_2056_RX_RSSI_MISC |
 					      ((core ==
 						PHY_CORE_0) ? RADIO_2056_RX0 :
 					       RADIO_2056_RX1),
 					      RADIO_2056_VCM_MASK,
 					      vcm << RADIO_2056_RSSI_VCM_SHIFT);
-			}
 
 			wlc_phy_poll_rssi_nphy(pi, NPHY_RSSI_SEL_NB,
 					       &poll_results[vcm][0],
@@ -21843,29 +21698,27 @@ static void wlc_phy_rssi_cal_nphy_rev3(struct brcms_phy *pi)
 						min_vcm = vcm;
 					}
 					if (poll_results[vcm][result_idx] <
-					    min_poll) {
+					    min_poll)
 						min_poll =
 						    poll_results[vcm]
 						    [result_idx];
-					}
 				}
 				vcm_final = min_vcm;
 				poll_results_min[result_idx] = min_poll;
 			}
 		}
 
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		if (NREV_GE(pi->pubpi.phy_rev, 7))
 			mod_radio_reg(pi, (core == PHY_CORE_0) ?
 				      RADIO_2057_NB_MASTER_CORE0 :
 				      RADIO_2057_NB_MASTER_CORE1,
 				      RADIO_2057_VCM_MASK, vcm_final);
-		} else {
+		else
 			mod_radio_reg(pi, RADIO_2056_RX_RSSI_MISC |
 				      ((core ==
 					PHY_CORE_0) ? RADIO_2056_RX0 :
 				       RADIO_2056_RX1), RADIO_2056_VCM_MASK,
 				      vcm_final << RADIO_2056_RSSI_VCM_SHIFT);
-		}
 
 		for (result_idx = 0; result_idx < 4; result_idx++) {
 			if (core == result_idx / 2) {
@@ -21891,11 +21744,10 @@ static void wlc_phy_rssi_cal_nphy_rev3(struct brcms_phy *pi)
 				}
 
 				if (poll_results_min[result_idx] ==
-				    NPHY_RSSICAL_MAXREAD * NPHY_RSSICAL_NPOLL) {
+				    NPHY_RSSICAL_MAXREAD * NPHY_RSSICAL_NPOLL)
 					fine_digital_offset[result_idx] =
 					    (NPHY_RSSICAL_NB_TARGET -
 					     NPHY_RSSICAL_MAXREAD - 1);
-				}
 
 				wlc_phy_scale_offset_rssi_nphy(pi, 0x0,
 							       (s8)
@@ -22259,9 +22111,8 @@ wlc_phy_gen_load_samples_nphy(struct brcms_phy *pi, u32 f_kHz, u16 max_val,
 	}
 
 	tone_buf = kmalloc(sizeof(struct cs32) * tbl_len, GFP_ATOMIC);
-	if (tone_buf == NULL) {
+	if (tone_buf == NULL)
 		return 0;
-	}
 
 	num_samps = (u16) tbl_len;
 	rot = FIXED((f_kHz * 36) / phy_bw) / 100;
@@ -22294,9 +22145,8 @@ wlc_phy_tx_tone_nphy(struct brcms_phy *pi, u32 f_kHz, u16 max_val,
 
 	num_samps =
 		wlc_phy_gen_load_samples_nphy(pi, f_kHz, max_val, dac_test_mode);
-	if (num_samps == 0) {
+	if (num_samps == 0)
 		return -EBADE;
-	}
 
 	wlc_phy_runsamples_nphy(pi, num_samps, loops, wait, iqmode,
 				dac_test_mode, modify_bbmult);
@@ -22312,17 +22162,15 @@ wlc_phy_loadsampletable_nphy(struct brcms_phy *pi, struct cs32 *tone_buf,
 	u32 *data_buf = NULL;
 
 	data_buf = kmalloc(sizeof(u32) * num_samps, GFP_ATOMIC);
-	if (data_buf == NULL) {
+	if (data_buf == NULL)
 		return;
-	}
 
 	if (pi->phyhang_avoid)
 		wlc_phy_stay_in_carriersearch_nphy(pi, true);
 
-	for (t = 0; t < num_samps; t++) {
+	for (t = 0; t < num_samps; t++)
 		data_buf[t] = ((((unsigned int)tone_buf[t].i) & 0x3ff) << 10) |
 		    (((unsigned int)tone_buf[t].q) & 0x3ff);
-	}
 	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_SAMPLEPLAY, num_samps, 0, 32,
 				 data_buf);
 
@@ -22395,11 +22243,11 @@ wlc_phy_runsamples_nphy(struct brcms_phy *pi, u16 num_samps, u16 loops,
 
 	write_phy_reg(pi, 0xc6, num_samps - 1);
 
-	if (loops != 0xffff) {
+	if (loops != 0xffff)
 		write_phy_reg(pi, 0xc4, loops - 1);
-	} else {
+	else
 		write_phy_reg(pi, 0xc4, loops);
-	}
+
 	write_phy_reg(pi, 0xc5, wait);
 
 	orig_RfseqCoreActv = read_phy_reg(pi, 0xa1);
@@ -22429,13 +22277,11 @@ void wlc_phy_stopplayback_nphy(struct brcms_phy *pi)
 		wlc_phy_stay_in_carriersearch_nphy(pi, true);
 
 	playback_status = read_phy_reg(pi, 0xc7);
-	if (playback_status & 0x1) {
+	if (playback_status & 0x1)
 		or_phy_reg(pi, 0xc3, NPHY_sampleCmd_STOP);
-	} else if (playback_status & 0x2) {
-
+	else if (playback_status & 0x2)
 		and_phy_reg(pi, 0xc2,
 			    (u16) ~NPHY_iqloCalCmdGctl_IQLO_CAL_EN);
-	}
 
 	and_phy_reg(pi, 0xc3, (u16) ~(0x1 << 2));
 
@@ -22523,10 +22369,10 @@ struct nphy_txgains wlc_phy_get_tx_gain_nphy(struct brcms_phy *pi)
 					    wlc_phy_get_ipa_gaintbl_nphy(pi);
 				} else {
 					if (CHSPEC_IS5G(pi->radio_chanspec)) {
-						if (NREV_IS(phyrev, 3)) {
+						if (NREV_IS(phyrev, 3))
 							tx_pwrctrl_tbl =
 							    nphy_tpc_5GHz_txgain_rev3;
-						} else if (NREV_IS(phyrev, 4)) {
+						else if (NREV_IS(phyrev, 4))
 							tx_pwrctrl_tbl =
 							    (pi->srom_fem5g.
 							     extpagain ==
@@ -22534,34 +22380,30 @@ struct nphy_txgains wlc_phy_get_tx_gain_nphy(struct brcms_phy *pi)
 							    nphy_tpc_5GHz_txgain_HiPwrEPA
 							    :
 							    nphy_tpc_5GHz_txgain_rev4;
-						} else {
+						else
 							tx_pwrctrl_tbl =
 							    nphy_tpc_5GHz_txgain_rev5;
-						}
 					} else {
 						if (NREV_GE(phyrev, 7)) {
 							if (pi->pubpi.
-							    radiorev == 3) {
+							    radiorev == 3)
 								tx_pwrctrl_tbl =
 								    nphy_tpc_txgain_epa_2057rev3;
-							} else if (pi->pubpi.
+							else if (pi->pubpi.
 								   radiorev ==
-								   5) {
+								 5)
 								tx_pwrctrl_tbl =
 								    nphy_tpc_txgain_epa_2057rev5;
-							}
-
 						} else {
 							if (NREV_GE(phyrev, 5)
 							    && (pi->srom_fem2g.
 								extpagain ==
-								3)) {
+								3))
 								tx_pwrctrl_tbl =
 								    nphy_tpc_txgain_HiPwrEPA;
-							} else {
+							else
 								tx_pwrctrl_tbl =
 								    nphy_tpc_txgain_rev3;
-							}
 						}
 					}
 				}
@@ -22626,26 +22468,26 @@ wlc_phy_iqcal_gainparams_nphy(struct brcms_phy *pi, u16 core_no,
 	u8 band_idx = (CHSPEC_IS5G(pi->radio_chanspec) ? 1 : 0);
 
 	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		if (NREV_GE(pi->pubpi.phy_rev, 7))
 			params->txlpf = target_gain.txlpf[core_no];
-		}
+
 		params->txgm = target_gain.txgm[core_no];
 		params->pga = target_gain.pga[core_no];
 		params->pad = target_gain.pad[core_no];
 		params->ipa = target_gain.ipa[core_no];
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		if (NREV_GE(pi->pubpi.phy_rev, 7))
 			params->cal_gain =
 			    ((params->txlpf << 15) | (params->
 						      txgm << 12) | (params->
 								     pga << 8) |
 			     (params->pad << 3) | (params->ipa));
-		} else {
+		else
 			params->cal_gain =
 			    ((params->txgm << 12) | (params->
 						     pga << 8) | (params->
 								  pad << 4) |
 			     (params->ipa));
-		}
+
 		params->ncorr[0] = 0x79;
 		params->ncorr[1] = 0x79;
 		params->ncorr[2] = 0x79;
@@ -22734,19 +22576,15 @@ static void wlc_phy_txcal_radio_setup_nphy(struct brcms_phy *pi)
 				if (pi->use_int_tx_iqlo_cal_nphy) {
 					WRITE_RADIO_REG3(pi, RADIO_2057, TX,
 							 core, TX_SSI_MUX, 0x4);
-					if (!
-					    (pi->
-					     internal_tx_iqlo_cal_tapoff_intpa_nphy)) {
-
+					if (!(pi->
+					internal_tx_iqlo_cal_tapoff_intpa_nphy))
 						WRITE_RADIO_REG3(pi, RADIO_2057,
 								 TX, core,
 								 TSSIA, 0x31);
-					} else {
-
+					else
 						WRITE_RADIO_REG3(pi, RADIO_2057,
 								 TX, core,
 								 TSSIA, 0x21);
-					}
 				}
 				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
 						 TSSI_MISC1, 0x00);
@@ -22767,19 +22605,15 @@ static void wlc_phy_txcal_radio_setup_nphy(struct brcms_phy *pi)
 					WRITE_RADIO_REG3(pi, RADIO_2057, TX,
 							 core, TX_SSI_MUX,
 							 0x06);
-					if (!
-					    (pi->
-					     internal_tx_iqlo_cal_tapoff_intpa_nphy)) {
-
+					if (!(pi->
+					internal_tx_iqlo_cal_tapoff_intpa_nphy))
 						WRITE_RADIO_REG3(pi, RADIO_2057,
 								 TX, core,
 								 TSSIG, 0x31);
-					} else {
-
+					else
 						WRITE_RADIO_REG3(pi, RADIO_2057,
 								 TX, core,
 								 TSSIG, 0x21);
-					}
 				}
 				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
 						 TSSI_MISC1, 0x00);
@@ -22912,19 +22746,16 @@ static void wlc_phy_txcal_radio_setup_nphy(struct brcms_phy *pi)
 					write_radio_reg(pi,
 							RADIO_2056_TX_TX_SSI_MUX
 							| jtag_core, 0x06);
-					if (NREV_LT(pi->pubpi.phy_rev, 5)) {
-
+					if (NREV_LT(pi->pubpi.phy_rev, 5))
 						write_radio_reg(pi,
 								RADIO_2056_TX_TSSIG
 								| jtag_core,
 								0x11);
-					} else {
-
+					else
 						write_radio_reg(pi,
 								RADIO_2056_TX_TSSIG
 								| jtag_core,
 								0x1);
-					}
 				} else {
 					write_radio_reg(pi,
 							RADIO_2056_TX_TX_SSI_MUX
@@ -23171,23 +23002,20 @@ static void wlc_phy_txcal_physetup_nphy(struct brcms_phy *pi)
 		pi->tx_rx_cal_phy_saveregs[7] = read_phy_reg(pi, 0x91);
 		pi->tx_rx_cal_phy_saveregs[8] = read_phy_reg(pi, 0x92);
 
-		if (!(pi->use_int_tx_iqlo_cal_nphy)) {
-
+		if (!(pi->use_int_tx_iqlo_cal_nphy))
 			wlc_phy_rfctrlintc_override_nphy(pi,
 							 NPHY_RfctrlIntc_override_PA,
 							 1,
 							 RADIO_MIMO_CORESEL_CORE1
 							 |
 							 RADIO_MIMO_CORESEL_CORE2);
-		} else {
-
+		else
 			wlc_phy_rfctrlintc_override_nphy(pi,
 							 NPHY_RfctrlIntc_override_PA,
 							 0,
 							 RADIO_MIMO_CORESEL_CORE1
 							 |
 							 RADIO_MIMO_CORESEL_CORE2);
-		}
 
 		wlc_phy_rfctrlintc_override_nphy(pi,
 						 NPHY_RfctrlIntc_override_TRSW,
@@ -23205,12 +23033,11 @@ static void wlc_phy_txcal_physetup_nphy(struct brcms_phy *pi)
 			    0x29b, (0x1 << 0), (0) << 0);
 
 		if (NREV_IS(pi->pubpi.phy_rev, 7)
-		    || NREV_GE(pi->pubpi.phy_rev, 8)) {
+		    || NREV_GE(pi->pubpi.phy_rev, 8))
 			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 7),
 							  wlc_phy_read_lpf_bw_ctl_nphy
 							  (pi, 0), 0, 0,
 							  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		}
 
 		if (pi->use_int_tx_iqlo_cal_nphy
 		    && !(pi->internal_tx_iqlo_cal_tapoff_intpa_nphy)) {
@@ -23302,11 +23129,10 @@ static void wlc_phy_txcal_phycleanup_nphy(struct brcms_phy *pi)
 		write_phy_reg(pi, 0x29b, pi->tx_rx_cal_phy_saveregs[10]);
 
 		if (NREV_IS(pi->pubpi.phy_rev, 7)
-		    || NREV_GE(pi->pubpi.phy_rev, 8)) {
+		    || NREV_GE(pi->pubpi.phy_rev, 8))
 			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 7), 0, 0,
 							  1,
 							  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		}
 
 		wlc_phy_resetcca_nphy(pi);
 
@@ -23390,17 +23216,15 @@ wlc_phy_est_tonepwr_nphy(struct brcms_phy *pi, s32 *qdBm_pwrbuf, u8 num_samps)
 	pwrindex[0] = idle_tssi[0] - tssival[0] + 64;
 	pwrindex[1] = idle_tssi[1] - tssival[1] + 64;
 
-	if (pwrindex[0] < 0) {
+	if (pwrindex[0] < 0)
 		pwrindex[0] = 0;
-	} else if (pwrindex[0] > 63) {
+	else if (pwrindex[0] > 63)
 		pwrindex[0] = 63;
-	}
 
-	if (pwrindex[1] < 0) {
+	if (pwrindex[1] < 0)
 		pwrindex[1] = 0;
-	} else if (pwrindex[1] > 63) {
+	else if (pwrindex[1] > 63)
 		pwrindex[1] = 63;
-	}
 
 	wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_CORE1TXPWRCTL, 1,
 				(u32) pwrindex[0], 32, &qdBm_pwrbuf[0]);
@@ -23488,22 +23312,19 @@ static void wlc_phy_precal_txgain_nphy(struct brcms_phy *pi)
 					save_bbmult = true;
 				}
 			} else {
-
 				wlc_phy_internal_cal_txgain_nphy(pi);
 				save_bbmult = true;
 			}
 
 		} else if (NREV_IS(pi->pubpi.phy_rev, 6)) {
 			if (PHY_IPA(pi)) {
-				if (CHSPEC_IS2G(pi->radio_chanspec)) {
+				if (CHSPEC_IS2G(pi->radio_chanspec))
 					wlc_phy_cal_txgainctrl_nphy(pi, 12,
 								    false);
-				} else {
+				else
 					wlc_phy_cal_txgainctrl_nphy(pi, 14,
 								    false);
-				}
 			} else {
-
 				wlc_phy_internal_cal_txgain_nphy(pi);
 				save_bbmult = true;
 			}
@@ -23513,10 +23334,9 @@ static void wlc_phy_precal_txgain_nphy(struct brcms_phy *pi)
 		wlc_phy_cal_txgainctrl_nphy(pi, 10, false);
 	}
 
-	if (save_bbmult) {
+	if (save_bbmult)
 		wlc_phy_table_read_nphy(pi, 15, 1, 87, 16,
 					&pi->nphy_txcal_bbmult);
-	}
 }
 
 void
@@ -23536,19 +23356,15 @@ wlc_phy_cal_txgainctrl_nphy(struct brcms_phy *pi, s32 dBm_targetpower,
 	uint stepsize;
 	bool phyhang_avoid_state = false;
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
 		stepsize = 2;
-	} else {
-
+	else
 		stepsize = 1;
-	}
 
-	if (CHSPEC_IS40(pi->radio_chanspec)) {
+	if (CHSPEC_IS40(pi->radio_chanspec))
 		freq_test = 5000;
-	} else {
+	else
 		freq_test = 2500;
-	}
 
 	wlc_phy_txpwr_index_nphy(pi, 1, pi->nphy_cal_orig_pwr_idx[0], true);
 	wlc_phy_txpwr_index_nphy(pi, 2, pi->nphy_cal_orig_pwr_idx[1], true);
@@ -23596,11 +23412,10 @@ wlc_phy_cal_txgainctrl_nphy(struct brcms_phy *pi, s32 dBm_targetpower,
 			wlc_phy_tx_tone_nphy(pi, freq_test, ampl_test, 0, 0,
 					     false);
 
-			if (core == PHY_CORE_0) {
+			if (core == PHY_CORE_0)
 				curr_m0m1 = m0m1 & 0xff00;
-			} else {
+			else
 				curr_m0m1 = m0m1 & 0x00ff;
-			}
 
 			wlc_phy_table_write_nphy(pi, 15, 1, 87, 16, &curr_m0m1);
 			wlc_phy_table_write_nphy(pi, 15, 1, 95, 16, &curr_m0m1);
@@ -23616,25 +23431,22 @@ wlc_phy_cal_txgainctrl_nphy(struct brcms_phy *pi, s32 dBm_targetpower,
 			delta_power = (dBm_targetpower * 4) - qdBm_power[core];
 
 			txpwrindex -= stepsize * delta_power;
-			if (txpwrindex < 0) {
+			if (txpwrindex < 0)
 				txpwrindex = 0;
-			} else if (txpwrindex > 127) {
+			else if (txpwrindex > 127)
 				txpwrindex = 127;
-			}
 
 			if (CHSPEC_IS5G(pi->radio_chanspec)) {
 				if (NREV_IS(pi->pubpi.phy_rev, 4) &&
 				    (pi->srom_fem5g.extpagain == 3)) {
-					if (txpwrindex < 30) {
+					if (txpwrindex < 30)
 						txpwrindex = 30;
-					}
 				}
 			} else {
 				if (NREV_GE(pi->pubpi.phy_rev, 5) &&
 				    (pi->srom_fem2g.extpagain == 3)) {
-					if (txpwrindex < 50) {
+					if (txpwrindex < 50)
 						txpwrindex = 50;
-					}
 				}
 			}
 
@@ -23751,19 +23563,17 @@ void wlc_phy_cal_perical_nphy_run(struct brcms_phy *pi, u8 caltype)
 	else if (caltype == PHY_PERICAL_PARTIAL)
 		fullcal = false;
 
-	if (pi->cal_type_override != PHY_PERICAL_AUTO) {
+	if (pi->cal_type_override != PHY_PERICAL_AUTO)
 		fullcal =
 		    (pi->cal_type_override == PHY_PERICAL_FULL) ? true : false;
-	}
 
 	if ((pi->mphase_cal_phase_id > MPHASE_CAL_STATE_INIT)) {
 		if (pi->nphy_txiqlocal_chanspec != pi->radio_chanspec)
 			wlc_phy_cal_perical_mphase_restart(pi);
 	}
 
-	if ((pi->mphase_cal_phase_id == MPHASE_CAL_STATE_RXCAL)) {
+	if ((pi->mphase_cal_phase_id == MPHASE_CAL_STATE_RXCAL))
 		wlapi_bmac_write_shm(pi->sh->physhim, M_CTS_DURATION, 10000);
-	}
 
 	wlapi_suspend_mac_and_wait(pi->sh->physhim);
 
@@ -23829,9 +23639,8 @@ void wlc_phy_cal_perical_nphy_run(struct brcms_phy *pi, u8 caltype)
 				pi->nphy_perical_last = pi->sh->now;
 			}
 		}
-		if (caltype != PHY_PERICAL_AUTO) {
+		if (caltype != PHY_PERICAL_AUTO)
 			wlc_phy_rssi_cal_nphy(pi);
-		}
 
 		if (pi->first_cal_after_assoc
 		    || (pi->cal_type_override == PHY_PERICAL_FULL)) {
@@ -23840,18 +23649,17 @@ void wlc_phy_cal_perical_nphy_run(struct brcms_phy *pi, u8 caltype)
 			wlc_phy_txpwrctrl_pwr_setup_nphy(pi);
 		}
 
-		if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		if (NREV_GE(pi->pubpi.phy_rev, 3))
 			wlc_phy_radio205x_vcocal_nphy(pi);
-		}
 	} else {
 		switch (pi->mphase_cal_phase_id) {
 		case MPHASE_CAL_STATE_INIT:
 			pi->nphy_perical_last = pi->sh->now;
 			pi->nphy_txiqlocal_chanspec = pi->radio_chanspec;
 
-			if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+			if (NREV_GE(pi->pubpi.phy_rev, 3))
 				wlc_phy_precal_txgain_nphy(pi);
-			}
+
 			pi->nphy_cal_target_gain = wlc_phy_get_tx_gain_nphy(pi);
 			pi->mphase_cal_phase_id++;
 			break;
@@ -23875,20 +23683,19 @@ void wlc_phy_cal_perical_nphy_run(struct brcms_phy *pi, u8 caltype)
 
 			if (NREV_LE(pi->pubpi.phy_rev, 2) &&
 			    (pi->mphase_cal_phase_id ==
-			     MPHASE_CAL_STATE_TXPHASE4)) {
+			     MPHASE_CAL_STATE_TXPHASE4))
 				pi->mphase_cal_phase_id += 2;
-			} else {
+			else
 				pi->mphase_cal_phase_id++;
-			}
 			break;
 
 		case MPHASE_CAL_STATE_PAPDCAL:
 			if ((pi->radar_percal_mask & 0x2) != 0)
 				pi->nphy_rxcal_active = true;
 
-			if (PHY_IPA(pi)) {
+			if (PHY_IPA(pi))
 				wlc_phy_a4(pi, true);
-			}
+
 			pi->mphase_cal_phase_id++;
 			break;
 
@@ -23899,9 +23706,8 @@ void wlc_phy_cal_perical_nphy_run(struct brcms_phy *pi, u8 caltype)
 						  (pi->first_cal_after_assoc ||
 						   (pi->cal_type_override ==
 						    PHY_PERICAL_FULL)) ? 2 : 0,
-						  false) == 0) {
+						  false) == 0)
 				wlc_phy_savecal_nphy(pi);
-			}
 
 			pi->mphase_cal_phase_id++;
 			break;
@@ -23912,16 +23718,15 @@ void wlc_phy_cal_perical_nphy_run(struct brcms_phy *pi, u8 caltype)
 			wlc_phy_txpwrctrl_coeff_setup_nphy(pi);
 			wlc_phy_rssi_cal_nphy(pi);
 
-			if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+			if (NREV_GE(pi->pubpi.phy_rev, 3))
 				wlc_phy_radio205x_vcocal_nphy(pi);
-			}
+
 			restore_tx_gain = true;
 
-			if (pi->first_cal_after_assoc) {
+			if (pi->first_cal_after_assoc)
 				pi->mphase_cal_phase_id++;
-			} else {
+			else
 				wlc_phy_cal_perical_mphase_reset(pi);
-			}
 
 			break;
 
@@ -24071,11 +23876,10 @@ wlc_phy_cal_txiqlo_nphy(struct brcms_phy *pi, struct nphy_txgains target_gain,
 		pi->phyhang_avoid = false;
 	}
 
-	if (CHSPEC_IS40(pi->radio_chanspec)) {
+	if (CHSPEC_IS40(pi->radio_chanspec))
 		phy_bw = 40;
-	} else {
+	else
 		phy_bw = 20;
-	}
 
 	wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16, gain_save);
 
@@ -24117,11 +23921,10 @@ wlc_phy_cal_txiqlo_nphy(struct brcms_phy *pi, struct nphy_txgains target_gain,
 					 16, tbl_ptr);
 	}
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
 		write_phy_reg(pi, 0xc2, 0x8ad9);
-	} else {
+	else
 		write_phy_reg(pi, 0xc2, 0x8aa9);
-	}
 
 	max_val = 250;
 	tone_freq = (phy_bw == 20) ? 2500 : 5000;
@@ -24139,19 +23942,15 @@ wlc_phy_cal_txiqlo_nphy(struct brcms_phy *pi, struct nphy_txgains target_gain,
 		if (pi->mphase_cal_phase_id > MPHASE_CAL_STATE_TXPHASE0) {
 			tbl_ptr = pi->mphase_txcal_bestcoeffs;
 			tbl_len = ARRAY_SIZE(pi->mphase_txcal_bestcoeffs);
-			if (NREV_LT(pi->pubpi.phy_rev, 3)) {
-
+			if (NREV_LT(pi->pubpi.phy_rev, 3))
 				tbl_len -= 2;
-			}
 		} else {
 			if ((!fullcal) && (pi->nphy_txiqlocal_coeffsvalid)) {
 
 				tbl_ptr = pi->nphy_txiqlocal_bestc;
 				tbl_len = ARRAY_SIZE(pi->nphy_txiqlocal_bestc);
-				if (NREV_LT(pi->pubpi.phy_rev, 3)) {
-
+				if (NREV_LT(pi->pubpi.phy_rev, 3))
 					tbl_len -= 2;
-				}
 			} else {
 
 				fullcal = true;
@@ -24185,11 +23984,10 @@ wlc_phy_cal_txiqlo_nphy(struct brcms_phy *pi, struct nphy_txgains target_gain,
 
 		if (mphase) {
 			cal_cnt = pi->mphase_txcal_cmdidx;
-			if ((cal_cnt + pi->mphase_txcal_numcmds) < max_cal_cmds) {
+			if ((cal_cnt + pi->mphase_txcal_numcmds) < max_cal_cmds)
 				num_cals = cal_cnt + pi->mphase_txcal_numcmds;
-			} else {
+			else
 				num_cals = max_cal_cmds;
-			}
 		} else {
 			cal_cnt = 0;
 			num_cals = max_cal_cmds;
@@ -24303,10 +24101,9 @@ wlc_phy_cal_txiqlo_nphy(struct brcms_phy *pi, struct nphy_txgains target_gain,
 						 16, tbl_buf);
 
 			tbl_len = ARRAY_SIZE(pi->nphy_txiqlocal_bestc);
-			if (NREV_LT(pi->pubpi.phy_rev, 3)) {
-
+			if (NREV_LT(pi->pubpi.phy_rev, 3))
 				tbl_len -= 2;
-			}
+
 			wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_IQLOCAL,
 						tbl_len, 96, 16,
 						pi->nphy_txiqlocal_bestc);
@@ -24315,10 +24112,9 @@ wlc_phy_cal_txiqlo_nphy(struct brcms_phy *pi, struct nphy_txgains target_gain,
 			pi->nphy_txiqlocal_chanspec = pi->radio_chanspec;
 		} else {
 			tbl_len = ARRAY_SIZE(pi->mphase_txcal_bestcoeffs);
-			if (NREV_LT(pi->pubpi.phy_rev, 3)) {
-
+			if (NREV_LT(pi->pubpi.phy_rev, 3))
 				tbl_len -= 2;
-			}
+
 			wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_IQLOCAL,
 						tbl_len, 96, 16,
 						pi->mphase_txcal_bestcoeffs);
@@ -24343,9 +24139,8 @@ wlc_phy_cal_txiqlo_nphy(struct brcms_phy *pi, struct nphy_txgains target_gain,
 			wlc_phy_tx_iq_war_nphy(pi);
 	}
 
-	if (NREV_GE(pi->pubpi.phy_rev, 4)) {
+	if (NREV_GE(pi->pubpi.phy_rev, 4))
 		pi->phyhang_avoid = phyhang_avoid_state;
-	}
 
 	wlc_phy_stay_in_carriersearch_nphy(pi, false);
 
@@ -24946,37 +24741,35 @@ static void wlc_phy_rxcal_radio_cleanup_nphy(struct brcms_phy *pi, u8 rx_core)
 			}
 
 			if (CHSPEC_IS5G(pi->radio_chanspec)) {
-				if (pi->pubpi.radiorev >= 5) {
+				if (pi->pubpi.radiorev >= 5)
 					write_radio_reg(pi,
 							RADIO_2056_RX_LNAA_MASTER
 							| RADIO_2056_RX0,
 							pi->
 							tx_rx_cal_radio_saveregs
 							[4]);
-				} else {
+				else
 					write_radio_reg(pi,
 							RADIO_2056_RX_LNAA_TUNE
 							| RADIO_2056_RX0,
 							pi->
 							tx_rx_cal_radio_saveregs
 							[4]);
-				}
 			} else {
-				if (pi->pubpi.radiorev >= 5) {
+				if (pi->pubpi.radiorev >= 5)
 					write_radio_reg(pi,
 							RADIO_2056_RX_LNAG_MASTER
 							| RADIO_2056_RX0,
 							pi->
 							tx_rx_cal_radio_saveregs
 							[4]);
-				} else {
+				else
 					write_radio_reg(pi,
 							RADIO_2056_RX_LNAG_TUNE
 							| RADIO_2056_RX0,
 							pi->
 							tx_rx_cal_radio_saveregs
 							[4]);
-				}
 			}
 
 		} else {
@@ -25005,37 +24798,35 @@ static void wlc_phy_rxcal_radio_cleanup_nphy(struct brcms_phy *pi, u8 rx_core)
 			}
 
 			if (CHSPEC_IS5G(pi->radio_chanspec)) {
-				if (pi->pubpi.radiorev >= 5) {
+				if (pi->pubpi.radiorev >= 5)
 					write_radio_reg(pi,
 							RADIO_2056_RX_LNAA_MASTER
 							| RADIO_2056_RX1,
 							pi->
 							tx_rx_cal_radio_saveregs
 							[4]);
-				} else {
+				else
 					write_radio_reg(pi,
 							RADIO_2056_RX_LNAA_TUNE
 							| RADIO_2056_RX1,
 							pi->
 							tx_rx_cal_radio_saveregs
 							[4]);
-				}
 			} else {
-				if (pi->pubpi.radiorev >= 5) {
+				if (pi->pubpi.radiorev >= 5)
 					write_radio_reg(pi,
 							RADIO_2056_RX_LNAG_MASTER
 							| RADIO_2056_RX1,
 							pi->
 							tx_rx_cal_radio_saveregs
 							[4]);
-				} else {
+				else
 					write_radio_reg(pi,
 							RADIO_2056_RX_LNAG_TUNE
 							| RADIO_2056_RX1,
 							pi->
 							tx_rx_cal_radio_saveregs
 							[4]);
-				}
 			}
 		}
 	}
@@ -25046,12 +24837,10 @@ static void wlc_phy_rxcal_physetup_nphy(struct brcms_phy *pi, u8 rx_core)
 	u8 tx_core;
 	u16 rx_antval, tx_antval;
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
 		tx_core = rx_core;
-	} else {
+	else
 		tx_core = (rx_core == PHY_CORE_0) ? 1 : 0;
-	}
 
 	pi->tx_rx_cal_phy_saveregs[0] = read_phy_reg(pi, 0xa2);
 	pi->tx_rx_cal_phy_saveregs[1] =
@@ -25122,17 +24911,17 @@ static void wlc_phy_rxcal_physetup_nphy(struct brcms_phy *pi, u8 rx_core)
 						  NPHY_REV7_RFCTRLOVERRIDE_ID2);
 		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 11), 0, 0, 0,
 						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		if (CHSPEC_IS40(pi->radio_chanspec)) {
+		if (CHSPEC_IS40(pi->radio_chanspec))
 			wlc_phy_rfctrl_override_nphy_rev7(pi,
 							  (0x1 << 7),
 							  2, 0, 0,
 							  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		} else {
+		else
 			wlc_phy_rfctrl_override_nphy_rev7(pi,
 							  (0x1 << 7),
 							  0, 0, 0,
 							  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		}
+
 		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 7),
 						  0, 0, 0,
 						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
@@ -25217,12 +25006,10 @@ wlc_phy_rxcal_gainctrl_nphy_rev5(struct brcms_phy *pi, u8 rx_core,
 	s8 txpwrindex;
 	u16 nphy_rxcal_txgain[2];
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
 		tx_core = rx_core;
-	} else {
+	else
 		tx_core = 1 - rx_core;
-	}
 
 	num_samps = 1024;
 	desired_log2_pwr = (cal_type == 0) ? 13 : 13;
@@ -25232,24 +25019,21 @@ wlc_phy_rxcal_gainctrl_nphy_rev5(struct brcms_phy *pi, u8 rx_core,
 	wlc_phy_rx_iq_coeffs_nphy(pi, 1, &zero_comp);
 
 	if (CHSPEC_IS5G(pi->radio_chanspec)) {
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		if (NREV_GE(pi->pubpi.phy_rev, 7))
 			mix_tia_gain = 3;
-		} else if (NREV_GE(pi->pubpi.phy_rev, 4)) {
+		else if (NREV_GE(pi->pubpi.phy_rev, 4))
 			mix_tia_gain = 4;
-		} else {
+		else
 			mix_tia_gain = 6;
-		}
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		if (NREV_GE(pi->pubpi.phy_rev, 7))
 			nphy_rxcal_gaintbl = nphy_ipa_rxcal_gaintbl_5GHz_rev7;
-		} else {
+		else
 			nphy_rxcal_gaintbl = nphy_ipa_rxcal_gaintbl_5GHz;
-		}
 	} else {
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		if (NREV_GE(pi->pubpi.phy_rev, 7))
 			nphy_rxcal_gaintbl = nphy_ipa_rxcal_gaintbl_2GHz_rev7;
-		} else {
+		else
 			nphy_rxcal_gaintbl = nphy_ipa_rxcal_gaintbl_2GHz;
-		}
 	}
 
 	do {
@@ -25262,7 +25046,7 @@ wlc_phy_rxcal_gainctrl_nphy_rev5(struct brcms_phy *pi, u8 rx_core,
 		lna1 = nphy_rxcal_gaintbl[curr_gaintbl_index].lna1;
 		txpwrindex = nphy_rxcal_gaintbl[curr_gaintbl_index].txpwrindex;
 
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		if (NREV_GE(pi->pubpi.phy_rev, 7))
 			wlc_phy_rfctrl_override_1tomany_nphy(pi,
 							     NPHY_REV7_RfctrlOverride_cmd_rxgain,
 							     ((lpf_biq1 << 12) |
@@ -25270,7 +25054,7 @@ wlc_phy_rxcal_gainctrl_nphy_rev5(struct brcms_phy *pi, u8 rx_core,
 							      (mix_tia_gain <<
 							       4) | (lna2 << 2)
 							      | lna1), 0x3, 0);
-		} else {
+		else
 			wlc_phy_rfctrl_override_nphy(pi, (0x1 << 12),
 						     ((hpvga << 12) |
 						      (lpf_biq1 << 10) |
@@ -25278,7 +25062,6 @@ wlc_phy_rxcal_gainctrl_nphy_rev5(struct brcms_phy *pi, u8 rx_core,
 						      (mix_tia_gain << 4) |
 						      (lna2 << 2) | lna1), 0x3,
 						     0);
-		}
 
 		pi->nphy_rxcal_pwr_idx[tx_core] = txpwrindex;
 
@@ -25367,11 +25150,11 @@ wlc_phy_rxcal_gainctrl_nphy_rev5(struct brcms_phy *pi, u8 rx_core,
 	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 		fine_gain_idx = (int)lpf_biq1 + delta_pwr;
 
-		if (fine_gain_idx + (int)lpf_biq0 > 10) {
+		if (fine_gain_idx + (int)lpf_biq0 > 10)
 			lpf_biq1 = 10 - lpf_biq0;
-		} else {
+		else
 			lpf_biq1 = (u16) max(fine_gain_idx, 0);
-		}
+
 		wlc_phy_rfctrl_override_1tomany_nphy(pi,
 						     NPHY_REV7_RfctrlOverride_cmd_rxgain,
 						     ((lpf_biq1 << 12) |
@@ -25444,9 +25227,8 @@ wlc_phy_rc_sweep_nphy(struct brcms_phy *pi, u8 core_idx, u8 loopback_type)
 	u16 num_samps, log_num_samps = 10;
 	struct phy_iq_est est[PHY_CORE_MAX];
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
 		return 0;
-	}
 
 	num_samps = (1 << log_num_samps);
 
@@ -25549,17 +25331,16 @@ wlc_phy_rc_sweep_nphy(struct brcms_phy *pi, u8 core_idx, u8 loopback_type)
 
 			wlc_phy_rx_iq_est_nphy(pi, est, num_samps, 32, 0);
 
-			if (core_idx == 0) {
+			if (core_idx == 0)
 				ref_iq_vals =
 				    max_t(u32, (est[0].i_pwr +
 					 est[0].q_pwr) >> (log_num_samps + 1),
 					1);
-			} else {
+			else
 				ref_iq_vals =
 				    max_t(u32, (est[1].i_pwr +
 					 est[1].q_pwr) >> (log_num_samps + 1),
 					1);
-			}
 
 			wlc_phy_tx_tone_nphy(pi, target_bw, NPHY_RXCAL_TONEAMP,
 					     0, 1, false);
@@ -25568,20 +25349,20 @@ wlc_phy_rc_sweep_nphy(struct brcms_phy *pi, u8 core_idx, u8 loopback_type)
 
 		wlc_phy_rx_iq_est_nphy(pi, est, num_samps, 32, 0);
 
-		if (core_idx == 0) {
+		if (core_idx == 0)
 			target_iq_vals =
 			    (est[0].i_pwr + est[0].q_pwr) >> (log_num_samps +
 							      1);
-		} else {
+		else
 			target_iq_vals =
 			    (est[1].i_pwr + est[1].q_pwr) >> (log_num_samps +
 							      1);
-		}
+
 		pwr_ratio = (uint) ((target_iq_vals << 16) / ref_iq_vals);
 
-		if (rccal_stepsize == 0) {
+		if (rccal_stepsize == 0)
 			rccal_stepsize--;
-		} else if (rccal_stepsize == 1) {
+		else if (rccal_stepsize == 1) {
 			last_rccal_val = rccal_val;
 			rccal_val += (pwr_ratio > target_pwr_ratio) ? 1 : -1;
 			last_pwr_ratio = pwr_ratio;
@@ -25601,14 +25382,12 @@ wlc_phy_rc_sweep_nphy(struct brcms_phy *pi, u8 core_idx, u8 loopback_type)
 
 			if (CHSPEC_IS40(pi->radio_chanspec)) {
 				if ((best_rccal_val > 140)
-				    || (best_rccal_val < 135)) {
+				    || (best_rccal_val < 135))
 					best_rccal_val = 138;
-				}
 			} else {
 				if ((best_rccal_val > 142)
-				    || (best_rccal_val < 137)) {
+				    || (best_rccal_val < 137))
 					best_rccal_val = 140;
-				}
 			}
 
 			write_radio_reg(pi,
@@ -25721,10 +25500,9 @@ static int wlc_phy_cal_rxiq_nphy_rev3(struct brcms_phy *pi,
 
 			if (rx_core == PHY_CORE_1) {
 
-				if (rxcore_state == 1) {
+				if (rxcore_state == 1)
 					wlc_phy_rxcore_setstate_nphy(
 						(struct brcms_phy_pub *) pi, 3);
-				}
 
 				wlc_phy_rxcal_gainctrl_nphy(pi, rx_core, NULL,
 							    1);
@@ -25733,11 +25511,10 @@ static int wlc_phy_cal_rxiq_nphy_rev3(struct brcms_phy *pi,
 				    wlc_phy_rc_sweep_nphy(pi, rx_core, 1);
 				pi->nphy_rccal_value = best_rccal[rx_core];
 
-				if (rxcore_state == 1) {
+				if (rxcore_state == 1)
 					wlc_phy_rxcore_setstate_nphy(
 						(struct brcms_phy_pub *) pi,
 						rxcore_state);
-				}
 			}
 		}
 
@@ -25787,21 +25564,20 @@ static int wlc_phy_cal_rxiq_nphy_rev3(struct brcms_phy *pi,
 
 	wlc_phy_resetcca_nphy(pi);
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
 		wlc_phy_rfctrl_override_1tomany_nphy(pi,
 						     NPHY_REV7_RfctrlOverride_cmd_rxgain,
 						     0, 0x3, 1);
-	} else {
+	else
 		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 12), 0, 0x3, 1);
-	}
+
 	wlc_phy_force_rfseq_nphy(pi, NPHY_RFSEQ_RESET2RX);
 
 	wlc_phy_table_write_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16,
 				 gain_save);
 
-	if (NREV_GE(pi->pubpi.phy_rev, 4)) {
+	if (NREV_GE(pi->pubpi.phy_rev, 4))
 		pi->phyhang_avoid = phyhang_avoid_state;
-	}
 
 	wlc_phy_stay_in_carriersearch_nphy(pi, false);
 
@@ -25835,10 +25611,8 @@ wlc_phy_cal_rxiq_nphy_rev2(struct brcms_phy *pi,
 
 	wlc_phy_stay_in_carriersearch_nphy(pi, true);
 
-	if (NREV_LT(pi->pubpi.phy_rev, 2)) {
-
+	if (NREV_LT(pi->pubpi.phy_rev, 2))
 		wlc_phy_reapply_txcal_coeffs_nphy(pi);
-	}
 
 	wlc_phy_table_read_nphy(pi, NPHY_TBL_ID_RFSEQ, 2, 0x110, 16, gain_save);
 
@@ -25874,19 +25648,16 @@ wlc_phy_cal_rxiq_nphy_rev2(struct brcms_phy *pi,
 			   ((0x1 << 1) | (0x1 << 2)));
 		or_phy_reg(pi, 0xa5, ((0x1 << 1) | (0x1 << 2)));
 
-		if (((pi->nphy_rxcalparams) & 0xff000000)) {
-
+		if (((pi->nphy_rxcalparams) & 0xff000000))
 			write_phy_reg(pi,
 				      (rx_core == PHY_CORE_0) ? 0x91 : 0x92,
 				      (CHSPEC_IS5G(pi->radio_chanspec) ? 0x140 :
 				       0x110));
-		} else {
-
+		else
 			write_phy_reg(pi,
 				      (rx_core == PHY_CORE_0) ? 0x91 : 0x92,
 				      (CHSPEC_IS5G(pi->radio_chanspec) ? 0x180 :
 				       0x120));
-		}
 
 		write_phy_reg(pi, (tx_core == PHY_CORE_0) ? 0x91 : 0x92,
 			      (CHSPEC_IS5G(pi->radio_chanspec) ? 0x148 :
@@ -25950,11 +25721,10 @@ wlc_phy_cal_rxiq_nphy_rev2(struct brcms_phy *pi,
 				hpf_change = desired_log2_pwr - actual_log2_pwr;
 				curr_hpf += hpf_change;
 				curr_hpf = max(min_t(u16, curr_hpf, 10), 0);
-				if (use_hpf_num == 1) {
+				if (use_hpf_num == 1)
 					curr_hpf1 = curr_hpf;
-				} else {
+				else
 					curr_hpf2 = curr_hpf;
-				}
 			}
 
 			wlc_phy_rfctrl_override_nphy(pi, (0x1 << 10),
@@ -26038,16 +25808,14 @@ int
 wlc_phy_cal_rxiq_nphy(struct brcms_phy *pi, struct nphy_txgains target_gain,
 		      u8 cal_type, bool debug)
 {
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
 		cal_type = 0;
-	}
-	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+
+	if (NREV_GE(pi->pubpi.phy_rev, 3))
 		return wlc_phy_cal_rxiq_nphy_rev3(pi, target_gain, cal_type,
 						  debug);
-	} else {
+	else
 		return wlc_phy_cal_rxiq_nphy_rev2(pi, target_gain, debug);
-	}
 }
 
 static void wlc_phy_extpa_set_tx_digi_filts_nphy(struct brcms_phy *pi)
@@ -26055,46 +25823,39 @@ static void wlc_phy_extpa_set_tx_digi_filts_nphy(struct brcms_phy *pi)
 	int j, type = 2;
 	u16 addr_offset = 0x2c5;
 
-	for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++) {
+	for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++)
 		write_phy_reg(pi, addr_offset + j,
 			      NPHY_IPA_REV4_txdigi_filtcoeffs[type][j]);
-	}
 }
 
 static void wlc_phy_ipa_set_tx_digi_filts_nphy(struct brcms_phy *pi)
 {
 	int j, type;
-	u16 addr_offset[] = { 0x186, 0x195,
-		0x2c5
-	};
+	u16 addr_offset[] = { 0x186, 0x195, 0x2c5};
 
 	for (type = 0; type < 3; type++) {
-		for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++) {
+		for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++)
 			write_phy_reg(pi, addr_offset[type] + j,
 				      NPHY_IPA_REV4_txdigi_filtcoeffs[type][j]);
-		}
 	}
 
 	if (IS40MHZ(pi)) {
-		for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++) {
+		for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++)
 			write_phy_reg(pi, 0x186 + j,
 				      NPHY_IPA_REV4_txdigi_filtcoeffs[3][j]);
-		}
 	} else {
 		if (CHSPEC_IS5G(pi->radio_chanspec)) {
-			for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++) {
+			for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++)
 				write_phy_reg(pi, 0x186 + j,
 					      NPHY_IPA_REV4_txdigi_filtcoeffs[5]
 					      [j]);
-			}
 		}
 
 		if (CHSPEC_CHANNEL(pi->radio_chanspec) == 14) {
-			for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++) {
+			for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++)
 				write_phy_reg(pi, 0x2c5 + j,
 					      NPHY_IPA_REV4_txdigi_filtcoeffs[6]
 					      [j]);
-			}
 		}
 	}
 }
@@ -26104,15 +25865,13 @@ static void wlc_phy_ipa_restore_tx_digi_filts_nphy(struct brcms_phy *pi)
 	int j;
 
 	if (IS40MHZ(pi)) {
-		for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++) {
+		for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++)
 			write_phy_reg(pi, 0x195 + j,
 				      NPHY_IPA_REV4_txdigi_filtcoeffs[4][j]);
-		}
 	} else {
-		for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++) {
+		for (j = 0; j < NPHY_NUM_DIG_FILT_COEFFS; j++)
 			write_phy_reg(pi, 0x186 + j,
 				      NPHY_IPA_REV4_txdigi_filtcoeffs[3][j]);
-		}
 	}
 }
 
@@ -26138,55 +25897,39 @@ static u32 *wlc_phy_get_ipa_gaintbl_nphy(struct brcms_phy *pi)
 	u32 *tx_pwrctrl_tbl = NULL;
 
 	if (CHSPEC_IS2G(pi->radio_chanspec)) {
-
 		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
-
 			if ((pi->pubpi.radiorev == 4)
-			    || (pi->pubpi.radiorev == 6)) {
-
+			    || (pi->pubpi.radiorev == 6))
 				tx_pwrctrl_tbl =
 				    nphy_tpc_txgain_ipa_2g_2057rev4n6;
-			} else if (pi->pubpi.radiorev == 3) {
-
+			else if (pi->pubpi.radiorev == 3)
 				tx_pwrctrl_tbl =
 				    nphy_tpc_txgain_ipa_2g_2057rev3;
-			} else if (pi->pubpi.radiorev == 5) {
-
+			else if (pi->pubpi.radiorev == 5)
 				tx_pwrctrl_tbl =
 				    nphy_tpc_txgain_ipa_2g_2057rev5;
-			} else if ((pi->pubpi.radiorev == 7)
-				   || (pi->pubpi.radiorev == 8)) {
-
+			else if ((pi->pubpi.radiorev == 7)
+				   || (pi->pubpi.radiorev == 8))
 				tx_pwrctrl_tbl =
 				    nphy_tpc_txgain_ipa_2g_2057rev7;
-			}
-
 		} else if (NREV_IS(pi->pubpi.phy_rev, 6)) {
-
 			tx_pwrctrl_tbl = nphy_tpc_txgain_ipa_rev6;
 		} else if (NREV_IS(pi->pubpi.phy_rev, 5)) {
-
 			tx_pwrctrl_tbl = nphy_tpc_txgain_ipa_rev5;
 		} else {
-
 			tx_pwrctrl_tbl = nphy_tpc_txgain_ipa;
 		}
-
 	} else {
 
 		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 			if ((pi->pubpi.radiorev == 3) ||
 			    (pi->pubpi.radiorev == 4) ||
-			    (pi->pubpi.radiorev == 6)) {
-
+			    (pi->pubpi.radiorev == 6))
 				tx_pwrctrl_tbl = nphy_tpc_txgain_ipa_5g_2057;
-			} else if ((pi->pubpi.radiorev == 7)
-				   || (pi->pubpi.radiorev == 8)) {
-
+			else if ((pi->pubpi.radiorev == 7)
+				   || (pi->pubpi.radiorev == 8))
 				tx_pwrctrl_tbl =
 				    nphy_tpc_txgain_ipa_5g_2057rev7;
-			}
-
 		} else {
 			tx_pwrctrl_tbl = nphy_tpc_txgain_ipa_5g;
 		}
@@ -26207,39 +25950,29 @@ wlc_phy_papd_cal_setup_nphy(struct brcms_phy *pi,
 	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 
 		if (NREV_IS(pi->pubpi.phy_rev, 7)
-		    || NREV_GE(pi->pubpi.phy_rev, 8)) {
+		    || NREV_GE(pi->pubpi.phy_rev, 8))
 			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 7),
 							  wlc_phy_read_lpf_bw_ctl_nphy
 							  (pi, 0), 0, 0,
 							  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		}
 
 		if (CHSPEC_IS2G(pi->radio_chanspec)) {
-			if (pi->pubpi.radiorev == 5) {
+			if (pi->pubpi.radiorev == 5)
 				mixgain = (core == 0) ? 0x20 : 0x00;
-
-			} else if ((pi->pubpi.radiorev == 7)
-				   || (pi->pubpi.radiorev == 8)) {
-
+			else if ((pi->pubpi.radiorev == 7)
+				   || (pi->pubpi.radiorev == 8))
 				mixgain = 0x00;
-
-			} else if ((pi->pubpi.radiorev <= 4)
-				   || (pi->pubpi.radiorev == 6)) {
-
+			else if ((pi->pubpi.radiorev <= 4)
+				   || (pi->pubpi.radiorev == 6))
 				mixgain = 0x00;
-			}
-
 		} else {
 			if ((pi->pubpi.radiorev == 4) ||
-			    (pi->pubpi.radiorev == 6)) {
-
+			    (pi->pubpi.radiorev == 6))
 				mixgain = 0x50;
-			} else if ((pi->pubpi.radiorev == 3)
-				   || (pi->pubpi.radiorev == 7)
-				   || (pi->pubpi.radiorev == 8)) {
-
+			else if ((pi->pubpi.radiorev == 3)
+				  || (pi->pubpi.radiorev == 7)
+				  || (pi->pubpi.radiorev == 8))
 				mixgain = 0x0;
-			}
 		}
 
 		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 11),
@@ -26323,30 +26056,22 @@ wlc_phy_papd_cal_setup_nphy(struct brcms_phy *pi,
 
 			if ((pi->pubpi.radiorev == 3) ||
 			    (pi->pubpi.radiorev == 4) ||
-			    (pi->pubpi.radiorev == 6)) {
-
+			    (pi->pubpi.radiorev == 6))
 				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
 						 TXRXCOUPLE_2G_ATTEN, 0xf0);
-
-			} else if (pi->pubpi.radiorev == 5) {
-
+			else if (pi->pubpi.radiorev == 5)
 				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
 						 TXRXCOUPLE_2G_ATTEN,
 						 (core == 0) ? 0xf7 : 0xf2);
-
-			} else if ((pi->pubpi.radiorev == 7)
-				   || (pi->pubpi.radiorev == 8)) {
-
+			else if ((pi->pubpi.radiorev == 7)
+				   || (pi->pubpi.radiorev == 8))
 				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
 						 TXRXCOUPLE_2G_ATTEN, 0xf0);
 
-			}
-
 			WRITE_RADIO_REG3(pi, RADIO_2057, TX, off_core,
 					 TXRXCOUPLE_2G_PWRUP, 0x0);
 			WRITE_RADIO_REG3(pi, RADIO_2057, TX, off_core,
 					 TXRXCOUPLE_2G_ATTEN, 0xff);
-
 		} else {
 			state->pwrup[core] =
 			    READ_RADIO_REG3(pi, RADIO_2057, TX, core,
@@ -26365,15 +26090,13 @@ wlc_phy_papd_cal_setup_nphy(struct brcms_phy *pi,
 					 TXRXCOUPLE_5G_PWRUP, 0xc);
 
 			if ((pi->pubpi.radiorev == 7)
-			    || (pi->pubpi.radiorev == 8)) {
-
+			    || (pi->pubpi.radiorev == 8))
 				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
 						 TXRXCOUPLE_5G_ATTEN, 0xf4);
 
-			} else {
+			else
 				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
 						 TXRXCOUPLE_5G_ATTEN, 0xf0);
-			}
 
 			WRITE_RADIO_REG3(pi, RADIO_2057, TX, off_core,
 					 TXRXCOUPLE_5G_PWRUP, 0x0);
@@ -26492,15 +26215,15 @@ wlc_phy_papd_cal_cleanup_nphy(struct brcms_phy *pi,
 			}
 		}
 
-		if ((pi->pubpi.radiorev == 4) || (pi->pubpi.radiorev == 6)) {
+		if ((pi->pubpi.radiorev == 4) || (pi->pubpi.radiorev == 6))
 			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 2),
 							  1, 0x3, 0,
 							  NPHY_REV7_RFCTRLOVERRIDE_ID0);
-		} else {
+		else
 			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 2),
 							  0, 0x3, 1,
 							  NPHY_REV7_RFCTRLOVERRIDE_ID0);
-		}
+
 		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 1),
 						  0, 0x3, 1,
 						  NPHY_REV7_RFCTRLOVERRIDE_ID1);
@@ -26547,13 +26270,11 @@ wlc_phy_papd_cal_cleanup_nphy(struct brcms_phy *pi,
 					    (state->mm & 0xff));
 
 		if (NREV_IS(pi->pubpi.phy_rev, 7)
-		    || NREV_GE(pi->pubpi.phy_rev, 8)) {
+		    || NREV_GE(pi->pubpi.phy_rev, 8))
 			wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 7), 0, 0,
 							  1,
 							  NPHY_REV7_RFCTRLOVERRIDE_ID1);
-		}
 	} else {
-
 		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 12), 0, 0x3, 1);
 		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 13), 0, 0x3, 1);
 		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 0), 0, 0x3, 1);
@@ -26601,9 +26322,8 @@ wlc_phy_a1_nphy(struct brcms_phy *pi, u8 core, u32 winsz, u32 start,
 	sz = end - start + 1;
 
 	buf = kmalloc(2 * sizeof(u32) * NPHY_PAPD_EPS_TBL_SIZE, GFP_ATOMIC);
-	if (NULL == buf) {
+	if (NULL == buf)
 		return;
-	}
 
 	src = buf;
 	dst = buf + NPHY_PAPD_EPS_TBL_SIZE;
@@ -26667,18 +26387,17 @@ wlc_phy_a2_nphy(struct brcms_phy *pi, struct nphy_ipa_txcalgains *txgains,
 
 		phy_a9 = wlc_phy_get_tx_gain_nphy(pi);
 
-		if (CHSPEC_IS2G(pi->radio_chanspec)) {
+		if (CHSPEC_IS2G(pi->radio_chanspec))
 			phy_a5 = ((phy_a9.txlpf[core] << 15) |
 				  (phy_a9.txgm[core] << 12) |
 				  (phy_a9.pga[core] << 8) |
 				  (txgains->gains.pad[core] << 3) |
 				  (phy_a9.ipa[core]));
-		} else {
+		else
 			phy_a5 = ((phy_a9.txlpf[core] << 15) |
 				  (phy_a9.txgm[core] << 12) |
 				  (txgains->gains.pga[core] << 8) |
 				  (phy_a9.pad[core] << 3) | (phy_a9.ipa[core]));
-		}
 
 		wlc_phy_rfctrl_override_1tomany_nphy(pi,
 						     NPHY_REV7_RfctrlOverride_cmd_txgain,
@@ -26686,14 +26405,10 @@ wlc_phy_a2_nphy(struct brcms_phy *pi, struct nphy_ipa_txcalgains *txgains,
 
 		if (CHSPEC_IS2G(pi->radio_chanspec)) {
 			if ((pi->pubpi.radiorev <= 4)
-			    || (pi->pubpi.radiorev == 6)) {
-
+			    || (pi->pubpi.radiorev == 6))
 				m[core] = IS40MHZ(pi) ? 60 : 79;
-			} else {
-
+			else
 				m[core] = IS40MHZ(pi) ? 45 : 64;
-			}
-
 		} else {
 			m[core] = IS40MHZ(pi) ? 75 : 107;
 		}
@@ -26726,16 +26441,15 @@ wlc_phy_a2_nphy(struct brcms_phy *pi, struct nphy_ipa_txcalgains *txgains,
 
 		if (cal_mode == CAL_GCTRL) {
 			if ((pi->pubpi.radiorev == 5)
-			    && (CHSPEC_IS2G(pi->radio_chanspec))) {
+			    && (CHSPEC_IS2G(pi->radio_chanspec)))
 				phy_a1 = 55;
-			} else if (((pi->pubpi.radiorev == 7) &&
+			else if (((pi->pubpi.radiorev == 7) &&
 				    (CHSPEC_IS2G(pi->radio_chanspec))) ||
 				   ((pi->pubpi.radiorev == 8) &&
-				    (CHSPEC_IS2G(pi->radio_chanspec)))) {
+				  (CHSPEC_IS2G(pi->radio_chanspec))))
 				phy_a1 = 60;
-			} else {
+			else
 				phy_a1 = 63;
-			}
 
 		} else if ((cal_mode != CAL_FULL) && (cal_mode != CAL_SOFT)) {
 
@@ -26796,9 +26510,8 @@ wlc_phy_a2_nphy(struct brcms_phy *pi, struct nphy_ipa_txcalgains *txgains,
 					 32, &phy_a8);
 
 		if (cal_mode != CAL_GCTRL) {
-			if (CHSPEC_IS5G(pi->radio_chanspec)) {
+			if (CHSPEC_IS5G(pi->radio_chanspec))
 				wlc_phy_a1_nphy(pi, core, 5, 0, 35);
-			}
 		}
 
 		wlc_phy_rfctrl_override_1tomany_nphy(pi,
@@ -26834,11 +26547,10 @@ wlc_phy_a2_nphy(struct brcms_phy *pi, struct nphy_ipa_txcalgains *txgains,
 			}
 		}
 
-		if (CHSPEC_IS2G(pi->radio_chanspec)) {
+		if (CHSPEC_IS2G(pi->radio_chanspec))
 			m[core] = IS40MHZ(pi) ? 45 : 64;
-		} else {
+		else
 			m[core] = IS40MHZ(pi) ? 75 : 107;
-		}
 
 		m[phy_a7] = 0;
 		wlc_phy_ipa_set_bbmult_nphy(pi, m[0], m[1]);
@@ -26928,9 +26640,8 @@ wlc_phy_a2_nphy(struct brcms_phy *pi, struct nphy_ipa_txcalgains *txgains,
 					 : NPHY_TBL_ID_EPSILONTBL1, 1, phy_a3,
 					 32, &phy_a8);
 
-		if (cal_mode != CAL_GCTRL) {
+		if (cal_mode != CAL_GCTRL)
 			wlc_phy_a1_nphy(pi, core, 5, 0, 40);
-		}
 	}
 }
 
@@ -26990,13 +26701,12 @@ static u8 wlc_phy_a3_nphy(struct brcms_phy *pi, u8 start_gain, u8 core)
 		phy_a14 = 0;
 
 		for (phy_a10 = 0; phy_a10 < phy_a2; phy_a10++) {
-			if (CHSPEC_IS2G(pi->radio_chanspec)) {
+			if (CHSPEC_IS2G(pi->radio_chanspec))
 				phy_a4.gains.pad[core] =
 				    (u16) phy_a15[phy_a12];
-			} else {
+			else
 				phy_a4.gains.pga[core] =
 				    (u16) phy_a15[phy_a12];
-			}
 
 			wlc_phy_a2_nphy(pi, &phy_a4, CAL_GCTRL, core);
 
@@ -27013,9 +26723,9 @@ static u8 wlc_phy_a3_nphy(struct brcms_phy *pi, u8 start_gain, u8 core)
 				  (phy_a8 == 4095) || (phy_a8 == -4096));
 
 			if (!phy_a6 && (phy_a3 != phy_a5)) {
-				if (!phy_a3) {
+				if (!phy_a3)
 					phy_a12 -= (u8) phy_a1;
-				}
+
 				phy_a11 = true;
 				break;
 			}
@@ -27026,11 +26736,11 @@ static u8 wlc_phy_a3_nphy(struct brcms_phy *pi, u8 start_gain, u8 core)
 				phy_a12 -= (u8) phy_a1;
 
 			if ((phy_a12 < phy_a14) || (phy_a12 > phy_a13)) {
-				if (phy_a12 < phy_a14) {
+				if (phy_a12 < phy_a14)
 					phy_a12 = phy_a14;
-				} else {
+				else
 					phy_a12 = phy_a13;
-				}
+
 				phy_a11 = true;
 				break;
 			}
@@ -27059,9 +26769,9 @@ static u8 wlc_phy_a3_nphy(struct brcms_phy *pi, u8 start_gain, u8 core)
 				  (phy_a8 == 4095) || (phy_a8 == -4096));
 
 			if (!phy_a6 && (phy_a3 != phy_a5)) {
-				if (!phy_a3) {
+				if (!phy_a3)
 					phy_a12 -= (u8) phy_a1;
-				}
+
 				phy_a11 = true;
 				break;
 			}
@@ -27072,11 +26782,11 @@ static u8 wlc_phy_a3_nphy(struct brcms_phy *pi, u8 start_gain, u8 core)
 				phy_a12 -= (u8) phy_a1;
 
 			if ((phy_a12 < 0) || (phy_a12 > 127)) {
-				if (phy_a12 < 0) {
+				if (phy_a12 < 0)
 					phy_a12 = 0;
-				} else {
+				else
 					phy_a12 = 127;
-				}
+
 				phy_a11 = true;
 				break;
 			}
@@ -27087,11 +26797,10 @@ static u8 wlc_phy_a3_nphy(struct brcms_phy *pi, u8 start_gain, u8 core)
 
 	}
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
 		return (u8) phy_a15[phy_a12];
-	} else {
+	else
 		return (u8) phy_a12;
-	}
 
 }
 
@@ -27117,9 +26826,8 @@ static void wlc_phy_a4(struct brcms_phy *pi, bool full_cal)
 
 	phy_b3 =
 	    (0 == (R_REG(&pi->regs->maccontrol) & MCTL_EN_MAC));
-	if (!phy_b3) {
+	if (!phy_b3)
 		wlapi_suspend_mac_and_wait(pi->sh->physhim);
-	}
 
 	wlc_phy_stay_in_carriersearch_nphy(pi, true);
 
@@ -27148,14 +26856,13 @@ static void wlc_phy_a4(struct brcms_phy *pi, bool full_cal)
 
 	for (phy_b5 = 0; phy_b5 < pi->pubpi.phy_corenum; phy_b5++) {
 		s32 i, val = 0;
-		for (i = 0; i < 64; i++) {
+		for (i = 0; i < 64; i++)
 			wlc_phy_table_write_nphy(pi,
 						 ((phy_b5 ==
 						   PHY_CORE_0) ?
 						  NPHY_TBL_ID_EPSILONTBL0 :
 						  NPHY_TBL_ID_EPSILONTBL1), 1,
 						 i, 32, &val);
-		}
 	}
 
 	wlc_phy_ipa_restore_tx_digi_filts_nphy(pi);
@@ -27166,16 +26873,12 @@ static void wlc_phy_a4(struct brcms_phy *pi, bool full_cal)
 
 		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 			if (CHSPEC_IS2G(pi->radio_chanspec)) {
-
 				if ((pi->pubpi.radiorev == 3)
 				    || (pi->pubpi.radiorev == 4)
 				    || (pi->pubpi.radiorev == 6)) {
-
 					pi->nphy_papd_cal_gain_index[phy_b5] =
 					    23;
-
 				} else if (pi->pubpi.radiorev == 5) {
-
 					pi->nphy_papd_cal_gain_index[phy_b5] =
 					    0;
 					pi->nphy_papd_cal_gain_index[phy_b5] =
@@ -27229,27 +26932,24 @@ static void wlc_phy_a4(struct brcms_phy *pi, bool full_cal)
 			break;
 		}
 
-		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+		if (NREV_GE(pi->pubpi.phy_rev, 7))
 			wlc_phy_papd_cal_cleanup_nphy(pi, &phy_b2);
-		}
 	}
 
-	if (NREV_LT(pi->pubpi.phy_rev, 7)) {
+	if (NREV_LT(pi->pubpi.phy_rev, 7))
 		wlc_phy_papd_cal_cleanup_nphy(pi, &phy_b2);
-	}
 
 	for (phy_b5 = 0; phy_b5 < pi->pubpi.phy_corenum; phy_b5++) {
 		int eps_offset = 0;
 
 		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 			if (CHSPEC_IS2G(pi->radio_chanspec)) {
-				if (pi->pubpi.radiorev == 3) {
+				if (pi->pubpi.radiorev == 3)
 					eps_offset = -2;
-				} else if (pi->pubpi.radiorev == 5) {
+				else if (pi->pubpi.radiorev == 5)
 					eps_offset = 3;
-				} else {
+				else
 					eps_offset = -1;
-				}
 			} else {
 				eps_offset = 2;
 			}
@@ -27282,40 +26982,37 @@ static void wlc_phy_a4(struct brcms_phy *pi, bool full_cal)
 				phy_b7 = phy_b1[phy_b5].gains.pga[phy_b5];
 				if ((pi->pubpi.radiorev == 3) ||
 				    (pi->pubpi.radiorev == 4) ||
-				    (pi->pubpi.radiorev == 6)) {
+				    (pi->pubpi.radiorev == 6))
 					phy_b11 =
 					    -(nphy_papd_pgagain_dlt_5g_2057
 					      [phy_b7]
 					      + 1) / 2;
-				} else if ((pi->pubpi.radiorev == 7)
-					   || (pi->pubpi.radiorev == 8)) {
+				else if ((pi->pubpi.radiorev == 7)
+					   || (pi->pubpi.radiorev == 8))
 					phy_b11 =
 					    -(nphy_papd_pgagain_dlt_5g_2057rev7
 					      [phy_b7]
 					      + 1) / 2;
-				}
 
 				phy_b10 = -9;
 			}
 
-			if (CHSPEC_IS2G(pi->radio_chanspec)) {
+			if (CHSPEC_IS2G(pi->radio_chanspec))
 				phy_b6 =
 				    -60 + 27 + eps_offset + phy_b12 + phy_b10;
-			} else {
+			else
 				phy_b6 =
 				    -60 + 27 + eps_offset + phy_b11 + phy_b10;
-			}
 
 			mod_phy_reg(pi, (phy_b5 == PHY_CORE_0) ? 0x298 :
 				    0x29c, (0x1ff << 7), (phy_b6) << 7);
 
 			pi->nphy_papd_epsilon_offset[phy_b5] = phy_b6;
 		} else {
-			if (NREV_LT(pi->pubpi.phy_rev, 5)) {
+			if (NREV_LT(pi->pubpi.phy_rev, 5))
 				eps_offset = 4;
-			} else {
+			else
 				eps_offset = 2;
-			}
 
 			phy_b7 = 15 - ((phy_b1[phy_b5].index) >> 3);
 
@@ -27379,9 +27076,8 @@ static void wlc_phy_a4(struct brcms_phy *pi, bool full_cal)
 
 	wlc_phy_stay_in_carriersearch_nphy(pi, false);
 
-	if (!phy_b3) {
+	if (!phy_b3)
 		wlapi_enable_mac(pi->sh->physhim);
-	}
 }
 
 void wlc_phy_txpwr_fixpower_nphy(struct brcms_phy *pi)
@@ -27423,11 +27119,10 @@ void wlc_phy_txpwr_fixpower_nphy(struct brcms_phy *pi)
 		}
 	}
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
 		txpi[0] = txpi[1] = 30;
-	} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+	else if (NREV_GE(pi->pubpi.phy_rev, 3))
 		txpi[0] = txpi[1] = 40;
-	}
 
 	if (NREV_LT(pi->pubpi.phy_rev, 7)) {
 
@@ -27497,12 +27192,12 @@ void wlc_phy_txpwr_fixpower_nphy(struct brcms_phy *pi)
 
 		bbmult = (txgain >> 0) & ((1 << (7 - 0 + 1)) - 1);
 
-		if (NREV_GE(phyrev, 3)) {
+		if (NREV_GE(phyrev, 3))
 			mod_phy_reg(pi, ((core == PHY_CORE_0) ? 0x8f :
 					 0xa5), (0x1 << 8), (0x1 << 8));
-		} else {
+		else
 			mod_phy_reg(pi, 0xa5, (0x1 << 14), (0x1 << 14));
-		}
+
 		write_phy_reg(pi, (core == PHY_CORE_0) ? 0xaa : 0xab, dac_gain);
 
 		wlc_phy_table_write_nphy(pi, 7, 1, (0x110 + core), 16,
@@ -27562,9 +27257,8 @@ wlc_phy_txpwr_nphy_po_apply(u8 *srom_max, u8 pwr_offset,
 {
 	u8 rate;
 
-	for (rate = rate_start; rate <= rate_end; rate++) {
+	for (rate = rate_start; rate <= rate_end; rate++)
 		srom_max[rate] -= 2 * pwr_offset;
-	}
 }
 
 void
@@ -27696,12 +27390,10 @@ void wlc_phy_txpwr_apply_nphy(struct brcms_phy *pi)
 						TXP_FIRST_MCS_20_CDD,
 						TXP_LAST_MCS_20_CDD);
 
-		if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-
+		if (NREV_GE(pi->pubpi.phy_rev, 3))
 			wlc_phy_txpwr_nphy_po_apply(tx_srom_max_rate, tmp_cddpo,
 						    TXP_FIRST_MCS_20_CDD,
 						    TXP_LAST_MCS_20_CDD);
-		}
 
 		wlc_phy_mcs_to_ofdm_powers_nphy(tx_srom_max_rate,
 						TXP_FIRST_OFDM_20_CDD,
@@ -27713,13 +27405,11 @@ void wlc_phy_txpwr_apply_nphy(struct brcms_phy *pi)
 						TXP_FIRST_MCS_20_STBC,
 						TXP_LAST_MCS_20_STBC);
 
-		if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-
+		if (NREV_GE(pi->pubpi.phy_rev, 3))
 			wlc_phy_txpwr_nphy_po_apply(tx_srom_max_rate,
 						    tmp_stbcpo,
 						    TXP_FIRST_MCS_20_STBC,
 						    TXP_LAST_MCS_20_STBC);
-		}
 
 		wlc_phy_txpwr_nphy_srom_convert(tx_srom_max_rate,
 						&pwr_offsets2[2], tmp_max_pwr,
@@ -27779,12 +27469,11 @@ void wlc_phy_txpwr_apply_nphy(struct brcms_phy *pi)
 				    tx_srom_max_rate[rate2];
 		}
 
-		if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+		if (NREV_GE(pi->pubpi.phy_rev, 3))
 			wlc_phy_txpwr_nphy_po_apply(tx_srom_max_rate,
 						    tmp_bw40po,
 						    TXP_FIRST_OFDM_40_SISO,
 						    TXP_LAST_MCS_40_SDM);
-		}
 
 		tx_srom_max_rate[TXP_MCS_32] =
 		    tx_srom_max_rate[TXP_FIRST_MCS_40_CDD];
@@ -27798,10 +27487,8 @@ static void wlc_phy_txpwr_srom_read_ppr_nphy(struct brcms_phy *pi)
 	u16 bw40po, cddpo, stbcpo, bwduppo;
 	uint band_num;
 
-	if (pi->sh->sromrev >= 9) {
-
+	if (pi->sh->sromrev >= 9)
 		return;
-	}
 
 	bw40po = (u16) PHY_GETINTVAR(pi, "bw40po");
 	pi->bw402gpo = bw40po & 0xf;
@@ -28018,43 +27705,37 @@ static bool wlc_phy_txpwr_srom_read_nphy(struct brcms_phy *pi)
 	pi->srom_fem5g.extpagain = (u8) PHY_GETINTVAR(pi, "extpagain5g");
 	pi->srom_fem5g.pdetrange = (u8) PHY_GETINTVAR(pi, "pdetrange5g");
 	pi->srom_fem5g.triso = (u8) PHY_GETINTVAR(pi, "triso5g");
-	if (PHY_GETVAR(pi, "antswctl5g")) {
-
+	if (PHY_GETVAR(pi, "antswctl5g"))
 		pi->srom_fem5g.antswctrllut =
 		    (u8) PHY_GETINTVAR(pi, "antswctl5g");
-	} else {
-
+	else
 		pi->srom_fem5g.antswctrllut =
 		    (u8) PHY_GETINTVAR(pi, "antswctl2g");
-	}
 
 	wlc_phy_txpower_ipa_upd(pi);
 
 	pi->phy_txcore_disable_temp = (s16) PHY_GETINTVAR(pi, "tempthresh");
-	if (pi->phy_txcore_disable_temp == 0) {
+	if (pi->phy_txcore_disable_temp == 0)
 		pi->phy_txcore_disable_temp = PHY_CHAIN_TX_DISABLE_TEMP;
-	}
 
 	pi->phy_tempsense_offset = (s8) PHY_GETINTVAR(pi, "tempoffset");
 	if (pi->phy_tempsense_offset != 0) {
 		if (pi->phy_tempsense_offset >
-		    (NPHY_SROM_TEMPSHIFT + NPHY_SROM_MAXTEMPOFFSET)) {
+		    (NPHY_SROM_TEMPSHIFT + NPHY_SROM_MAXTEMPOFFSET))
 			pi->phy_tempsense_offset = NPHY_SROM_MAXTEMPOFFSET;
-		} else if (pi->phy_tempsense_offset < (NPHY_SROM_TEMPSHIFT +
-						    NPHY_SROM_MINTEMPOFFSET)) {
+		else if (pi->phy_tempsense_offset < (NPHY_SROM_TEMPSHIFT +
+						     NPHY_SROM_MINTEMPOFFSET))
 			pi->phy_tempsense_offset = NPHY_SROM_MINTEMPOFFSET;
-		} else {
+		else
 			pi->phy_tempsense_offset -= NPHY_SROM_TEMPSHIFT;
-		}
 	}
 
 	pi->phy_txcore_enable_temp =
 	    pi->phy_txcore_disable_temp - PHY_HYSTERESIS_DELTATEMP;
 
 	pi->phycal_tempdelta = (u8) PHY_GETINTVAR(pi, "phycal_tempdelta");
-	if (pi->phycal_tempdelta > NPHY_CAL_MAXTEMPDELTA) {
+	if (pi->phycal_tempdelta > NPHY_CAL_MAXTEMPDELTA)
 		pi->phycal_tempdelta = 0;
-	}
 
 	wlc_phy_txpwr_srom_read_ppr_nphy(pi);
 
@@ -28107,9 +27788,8 @@ static void wlc_phy_txpwrctrl_coeff_setup_nphy(struct brcms_phy *pi)
 		    : (((u32) (iqloCalbuf[2] & 0x3ff)) << 10) |
 		    (iqloCalbuf[3] & 0x3ff);
 
-		for (idx = 0; idx < tbl_len; idx++) {
+		for (idx = 0; idx < tbl_len; idx++)
 			regval[idx] = iqcomp;
-		}
 		wlc_phy_table_write_nphy(pi, tbl_id, tbl_len, tbl_offset, 32,
 					 regval);
 	}
@@ -28168,15 +27848,12 @@ static void wlc_phy_ipa_internal_tssi_setup_nphy(struct brcms_phy *pi)
 					WRITE_RADIO_REG3(pi, RADIO_2057, TX,
 							 core, TSSIA, 0);
 
-				if (!NREV_IS(pi->pubpi.phy_rev, 7)) {
-
+				if (!NREV_IS(pi->pubpi.phy_rev, 7))
 					WRITE_RADIO_REG3(pi, RADIO_2057, TX,
 							 core, TSSIG, 0x1);
-				} else {
-
+				else
 					WRITE_RADIO_REG3(pi, RADIO_2057, TX,
 							 core, TSSIG, 0x31);
-				}
 			} else {
 				WRITE_RADIO_REG3(pi, RADIO_2057, TX, core,
 						 TX_SSI_MASTER, 0x9);
@@ -28186,17 +27863,14 @@ static void wlc_phy_ipa_internal_tssi_setup_nphy(struct brcms_phy *pi)
 						 TSSIG, 0);
 
 				if (pi->pubpi.radiorev != 5) {
-					if (!NREV_IS(pi->pubpi.phy_rev, 7)) {
-
+					if (!NREV_IS(pi->pubpi.phy_rev, 7))
 						WRITE_RADIO_REG3(pi, RADIO_2057,
 								 TX, core,
 								 TSSIA, 0x1);
-					} else {
-
+					else
 						WRITE_RADIO_REG3(pi, RADIO_2057,
 								 TX, core,
 								 TSSIA, 0x31);
-					}
 				}
 			}
 			WRITE_RADIO_REG3(pi, RADIO_2057, TX, core, IQCAL_VCM_HG,
@@ -28238,14 +27912,12 @@ static void wlc_phy_ipa_internal_tssi_setup_nphy(struct brcms_phy *pi)
 				if (pi->pubpi.radiorev != 5)
 					WRITE_RADIO_REG2(pi, RADIO_2056, TX,
 							 core, TSSIA, 0x0);
-				if (NREV_GE(pi->pubpi.phy_rev, 5)) {
-
+				if (NREV_GE(pi->pubpi.phy_rev, 5))
 					WRITE_RADIO_REG2(pi, RADIO_2056, TX,
 							 core, TSSIG, 0x31);
-				} else {
+				else
 					WRITE_RADIO_REG2(pi, RADIO_2056, TX,
 							 core, TSSIG, 0x11);
-				}
 				WRITE_RADIO_REG2(pi, RADIO_2056, TX, core,
 						 TX_SSI_MUX, 0xe);
 			} else {
@@ -28271,17 +27943,15 @@ static void wlc_phy_txpwrctrl_idle_tssi_nphy(struct brcms_phy *pi)
 
 		return;
 
-	if (PHY_IPA(pi)) {
+	if (PHY_IPA(pi))
 		wlc_phy_ipa_internal_tssi_setup_nphy(pi);
-	}
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
 		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 12),
 						  0, 0x3, 0,
 						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
-	} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+	else if (NREV_GE(pi->pubpi.phy_rev, 3))
 		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 13), 0, 3, 0);
-	}
 
 	wlc_phy_stopplayback_nphy(pi);
 
@@ -28294,13 +27964,12 @@ static void wlc_phy_txpwrctrl_idle_tssi_nphy(struct brcms_phy *pi)
 	wlc_phy_stopplayback_nphy(pi);
 	wlc_phy_rssisel_nphy(pi, RADIO_MIMO_CORESEL_OFF, 0);
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
 		wlc_phy_rfctrl_override_nphy_rev7(pi, (0x1 << 12),
 						  0, 0x3, 1,
 						  NPHY_REV7_RFCTRLOVERRIDE_ID0);
-	} else if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+	else if (NREV_GE(pi->pubpi.phy_rev, 3))
 		wlc_phy_rfctrl_override_nphy(pi, (0x1 << 13), 0, 3, 1);
-	}
 
 	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 
@@ -28351,12 +28020,10 @@ static void wlc_phy_txpwrctrl_pwr_setup_nphy(struct brcms_phy *pi)
 
 	or_phy_reg(pi, 0x122, (0x1 << 0));
 
-	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+	if (NREV_GE(pi->pubpi.phy_rev, 3))
 		and_phy_reg(pi, 0x1e7, (u16) (~(0x1 << 15)));
-	} else {
-
+	else
 		or_phy_reg(pi, 0x1e7, (0x1 << 15));
-	}
 
 	if (D11REV_IS(pi->sh->corerev, 11) || D11REV_IS(pi->sh->corerev, 12))
 		wlapi_bmac_mctrl(pi->sh->physhim, MCTL_PHYLOCK, 0);
@@ -28451,26 +28118,22 @@ static void wlc_phy_txpwrctrl_pwr_setup_nphy(struct brcms_phy *pi)
 	target_pwr_qtrdbm[1] = (s8) pi->tx_power_max;
 
 	if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-		if (pi->srom_fem2g.tssipos) {
+		if (pi->srom_fem2g.tssipos)
 			or_phy_reg(pi, 0x1e9, (0x1 << 14));
-		}
 
 		if (NREV_GE(pi->pubpi.phy_rev, 7)) {
 			for (core = 0; core <= 1; core++) {
 				if (PHY_IPA(pi)) {
-
-					if (CHSPEC_IS2G(pi->radio_chanspec)) {
+					if (CHSPEC_IS2G(pi->radio_chanspec))
 						WRITE_RADIO_REG3(pi, RADIO_2057,
 								 TX, core,
 								 TX_SSI_MUX,
 								 0xe);
-					} else {
+					else
 						WRITE_RADIO_REG3(pi, RADIO_2057,
 								 TX, core,
 								 TX_SSI_MUX,
 								 0xc);
-					}
-				} else {
 				}
 			}
 		} else {
@@ -28503,21 +28166,19 @@ static void wlc_phy_txpwrctrl_pwr_setup_nphy(struct brcms_phy *pi)
 		udelay(1);
 	}
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
 		mod_phy_reg(pi, 0x1e7, (0x7f << 0),
 			    (NPHY_TxPwrCtrlCmd_pwrIndex_init_rev7 << 0));
-	} else {
+	else
 		mod_phy_reg(pi, 0x1e7, (0x7f << 0),
 			    (NPHY_TxPwrCtrlCmd_pwrIndex_init << 0));
-	}
 
-	if (NREV_GE(pi->pubpi.phy_rev, 7)) {
+	if (NREV_GE(pi->pubpi.phy_rev, 7))
 		mod_phy_reg(pi, 0x222, (0xff << 0),
 			    (NPHY_TxPwrCtrlCmd_pwrIndex_init_rev7 << 0));
-	} else if (NREV_GT(pi->pubpi.phy_rev, 1)) {
+	else if (NREV_GT(pi->pubpi.phy_rev, 1))
 		mod_phy_reg(pi, 0x222, (0xff << 0),
 			    (NPHY_TxPwrCtrlCmd_pwrIndex_init << 0));
-	}
 
 	if (D11REV_IS(pi->sh->corerev, 11) || D11REV_IS(pi->sh->corerev, 12))
 		wlapi_bmac_mctrl(pi->sh->physhim, MCTL_PHYLOCK, 0);
@@ -28622,9 +28283,8 @@ void wlc_phy_txpwr_papd_cal_nphy(struct brcms_phy *pi)
 			  pi->nphy_papd_tx_gain_at_last_cal[0]) >= 4)
 		     || ((u32)
 			 ABS(wlc_phy_txpwr_idx_cur_get_nphy(pi, 1) -
-			     pi->nphy_papd_tx_gain_at_last_cal[1]) >= 4))))) {
+			     pi->nphy_papd_tx_gain_at_last_cal[1]) >= 4)))))
 		wlc_phy_a4(pi, true);
-	}
 }
 
 void wlc_phy_txpwrctrl_enable_nphy(struct brcms_phy *pi, u8 ctrl_type)
@@ -28664,23 +28324,20 @@ void wlc_phy_txpwrctrl_enable_nphy(struct brcms_phy *pi, u8 ctrl_type)
 
 		tbl_len = 84;
 		tbl_offset = 64;
-		for (ctr = 0; ctr < tbl_len; ctr++) {
+		for (ctr = 0; ctr < tbl_len; ctr++)
 			regval[ctr] = 0;
-		}
 		wlc_phy_table_write_nphy(pi, 26, tbl_len, tbl_offset, 16,
 					 regval);
 		wlc_phy_table_write_nphy(pi, 27, tbl_len, tbl_offset, 16,
 					 regval);
 
-		if (NREV_GE(pi->pubpi.phy_rev, 3)) {
-
+		if (NREV_GE(pi->pubpi.phy_rev, 3))
 			and_phy_reg(pi, 0x1e7,
 				    (u16) (~((0x1 << 15) |
 						(0x1 << 14) | (0x1 << 13))));
-		} else {
+		else
 			and_phy_reg(pi, 0x1e7,
 				    (u16) (~((0x1 << 14) | (0x1 << 13))));
-		}
 
 		if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 			or_phy_reg(pi, 0x8f, (0x1 << 8));
@@ -28730,7 +28387,7 @@ void wlc_phy_txpwrctrl_enable_nphy(struct brcms_phy *pi, u8 ctrl_type)
 
 		if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 			if ((pi->nphy_txpwr_idx[0] != 128)
-			    && (pi->nphy_txpwr_idx[1] != 128)) {
+			    && (pi->nphy_txpwr_idx[1] != 128))
 				wlc_phy_txpwr_idx_cur_set_nphy(pi,
 							       pi->
 							       nphy_txpwr_idx
@@ -28738,7 +28395,6 @@ void wlc_phy_txpwrctrl_enable_nphy(struct brcms_phy *pi, u8 ctrl_type)
 							       pi->
 							       nphy_txpwr_idx
 							       [1]);
-			}
 		}
 
 		if (NREV_GE(pi->pubpi.phy_rev, 3)) {
@@ -28799,17 +28455,14 @@ wlc_phy_txpwr_index_nphy(struct brcms_phy *pi, u8 core_mask, s8 txpwrindex,
 
 	for (core = 0; core < pi->pubpi.phy_corenum; core++) {
 
-		if ((core_mask & (1 << core)) == 0) {
+		if ((core_mask & (1 << core)) == 0)
 			continue;
-		}
 
 		txpwrctl_tbl = (core == PHY_CORE_0) ? 26 : 27;
 
 		if (txpwrindex < 0) {
-			if (pi->nphy_txpwrindex[core].index < 0) {
-
+			if (pi->nphy_txpwrindex[core].index < 0)
 				continue;
-			}
 
 			if (NREV_GE(pi->pubpi.phy_rev, 3)) {
 				mod_phy_reg(pi, 0x8f,
@@ -28927,22 +28580,22 @@ wlc_phy_txpwr_index_nphy(struct brcms_phy *pi, u8 core_mask, s8 txpwrindex,
 						(tx_ind0 + txpwrindex), 32,
 						&txgain);
 
-			if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+			if (NREV_GE(pi->pubpi.phy_rev, 3))
 				rad_gain =
 				    (txgain >> 16) & ((1 << (32 - 16 + 1)) - 1);
-			} else {
+			else
 				rad_gain =
 				    (txgain >> 16) & ((1 << (28 - 16 + 1)) - 1);
-			}
+
 			dac_gain = (txgain >> 8) & ((1 << (13 - 8 + 1)) - 1);
 			bbmult = (txgain >> 0) & ((1 << (7 - 0 + 1)) - 1);
 
-			if (NREV_GE(pi->pubpi.phy_rev, 3)) {
+			if (NREV_GE(pi->pubpi.phy_rev, 3))
 				mod_phy_reg(pi, ((core == PHY_CORE_0) ? 0x8f :
 						 0xa5), (0x1 << 8), (0x1 << 8));
-			} else {
+			else
 				mod_phy_reg(pi, 0xa5, (0x1 << 14), (0x1 << 14));
-			}
+
 			write_phy_reg(pi, (core == PHY_CORE_0) ?
 				      0xaa : 0xab, dac_gain);
 
@@ -28974,10 +28627,9 @@ wlc_phy_txpwr_index_nphy(struct brcms_phy *pi, u8 core_mask, s8 txpwrindex,
 			wlc_phy_table_read_nphy(pi, txpwrctl_tbl, 1,
 						(lo_ind0 + txpwrindex), 32,
 						&locomp);
-			if (restore_cals) {
+			if (restore_cals)
 				wlc_phy_table_write_nphy(pi, 15, 1, (85 + core),
 							 16, &locomp);
-			}
 
 			if (NREV_IS(pi->pubpi.phy_rev, 1))
 				wlapi_bmac_phyclk_fgc(pi->sh->physhim, OFF);
@@ -29074,9 +28726,9 @@ void wlc_nphy_deaf_mode(struct brcms_phy *pi, bool mode)
 	if (mode) {
 		if (pi->nphy_deaf_count == 0)
 			wlc_phy_stay_in_carriersearch_nphy(pi, true);
-	} else {
-		if (pi->nphy_deaf_count > 0)
-			wlc_phy_stay_in_carriersearch_nphy(pi, false);
+	} else if (pi->nphy_deaf_count > 0) {
+		wlc_phy_stay_in_carriersearch_nphy(pi, false);
 	}
+
 	wlapi_enable_mac(pi->sh->physhim);
 }
diff --git a/drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.c b/drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.c
index 01ff0c8..7ff2850 100644
--- a/drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.c
+++ b/drivers/staging/brcm80211/brcmsmac/phy/phy_qmath.c
@@ -35,11 +35,11 @@ When both the 16bit inputs are 0x8000 then the output is saturated to 0x7fffffff
 s16 qm_muls16(s16 op1, s16 op2)
 {
 	s32 result;
-	if (op1 == (s16) 0x8000 && op2 == (s16) 0x8000) {
+	if (op1 == (s16) 0x8000 && op2 == (s16) 0x8000)
 		result = 0x7fffffff;
-	} else {
+	else
 		result = ((s32) (op1) * (s32) (op2));
-	}
+
 	return (s16) (result >> 15);
 }
 
@@ -51,11 +51,11 @@ s32 qm_add32(s32 op1, s32 op2)
 {
 	s32 result;
 	result = op1 + op2;
-	if (op1 < 0 && op2 < 0 && result > 0) {
+	if (op1 < 0 && op2 < 0 && result > 0)
 		result = 0x80000000;
-	} else if (op1 > 0 && op2 > 0 && result < 0) {
+	else if (op1 > 0 && op2 > 0 && result < 0)
 		result = 0x7fffffff;
-	}
+
 	return result;
 }
 
@@ -67,13 +67,13 @@ s16 qm_add16(s16 op1, s16 op2)
 {
 	s16 result;
 	s32 temp = (s32) op1 + (s32) op2;
-	if (temp > (s32) 0x7fff) {
+	if (temp > (s32) 0x7fff)
 		result = (s16) 0x7fff;
-	} else if (temp < (s32) 0xffff8000) {
+	else if (temp < (s32) 0xffff8000)
 		result = (s16) 0xffff8000;
-	} else {
+	else
 		result = (s16) temp;
-	}
+
 	return result;
 }
 
@@ -85,13 +85,13 @@ s16 qm_sub16(s16 op1, s16 op2)
 {
 	s16 result;
 	s32 temp = (s32) op1 - (s32) op2;
-	if (temp > (s32) 0x7fff) {
+	if (temp > (s32) 0x7fff)
 		result = (s16) 0x7fff;
-	} else if (temp < (s32) 0xffff8000) {
+	else if (temp < (s32) 0xffff8000)
 		result = (s16) 0xffff8000;
-	} else {
+	else
 		result = (s16) temp;
-	}
+
 	return result;
 }
 
@@ -110,12 +110,12 @@ s32 qm_shl32(s32 op, int shift)
 	else if (shift < -31)
 		shift = -31;
 	if (shift >= 0) {
-		for (i = 0; i < shift; i++) {
+		for (i = 0; i < shift; i++)
 			result = qm_add32(result, result);
-		}
 	} else {
 		result = result >> (-shift);
 	}
+
 	return result;
 }
 
@@ -134,12 +134,12 @@ s16 qm_shl16(s16 op, int shift)
 	else if (shift < -15)
 		shift = -15;
 	if (shift > 0) {
-		for (i = 0; i < shift; i++) {
+		for (i = 0; i < shift; i++)
 			result = qm_add16(result, result);
-		}
 	} else {
 		result = result >> (-shift);
 	}
+
 	return result;
 }
 
diff --git a/drivers/staging/brcm80211/brcmsmac/rate.c b/drivers/staging/brcm80211/brcmsmac/rate.c
index 86d47c8..c320384 100644
--- a/drivers/staging/brcm80211/brcmsmac/rate.c
+++ b/drivers/staging/brcm80211/brcmsmac/rate.c
@@ -435,14 +435,13 @@ brcms_c_rateset_default(struct brcms_c_rateset *rs_tgt,
 	    (PHYTYPE_IS(phy_type, PHY_TYPE_N)) ||
 	    (PHYTYPE_IS(phy_type, PHY_TYPE_LCN)) ||
 	    (PHYTYPE_IS(phy_type, PHY_TYPE_SSN))) {
-		if (BAND_5G(bandtype)) {
+		if (BAND_5G(bandtype))
 			rs_dflt = (bw == BRCMS_20_MHZ ?
 				   &ofdm_mimo_rates : &ofdm_40bw_mimo_rates);
-		} else {
+		else
 			rs_dflt = (bw == BRCMS_20_MHZ ?
 				   &cck_ofdm_mimo_rates :
 				   &cck_ofdm_40bw_mimo_rates);
-		}
 	} else if (PHYTYPE_IS(phy_type, PHY_TYPE_LP)) {
 		rs_dflt = (BAND_5G(bandtype)) ? &ofdm_rates : &cck_ofdm_rates;
 	} else if (PHYTYPE_IS(phy_type, PHY_TYPE_A)) {
diff --git a/drivers/staging/brcm80211/brcmsmac/srom.c b/drivers/staging/brcm80211/brcmsmac/srom.c
index f39442e..bef43ea 100644
--- a/drivers/staging/brcm80211/brcmsmac/srom.c
+++ b/drivers/staging/brcm80211/brcmsmac/srom.c
@@ -901,21 +901,20 @@ sprom_read_pci(struct si_pub *sih, u16 *sprom, uint wordoff,
 
 	if (check_crc) {
 
-		if (buf[0] == 0xffff) {
+		if (buf[0] == 0xffff)
 			/* The hardware thinks that an srom that starts with 0xffff
 			 * is blank, regardless of the rest of the content, so declare
 			 * it bad.
 			 */
 			return -ENODATA;
-		}
 
 		/* fixup the endianness so crc8 will pass */
 		htol16_buf(buf, nwords * 2);
 		if (brcmu_crc8((u8 *) buf, nwords * 2, CRC8_INIT_VALUE) !=
-		    CRC8_GOOD_VALUE) {
+		    CRC8_GOOD_VALUE)
 			/* DBG only pci always read srom4 first, then srom8/9 */
 			err = -EIO;
-		}
+
 		/* now correct the endianness of the byte array */
 		ltoh16_buf(buf, nwords * 2);
 	}
@@ -930,9 +929,8 @@ static int otp_read_pci(struct si_pub *sih, u16 *buf, uint bufsz)
 	int err = 0;
 
 	otp = kzalloc(OTP_SZ_MAX, GFP_ATOMIC);
-	if (otp == NULL) {
+	if (otp == NULL)
 		return -ENOMEM;
-	}
 
 	err = otp_read_region(sih, OTP_HW_RGN, (u16 *) otp, &sz);
 
@@ -941,20 +939,19 @@ static int otp_read_pci(struct si_pub *sih, u16 *buf, uint bufsz)
 	kfree(otp);
 
 	/* Check CRC */
-	if (buf[0] == 0xffff) {
+	if (buf[0] == 0xffff)
 		/* The hardware thinks that an srom that starts with 0xffff
 		 * is blank, regardless of the rest of the content, so declare
 		 * it bad.
 		 */
 		return -ENODATA;
-	}
 
 	/* fixup the endianness so crc8 will pass */
 	htol16_buf(buf, bufsz);
 	if (brcmu_crc8((u8 *) buf, SROM4_WORDS * 2, CRC8_INIT_VALUE) !=
-	    CRC8_GOOD_VALUE) {
+	    CRC8_GOOD_VALUE)
 		err = -EIO;
-	}
+
 	/* now correct the endianness of the byte array */
 	ltoh16_buf(buf, bufsz);
 
diff --git a/drivers/staging/brcm80211/brcmsmac/stf.c b/drivers/staging/brcm80211/brcmsmac/stf.c
index f6a4b66..709c9a3 100644
--- a/drivers/staging/brcm80211/brcmsmac/stf.c
+++ b/drivers/staging/brcm80211/brcmsmac/stf.c
@@ -80,15 +80,13 @@ void brcms_c_tempsense_upd(struct brcms_c_info *wlc)
 	txchain = active_chains & 0xf;
 
 	if (wlc->stf->txchain == wlc->stf->hw_txchain) {
-		if (txchain && (txchain < wlc->stf->hw_txchain)) {
+		if (txchain && (txchain < wlc->stf->hw_txchain))
 			/* turn off 1 tx chain */
 			brcms_c_stf_txchain_set(wlc, txchain, true);
-		}
 	} else if (wlc->stf->txchain < wlc->stf->hw_txchain) {
-		if (txchain == wlc->stf->hw_txchain) {
+		if (txchain == wlc->stf->hw_txchain)
 			/* turn back on txchain */
 			brcms_c_stf_txchain_set(wlc, txchain, true);
-		}
 	}
 }
 
@@ -136,9 +134,8 @@ brcms_c_stf_ss_algo_channel_get(struct brcms_c_info *wlc, u16 *ss_algo_channel,
 
 static bool brcms_c_stf_stbc_tx_set(struct brcms_c_info *wlc, s32 int_val)
 {
-	if ((int_val != AUTO) && (int_val != OFF) && (int_val != ON)) {
+	if ((int_val != AUTO) && (int_val != OFF) && (int_val != ON))
 		return false;
-	}
 
 	if ((int_val == ON) && (wlc->stf->txstreams == 1))
 		return false;
@@ -158,9 +155,8 @@ static bool brcms_c_stf_stbc_tx_set(struct brcms_c_info *wlc, s32 int_val)
 bool brcms_c_stf_stbc_rx_set(struct brcms_c_info *wlc, s32 int_val)
 {
 	if ((int_val != HT_CAP_RX_STBC_NO)
-	    && (int_val != HT_CAP_RX_STBC_ONE_STREAM)) {
+	    && (int_val != HT_CAP_RX_STBC_ONE_STREAM))
 		return false;
-	}
 
 	if (BRCMS_STF_SS_STBC_RX(wlc)) {
 		if ((int_val != HT_CAP_RX_STBC_NO)
@@ -178,15 +174,13 @@ static int brcms_c_stf_txcore_set(struct brcms_c_info *wlc, u8 Nsts,
 	BCMMSG(wlc->wiphy, "wl%d: Nsts %d core_mask %x\n",
 		 wlc->pub->unit, Nsts, core_mask);
 
-	if (BRCMS_BITSCNT(core_mask) > wlc->stf->txstreams) {
+	if (BRCMS_BITSCNT(core_mask) > wlc->stf->txstreams)
 		core_mask = 0;
-	}
 
 	if ((BRCMS_BITSCNT(core_mask) == wlc->stf->txstreams) &&
 	    ((core_mask & ~wlc->stf->txchain)
-	     || !(core_mask & wlc->stf->txchain))) {
+	     || !(core_mask & wlc->stf->txchain)))
 		core_mask = wlc->stf->txchain;
-	}
 
 	wlc->stf->txcore[Nsts] = core_mask;
 	/* Nsts = 1..4, txcore index = 1..4 */
@@ -375,9 +369,8 @@ static void _brcms_c_stf_phy_txant_upd(struct brcms_c_info *wlc)
 
 			if (BRCMS_ISNPHY(wlc->band) &&
 			    NREV_GE(wlc->band->phyrev, 3)
-			    && NREV_LT(wlc->band->phyrev, 7)) {
+			    && NREV_LT(wlc->band->phyrev, 7))
 				wlc->stf->phytxant = PHY_TXC_ANT_2;
-			}
 		} else {
 			if (BRCMS_ISLCNPHY(wlc->band) ||
 			    BRCMS_ISSSLPNPHY(wlc->band))
@@ -414,22 +407,20 @@ void brcms_c_stf_phy_chain_calc(struct brcms_c_info *wlc)
 
 	/* these parameter are intended to be used for all PHY types */
 	if (wlc->stf->hw_txchain == 0 || wlc->stf->hw_txchain == 0xf) {
-		if (BRCMS_ISNPHY(wlc->band)) {
+		if (BRCMS_ISNPHY(wlc->band))
 			wlc->stf->hw_txchain = TXCHAIN_DEF_NPHY;
-		} else {
+		else
 			wlc->stf->hw_txchain = TXCHAIN_DEF;
-		}
 	}
 
 	wlc->stf->txchain = wlc->stf->hw_txchain;
 	wlc->stf->txstreams = (u8) BRCMS_BITSCNT(wlc->stf->hw_txchain);
 
 	if (wlc->stf->hw_rxchain == 0 || wlc->stf->hw_rxchain == 0xf) {
-		if (BRCMS_ISNPHY(wlc->band)) {
+		if (BRCMS_ISNPHY(wlc->band))
 			wlc->stf->hw_rxchain = RXCHAIN_DEF_NPHY;
-		} else {
+		else
 			wlc->stf->hw_rxchain = RXCHAIN_DEF;
-		}
 	}
 
 	wlc->stf->rxchain = wlc->stf->hw_rxchain;
@@ -448,9 +439,9 @@ static u16 _brcms_c_stf_phytxchain_sel(struct brcms_c_info *wlc,
 {
 	u16 phytxant = wlc->stf->phytxant;
 
-	if (RSPEC_STF(rspec) != PHY_TXC1_MODE_SISO) {
+	if (RSPEC_STF(rspec) != PHY_TXC1_MODE_SISO)
 		phytxant = wlc->stf->txchain << PHY_TXC_ANT_SHIFT;
-	} else if (wlc->stf->txant == ANT_TX_DEF)
+	else if (wlc->stf->txant == ANT_TX_DEF)
 		phytxant = wlc->stf->txchain << PHY_TXC_ANT_SHIFT;
 	phytxant &= PHY_TXC_ANT_MASK;
 	return phytxant;
diff --git a/drivers/staging/brcm80211/brcmutil/utils.c b/drivers/staging/brcm80211/brcmutil/utils.c
index 2151e0b..4b08157 100644
--- a/drivers/staging/brcm80211/brcmutil/utils.c
+++ b/drivers/staging/brcm80211/brcmutil/utils.c
@@ -244,9 +244,8 @@ brcmu_pktq_pflush(struct pktq *pq, int prec, bool dir,
 		}
 	}
 
-	if (q->head == NULL) {
+	if (q->head == NULL)
 		q->tail = NULL;
-	}
 }
 EXPORT_SYMBOL(brcmu_pktq_pflush);
 
@@ -404,26 +403,23 @@ int brcmu_iovar_lencheck(const struct brcmu_iovar *vi, void *arg, int len,
 	case IOVT_UINT16:
 	case IOVT_UINT32:
 		/* all integers are s32 sized args at the ioctl interface */
-		if (len < (int)sizeof(int)) {
+		if (len < (int)sizeof(int))
 			bcmerror = -EOVERFLOW;
-		}
 		break;
 
 	case IOVT_BUFFER:
 		/* buffer must meet minimum length requirement */
-		if (len < vi->minlen) {
+		if (len < vi->minlen)
 			bcmerror = -EOVERFLOW;
-		}
 		break;
 
 	case IOVT_VOID:
-		if (!set) {
+		if (!set)
 			/* Cannot return nil... */
 			bcmerror = -ENOTSUPP;
-		} else if (len) {
+		else if (len)
 			/* Set is an action w/o parameters */
 			bcmerror = -ENOBUFS;
-		}
 		break;
 
 	default:
@@ -670,10 +666,9 @@ u16 brcmu_qdbm_to_mw(u8 qdbm)
 	uint factor = 1;
 	int idx = qdbm - QDBM_OFFSET;
 
-	if (idx >= QDBM_TABLE_LEN) {
+	if (idx >= QDBM_TABLE_LEN)
 		/* clamp to max u16 mW value */
 		return 0xFFFF;
-	}
 
 	/* scale the qdBm index up to the range of the table 0-40
 	 * where an offset of 40 qdBm equals a factor of 10 mW.
diff --git a/drivers/staging/brcm80211/brcmutil/wifi.c b/drivers/staging/brcm80211/brcmutil/wifi.c
index e8f7f56..1bce888 100644
--- a/drivers/staging/brcm80211/brcmutil/wifi.c
+++ b/drivers/staging/brcm80211/brcmutil/wifi.c
@@ -34,9 +34,8 @@ bool brcmu_chspec_malformed(u16 chanspec)
 	if (CHSPEC_IS20(chanspec)) {
 		if (!CHSPEC_SB_NONE(chanspec))
 			return true;
-	} else {
-		if (!CHSPEC_SB_UPPER(chanspec) && !CHSPEC_SB_LOWER(chanspec))
-			return true;
+	} else if (!CHSPEC_SB_UPPER(chanspec) && !CHSPEC_SB_LOWER(chanspec)) {
+		return true;
 	}
 
 	return false;
@@ -60,13 +59,12 @@ u8 brcmu_chspec_ctlchan(u16 chspec)
 		/* chanspec channel holds the centre frequency, use that and the
 		 * side band information to reconstruct the control channel number
 		 */
-		if (CHSPEC_CTL_SB(chspec) == WL_CHANSPEC_CTL_SB_UPPER) {
+		if (CHSPEC_CTL_SB(chspec) == WL_CHANSPEC_CTL_SB_UPPER)
 			/* control chan is the upper 20 MHZ SB of the 40MHZ channel */
 			ctl_chan = UPPER_20_SB(CHSPEC_CHANNEL(chspec));
-		} else {
+		else
 			/* control chan is the lower 20 MHZ SB of the 40MHZ channel */
 			ctl_chan = LOWER_20_SB(CHSPEC_CHANNEL(chspec));
-		}
 	}
 
 	return ctl_chan;
-- 
1.7.1


