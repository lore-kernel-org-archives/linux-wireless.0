Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:63306 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754532Ab2DXNQw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 09:16:52 -0400
From: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>
To: linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: [RFCv2 4/6] mac80211: softamp: Handle assoc request
Date: Tue, 24 Apr 2012 16:17:38 +0300
Message-Id: <1335273460-12682-5-git-send-email-Andrei.Emeltchenko.news@gmail.com> (sfid-20120424_151656_805125_63BCA33F)
In-Reply-To: <1335273460-12682-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
References: <1335273460-12682-1-git-send-email-Andrei.Emeltchenko.news@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Andrei Emeltchenko <andrei.emeltchenko@intel.com>

Handle AMP assoc request.

Signed-off-by: Andrei Emeltchenko <andrei.emeltchenko@intel.com>
---
 net/mac80211/virtual_amp.c |  138 ++++++++++++++++++++++++++++++++++++++++++++
 net/mac80211/virtual_amp.h |   20 +++++++
 2 files changed, 158 insertions(+)

diff --git a/net/mac80211/virtual_amp.c b/net/mac80211/virtual_amp.c
index 3c81fda..19e5530 100644
--- a/net/mac80211/virtual_amp.c
+++ b/net/mac80211/virtual_amp.c
@@ -179,6 +179,140 @@ static void vamp_cmd_read_local_amp_info(struct vamp_data *data,
 	hci_send_evt_cmplt(hdev, HCI_OP_READ_LOCAL_AMP_INFO, sizeof(rp), &rp);
 }
 
