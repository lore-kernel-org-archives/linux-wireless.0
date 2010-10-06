Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:60093 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759110Ab0JFONy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Oct 2010 10:13:54 -0400
Received: by iwn5 with SMTP id 5so9800266iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 06 Oct 2010 07:13:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <201010061150.52352.br1@einfach.org>
References: <20101005095510.3083.46174.stgit@tt-desk> <201010061125.54247.br1@einfach.org>
 <4CABE2DA.5020204@openwrt.org> <201010061150.52352.br1@einfach.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 6 Oct 2010 07:13:32 -0700
Message-ID: <AANLkTikS0=Nq8zqpf7_HjXY7-YeY0oAhUNJ8RrZwkkFJ@mail.gmail.com>
Subject: Re: [PATCH 5/5] ath5k: Add busy ratios to survey data
To: Bruno Randolf <br1@einfach.org>
Cc: Felix Fietkau <nbd@openwrt.org>, vasanth@atheros.com,
	linville@tuxdriver.com, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 5, 2010 at 7:50 PM, Bruno Randolf <br1@einfach.org> wrote:
> On Wed October 6 2010 11:45:46 Felix Fietkau wrote:
>> On 2010-10-06 4:25 AM, Bruno Randolf wrote:
>> > On Wed October 6 2010 07:38:34 Luis R. Rodriguez wrote:
>> >> This is all being sucked out of common, so can we just share the
>> >> filler for the survey between ath5k and ath9k? Note we should split up
>> >> hw code and core driver code on the ath module by file.
>> >
>> > sure, that would be good! noise floor comes from ath5k_hw though, but
>> > that can easily be moved to common.
>> >
>> > there's so much code which could be shared between ath5k and ath9k...
>>
>> That would need sharing of the channel list and some per-channel data
>> though - so it may need some more code reshuffling...
>
> also - we would need a common way to get ath_common from ieee80211_hw, which
> works for both ath5k and ath9k. right now each has it's own structures. so...
> i'd say: later...

Lets also learn from the iwlwifi issues. The more you share the easier
it is to regress older drivers. So I'd love to share but I think I now
prefer to be more conservative towards code sharing, share only what
we know will not change at all and are 100% confident in, and fork off
a driver every now and then so we can maintain stability on the older
drivers.

  Luis
