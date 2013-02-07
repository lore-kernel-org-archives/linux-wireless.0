Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:57401 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751535Ab3BGIBo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Feb 2013 03:01:44 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 07 Feb 2013 00:01:44 -0800
From: chaitanyatk@posedge.com
To: <linux-wireless@vger.kernel.org>
Cc: <johannes@sipsolutions.net>, <maheshp@posedge.com>
Subject: [RFC] mac80211: Add support for Tx-AMSDU viz debugfs.
Message-ID: <7384f4ddc838247a0f467708d66baa8c@posedge.com> (sfid-20130207_090148_148406_E88982BD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Add support for sending AMSDU packet with the
user defined config through debugfs. This helps in
testing the Rx-AMSDU path without needing a special
driver/stack.

Note: Its purely for debug purposes.

Signed-off-by: T Krushna Chaitanya <chaitanyatk@posedge.com>
---
Tests and Observations
==============
1)  Verified the Rx-AMSDU logic with mac80211 based chip
it works fine all msdu's are delivered.

2) Wireshark parses this frame fine.

3)sample cmd: echo "0,7,5,100,00:10:18:a9:50:6c"
> /sys/kernel/debug/ieee80211/phy0/netdev:wlan0/send_amsdu

Issues: Comments are welcome
===
1) Netgear/Broadcom AP's are dropping some AMSDU's in
the AMSDU deaggregation when seen on wired side.

2) with 8K seeing a DMA timeout and warning in ath9k driver.
(will send a separate mail)

3) dev_alloc_skb allocates as below(local PAGE_SIZE=4096)

AMSDU Size:    SKB tailroom

2304+26            2368
3839+26            7936
7935+26            16128

---

  include/linux/ieee80211.h     |   22 ++++
  include/net/mac80211.h        |    8 +-
  net/mac80211/debugfs_netdev.c |  257 
+++++++++++++++++++++++++++++++++++++++++
  net/mac80211/ieee80211_i.h    |    1 -
  net/mac80211/mlme.c           |    2 +-
  net/mac80211/tx.c             |    4 +-
  net/mac80211/wme.c            |    5 +
  7 files changed, 293 insertions(+), 6 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index ccf9ee1..b91902b 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -172,6 +172,28 @@

  #define IEEE80211_HT_CTL_LEN		4