+/* Add Type-Length-Value to buffer */
+static u16 tlv_add(u8 *msg, u8 type, u16 len, u8 *val)
+{
+	struct tlv *tlvmsg = (struct tlv *) msg;
+
+	tlvmsg->type = type;
+	tlvmsg->len = cpu_to_le16(len);
+
+	memcpy(tlvmsg->val, val, len);
+
+	return len + sizeof(*tlvmsg);
+}
+
+static void vamp_cmd_read_local_amp_assoc(struct vamp_data *data,
+					  struct sk_buff *skb)
+{
+	struct hci_dev *hdev = data->hdev;
+	struct ieee80211_sub_if_data *sdata = data->sdata;
+	struct hci_cp_read_local_amp_assoc *cp = (void *) skb->data;
+	struct hci_rp_read_local_amp_assoc *rp;
+	struct softamp_pref_chans pref_chans = {
+		.country_code = { 'X', 'X', 'X' }
+	};
+	enum ieee80211_band band;
+	int buf_len = 0, triplet_size;
+	u8 num_triplet = 0;
+
+	char buf[670];
+	char mac[ETH_ALEN];
+
+	char pal_cap[] = { 0x00, 0x00, 0x00, 0x00 };
+	char pal_ver[] = {
+		0x01 /*PAL version*/,
+		0x00, 0x01 /* PAL company ID*/,
+		0x00, 0x01 /* PAL sub version */
+	};
+
+	BT_DBG("%s", hdev->name);
+
+	memcpy(mac, sdata->vif.addr, ETH_ALEN);
+
+	/* Add wireless MAC address */
+	buf_len += tlv_add(buf, SOFTAMP_MAC_ADDR_TYPE, sizeof(mac), mac);
+
+	/* Add PAL capacities */
+	buf_len += tlv_add(buf + buf_len, SOFTAMP_PAL_CAP_TYPE,
+			   sizeof(pal_cap), pal_cap);
+
+	/* Add PAL version info */
+	buf_len += tlv_add(buf + buf_len, SOFTAMP_PAL_VER_INFO,
+			   sizeof(pal_ver), pal_ver);
+
+	/* Add Preffered Channel list */
+	for (band = 0; band < IEEE80211_NUM_BANDS; band++) {
+		struct ieee80211_supported_band *sband;
+		struct ieee80211_country_ie_triplet *t;
+		u8 flag = 0, first_chan = 0, prev_chan = 0, max_power = 0;
+		u8 j, chan_num = 0, num_parsed_chans = 0;
+
+		sband = sdata->wdev.wiphy->bands[band];
+
+		for (j = 0; j < sband->n_channels; j++) {
+			struct ieee80211_channel *ch = &sband->channels[j];
+
+			if (ch->flags & IEEE80211_CHAN_DISABLED)
+				continue;
+
+			chan_num = ieee80211_frequency_to_channel(
+					ch->center_freq);
+
+			if (!flag) {
+				/* First channel in a range */
+				flag = 1;
+				first_chan = chan_num;
+				prev_chan = first_chan;
+				max_power = ch->max_power;
+				num_parsed_chans = 1;
+
+				continue;
+			}
+
+			if (chan_num == prev_chan + 1 &&
+			    ch->max_power == max_power) {
+				prev_chan++;
+				num_parsed_chans++;
+			} else {
+				/* Add channel previous triplet*/
+				t = &pref_chans.triplets[num_triplet];
+
+				t->chans.first_channel = first_chan;
+				t->chans.num_channels = num_parsed_chans;
+				t->chans.max_power = max_power;
+				num_triplet++;
+
+				first_chan = chan_num;
+				prev_chan = first_chan;
+				max_power = ch->max_power;
+				num_parsed_chans = 1;
+			}
+		}
+
+		/* Add whole range */
+		if (flag && num_parsed_chans != 1) {
+			t = &pref_chans.triplets[num_triplet];
+
+			t->chans.first_channel = first_chan;
+			t->chans.num_channels = num_parsed_chans;
+			t->chans.max_power = max_power;
+			num_triplet++;
+		}
+	}
+
+	triplet_size = num_triplet *
+		sizeof(struct ieee80211_country_ie_triplet) +
+		IEEE80211_COUNTRY_STRING_LEN;
+
+	buf_len += tlv_add(buf + buf_len, SOFTAMP_PREF_CHANLIST_TYPE,
+			   triplet_size, (u8 *) &pref_chans);
+
+	rp = kzalloc(sizeof(*rp) + buf_len, GFP_KERNEL);
+	if (!rp)
+		return;
+
+	rp->status = 0;
+	rp->handle = cp->handle;
+	rp->rem_len = cpu_to_le16(buf_len);
+
+	memcpy(rp->frag, buf, buf_len);
+	hci_send_evt_cmplt(hdev, HCI_OP_READ_LOCAL_AMP_ASSOC,
+			   buf_len + sizeof(*rp), rp);
+
+	kfree(rp);
+}
+
 static void vamp_cmd_reset(struct vamp_data *data, struct sk_buff *skb)
 {
 	struct hci_dev *hdev = data->hdev;
@@ -215,6 +349,10 @@ static void vamp_command_packet(struct vamp_data *data, struct sk_buff *skb)
 		vamp_cmd_read_local_amp_info(data, skb);
 		break;
 
+	case HCI_OP_READ_LOCAL_AMP_ASSOC:
+		vamp_cmd_read_local_amp_assoc(data, skb);
+		break;
+
 	case HCI_OP_RESET:
 		vamp_cmd_reset(data, skb);
 		break;
diff --git a/net/mac80211/virtual_amp.h b/net/mac80211/virtual_amp.h
index e45f58b..3717530 100644
--- a/net/mac80211/virtual_amp.h
+++ b/net/mac80211/virtual_amp.h
@@ -14,6 +14,26 @@
 
 #ifdef CONFIG_MAC80211_BLUETOOTH_SOFTAMP
 
+#define SOFTAMP_MAC_ADDR_TYPE		1
+#define SOFTAMP_PREF_CHANLIST_TYPE	2
+#define SOFTAMP_CONNECTED_CHAN		3
+#define SOFTAMP_PAL_CAP_TYPE		4
+#define SOFTAMP_PAL_VER_INFO		5
+
+/* Data types related to ASSOC data */
+struct tlv {
+	__u8 type;
+	__u16 len;
+	__u8 val[0];
+} __packed;
+
+#define MAX_11D_TRIPLETS        83
+
+struct softamp_pref_chans {
+	__u8 country_code[IEEE80211_COUNTRY_STRING_LEN];
+	struct ieee80211_country_ie_triplet triplets[MAX_11D_TRIPLETS];
+} __packed;
+
 void ieee80211_vamp_setup_sdata(struct ieee80211_sub_if_data *sdata);
 void ieee80211_vamp_clean_sdata(struct ieee80211_sub_if_data *sdata);
 
-- 
1.7.9.5

