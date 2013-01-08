Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2075 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab3AHJRw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Jan 2013 04:17:52 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Arend van Spriel" <arend@broadcom.com>, "Jouni Malinen" <j@w1.fi>,
	"Greg Goldman" <ggoldman@broadcom.com>,
	"Jithu Jance" <jithu@broadcom.com>
Subject: [PATCH] nl80211: allow user-space to determine address for
 P2P_DEVICE
Date: Tue, 8 Jan 2013 10:17:27 +0100
Message-ID: <1357636648-4012-1-git-send-email-arend@broadcom.com> (sfid-20130108_101757_557658_8AA0FFF6)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

As per email discussion Jouni Malinen pointed out that:

"P2P message exchanges can be executed on the current operating channel
of any operation (both P2P and non-P2P station). These can be on 5 GHz
and even on 60 GHz (so yes, you _can_ do GO Negotiation on 60 GHz).

As an example, it would be possible to receive a GO Negotiation Request
frame on a 5 GHz only radio and then to complete GO Negotiation on that
band. This can happen both when connected to a P2P group (through client
discoverability mechanism) and when connected to a legacy AP (assuming
the station receive Probe Request frame from full scan in the beginning
of P2P device discovery)."

This means that P2P messages can be sent over different radio devices.
However, these should use the same P2P device address so it should be
able to provision this from user-space. This patch adds a parameter for
this to struct vif_params which should only be used during creation of
the P2P device interface.

Cc: Jouni Malinen <j@w1.fi>
Cc: Greg Goldman <ggoldman@broadcom.com>
Cc: Jithu Jance <jithu@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
Hi Johannes,

Best wishes. Found this patch catching dust on my shelf/branch. Cleaning
up in 2013 so here you have it :-)

Regards,
Arend
---
 include/net/cfg80211.h |    4 ++++
 net/wireless/nl80211.c |    4 ++++
 2 files changed, 8 insertions(+)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index e5f085c..f9e4833 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -281,9 +281,13 @@ struct ieee80211_supported_band {
 /**
  * struct vif_params - describes virtual interface parameters
  * @use_4addr: use 4-address frames
+ * @macaddr: address to use for this virtual interface. This will only
+ * 	be used for non-netdevice interfaces. If this parameter is set
+ * 	to zero address the driver may determine the address as needed.
  */
 struct vif_params {
        int use_4addr;
+       u8 macaddr[ETH_ALEN];
 };
 
 /**
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 9bd8340..42858eb 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2079,6 +2079,10 @@ static int nl80211_new_interface(struct sk_buff *skb, struct genl_info *info)
 	    !(rdev->wiphy.interface_modes & (1 << type)))
 		return -EOPNOTSUPP;
 
+	if (type == NL80211_IFTYPE_P2P_DEVICE && info->attrs[NL80211_ATTR_MAC])
+		nla_memcpy(&params.macaddr[0], info->attrs[NL80211_ATTR_MAC],
+			   ETH_ALEN);
+
 	if (info->attrs[NL80211_ATTR_4ADDR]) {
 		params.use_4addr = !!nla_get_u8(info->attrs[NL80211_ATTR_4ADDR]);
 		err = nl80211_valid_4addr(rdev, NULL, params.use_4addr, type);
-- 
1.7.10.4