+/*AMSDU Params*/
+#define LLC_SNAP_LEN			8
+#define AMSDU_SIZE_2K			2304
+#define AMSDU_SIZE_4K			3839
+#define AMSDU_SIZE_8K			7935
+#define AMSDU_SHDR_LEN			14
+#define AMSDU_RESERVE			0
+
+struct ieee80211_amsdu_sub_header {
+	u8 daddr[6];
+	u8 saddr[6];
+	__le16 len;
+} __packed;
+
+struct ieee80211_amsdu_llc_hdr {
+	u8 llc_dsap;
+	u8 llc_ssap;
+	u8 llc_ctrl;
+	u8 snap_oui[3];
+	u16 snap_type;
+} __packed;
+
  struct ieee80211_hdr {
  	__le16 frame_control;
  	__le16 duration_id;
diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 23daed3..3bf5aef 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -470,6 +470,7 @@ enum mac80211_tx_control_flags {
  	IEEE80211_TX_STATUS_EOSP		= BIT(28),
  	IEEE80211_TX_CTL_USE_MINRATE		= BIT(29),
  	IEEE80211_TX_CTL_DONTFRAG		= BIT(30),
+	IEEE80211_TX_CTL_AMSDU			= BIT(31),
  };

  #define IEEE80211_TX_CTL_STBC_SHIFT		23
@@ -485,7 +486,8 @@ enum mac80211_tx_control_flags {
  	IEEE80211_TX_STAT_AMPDU | IEEE80211_TX_STAT_AMPDU_NO_BACK |	      \
  	IEEE80211_TX_CTL_RATE_CTRL_PROBE | IEEE80211_TX_CTL_NO_PS_BUFFER |    
\
  	IEEE80211_TX_CTL_MORE_FRAMES | IEEE80211_TX_CTL_LDPC |		      \
-	IEEE80211_TX_CTL_STBC | IEEE80211_TX_STATUS_EOSP)
+	IEEE80211_TX_CTL_STBC | IEEE80211_TX_STATUS_EOSP|		      \
+	IEEE80211_TX_CTL_AMSDU)

  /**
   * enum mac80211_rate_control_flags - per-rate flags set by the
@@ -1402,6 +1404,10 @@ enum ieee80211_hw_flags {
  	IEEE80211_HW_SCAN_WHILE_IDLE			= 1<<24,
  	IEEE80211_HW_P2P_DEV_ADDR_FOR_INTF		= 1<<25,
  	IEEE80211_HW_TEARDOWN_AGGR_ON_BAR_FAIL		= 1<<26,
+	/* Some Drivers may not support 4K frame transmission
+	 * in that case we need 2 bits, else 1 bit is enough*/
+	IEEE80211_HW_TX_4K_AMSDU			= 1<<27,
+	IEEE80211_HW_TX_8K_AMSDU			= 1<<28
  };

  /**
diff --git a/net/mac80211/debugfs_netdev.c 
b/net/mac80211/debugfs_netdev.c
index cbde5cc..3041717 100644
--- a/net/mac80211/debugfs_netdev.c
+++ b/net/mac80211/debugfs_netdev.c
@@ -11,6 +11,7 @@
  #include <linux/device.h>
  #include <linux/if.h>
  #include <linux/if_ether.h>
+#include <linux/string.h>
  #include <linux/interrupt.h>
  #include <linux/netdevice.h>
  #include <linux/rtnetlink.h>
@@ -336,6 +337,261 @@ static ssize_t ieee80211_if_parse_tkip_mic_test(

  __IEEE80211_IF_FILE_W(tkip_mic_test);

+static ssize_t ieee80211_if_fmt_send_amsdu(
+		const struct ieee80211_sub_if_data *sdata,
+		char *buf,
+		int buflen)
+{
+	return -EOPNOTSUPP;
+}
+static ssize_t ieee80211_if_parse_send_amsdu(
+		struct ieee80211_sub_if_data *sdata,
+		const char *buf,
+		int buflen)
+{
+	struct ieee80211_local *local = sdata->local;
+	struct sta_info *sta = NULL;
+	struct sk_buff *skb = NULL;
+	struct sk_buff *skb_amsdu = NULL;
+	struct ieee80211_hdr *hdr = NULL;
+	struct ieee80211_amsdu_sub_header *amsdu_shdr = NULL;
+	struct ieee80211_amsdu_llc_hdr amsdu_llc = { /* From mwifiex*/
+		0xaa,           /* LLC DSAP */
+		0xaa,           /* LLC SSAP */
+		0x03,           /* LLC CTRL */
+		{0x00, 0x00, 0x00},     /* SNAP OUI */
+		0x9999          /* SNAP type */
+	};
+	__le16 fc, pad;
+
+	/*==== User Inputs===*/
+	u8 addr[ETH_ALEN] = {0x0};
+	u8 daddr[ETH_ALEN], saddr[ETH_ALEN], bssid[ETH_ALEN];
+	u32 tid;
+	u32 total_msdu, num_msdu;
+	u32 msdu_size, payload_size;
+	u32 amsdu_size = 0;
+
+	char *buffer;
+	/* Defaults: amsdu_size,tid,no of msdu's, size of msdu, DAddr*/
+	char *buffer_array[5] = {"0", "0", "3", "300", "ff:ff:ff:ff:ff:ff"};
+	int j = 0;
+
+	/* Sanity checks for the buffer Rx*/
+	if (buflen == 0 || !buf)
+		return -EINVAL;
+
+	/*We have already copied data from user space*/
+	buffer = kstrdup(buf, GFP_KERNEL);
+	/* Its reentrant safe.*/
+	while ((buffer_array[j] = strsep(&buffer, ",")) != NULL) {
+		/*Skip the MAC address part, we will handle it below*/
+		j++;
+	}
+	/* Conver to respective data types*/
+	kstrtouint(buffer_array[0], 10, &amsdu_size);
+	kstrtouint(buffer_array[1], 10, &tid);
+	kstrtouint(buffer_array[2], 10, &total_msdu);
+	kstrtouint(buffer_array[3], 10, &msdu_size);
+
+	if (buffer_array[4])
+		sscanf(buffer_array[4], "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx",
+		&addr[0], &addr[1], &addr[2], &addr[3], &addr[4], &addr[5]);
+
+	/* Validate all input params*/
+
+	/* Check for AMSDU_size*/
+
+	/* User Inputs*/
+	if (amsdu_size == 0)
+		amsdu_size = AMSDU_SIZE_2K;
+	else if (amsdu_size == 1)
+		amsdu_size = AMSDU_SIZE_4K;
+	else if (amsdu_size == 2)
+		amsdu_size = AMSDU_SIZE_8K;
+	else if (amsdu_size != 0 || amsdu_size != 1 || amsdu_size != 2)
+		amsdu_size = AMSDU_SIZE_2K;
+
+	/* MSDU Size Checks: Min-100, Max: 2304*/
+	if (msdu_size < 0)
+		msdu_size = 100;
+	if (msdu_size > 2304)
+		msdu_size = 2304;
+
+	/* TID CHecks: Default is 0-BE*/
+	if (tid < 0 || tid > 7)
+		tid = 0;/* Default is BE*/
+
+	/* Total MSDU's Checks: Default 3*/
+	if (total_msdu < 0 || total_msdu > 10)
+		total_msdu = 3;
+	/* Driver Inputs: Tx Side*/
+	if ((local->hw.flags & IEEE80211_HW_TX_4K_AMSDU) &&
+		!(local->hw.flags & IEEE80211_HW_TX_8K_AMSDU)) {
+		if (amsdu_size == AMSDU_SIZE_8K)
+			amsdu_size = AMSDU_SIZE_4K;
+	} else if ((local->hw.flags & IEEE80211_HW_TX_8K_AMSDU) &&
+		!(local->hw.flags & IEEE80211_HW_TX_4K_AMSDU)) {
+		/* Take the User Input*/
+	} else if (!(local->hw.flags & IEEE80211_HW_TX_4K_AMSDU) &&
+		    !(local->hw.flags & IEEE80211_HW_TX_8K_AMSDU))  {
+		/* Most drivrs are suporting only 2k buffer allocation*/
+		amsdu_size = AMSDU_SIZE_2K;
+	} else if ((local->hw.flags & IEEE80211_HW_TX_4K_AMSDU) &&
+		(local->hw.flags & IEEE80211_HW_TX_8K_AMSDU)) {
+		/* Invalid Case, but just handle it.
+		 * Take the User Input
+		 */
+	}
+
+	if (!ieee80211_sdata_running(sdata))
+		return -ENOTCONN;
+
+	/* Reciver Inputs: Rx Side
+	 * Check the HT Capabilities: Depending on Mode: AP/STA
+	 * If user configured 8K but RX doesn't support: Use 4K
+	 */
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_AP:
+		rcu_read_lock();
+		sta = sta_info_get(sdata, addr);
+		if (!sta) {
+			/* Passed Address is not one of the STAs': Reject*/
+			rcu_read_unlock();
+			return -ENOENT;
+		}
+		if (!(sta->sta.ht_cap.cap & IEEE80211_HT_CAP_MAX_AMSDU) &&
+				amsdu_size == AMSDU_SIZE_8K)
+			amsdu_size = AMSDU_SIZE_4K;
+		rcu_read_unlock();
+		break;
+	case NL80211_IFTYPE_STATION:
+		rcu_read_lock();
+		mutex_lock(&sdata->u.mgd.mtx);
+		if (!sdata->u.mgd.associated) {
+			mutex_unlock(&sdata->u.mgd.mtx);
+			return -ENOTCONN;
+		}
+		sta = sta_info_get(sdata, sdata->u.mgd.associated->bssid);
+		/*Used later while filling the header*/
+		memcpy(bssid, sdata->u.mgd.associated->bssid, ETH_ALEN);
+		mutex_unlock(&sdata->u.mgd.mtx);
+		if (!sta) {
+			/* Unable to retrive ht.cap info, so fall back to 4K*/
+			amsdu_size = AMSDU_SIZE_4K;
+		} else if (!(sta->sta.ht_cap.cap & IEEE80211_HT_CAP_MAX_AMSDU)
+				&& amsdu_size == AMSDU_SIZE_8K) {
+			amsdu_size = AMSDU_SIZE_4K;
+		}
+		rcu_read_unlock();
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+
+	skb = dev_alloc_skb(local->hw.extra_tx_headroom + amsdu_size + 26);
+	if (!skb)
+		return -ENOMEM;
+
+	skb_reserve(skb, local->hw.extra_tx_headroom);
+	/* Reserve Room for Qos Hdr now, it will be filled later*/
+	hdr = (struct ieee80211_hdr *) skb_put(skb, 26);
+	memset(hdr, 0, 26);
+
+	fc = cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_STYPE_QOS_DATA);
+
+	switch (sdata->vif.type) {
+	case NL80211_IFTYPE_AP:
+		fc |= cpu_to_le16(IEEE80211_FCTL_FROMDS);
+		/* DA BSSID SA */
+		memcpy(hdr->addr1, addr, ETH_ALEN);
+		memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
+		memcpy(hdr->addr3, sdata->vif.addr, ETH_ALEN);/*A-MSDU Case*/
+
+		/* Store the Addresses for Subframe AMSDU*/
+		memcpy(daddr, addr, ETH_ALEN);
+		memcpy(saddr, sdata->vif.addr, ETH_ALEN);
+		break;
+	case NL80211_IFTYPE_STATION:
+		fc |= cpu_to_le16(IEEE80211_FCTL_TODS);
+		/* BSSID SA DA */
+		memcpy(hdr->addr1, bssid, ETH_ALEN);
+		memcpy(hdr->addr2, sdata->vif.addr, ETH_ALEN);
+		memcpy(hdr->addr3, bssid, ETH_ALEN); /* A-MSDU Case*/
+
+		/* Store the Addresses for Subframe AMSDU*/
+		memcpy(daddr, addr, ETH_ALEN);
+		memcpy(saddr, sdata->vif.addr, ETH_ALEN);
+		break;
+	default:
+		dev_kfree_skb(skb);
+		return -EOPNOTSUPP;
+	}
+	hdr->frame_control = fc;
+
+	/* Read from the debugfs file and form the AMSDU
+	 * Reference: mwifiex driver
+	 */
+	payload_size = msdu_size;
+	/*subheader+Reserve+LLC*/
+	msdu_size += AMSDU_SHDR_LEN + AMSDU_RESERVE + LLC_SNAP_LEN;
+	for (num_msdu = 0; num_msdu < total_msdu; num_msdu++) {
+
+		/* Check if there is enough room for
+		 * new MSDU
+		 */
+		if (skb_tailroom(skb) < (msdu_size))
+			break;
+
+		/* Loop thru and create a AMSDU*/
+		skb_amsdu = dev_alloc_skb(msdu_size);
+		if (!skb_amsdu) {
+			dev_kfree_skb(skb);
+			return -ENOMEM;
+		}
+		/* 4 Byte Alignment..Not required..hence 0*/
+		skb_reserve(skb_amsdu, AMSDU_RESERVE);
+		amsdu_shdr = (struct ieee80211_amsdu_sub_header *)
+			skb_put(skb_amsdu, AMSDU_SHDR_LEN);
+
+		memcpy(amsdu_shdr->daddr, daddr, ETH_ALEN);
+		memcpy(amsdu_shdr->saddr, saddr, ETH_ALEN);
+		/* Doesn't include Subheaders, only MSDU Length*/
+		amsdu_shdr->len = htons(msdu_size-AMSDU_RESERVE-AMSDU_SHDR_LEN);
+
+		/* Add some LLC Header*/
+		memcpy((struct ieee80211_amsdu_llc_hdr *)skb_put(skb_amsdu,
+			 LLC_SNAP_LEN) , &amsdu_llc, LLC_SNAP_LEN);
+
+		/* Add Some Payload, as Requested
+		 * Add different payload to identify each MSDU in an AMSDU OTA
+		 */
+		memset(skb_put(skb_amsdu, payload_size), num_msdu+1,
+			payload_size);
+		if (num_msdu != total_msdu-1)  { /* Excpet for the last*/
+			/* pad new MSDU to start at 4 byte boundary*/
+			pad = (4 - ((unsigned long)skb_amsdu->tail & 0x3)) % 4;
+			if (skb_tailroom(skb_amsdu) < pad) {
+				pad = 0;
+				break;
+			}
+			memset(skb_put(skb_amsdu, pad), 0, pad);
+		}
+
+		/* Append to the Main SKB*/
+		memcpy(skb_put(skb, skb_amsdu->len), skb_amsdu->data,
+				skb_amsdu->len);
+		if (!skb_amsdu)
+			dev_kfree_skb(skb_amsdu);
+	}
+	/* The Qos Header changes based on this CTL FLAG*/
+	IEEE80211_SKB_CB(skb)->flags |= IEEE80211_TX_CTL_AMSDU;
+	ieee80211_tx_skb_tid(sdata, skb, tid);
+
+	return buflen;
+}
+__IEEE80211_IF_FILE_W(send_amsdu);
+
  static ssize_t ieee80211_if_fmt_uapsd_queues(
  	const struct ieee80211_sub_if_data *sdata, char *buf, int buflen)
  {
@@ -541,6 +797,7 @@ static void add_sta_files(struct 
ieee80211_sub_if_data *sdata)
  	DEBUGFS_ADD(ave_beacon);
  	DEBUGFS_ADD_MODE(smps, 0600);
  	DEBUGFS_ADD_MODE(tkip_mic_test, 0200);
+	DEBUGFS_ADD_MODE(send_amsdu, 0200);
  	DEBUGFS_ADD_MODE(uapsd_queues, 0600);
  	DEBUGFS_ADD_MODE(uapsd_max_sp_len, 0600);
  }
diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 0fa44a9..be07b6a 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -402,7 +402,6 @@ struct ieee80211_mgd_assoc_data {
  	bool have_beacon;
  	bool sent_assoc;
  	bool synced;
-
  	u8 ap_ht_param;

  	struct ieee80211_vht_cap ap_vht_cap;
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index e930175..9540215 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -2183,7 +2183,6 @@ static void ieee80211_destroy_assoc_data(struct 
ieee80211_sub_if_data *sdata,
  		sdata->u.mgd.flags = 0;
  		ieee80211_vif_release_channel(sdata);
  	}
-
  	kfree(assoc_data);
  	sdata->u.mgd.assoc_data = NULL;
  }
@@ -3905,6 +3904,7 @@ int ieee80211_mgd_assoc(struct 
ieee80211_sub_if_data *sdata,
  	assoc_data->supp_rates_len = bss->supp_rates_len;

  	rcu_read_lock();
+
  	ht_ie = ieee80211_bss_get_ie(req->bss, WLAN_EID_HT_OPERATION);
  	if (ht_ie && ht_ie[1] >= sizeof(struct ieee80211_ht_operation))
  		assoc_data->ap_ht_param =
diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index e9eadc4..0c42835 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -1144,7 +1144,6 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data 
*sdata,
  	info->flags &= ~IEEE80211_TX_INTFL_NEED_TXPROCESSING;

  	hdr = (struct ieee80211_hdr *) skb->data;
-
  	if (sdata->vif.type == NL80211_IFTYPE_AP_VLAN) {
  		tx->sta = rcu_dereference(sdata->u.vlan.sta);
  		if (!tx->sta && sdata->dev->ieee80211_ptr->use_4addr)
@@ -1327,7 +1326,7 @@ static int invoke_tx_handlers(struct 
ieee80211_tx_data *tx)
  #define CALL_TXH(txh) \
  	do {				\
  		res = txh(tx);		\
-		if (res != TX_CONTINUE)	\
+		if (res != TX_CONTINUE) \
  			goto txh_done;	\
  	} while (0)

@@ -1367,7 +1366,6 @@ static int invoke_tx_handlers(struct 
ieee80211_tx_data *tx)
  		I802_DEBUG_INC(tx->local->tx_handlers_queued);
  		return -1;
  	}
-
  	return 0;
  }

diff --git a/net/mac80211/wme.c b/net/mac80211/wme.c
index 906f00c..f444b5d 100644
--- a/net/mac80211/wme.c
+++ b/net/mac80211/wme.c
@@ -188,6 +188,11 @@ void ieee80211_set_qos_hdr(struct 
ieee80211_sub_if_data *sdata,
  		ack_policy |= IEEE80211_QOS_CTL_ACK_POLICY_NOACK;
  		info->flags |= IEEE80211_TX_CTL_NO_ACK;
  	}
+	/* Check for AMSDU Injection Tx*/
+	if (info->flags & IEEE80211_TX_CTL_AMSDU) {
+		ack_policy |= IEEE80211_QOS_CTL_A_MSDU_PRESENT;
+		info->flags |= IEEE80211_TX_CTL_DONTFRAG;
+	}

  	/* qos header is 2 bytes */
  	*p++ = ack_policy | tid;
