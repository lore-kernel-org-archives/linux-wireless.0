Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:37062 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab2EAT62 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2012 15:58:28 -0400
Received: by obbtb18 with SMTP id tb18so1232580obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 01 May 2012 12:58:25 -0700 (PDT)
Message-ID: <4FA0405C.8050101@lwfinger.net> (sfid-20120501_215831_317442_B26B5131)
Date: Tue, 01 May 2012 14:58:20 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>
Subject: Wireless problem in 3.4-rc5
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

After upgrading to 3.4-rc5 from wireless-testing, one of my boxes fails to scan 
and gets a "Network down" message for all wireless devices. The code in 3.4-rc4 
was OK, thus I bisected to find the offending commit. The one that broke my 
wireless is commit 3a25a8c entitled "mac80211: add improved HW queue control".

On my main laptop, this patch causes no problems. On a 3rd box, a BCM4312 (b43) 
is OK, but an RTL8187L (rtl8187) also fails in the same manner.

The problem is not in the configuration as I copied the one from the box that 
works to the one that fails, and it still fails. The only difference is that the 
working system has 2 CPUs and the ones that fail are uni-processor; however, if 
I boot with maxcpus=1, my main machine still works.

Any suggestions of things to try will be appreciated.

Larry

