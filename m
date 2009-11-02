Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.223.180]:35056 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262AbZKBUgq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 15:36:46 -0500
Received: by iwn10 with SMTP id 10so3612690iwn.4
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2009 12:36:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4AEF40A0.2030408@openwrt.org>
References: <19182.33851.980271.360757@gargle.gargle.HOWL>
	<1257151486.3555.161.camel@johannes.local> <20091102153614.GC14046@tuxdriver.com>
	<4AEF14E9.7060902@nbd.name> <43e72e890911020947i3a9ea736ve95fa6b1fac724a4@mail.gmail.com>
	<4AEF40A0.2030408@openwrt.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 2 Nov 2009 12:36:31 -0800
Message-ID: <43e72e890911021236ra2a77baj6436abcc2d86cb3b@mail.gmail.com>
Subject: Re: [PATCH] mac80211: Fix IBSS merge
To: Felix Fietkau <nbd@openwrt.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Sujith <Sujith.Manoharan@atheros.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 2, 2009 at 12:27 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> Luis R. Rodriguez wrote:
>> On Mon, Nov 2, 2009 at 9:20 AM, Felix Fietkau <nbd@nbd.name> wrote:
>>> John W. Linville wrote:
>>>> On Mon, Nov 02, 2009 at 09:44:46AM +0100, Johannes Berg wrote:
>>>>> On Mon, 2009-11-02 at 12:33 +0530, Sujith wrote:
>>>>> > Currently, in IBSS mode, a single creator would go into
>>>>> > a loop trying to merge/scan. This happens because the IBSS timer is
>>>>> > rearmed on finishing a scan and the subsequent
>>>>> > timer invocation requests another scan immediately.
>>>>> >
>>>>> > This patch fixes this issue by checking if we have just completed
>>>>> > a scan run trying to merge with other IBSS networks.
>>>>>
>>>>> Heh, how many people do we need to fix IBSS? :)
>>>>
>>>> Yeah, no kidding...I suspect that actual IBSS users are few, and a
>>>> substantial number of those are doing crazy things with it! :-)
>>> Yeah, we're doing crazy things like mesh networks of few hundred
>>> nodes... something that 11s isn't really suitable for. :-)
>>
>> Anyone know if this applies for 32?
> What exactly?

The patch.

  Luis
