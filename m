Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:41901 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752370AbZJ2NF7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 Oct 2009 09:05:59 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: ath5k AP issues
Date: Thu, 29 Oct 2009 14:06:01 +0100
Cc: linux-wireless@vger.kernel.org, Luis Rodriguez <mcgrof@gmail.com>
References: <200910291330.26172.mb@bu3sch.de>
In-Reply-To: <200910291330.26172.mb@bu3sch.de>
MIME-Version: 1.0
Message-Id: <200910291406.03422.mb@bu3sch.de>
Content-Type: text/plain;
  charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 29 October 2009 13:30:24 Michael Buesch wrote:
> Attached is a wireshark log. Let me explain what you see in there:
> 
> I have an ath5k AP and the powersaving n810 device as STA.
> What I try to do is ping the n810. You can see that at the start of the log.
> 
> Packet #31 is a ping to the n810. #42, too. and so on...
> You see that the n810 does not reply. (not even with an 802.11 ack)
> I guess the n810 is in PS at that time.
> Also note that the TIM sent by the AP is empty.
> 
> What I did at #135 is _simultaneously_ ping from the n810 to the ath5k.
> At that point suddenly both pings running on both ends start to succeed.
> 
> This is with a vanilla 2.6.31.5 kernel, but I can also reproduce this with
> compat-wireless and compat-wireless-stable.
> 

This is dmesg log with verbose PS debugging enabled.

[265617.902457] phy0: Allocated STA 00:1d:6e:9b:c5:a6
[265617.903187] phy0: Inserted STA 00:1d:6e:9b:c5:a6
[265620.539771] wlan0: STA 00:1d:6e:9b:c5:a6 aid 1 enters power save mode

Here I start pinging the n810. No dmesg messages appear and pinging does not work.

When I start pinging _from_ the n810, the following messages appear:

[265660.078055] wlan0: STA 00:1d:6e:9b:c5:a6 aid 1 exits power save mode
[265660.078066] wlan0: STA 00:1d:6e:9b:c5:a6 aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
[265660.289206] wlan0: STA 00:1d:6e:9b:c5:a6 aid 1 enters power save mode
[265660.938988] STA 00:1d:6e:9b:c5:a6 aid 1: PS buffer (entries before 0)
[265660.985997] STA 00:1d:6e:9b:c5:a6 aid 1: PS Poll (entries after 0)
[265660.986016] wlan0: STA 00:1d:6e:9b:c5:a6 in PS mode, but pspoll set -> send frame
[265661.008310] wlan0: STA 00:1d:6e:9b:c5:a6 aid 1 exits power save mode
[265661.008321] wlan0: STA 00:1d:6e:9b:c5:a6 aid 1 sending 0 filtered/0 PS frames since STA not sleeping anymore
[265661.226915] wlan0: STA 00:1d:6e:9b:c5:a6 aid 1 enters power save mode


-- 
Greetings, Michael.
