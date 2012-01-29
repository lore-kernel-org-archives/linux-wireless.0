Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:32876 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751500Ab2A2Cgm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jan 2012 21:36:42 -0500
Message-ID: <4F24B0B5.1060101@openwrt.org> (sfid-20120129_033648_152486_9B1650EC)
Date: Sun, 29 Jan 2012 03:36:37 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
CC: Marek Lindner <lindner_marek@yahoo.de>,
	Daniel Halperin <dhalperi@cs.washington.edu>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: minstrel_ht should not override user supplied
 rts setting
References: <1327735027-30121-1-git-send-email-lindner_marek@yahoo.de> <201201290409.07368.lindner_marek@yahoo.de> <CALSq=BbhM6vLOJt9MGi2BhHKO0-NzAm73WohLDy4YC7x9rpDmw@mail.gmail.com> <201201290435.14048.lindner_marek@yahoo.de> <20120128221452.GB22180@pandem0nium>
In-Reply-To: <20120128221452.GB22180@pandem0nium>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-01-28 11:14 PM, Simon Wunderlich wrote:
> I agree to Marek here - if I want to disable RTS (for whatever reason), I type
> 
> iw phy0 set rts off
> 
> I would expect to see no RTS frames coming from my WiFi card at all. If the
> rate control algorithm (whether ath9k or minstrel_ht) wants to be clever, it should
> still respect this decision. The oven in my kitchen also has a temperature regulator,
> but if I turn it off I also don't want my oven to be too clever and burn down the house. ;)
> 
> I know, apples and oranges, but I hope this makes this point understandable. I also
> had quite a debugging night to find the reason for these "wild rts" frames.
> 
> Can't we add something two states, like:
>  * "RTS really off" and
>  * "RTS usually off, but rc's may still use it" ?
If you send a patch for that, I'm ok with it. The default should be RTS
off, but rc may still use it.

- Feli
