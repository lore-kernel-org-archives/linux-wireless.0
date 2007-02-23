Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:25520 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161093AbXBWQhR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Feb 2007 11:37:17 -0500
Message-ID: <45DF176E.9090509@linux.intel.com>
Date: Fri, 23 Feb 2007 08:33:50 -0800
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] create net/wireless/Kconfig and make nl80211 optional
References: <45DDF22D.9000003@linux.intel.com> <1172229914.3870.13.camel@johannes.berg>
In-Reply-To: <1172229914.3870.13.camel@johannes.berg>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Thu, 2007-02-22 at 11:42 -0800, James Ketrenos wrote:
>> Move the wireless Kconfig options into their own wireless/Kconfig and
>> add a CONFIG_NL80211 configuration option to allow nl80211 support to be
>> optionally included (default =y)
> 
> Ack, but we'll need to modify core.h to stub out nl80211_init() and
> nl80211_exit() in case nl80211 isn't compiled in. The reason this worked
> for you is that I forgot to hook up nl80211 completely ;)
> 
> Do you want me to take care of that?`

Something like this?

James
--------------

[PATCH] Make nl80211_init and nl80211_exit depend on NL80211 config

This applies after Johannes patch 'hook up nl80211 again' and wraps
nl80211_init and nl80211_exit usage in CONFIG_CFG80211_NL80211.

Signed-off-by: James Ketrenos <jketreno@linux.intel.com>
---
  net/wireless/core.c |    6 ++++++
  1 file changed, 6 insertions(+)
---
diff --git a/net/wireless/core.c b/net/wireless/core.c
index abf0f78..8c1e914 100644
--- a/net/wireless/core.c
+++ b/net/wireless/core.c
@@ -249,16 +249,20 @@ static int cfg80211_init(void)
         if (err)
                 goto out_exit_sysfs;

+#ifdef CONFIG_CFG80211_NL80211
         err = nl80211_init();
         if (err)
                 goto out_nl80211;
+#endif

         ieee80211_debugfs_dir = debugfs_create_dir("ieee80211", NULL);

         return 0;

+#ifdef CONFIG_CFG80211_NL80211
   out_nl80211:
         cfg80211_wext_exit();
+#endif
   out_exit_sysfs:
         wiphy_sysfs_exit();

@@ -269,7 +273,9 @@ module_init(cfg80211_init);
  static void cfg80211_exit(void)
  {
         debugfs_remove(ieee80211_debugfs_dir);
+#ifdef CONFIG_CFG80211_NL80211
         nl80211_exit();
+#endif
         cfg80211_wext_exit();
         wiphy_sysfs_exit();
  }




