Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from vms173001pub.verizon.net ([206.46.173.1]:33497 "EHLO
	vms173001pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751870Ab3CIWqY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Mar 2013 17:46:24 -0500
Received: from [192.168.1.7] ([unknown] [173.66.143.125])
 by vms173001.mailsrvcs.net
 (Sun Java(tm) System Messaging Server 7u2-7.02 32bit (built Apr 16 2009))
 with ESMTPA id <0MJE003IYXSSTS60@vms173001.mailsrvcs.net> for
 linux-wireless@vger.kernel.org; Sat, 09 Mar 2013 15:46:05 -0600 (CST)
Message-id: <513BAD9C.7000408@verizon.net> (sfid-20130309_234637_778669_E2A65931)
Date: Sat, 09 Mar 2013 16:46:04 -0500
From: "C. McPherson" <ccmcphe@verizon.net>
MIME-version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Cannot use ioctl SIOCGIWFREQ
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello:
I am running my compat-wireless with version 3.8-1 and found that when I 
issue ghe SIOCGIWFREQ ioctl while in monitor mode returns with a 
-ENODATA. I have found that the ieee80211_cfg_get_channel function in 
net/wireless/cfg.c does not account for any channel context when the 
interface is in monitor mode and any attepmpt to use the SIOCGIWFREQ 
function will error out. I have modified my local version to include a 
check for a monitor interfaces  The code block below fixes the problem:


static int ieee80211_cfg_get_channel(struct wiphy *wiphy,
                                      struct wireless_dev *wdev,
                                      struct cfg80211_chan_def *chandef)
{
         struct ieee80211_sub_if_data *sdata = 
IEEE80211_WDEV_TO_SUB_IF(wdev);
         struct ieee80211_chanctx_conf *chanctx_conf;
         struct ieee80211_local *local = wiphy_priv(wiphy);
         int ret = -ENODATA;


         if (!wdev)
                 return -EOPNOTSUPP;

         switch (wdev->iftype) {
                 case NL80211_IFTYPE_MONITOR:
                         *chandef = local->monitor_chandef;
                         ret = 0;
                         break;
                 default:
                         rcu_read_lock();
                         chanctx_conf = 
rcu_dereference(sdata->vif.chanctx_conf);
                         if (chanctx_conf) {
                                 *chandef = chanctx_conf->def;
                                 ret = 0;
                         }
                         rcu_read_unlock();
         }
         return ret;
}


Thanks
Clyde
