Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:35844 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756462AbZFLRlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Jun 2009 13:41:52 -0400
Received: by ewy6 with SMTP id 6so3185819ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 12 Jun 2009 10:41:53 -0700 (PDT)
Message-ID: <4A280237.2040807@gmail.com>
Date: Thu, 04 Jun 2009 18:19:51 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Samuel Ortiz <samuel@sortiz.org>
Subject: Re: [PATCH] cfg80211: pass netdev to change_virtual_intf
References: <1244574283.18481.29.camel@johannes.local>
In-Reply-To: <1244574283.18481.29.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> If there was a reason I'm passing the ifidx I cannot
> remember it any more and don't see one now, so let's
> just pass the pointer itself.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
>  drivers/net/wireless/iwmc3200wifi/cfg80211.c |    9 ++-------
>  include/net/cfg80211.h                       |    3 ++-
>  net/mac80211/cfg.c                           |    9 ++-------
>  net/wireless/nl80211.c                       |   12 +++++-------
>  net/wireless/wext-compat.c                   |    2 +-
>  5 files changed, 12 insertions(+), 23 deletions(-)

rndis_wlan.c will need an update for this as well


Dave.
---
diff --git a/drivers/net/wireless/rndis_wlan.c b/drivers/net/wireless/rndis_wlan.c
index c254fdf..230962e 100644
--- a/drivers/net/wireless/rndis_wlan.c
+++ b/drivers/net/wireless/rndis_wlan.c
@@ -420,7 +420,8 @@ struct rndis_wext_private {
 /*
  * cfg80211 ops
  */
-static int rndis_change_virtual_intf(struct wiphy *wiphy, int ifindex,
+static int rndis_change_virtual_intf(struct wiphy *wiphy,
+                                       struct net_device *dev,
                                        enum nl80211_iftype type, u32 *flags,
                                        struct vif_params *params);

@@ -1222,20 +1223,14 @@ static void set_multicast_list(struct usbnet *usbdev)
 /*
  * cfg80211 ops
  */
-static int rndis_change_virtual_intf(struct wiphy *wiphy, int ifindex,
+static int rndis_change_virtual_intf(struct wiphy *wiphy,
+                                       struct net_device *dev,
                                        enum nl80211_iftype type, u32 *flags,
                                        struct vif_params *params)
 {
-       struct net_device *dev;
-       struct usbnet *usbdev;
+       struct usbnet *usbdev = netdev_priv(dev);
        int mode;

-       /* we're under RTNL */
-       dev = __dev_get_by_index(&init_net, ifindex);
-       if (!dev)
-               return -ENODEV;
-       usbdev = netdev_priv(dev);
-
        switch (type) {
        case NL80211_IFTYPE_ADHOC:
                mode = ndis_80211_infra_adhoc;



