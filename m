Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49820 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab0LBAYC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 19:24:02 -0500
Received: by qwb7 with SMTP id 7so7717142qwb.19
        for <linux-wireless@vger.kernel.org>; Wed, 01 Dec 2010 16:24:02 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20101201210226.159495600@sipsolutions.net>
References: <20101201205939.009530439@sipsolutions.net> <20101201210226.159495600@sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Wed, 1 Dec 2010 16:23:41 -0800
Message-ID: <AANLkTin==aJjY4Sctu1+g7bitDsd6S14SKRymrNW_WLy@mail.gmail.com>
Subject: Re: [RFC 5/5] cfg80211/mac80211: add mesh join/leave commands
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Steve Derosier <steve@cozybit.com>,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wow, Johannes!

On Wed, Dec 1, 2010 at 12:59 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> Instead of tying mesh activity to interface up,
> add join and leave commands for mesh. Since we
> must be backward compatible, let cfg80211 handle
> joining a mesh if a mesh ID was pre-configured
> when the device goes up.
>
> Note that this therefore must modify mac80211 as
> well since mac80211 needs to lose the logic to
> start the mesh on interface up.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Pretty impressive.  Comments below

+static int nl80211_join_mesh(struct sk_buff *skb, struct genl_info *info)
+{
+       struct cfg80211_registered_device *rdev = info->user_ptr[0];
+       struct net_device *dev = info->user_ptr[1];
+       struct mesh_config cfg;
+       int err;
+
+       /* start with default */
+       memcpy(&cfg, &default_mesh_config, sizeof(cfg));
+
+       /* and parse other given info */
+       err = nl80211_parse_mesh_params(info, &cfg, NULL);
+       if (err)
+               return err;

Only the mesh id should be mandatory for starting the mesh, and none
of the other mesh parameters.  Therefore I would change the above to:

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 75c501f..300835d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4527,9 +4527,11 @@ static int nl80211_join_mesh(struct sk_buff
*skb, struct genl_info *info)
        memcpy(&cfg, &default_mesh_config, sizeof(cfg));

        /* and parse other given info */
-       err = nl80211_parse_mesh_params(info, &cfg, NULL);
-       if (err)
-               return err;
+       if (info->attrs[NL80211_ATTR_MESH_PARAMS]) {
+               err = nl80211_parse_mesh_params(info, &cfg, NULL);
+               if (err)
+                       return err;
+       }

        if (!info->attrs[NL80211_ATTR_MESH_ID] ||
            !nla_len(info->attrs[NL80211_ATTR_MESH_ID]))

@@ -775,20 +779,26 @@ static int cfg80211_netdev_notifier_call
               }
               cfg80211_lock_rdev(rdev);
               mutex_lock(&rdev->devlist_mtx);
-#ifdef CONFIG_CFG80211_WEXT
               wdev_lock(wdev);
               switch (wdev->iftype) {
+#ifdef CONFIG_CFG80211_WEXT
               case NL80211_IFTYPE_ADHOC:
                       cfg80211_ibss_wext_join(rdev, wdev);
                       break;
               case NL80211_IFTYPE_STATION:
                       cfg80211_mgd_wext_connect(rdev, wdev);
                       break;
+#endif
+               case NL80211_IFTYPE_MESH_POINT:
+                       /* backward compat code ... */
+                       if (wdev->ssid_len)
+                               __cfg80211_join_mesh(rdev, dev, wdev->ssid,
+                                                    wdev->ssid_len, NULL);
+

This doesn't quite work:  when mesh interfaces are created with a mesh
id you set wdev->ssid_len.
Later, when the interface is brought up, the mesh won't start because
of the last check below:

+int __cfg80211_join_mesh(struct cfg80211_registered_device *rdev,
+                        struct net_device *dev,
+                        const u8 *mesh_id, size_t mesh_id_len,
+                        const struct mesh_config *conf)
+{
+       struct wireless_dev *wdev = dev->ieee80211_ptr;
+       int err;
+
+       BUILD_BUG_ON(IEEE80211_MAX_SSID_LEN != IEEE80211_MAX_MESH_ID_LEN);
+
+       ASSERT_WDEV_LOCK(wdev);
+
+       if (dev->ieee80211_ptr->iftype != NL80211_IFTYPE_MESH_POINT)
+               return -EOPNOTSUPP;
+
+       if (wdev->ssid_len)       <<<<<<
+               return -EALREADY;

If you want to keep working on this we'll be happy to test it again,
or if you want we can take it from here and finish this.
Let me know.

Regarding...

> I just noticed that this will lose mesh parameters when you leave the
> mesh, unlike previously where they would be kept.

...I don't think there's an issue.  I'll ask around.

Cheers,

Javier

-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
