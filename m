Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.36.123.2]:32644 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751780AbYHNKJx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Aug 2008 06:09:53 -0400
Received: from mail.atheros.com ([10.10.20.105])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Thu, 14 Aug 2008 03:09:53 -0700
Date: Thu, 14 Aug 2008 15:35:01 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: <linux-wireless@vger.kernel.org>
Subject: Improvement in mac80211 to move to a proper state when channel is
	set from user space
Message-ID: <20080814100501.GA5486@vasanth-lnx.users.atheros.com> (sfid-20080814_120956_481981_45C98D5D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The problem with the current behaviour of mac80211 when setting a
new channel from user space while interface is in associated state
is, it is still maintainig the associated state even after the h/w 
is set to a different channel and it is sending packets destined 
to the connected AP/STA which is operating in a different freq/band 
in the new channel before detecting that the AP is no more in the 
channel (in this case it is done by sending couple of probe req to 
the associated AP which is obviously operating on a different channel 
after the channel change). I think we need to put the interface into 
a proper state instead of just relying on this tx probe req logic in 
this case. I'm have the following proposals to improve the situation.

Handle proper state transition in wireless handler (ieee80211_ioctl_siwfreq):
For STA mode, move the interface to disassociated state with the associated AP 
in the current channel and move it to scan state to find an appropriate 
AP in the new channel.
For IBSS, mark all the joined ibss stations as not joined in the
current chanel and move the inteface state to scan in the new channel.
For AP mode, move the interface to disassociated state with all
associated stations in current channel and start a BSS in the new
channel.

Handle it from the diver:
Sense the situation from the beacon miss or in config() callback
(with some hacky check) and trigger the disassociation, for this
 we need to add one more notification type in ieee80211_notify_mac() 
for disassoc.

Would like to know comments on this one.

Thanks,
Vasanth
