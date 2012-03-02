Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:48176 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754539Ab2CBStb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Mar 2012 13:49:31 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Fri, 02 Mar 2012 10:39:11 -0800
From: vivekanandah@posedge.com
To: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: requesting information on null frame send during scan in mac80211 -
 linux =?UTF-8?Q?=33=5F=31=5F=34=20code=20base?=
Message-ID: <7596c51dab245e8f5cb1e3010943e28b@posedge.com> (sfid-20120302_194935_072166_53E02C01)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi,


i am new to the linux system and i am hoping that this is the right 
list to mail for my query.

I am presently working on linux kernel 3.1.4 and i was looking into the 
mac80211 code and the scan implementation on the same.

when the scan process is started, the station is supposed to send a 
null frame with PM bit set, so that AP can buffer frames to the station.

However, it is seen in code that when scan is initiated (software 
scan),
the ieee80211_offchannel_enable_all_ps(local, false); function is 
called, since the flag is set to false, the NULL frame will not be sent 
out. also, when the scan state changes to leaving operating channel, the 
vifs interface is blocked. even here, i see that the flag setting is 
false for offchannel Power save and the null frame is not sent out.

the comment however just prior to the vifs stop function call indicates 
that offchannel settings are already completed at the start of scan 
process. the code snippet is shown below:

/*PS will already be in off-channel mode, we do that once at the 
beginning of scanning.*/
ieee80211_offchannel_stop_vifs(local, false);

i just would like to know why the flag is FALSE in both cases, so we 
never send out a null frame to the AP at the start. is this a bug or 
there is some deficiency in my current understanding?

i would be very thankful for any help or guidance

thanks in advance
vivek
