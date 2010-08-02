Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36529 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904Ab0HBKTT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 06:19:19 -0400
Received: by ywh1 with SMTP id 1so1186289ywh.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Aug 2010 03:19:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C5699AE.6090103@openwrt.org>
References: <20100729035820.5930.29864.stgit@tt-desk> <201007291812.28639.br1@einfach.org>
	<AANLkTi=ihY=pAmKaEp7Pga=DOxwASZqSxqmURbgnks-d@mail.gmail.com>
	<201008021313.54850.br1@einfach.org> <AANLkTimRnfa8HVpi0hcP7Eo9Nrns60ff3Hs+fq39WoJh@mail.gmail.com>
	<4C5688F7.1070200@openwrt.org> <AANLkTi=Qm53CgFNNgtF4iBvh3jbfYzd8XPH4y9ysUaoV@mail.gmail.com>
	<4C568D23.2000203@openwrt.org> <AANLkTinGdwt4bSPRDV=ZfPBmoKS42GgUVjLAg_O1vL3i@mail.gmail.com>
	<4C5690C7.2080104@openwrt.org> <AANLkTimoU+iF2bVJ-Fs4iT3k5v0iU9PaE783NhUdnQQ-@mail.gmail.com>
	<4C5699AE.6090103@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 2 Aug 2010 03:18:59 -0700
Message-ID: <AANLkTimWnefNaiPzqMXwc6d8aePmy3SZ8w9FB4=6CRko@mail.gmail.com>
Subject: Re: [PATCH v5] cfg80211: Add nl80211 antenna configuration
To: Felix Fietkau <nbd@openwrt.org>
Cc: Bruno Randolf <br1@einfach.org>, johannes@sipsolutions.net,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 2, 2010 at 3:10 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2010-08-02 11:52 AM, Luis R. Rodriguez wrote:
>> On Mon, Aug 2, 2010 at 2:32 AM, Felix Fietkau <nbd@openwrt.org> wrote:
>>> On 2010-08-02 11:23 AM, Luis R. Rodriguez wrote:
>>>> Sure, I just did not see any code for this in these patches. My point
>>>> about the hw config vs fake/mod'd is if we'd expose the mod'd config
>>>> changes to userspace or if we'd keep them internal to cfg80211. How
>>>> would this be dealt with?
>>> Right now, cfg80211 doesn't know enough to handle this stuff on its own,
>>> so let's handle it in the driver completely on the first iteration. The
>>> patches do not need any changes for this right now.
>>
>> I'd prefer that code to be written rather then let this be defined as
>> API now and let drivers deal with this differently. But that's me, I'm
>> not the maintainer, I just will not deal with bug reports dealing with
>> this and I'll assign them to you guys if this gets through. Still
>> think its crap and should just go through debugfs until all the code
>> mentioned does exist.
> Sorry, but WTF? There's two parts to this: API visible to user space,
> and the internal API for handling changes.
> So you're suggesting to reject the user space API, because of missing
> parts in the internal API (which we can change any time) that will only
> be used for drivers that this series doesn't even contain any code for??
> Am I confused here, or does this seem rather strange?

If the current patches are accepted it means anyone *can* submit
patches for an 802.11n driver and expect it to be accepted. Hence why
I was asking for this to be defined as a legacy API only, if that is
the only purpose right now.

  Luis
