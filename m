Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:62684 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752850AbYHIQCw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Aug 2008 12:02:52 -0400
Message-ID: <489DBFA9.80608@lwfinger.net> (sfid-20080809_180257_756031_8C23CE84)
Date: Sat, 09 Aug 2008 11:02:49 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: John W Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] p54: Fix for TX sequence number problem that resulted
 from commit 741b4fbc44
References: <48987e74.ct5+sLOpTbiTPPHq%Larry.Finger@lwfinger.net> <200808081026.49041.chunkeey@web.de> <489C5833.2080009@lwfinger.net> <200808082038.48840.chunkeey@web.de>
In-Reply-To: <200808082038.48840.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chr wrote:
> On Friday 08 August 2008 16:29:07 Larry Finger wrote:
> 
> well, since I got the usb device I had nothing but problems with it.
> e.g: one single ping -s 1400 $AP can bring it down and a _replug_ is necessary.
> The minipci card on the other hand is very stable.
> 
> I guess p54usb needs some mutexes & udelays here & there.

Mine also crashes with a ping of length 1400, but 1390 and 1410 work 
just fine. I also tested with tcpperf and I am pretty sure that this 
is a transmit problem. When I set the MTU to 1300, then a ping of 
length 1400 works fine. Is this a firmware bug? Which firmware are you 
using? Mine is isl3887usb_bare.

> on-topic: I digged a bit in the logs:
> 
> http://jbnote.free.fr/prism54usb/data/usbsnoop-logs/
> and there "usbsnoop_old_drv_ver1.log.bz2"
> 
> you can easily find tx' data frames by searching for
> "00000010: 10 40" string.
> 
> to cut the case here is a extract (only ieee 80211 header @line 26218)
> 08 01 <= frame control
> 00 00 <= duration ZERO
> 00 06 25 bb 9d 4b <= mac
> 00 0f 66 17 46 6b <= mac
> ff ff ff ff ff ff <= mac
> 00 00 <= sequence ZERO
> aa aa 03 <= 802.2 LLC header
> 
> the next one is at line 27188... and so down to end of packages at line 329241.
> there isn't one single package where the sequence number is not zero!
> 
> So the problem must be somewhere else! what happens when:
> if (info->flags & IEEE80211_TX_CTL_ASSIGN_SEQ) {
> 	if (info->flags & IEEE80211_TX_CTL_FIRST_FRAGMENT)
> 		priv->seqno += 0x10;
> 
> 	ieee80211hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
> 	ieee80211hdr->seq_ctrl |= cpu_to_le16(priv->seqno);
> 	ieee80211hdr->seq_ctrl &= cpu_to_le16(IEEE80211_SCTL_FRAG);
> }
> (yeah a new definition for idiotic! but it's about the same amount of of clock cycles).

This didn't help the "ping -s 1400" problem.

Larry

