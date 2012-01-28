Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:53709 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752054Ab2A1UU2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jan 2012 15:20:28 -0500
Message-ID: <4F245888.2070202@openwrt.org> (sfid-20120128_212040_524409_F0DF5589)
Date: Sat, 28 Jan 2012 21:20:24 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Marek Lindner <lindner_marek@yahoo.de>
CC: Daniel Halperin <dhalperi@cs.washington.edu>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: minstrel_ht should not override user supplied
 rts setting
References: <1327735027-30121-1-git-send-email-lindner_marek@yahoo.de> <4F2443BB.3000602@openwrt.org> <CALSq=BahchLsgVVeFei+_FQAchMAAg2yU1drmpZTgt0pVoJbJg@mail.gmail.com> <201201290358.35433.lindner_marek@yahoo.de>
In-Reply-To: <201201290358.35433.lindner_marek@yahoo.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-01-28 8:58 PM, Marek Lindner wrote:
>> I'm with Felix: I could see adding an option that means "force never
>> use RTS/CTS" but I think we're at the right operating point when
>> interpreting the standard "RTS/CTS threshold" option.
> 
> Actually, this option exists already. It's just minstrel_ht overriding it:
> iw phy <phyname> set rts <rts threshold|off>
> Put special attention towards the "off" at the end.
> 
> If we let the rate algorithm override our rts settings it should at least be 
> communicated. I found no such mention anywhere. 
> 
> I'd like to further stress the point that no other rate algorithm does this. 
> We create incoherent and hard to debug behavior.
Which rate algorithms did you check to come to that conclusion? I just
looked at the ath9k rate control algorithm and it does the same ;)

- Felix
