Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53165 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab2A1UEC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jan 2012 15:04:02 -0500
Received: by vcbgb30 with SMTP id gb30so1916915vcb.19
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jan 2012 12:04:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <201201290358.35433.lindner_marek@yahoo.de>
References: <1327735027-30121-1-git-send-email-lindner_marek@yahoo.de>
 <4F2443BB.3000602@openwrt.org> <CALSq=BahchLsgVVeFei+_FQAchMAAg2yU1drmpZTgt0pVoJbJg@mail.gmail.com>
 <201201290358.35433.lindner_marek@yahoo.de>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Sat, 28 Jan 2012 12:03:41 -0800
Message-ID: <CALSq=BYOaFSa4zuK0j8vFavjR38wC86Hqcd-sbYZ3b+CBGReJw@mail.gmail.com> (sfid-20120128_210413_301343_9D16935A)
Subject: Re: [PATCH] mac80211: minstrel_ht should not override user supplied
 rts setting
To: Marek Lindner <lindner_marek@yahoo.de>
Cc: Felix Fietkau <nbd@openwrt.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 28, 2012 at 11:58 AM, Marek Lindner <lindner_marek@yahoo.de> wrote:
> On Sunday, January 29, 2012 03:17:32 Daniel Halperin wrote:
>> Adaptive RTS/CTS is important to control for interference---RTS/CTS is
>> there so that other Wi-Fi devices know not to interfere with your
>> flow. It may well be the case that this is not a major problem in
>> whatever your scenario you're working, Marek, but it makes a big
>> difference in a many bad corner cases.
>
> I am very well aware of what RTS/CTS is for and I am not against using it.
> However, having the rate algorithm overriding the user setting for a specific
> rate is extremely hard to grasp or debug.
> To give you an understanding where I am coming from: In our networks we
> experienced extremely variable throughput ranging from 30Mbit/s (single
> stream) to 0.2 Mbit/s in the next second. As you can imagine we were trying to
> figure out what was going on. After spending some time and losing hair I
> noticed that the RTS/CTS implementation of our driver (ath9k) is buggy. Every
> once in a while the nodes would "battle" each other with RTS/CTS packets.
> Strange enough for us, sometimes no RTS packets were sent and sometimes they
> would battle. All attempts to disable RTS/CTS for the mere sake of testing(!)
> was impossible. First I thought ath9k did not properly implement the "iw rts"
> setting but that wasn't the case. After losing more hair I realized that
> minstrel_ht, a rate control algorithm(!), was overriding my rts settings but
> not always(!). The only way to make RTS shut up was to apply the posted patch.

Can you explain what the low-level behavior of an RTS/CTS "battle" is?

Abstractly, the behavior you're describing sounds like a buggy driver
that doesn't obey overheard RTS or CTS packets.

Dan
