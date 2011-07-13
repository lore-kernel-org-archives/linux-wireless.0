Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:44984 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755008Ab1GMBfa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jul 2011 21:35:30 -0400
Subject: [PATCH 15/24] ath6kl: add ieee80211.h
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: devel@linuxdriverproject.org, gregkh@suse.de, error27@gmail.com
Date: Wed, 13 Jul 2011 04:35:24 +0300
Message-ID: <20110713013524.8517.92169.stgit@localhost6.localdomain6> (sfid-20110713_033533_941292_7CB29E9A)
In-Reply-To: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath6kl/ieee80211.h |  158 +++++++++++++++++++++++++++
 1 files changed, 158 insertions(+), 0 deletions(-)
 create mode 100644 drivers/net/wireless/ath/ath6kl/ieee80211.h

diff --git a/drivers/net/wireless/ath/ath6kl/ieee80211.h b/drivers/net/wireless/ath/ath6kl/ieee80211.h
new file mode 100644
index 0000000..1867ab2
--- /dev/null
+++ b/drivers/net/wireless/ath/ath6kl/ieee80211.h
@@ -0,0 +1,158 @@
+/*
+ * Copyright (c) 2011 Atheros Communications Inc.
+ *
+ * Permission to use, copy, modify, and/or distribute this software for any
+ * purpose with or without fee is hereby granted, provided that the above
+ * copyright notice and this permission notice appear in all copies.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
+ * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
+ * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
+ * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
+ * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
+ * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
+ * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
+ */
+
+#ifndef _ATH6KL_IEEE80211_H_
+#define _ATH6KL_IEEE80211_H_
+
+/*
+ * 802.11i defines an extended IV for use with non-WEP ciphers.
+ * When the EXTIV bit is set in the key id byte an additional
+ * 4 bytes immediately follow the IV for TKIP.  For CCMP the
+ * EXTIV bit is likewise set but the 8 bytes represent the
+ * CCMP header rather than IV+extended-IV.
+ */
+
+#define IEEE80211_KEYBUF_SIZE 16
+#define IEEE80211_MICBUF_SIZE (8+8)	/* space for both tx and rx */
+
+/*
+ * NB: these values are ordered carefully; there are lots of
+ * of implications in any reordering.  In particular beware
+ * that 4 is not used to avoid conflicting with IEEE80211_F_PRIVACY.
+ */
+#define IEEE80211_CIPHER_WEP            0
+#define IEEE80211_CIPHER_TKIP           1
+#define IEEE80211_CIPHER_AES_OCB        2
+#define IEEE80211_CIPHER_AES_CCM        3
+#define IEEE80211_CIPHER_CKIP           5
+#define IEEE80211_CIPHER_CCKM_KRK       6
+#define IEEE80211_CIPHER_NONE           7 /* pseudo value */
+
+/*
+ * 802.11 rate set.
+ */
+#define IEEE80211_RATE_MAXSIZE  15	/* max rates we'll handle */
+
+#define WMM_NUM_AC                  4	/* 4 AC categories */
+
+#define ATH_OUI_TYPE            0x01
+#define WPA_OUI_TYPE            0x01
+#define WMM_PARAM_OUI_SUBTYPE   0x01
+#define WMM_OUI_TYPE            0x02
+#define WSC_OUT_TYPE            0x04
+
+/* WMM stream classes */
+#define WMM_NUM_AC  4
+#define WMM_AC_BE   0		/* best effort */
+#define WMM_AC_BK   1		/* background */
+#define WMM_AC_VI   2		/* video */
+#define WMM_AC_VO   3		/* voice */
+
+enum tspec_status_code {
+	TSPEC_STS_ADMISS_ACCEPTED = 0,
+	TSPEC_STS_ADDTS_INVAL_PARAMS = 0x1,
+	TSPEC_STS_ADDTS_REQ_REFUSED = 0x3,
+	TSPEC_STS_UNSPEC_QOS_RELATED_FAILURE = 0xC8,
+	TSPEC_STS_REQ_REFUSED_POLICY_CONFIG = 0xC9,
+	TSPEC_STS_INSUFF_BANDWIDTH = 0xCA,
+	TSPEC_STS_INVAL_PARAMS = 0xCB,
+	TSPEC_STS_DELTS_SENT = 0x30,
+	TSPEC_STS_DELTS_RECV = 0x31,
+};
+
+#define TSPEC_TSID_MASK             0xF
+#define TSPEC_TSID_S                1
+
+/*
+ * WMM/802.11e Tspec Element
+ */
+struct wmm_tspec_ie {
+	u8 element_id;
+	u8 len;
+	u8 oui[3];
+	u8 oui_type;
+	u8 oui_subtype;
+	u8 version;
+	__le16 tsinfo;
+	u8 tsinfo_resvd;
+	__le16 nominal_msdu;
+	__le16 max_msdu;
+	__le32 min_service_int;
+	__le32 max_service_int;
+	__le32 inactivity_int;
+	__le32 suspension_int;
+	__le32 service_start_time;
+	__le32 min_data_rate;
+	__le32 mean_data_rate;
+	__le32 peak_data_rate;
+	__le32 max_burst_size;
+	__le32 delay_bound;
+	__le32 min_phy_rate;
+	__le16 sba;
+	__le16 medium_time;
+} __packed;
+
+/*
+ * WPA/RSN get/set key request.  Specify the key/cipher
+ * type and whether the key is to be used for sending and/or
+ * receiving.  The key index should be set only when working
+ * with global keys (use IEEE80211_KEYIX_NONE for ``no index'').
+ * Otherwise a unicast/pairwise key is specified by the bssid
+ * (on a station) or mac address (on an ap).  They key length
+ * must include any MIC key data; otherwise it should be no
+ * more than IEEE80211_KEYBUF_SIZE.
+ */
+struct ieee80211req_key {
+	u8 ik_type;	/* key/cipher type */
+	u8 ik_pad;
+	u16 ik_keyix;	/* key index */
+	u8 ik_keylen;	/* key length in bytes */
+	u8 ik_flags;
+#define IEEE80211_KEY_XMIT  0x01
+#define IEEE80211_KEY_RECV  0x02
+#define IEEE80211_KEY_DEFAULT   0x80	/* default xmit key */
+	u8 ik_macaddr[ETH_ALEN];
+	u64 ik_keyrsc;	/* key receive sequence counter */
+	u64 ik_keytsc;	/* key transmit sequence counter */
+	u8 ik_keydata[IEEE80211_KEYBUF_SIZE + IEEE80211_MICBUF_SIZE];
+};
+
+#define IEEE80211_NODE_HASHSIZE 32
+/* simple hash is enough for variation of macaddr */
+#define IEEE80211_NODE_HASH(addr)   \
+	(((const u8 *)(addr))[ETH_ALEN - 1] % \
+	 IEEE80211_NODE_HASHSIZE)
+
+/*
+ * Table of ieee80211_node instances.  Each ieee80211com
+ * has at least one for holding the scan candidates.
+ * When operating as an access point or in ibss mode there
+ * is a second table for associated stations or neighbors.
+ */
+struct ieee80211_node_table {
+	void *nt_wmi;		/* back reference */
+	spinlock_t nt_nodelock;	/* on node table */
+	struct bss *nt_node_first;	/* information of all nodes */
+	struct bss *nt_node_last;	/* information of all nodes */
+	struct bss *nt_hash[IEEE80211_NODE_HASHSIZE];
+	const char *nt_name;	/* for debugging */
+	u32 nt_node_age;		/* node aging time */
+};
+
+#define WLAN_NODE_INACT_TIMEOUT_MSEC    120000
+#define WLAN_NODE_INACT_CNT		4
+
+#endif /* _ATH6KL_IEEE80211_H_ */

