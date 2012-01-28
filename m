Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:56428 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970Ab2A1TRx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jan 2012 14:17:53 -0500
Received: by vbbfc26 with SMTP id fc26so2034125vbb.19
        for <linux-wireless@vger.kernel.org>; Sat, 28 Jan 2012 11:17:52 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4F2443BB.3000602@openwrt.org>
References: <1327735027-30121-1-git-send-email-lindner_marek@yahoo.de>
 <1327735027-30121-2-git-send-email-lindner_marek@yahoo.de>
 <4F23F753.8070405@openwrt.org> <201201290243.47953.lindner_marek@yahoo.de> <4F2443BB.3000602@openwrt.org>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Sat, 28 Jan 2012 11:17:32 -0800
Message-ID: <CALSq=BahchLsgVVeFei+_FQAchMAAg2yU1drmpZTgt0pVoJbJg@mail.gmail.com> (sfid-20120128_201821_764934_58AA0F95)
Subject: Re: [PATCH] mac80211: minstrel_ht should not override user supplied
 rts setting
To: Felix Fietkau <nbd@openwrt.org>
Cc: Marek Lindner <lindner_marek@yahoo.de>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jan 28, 2012 at 10:51 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2012-01-28 7:43 PM, Marek Lindner wrote:
>> On Saturday, January 28, 2012 21:25:39 Felix Fietkau wrote:
>> If you think it is unsuitable do you mind elaborating what this setting is
>> for? As far as I can tell minstrel_ht is the only rate control algorithm that
>> decides to be smarter than the user configuring the device. Without mentioning
>> this anywhere! IMHO it should be minstrel_ht explaining why this makes sense,
>> not the other way round.
> The user configurable RTS/CTS setting sets a threshold which is applied
> to all transmission attempts with a packet size above it.
> What minstrel_ht does is enable RTS/CTS only for on-chip retransmissions
> of the second rate slot and below. That means as long as it doesn't fall
> back to lower rates, no RTS/CTS gets used.
> It's not about minstrel_ht being smarter than the user. It's about
> adaptive control of RTS/CTS being smarter than a static setting.
>

Adaptive RTS/CTS is important to control for interference---RTS/CTS is
there so that other Wi-Fi devices know not to interfere with your
flow. It may well be the case that this is not a major problem in
whatever your scenario you're working, Marek, but it makes a big
difference in a many bad corner cases.

As Felix says, by not forcing RTS/CTS on until a retry, the user's
RTS/CTS preference is used for the overwhelming majority of packets
whose rates are chosen correctly (or a little too slow).

I'm with Felix: I could see adding an option that means "force never
use RTS/CTS" but I think we're at the right operating point when
interpreting the standard "RTS/CTS threshold" option.

(BUT @Felix: maybe max_tp_rate2 shouldn't use RTS/CTS---it's still
trying to be aggressive, whereas max_prob_rate is the one where you
*really* want the packet to get through. So maybe the first half of
Marek's patch is worth keeping, though it *should* be a marginal
difference in normal operating environments.)

Dan
