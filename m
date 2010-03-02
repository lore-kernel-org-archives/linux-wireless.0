Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f196.google.com ([209.85.223.196]:59228 "EHLO
	mail-iw0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab0CBMTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Mar 2010 07:19:35 -0500
Received: by iwn34 with SMTP id 34so117442iwn.15
        for <linux-wireless@vger.kernel.org>; Tue, 02 Mar 2010 04:19:34 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4B8C3A21.2050105@openwrt.org>
References: <4B8C3A21.2050105@openwrt.org>
Date: Tue, 2 Mar 2010 13:19:34 +0100
Message-ID: <133e8d7e1003020419r6fab7b13kd77b06407c8c1380@mail.gmail.com>
Subject: Re: [RFC/RFT] minstrel_ht: new rate control module for 802.11n
From: =?ISO-8859-1?Q?Bj=F6rn_Smedman?= <bjorn.smedman@venatech.se>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Derek Smithies <derek@indranet.co.nz>,
	Benoit PAPILLAULT <benoit.papillault@free.fr>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Felix,

First of all thanx for this new rate control algorithm!

One question about AMPDUs (which is not really specific to your code
but anyway): How do you handle "software retries"?

At least ath9k seems to retry frames in serveral AMPDUs up to
ATH_MAX_SW_RETRIES times within the driver (without notifying
mac80211). First of all, is this your understanding as well?

If my understanding is correct then there are two problems as I see it:

1) The rate control algorithm will get incorrect information about the
transmission attempts. This could be corrected to some extent by
correctly setting the count and idx tx_status fields taking software
retries into account, but that interface is actually too thin to carry
all the information since the frame may have been retried at many
bitrates (more than 4). Also, the duration the radio has been busy
transmitting the frame is impossible to derive because you do not know
how many separate AMPDUs it has been transmitted in which makes a
difference in contention window and inter frame space, etc.

2) The rate selection is suboptimal if software retries are not taken
into account. The reason you want to use a high probability bitrate on
the last few transmission attempts is that you want to avoid packet
loss at (almost) any price. But if you can retry the frame in software
it may be better to transmit only at spectrum efficient bitrates and
use the receivers reorder buffer to avoid packet loss. This is IMHO
one of the main advantages of the 802.11n MAC and something we should
really try to take advantage of.

Best regards,

Björn

On Mon, Mar 1, 2010 at 11:05 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>
> Hi all,
>
> this my initial implementation of minstrel for 802.11n. It works well
> for me with ath9k, haven't tested any other drivers yet. It handles
> guard interval setting, HT20/HT40 and multiple streams properly,
> STBC isn't implemented yet (I'll implement driver support in ath9k
> first). Legacy stations are handled by falling back to the old minstrel
> implementation.
>
> It requires the following other patches that I submitted:
> - ath9k: fix rate control tx status handling for A-MPDU
> - minstrel: simplify and fix debugfs code
> - minstrel: make the rate control ops reusable from another rc implementation
>
> There are still some things that need cleaning, for instance the
> internal flags that I use on tx_info->flags, or the sharing of
> the private struct with the old minstrel code.
[snip]
