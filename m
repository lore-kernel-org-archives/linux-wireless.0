Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:38507 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933948AbXC0CSH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2007 22:18:07 -0400
Subject: Re: [PATCH 2/5] mac80211: fix iwlist wlanX retry behavior
From: Hong Liu <hong.liu@intel.com>
To: Jiri Benc <jbenc@suse.cz>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20070323191145.2b4475d6@griffin.suse.cz>
References: <1174015699.3408.43.camel@devlinux-hong>
	 <20070323191145.2b4475d6@griffin.suse.cz>
Content-Type: text/plain
Date: Tue, 27 Mar 2007 10:07:20 +0800
Message-Id: <1174961240.3664.18.camel@napa-sdv1>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

iwconfig relies on what mac80211 returned to display the retry info when
it sets retry->flag = 0.
So we can't just return -EINVAL when retry->flag == 0.


Signed-off-by: Hong Liu <hong.liu@intel.com>

---

 net/mac80211/ieee80211_ioctl.c |   16 +++++++++-------
 1 files changed, 9 insertions(+), 7 deletions(-)

bd08dec1012d17f66af6fd0170dce870cce34ab6
diff --git a/net/mac80211/ieee80211_ioctl.c
b/net/mac80211/ieee80211_ioctl.c
index aa8b789..f57e48f 100644
--- a/net/mac80211/ieee80211_ioctl.c
+++ b/net/mac80211/ieee80211_ioctl.c
@@ -2176,16 +2176,18 @@ static int ieee80211_ioctl_giwretry(stru
        struct ieee80211_local *local = wdev_priv(dev->ieee80211_ptr);

        retry->disabled = 0;
-       if ((retry->flags & IW_RETRY_TYPE) != IW_RETRY_LIMIT)
-               return -EINVAL;
-       if (retry->flags & IW_RETRY_MAX) {
-               retry->flags = IW_RETRY_LIMIT | IW_RETRY_MAX;
-               retry->value = local->long_retry_limit;
-       } else {
-               retry->flags = IW_RETRY_LIMIT;
+       if (retry->flags == 0 || retry->flags & IW_RETRY_MIN) {
+               /* first return min value, iwconfig will ask max value
+                * later if needed */
+               retry->flags |= IW_RETRY_LIMIT;
                retry->value = local->short_retry_limit;
                if (local->long_retry_limit != local->short_retry_limit)
                        retry->flags |= IW_RETRY_MIN;
+               return 0;
+       }
+       if (retry->flags & IW_RETRY_MAX) {
+               retry->flags = IW_RETRY_LIMIT | IW_RETRY_MAX;
+               retry->value = local->long_retry_limit;
        }

        return 0;
--
1.3.3

On Fri, 2007-03-23 at 19:11 +0100, Jiri Benc wrote:
> On Fri, 16 Mar 2007 11:28:29 +0800, Hong Liu wrote:
> > Signed-off-by: Hong Liu <hong.liu@intel.com>
> 
> Please add a description what the patch does.
> 
> Thanks,
> 
>  Jiri
> 
