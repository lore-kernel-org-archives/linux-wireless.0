Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:2368 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752628AbZIPR1c (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2009 13:27:32 -0400
Subject: Re: WARNING: at net/mac80211/scan.c:267
 ieee80211_scan_completed+0x299/0x2b0 	[mac80211]()
From: reinette chatre <reinette.chatre@intel.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Zhu, Yi" <yi.zhu@intel.com>
In-Reply-To: <8db1092f0909160236i5d2b1f31k3ec289fbd9ac0bfa@mail.gmail.com>
References: <8db1092f0909160236i5d2b1f31k3ec289fbd9ac0bfa@mail.gmail.com>
Content-Type: text/plain
Date: Wed, 16 Sep 2009 10:27:35 -0700
Message-Id: <1253122055.26521.431.camel@rc-desk>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Maciej,

> Steps to reproduce:
> 1. Connect to the wireless network (WPA2), it takes long time (longer
> than in 2.6.31)
> 2. Connect to another wireless network:
> 3. Connect fails with error:

The important information is not what you posted here, but still in the
dmesg file you provided. In that log we see the following right before
the warnings:

[  163.126590] wlan0: direct probe to AP 00:1b:11:f6:0f:28 (try 1)
[  163.130027] wlan0 direct probe responded
[  163.130032] wlan0: authenticate with AP 00:1b:11:f6:0f:28 (try 1)
[  163.131924] wlan0: authenticated
[  163.131952] wlan0: associate with AP 00:1b:11:f6:0f:28 (try 1)
[  163.134325] wlan0: RX ReassocResp from 00:1b:11:f6:0f:28 (capab=0x431 status=0 aid=1)
[  163.134331] wlan0: associated
[  163.155938] wlan0: deauthenticating by local choice (reason=3)

It shows that association was successful, but something in userspace requested a disconnect. 

> 
> [  163.208063] ------------[ cut here ]------------
> [  163.208114] WARNING: at net/mac80211/scan.c:267
> ieee80211_scan_completed+0x299/0x2b0 [mac80211]()

I cannot get an exact line match based on the kernel information you
provided. I assume it is the first warning in
ieee80211_scan_completed(). This is not serious as it indicates that
mac80211 received a "scan completed" indication when it was not
scanning. 


> [  163.232845] ------------[ cut here ]------------
> [  163.232908] WARNING: at net/wireless/core.c:613
> wdev_cleanup_work+0xbb/0xe0 [cfg80211]()

This warning has just been reported in linux-wireless also. Perhaps you
can follow its discussion there. See
http://thread.gmane.org/gmane.linux.kernel.wireless.general/39607

Reinette


