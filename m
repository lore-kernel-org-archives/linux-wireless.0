Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from diserzione.investici.org ([82.221.99.153]:63209 "EHLO
	diserzione.investici.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966354Ab3HHXNI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Aug 2013 19:13:08 -0400
From: Antonio Quartulli <ordex@autistici.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Antonio Quartulli <antonio@open-mesh.com>
Subject: [PATCH] cfg/nl80211: send CMD_INTERFACE event on NETDEV_UNREGISTER
Date: Fri,  9 Aug 2013 01:12:53 +0200
Message-Id: <1376003573-1243-1-git-send-email-ordex@autistici.org> (sfid-20130809_011313_048601_4301E1F4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Antonio Quartulli <antonio@open-mesh.com>

Userspace applications may be listening for events (e.g.
matching mgmt frame) on a given interface. If such interface
is deleted they would keep hanging because no event will be
delivered anymore.

Send a CMD_INTERFACE event on NETDEV_UNREGISTER to notify
userspace that the interface does not exist anymore.

Signed-off-by: Antonio Quartulli <antonio@open-mesh.com>
---
 net/wireless/Module.symvers | 118 ++++++++++++++++++++++++++++++++++++++++++++
 net/wireless/core.c         |   2 +
 net/wireless/nl80211.c      |  31 ++++++++++++
 net/wireless/nl80211.h      |   3 ++
 4 files changed, 154 insertions(+)
 create mode 100644 net/wireless/Module.symvers

diff --git a/net/wireless/Module.symvers b/net/wireless/Module.symvers
new file mode 100644
index 0000000..a5a553e
--- /dev/null
+++ b/net/wireless/Module.symvers
@@ -0,0 +1,118 @@
+0xdbdf43bc	cfg80211_send_rx_assoc	net/wireless/cfg80211	EXPORT_SYMBOL
+0xaf87fb7b	cfg80211_wext_siwscan	net/wireless/cfg80211	EXPORT_SYMBOL_GPL
+0x265d8ee4	cfg80211_wext_giwscan	net/wireless/cfg80211	EXPORT_SYMBOL_GPL
+0x38b8991e	cfg80211_ch_switch_notify	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x9d488fc0	cfg80211_notify_new_peer_candidate	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x19e03378	cfg80211_get_p2p_attr	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x082e7b4f	cfg80211_wext_siwrts	net/wireless/cfg80211	EXPORT_SYMBOL_GPL
+0x41424204	cfg80211_wext_giwrts	net/wireless/cfg80211	EXPORT_SYMBOL_GPL
+0xc60b8679	ieee80211_data_from_8023	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xa6ec8f1a	cfg80211_sched_scan_results	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x5cd60887	ieee80211_get_hdrlen_from_skb	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x90e3fd5f	cfg80211_chandef_usable	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x7ef39823	ieee80211_hdrlen	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x7269516e	cfg80211_unlink_bss	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xa1425906	ieee80211_channel_to_frequency	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x1bbbbe3d	cfg80211_put_bss	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x2d0f99e5	print_ssid	net/wireless/lib80211	EXPORT_SYMBOL
+0x1210f5a4	cfg80211_wext_giwretry	net/wireless/cfg80211	EXPORT_SYMBOL_GPL
+0x23788f04	cfg80211_remain_on_channel_expired	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x2dbaca91	lib80211_register_crypto_ops	net/wireless/lib80211	EXPORT_SYMBOL
+0x7fe1a403	cfg80211_find_ie	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x415fccb2	cfg80211_tx_mlme_mgmt	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x21313351	cfg80211_rx_mlme_mgmt	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x019824c5	cfg80211_cqm_txe_notify	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x739212bb	lib80211_crypt_info_free	net/wireless/lib80211	EXPORT_SYMBOL
+0x09c64fbd	ieee80211_frequency_to_channel	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x36840579	cfg80211_ref_bss	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x4d206e0d	lib80211_crypt_info_init	net/wireless/lib80211	EXPORT_SYMBOL
+0x2cdb3e94	cfg80211_wext_siwfrag	net/wireless/cfg80211	EXPORT_SYMBOL_GPL
+0xcd9ccab5	cfg80211_wext_giwfrag	net/wireless/cfg80211	EXPORT_SYMBOL_GPL
+0x60dc3c86	cfg80211_conn_failed	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xbc55da77	cfg80211_rx_spurious_frame	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xe3167eca	ieee80211_mandatory_rates	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xfed4d591	cfg80211_find_vendor_ie	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x8a0718ed	cfg80211_crit_proto_stopped	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x791666c2	cfg80211_ready_on_channel	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x9efe8fd7	lib80211_unregister_crypto_ops	net/wireless/lib80211	EXPORT_SYMBOL
+0x16d11cd3	cfg80211_classify8021d	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x31bef516	cfg80211_cac_event	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x61b0b2ab	wiphy_register	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xd9076365	cfg80211_cqm_rssi_notify	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x571a7306	wiphy_rfkill_set_hw_state	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xa63bce9a	cfg80211_connect_result	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xfccb88dd	cfg80211_roamed	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x2a71a173	cfg80211_check_station_change	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xad0c2d5c	cfg80211_assoc_timeout	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x66485480	wiphy_free	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x284cbccf	cfg80211_rx_mgmt	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x982e6b6d	ieee80211_radiotap_iterator_init	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x001501f0	cfg80211_ibss_joined	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x7fbadd74	cfg80211_send_disassoc	net/wireless/cfg80211	EXPORT_SYMBOL
+0x45cd2a29	cfg80211_tdls_oper_request	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xc15c8611	cfg80211_chandef_create	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x6eb977c9	cfg80211_send_deauth	net/wireless/cfg80211	EXPORT_SYMBOL
+0xc849536e	cfg80211_roamed_bss	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x9832a501	wiphy_rfkill_stop_polling	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x1b383ef0	cfg80211_testmode_event	net/wireless/cfg80211	EXPORT_SYMBOL
+0x50641d9e	cfg80211_del_sta	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x4c3b5878	ieee80211_get_response_rate	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x820ce81d	cfg80211_cqm_pktloss_notify	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x8d27445a	cfg80211_ibss_sta	net/wireless/cfg80211	EXPORT_SYMBOL
+0xb57a24df	cfg80211_sched_scan_stopped	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x52a73bc0	cfg80211_get_bss	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x6cec0a2f	cfg80211_gtk_rekey_notify	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xc288a696	cfg80211_probe_status	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xee42db3c	cfg80211_chandef_compatible	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xcf618a57	cfg80211_calculate_bitrate	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x204e246e	cfg80211_send_unprot_disassoc	net/wireless/cfg80211	EXPORT_SYMBOL
+0x4e62865c	cfg80211_get_mesh	net/wireless/cfg80211	EXPORT_SYMBOL
+0x63650102	cfg80211_testmode_alloc_event_skb	net/wireless/cfg80211	EXPORT_SYMBOL
+0xea7be2e1	cfg80211_testmode_alloc_reply_skb	net/wireless/cfg80211	EXPORT_SYMBOL
+0xe70700d0	cfg80211_can_beacon_sec_chan	net/wireless/cfg80211	EXPORT_SYMBOL
+0x42d38a77	ieee80211_amsdu_to_8023s	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xcd93fd1a	cfg80211_new_sta	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x1879fcbd	bridge_tunnel_header	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xe681668b	wiphy_unregister	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xd45ebd75	cfg80211_send_assoc_timeout	net/wireless/cfg80211	EXPORT_SYMBOL
+0x0e6e34e9	__cfg80211_send_disassoc	net/wireless/cfg80211	EXPORT_SYMBOL
+0x7883ce71	cfg80211_auth_timeout	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x31298721	cfg80211_inform_bss_frame	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x40e6c9cc	__ieee80211_get_channel	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x6d7e6008	cfg80211_send_rx_auth	net/wireless/cfg80211	EXPORT_SYMBOL
+0x09fea8c4	cfg80211_disconnected	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x0c4b05f6	cfg80211_ft_event	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x0ea7420f	cfg80211_unregister_wdev	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xf236d7e9	cfg80211_report_obss_beacon	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xe7413011	cfg80211_scan_done	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xfc0943bb	cfg80211_radar_event	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x61bde271	cfg80211_rx_unprot_mlme_mgmt	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x406a8302	cfg80211_chandef_valid	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x6d6cb9ad	ieee80211_operating_class_to_band	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xb274f591	__cfg80211_send_deauth	net/wireless/cfg80211	EXPORT_SYMBOL
+0x69b18f43	rfc1042_header	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x72e8e699	cfg80211_wext_giwrange	net/wireless/cfg80211	EXPORT_SYMBOL_GPL
+0xfa6f9e08	cfg80211_pmksa_candidate_notify	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xa197b1ff	ieee80211_get_mesh_hdrlen	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xf07a40f4	lib80211_get_crypto_ops	net/wireless/lib80211	EXPORT_SYMBOL
+0x7f41d59b	cfg80211_mgmt_tx_status	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x08758a2e	freq_reg_info	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x7e07d929	cfg80211_testmode_reply	net/wireless/cfg80211	EXPORT_SYMBOL
+0xc63f1b81	ieee80211_radiotap_iterator_next	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xfd8576ae	wiphy_new	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x92c0c538	ieee80211_bss_get_ie	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xcb490c18	cfg80211_send_unprot_deauth	net/wireless/cfg80211	EXPORT_SYMBOL
+0xb368893f	cfg80211_inform_bss	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x5229b0bc	ieee80211_data_to_8023	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x63066fb0	cfg80211_wext_giwname	net/wireless/cfg80211	EXPORT_SYMBOL_GPL
+0xfb598113	cfg80211_wext_siwmode	net/wireless/cfg80211	EXPORT_SYMBOL_GPL
+0x73067d35	cfg80211_wext_giwmode	net/wireless/cfg80211	EXPORT_SYMBOL_GPL
+0x8f0272b8	cfg80211_send_auth_timeout	net/wireless/cfg80211	EXPORT_SYMBOL
+0xc4439a18	wiphy_rfkill_start_polling	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x70648cd8	regulatory_hint	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xfb4ed400	wiphy_apply_custom_regulatory	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x2270c84d	cfg80211_rx_assoc_resp	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xc3bf9629	cfg80211_rx_unexpected_4addr_frame	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x35066dc8	cfg80211_michael_mic_failure	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0xbcceeb1e	cfg80211_reg_can_beacon	/home/ordex/exp/mac80211/net/wireless/cfg80211	EXPORT_SYMBOL
+0x4209768c	lib80211_crypt_delayed_deinit	net/wireless/lib80211	EXPORT_SYMBOL
diff --git a/net/wireless/core.c b/net/wireless/core.c
index 389a3f2..ae4c148 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -913,6 +913,8 @@ static int cfg80211_netdev_notifier_call(struct notifier_block *nb,
 			}
 		break;
 	case NETDEV_UNREGISTER:
+		nl80211_send_del_iface(rdev, dev, GFP_KERNEL);
+
 		/*
 		 * It is possible to get NETDEV_UNREGISTER
 		 * multiple times. To detect that, check
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index f7cb121..61be4ea 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -10022,6 +10022,37 @@ void nl80211_send_disconnected(struct cfg80211_registered_device *rdev,
 
 }
 
+void nl80211_send_del_iface(struct cfg80211_registered_device *rdev,
+			    struct net_device *netdev, gfp_t gfp)
+{
+	struct sk_buff *msg;
+	void *hdr;
+
+	msg = nlmsg_new(NLMSG_DEFAULT_SIZE, gfp);
+	if (!msg)
+		return;
+
+	hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_DEL_INTERFACE);
+	if (!hdr) {
+		nlmsg_free(msg);
+		return;
+	}
+
+	if (nla_put_u32(msg, NL80211_ATTR_WIPHY, rdev->wiphy_idx) ||
+	    nla_put_u32(msg, NL80211_ATTR_IFINDEX, netdev->ifindex))
+		goto nla_put_failure;
+
+	genlmsg_end(msg, hdr);
+
+	genlmsg_multicast_netns(wiphy_net(&rdev->wiphy), msg, 0,
+				nl80211_mlme_mcgrp.id, gfp);
+	return;
+
+ nla_put_failure:
+	genlmsg_cancel(msg, hdr);
+	nlmsg_free(msg);
+}
+
 void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 			     struct net_device *netdev, const u8 *bssid,
 			     gfp_t gfp)
diff --git a/net/wireless/nl80211.h b/net/wireless/nl80211.h
index 44341bf..6071557 100644
--- a/net/wireless/nl80211.h
+++ b/net/wireless/nl80211.h
@@ -59,6 +59,9 @@ nl80211_send_beacon_hint_event(struct wiphy *wiphy,
 			       struct ieee80211_channel *channel_before,
 			       struct ieee80211_channel *channel_after);
 
+void nl80211_send_del_iface(struct cfg80211_registered_device *rdev,
+			    struct net_device *netdev, gfp_t gfp);
+
 void nl80211_send_ibss_bssid(struct cfg80211_registered_device *rdev,
 			     struct net_device *netdev, const u8 *bssid,
 			     gfp_t gfp);
-- 
1.8.1.5

