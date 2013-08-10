Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3809 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161017Ab3HJK2H (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Aug 2013 06:28:07 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 07/12] brcmfmac: add support for manual TDLS operations
Date: Sat, 10 Aug 2013 12:27:25 +0200
Message-ID: <1376130450-29746-8-git-send-email-arend@broadcom.com> (sfid-20130810_122826_698876_12FC1634)
In-Reply-To: <1376130450-29746-1-git-send-email-arend@broadcom.com>
References: <1376130450-29746-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Implement the .tdls_oper() callback and indicate TDLS support
in the wiphy flags.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/brcmfmac/fwil_types.h   | 21 ++++++++
 .../net/wireless/brcm80211/brcmfmac/wl_cfg80211.c  | 57 +++++++++++++++++++++-
 2 files changed, 77 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
index 665ef69..ecabb04 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
+++ b/drivers/net/wireless/brcm80211/brcmfmac/fwil_types.h
@@ -69,4 +69,25 @@ struct brcmf_fil_bss_enable_le {
 	__le32 enable;
 };
 
+/**
+ * struct tdls_iovar - common structure for tdls iovars.
+ *
+ * @ea: ether address of peer station.
+ * @mode: mode value depending on specific tdls iovar.
+ * @chanspec: channel specification.
+ * @pad: unused (for future use).
+ */
+struct brcmf_tdls_iovar_le {
+	u8 ea[ETH_ALEN];		/* Station address */
+	u8 mode;			/* mode: depends on iovar */
+	__le16 chanspec;
+	__le32 pad;			/* future */
+};
+
+enum brcmf_tdls_manual_ep_ops {
+	BRCMF_TDLS_MANUAL_EP_CREATE = 1,
+	BRCMF_TDLS_MANUAL_EP_DELETE = 3,
+	BRCMF_TDLS_MANUAL_EP_DISCOVERY = 6
+};
+
 #endif /* FWIL_TYPES_H_ */
diff --git a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
index c3dfea3..0370e44 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -4126,6 +4126,53 @@ static void brcmf_cfg80211_crit_proto_stop(struct wiphy *wiphy,
 	clear_bit(BRCMF_SCAN_STATUS_SUPPRESS, &cfg->scan_status);
 }
 
+static int brcmf_convert_nl80211_tdls_oper(enum nl80211_tdls_operation oper)
+{
+	int ret;
+
+	switch (oper) {
+	case NL80211_TDLS_DISCOVERY_REQ:
+		ret = BRCMF_TDLS_MANUAL_EP_DISCOVERY;
+		break;
+	case NL80211_TDLS_SETUP:
+		ret = BRCMF_TDLS_MANUAL_EP_CREATE;
+		break;
+	case NL80211_TDLS_TEARDOWN:
+		ret = BRCMF_TDLS_MANUAL_EP_DELETE;
+		break;
+	default:
+		brcmf_err("unsupported operation: %d\n", oper);
+		ret = -EOPNOTSUPP;
+	}
+	return ret;
+}
+
+static int brcmf_cfg80211_tdls_oper(struct wiphy *wiphy,
+				    struct net_device *ndev, u8 *peer,
+				    enum nl80211_tdls_operation oper)
+{
+	struct brcmf_if *ifp;
+	struct brcmf_tdls_iovar_le info;
+	int ret = 0;
+
+	ret = brcmf_convert_nl80211_tdls_oper(oper);
+	if (ret < 0)
+		return ret;
+
+	ifp = netdev_priv(ndev);
+	memset(&info, 0, sizeof(info));
+	info.mode = (u8)ret;
+	if (peer)
+		memcpy(info.ea, peer, ETH_ALEN);
+
+	ret = brcmf_fil_iovar_data_set(ifp, "tdls_endpoint",
+				       &info, sizeof(info));
+	if (ret < 0)
+		brcmf_err("tdls_endpoint iovar failed: ret=%d\n", ret);
+
+	return ret;
+}
+
 static struct cfg80211_ops wl_cfg80211_ops = {
 	.add_virtual_intf = brcmf_cfg80211_add_iface,
 	.del_virtual_intf = brcmf_cfg80211_del_iface,
@@ -4164,6 +4211,7 @@ static struct cfg80211_ops wl_cfg80211_ops = {
 	.stop_p2p_device = brcmf_p2p_stop_device,
 	.crit_proto_start = brcmf_cfg80211_crit_proto_start,
 	.crit_proto_stop = brcmf_cfg80211_crit_proto_stop,
+	.tdls_oper = brcmf_cfg80211_tdls_oper,
 	CFG80211_TESTMODE_CMD(brcmf_cfg80211_testmode)
 };
 
@@ -4285,7 +4333,8 @@ static struct wiphy *brcmf_setup_wiphy(struct device *phydev)
 	wiphy->n_cipher_suites = ARRAY_SIZE(__wl_cipher_suites);
 	wiphy->flags |= WIPHY_FLAG_PS_ON_BY_DEFAULT |
 			WIPHY_FLAG_OFFCHAN_TX |
-			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL;
+			WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
+			WIPHY_FLAG_SUPPORTS_TDLS;
 	wiphy->mgmt_stypes = brcmf_txrx_stypes;
 	wiphy->max_remain_on_channel_duration = 5000;
 	brcmf_wiphy_pno_params(wiphy);
@@ -4906,6 +4955,12 @@ struct brcmf_cfg80211_info *brcmf_cfg80211_attach(struct brcmf_pub *drvr,
 		goto cfg80211_p2p_attach_out;
 	}
 
+	err = brcmf_fil_iovar_int_set(ifp, "tdls_enable", 1);
+	if (err) {
+		brcmf_dbg(INFO, "TDLS not enabled (%d)\n", err);
+		wiphy->flags &= ~WIPHY_FLAG_SUPPORTS_TDLS;
+	}
+
 	err = brcmf_fil_cmd_int_get(ifp, BRCMF_C_GET_VERSION,
 				    &io_type);
 	if (err) {
-- 
1.8.1.3


