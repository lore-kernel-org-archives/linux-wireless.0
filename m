Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([88.198.39.176]:59355 "EHLO ds10.mine.nu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932266AbZKBU1Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Nov 2009 15:27:25 -0500
Message-ID: <4AEF40A0.2030408@openwrt.org>
Date: Mon, 02 Nov 2009 21:27:12 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Sujith <Sujith.Manoharan@atheros.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Fix IBSS merge
References: <19182.33851.980271.360757@gargle.gargle.HOWL> 	<1257151486.3555.161.camel@johannes.local> <20091102153614.GC14046@tuxdriver.com> 	<4AEF14E9.7060902@nbd.name> <43e72e890911020947i3a9ea736ve95fa6b1fac724a4@mail.gmail.com>
In-Reply-To: <43e72e890911020947i3a9ea736ve95fa6b1fac724a4@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Mon, Nov 2, 2009 at 9:20 AM, Felix Fietkau <nbd@nbd.name> wrote:
>> John W. Linville wrote:
>>> On Mon, Nov 02, 2009 at 09:44:46AM +0100, Johannes Berg wrote:
>>>> On Mon, 2009-11-02 at 12:33 +0530, Sujith wrote:
>>>> > Currently, in IBSS mode, a single creator would go into
>>>> > a loop trying to merge/scan. This happens because the IBSS timer is
>>>> > rearmed on finishing a scan and the subsequent
>>>> > timer invocation requests another scan immediately.
>>>> >
>>>> > This patch fixes this issue by checking if we have just completed
>>>> > a scan run trying to merge with other IBSS networks.
>>>>
>>>> Heh, how many people do we need to fix IBSS? :)
>>>
>>> Yeah, no kidding...I suspect that actual IBSS users are few, and a
>>> substantial number of those are doing crazy things with it! :-)
>> Yeah, we're doing crazy things like mesh networks of few hundred
>> nodes... something that 11s isn't really suitable for. :-)
> 
> Anyone know if this applies for 32?
What exactly?

- Felix
