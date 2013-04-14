Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.nanl.de ([217.115.11.12]:52880 "EHLO mail.nanl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab3DNKtf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Apr 2013 06:49:35 -0400
Received: from mail-vb0-f52.google.com (mail-vb0-f52.google.com [209.85.212.52])
	by mail.nanl.de (Postfix) with ESMTPSA id 735BE45F0C
	for <linux-wireless@vger.kernel.org>; Sun, 14 Apr 2013 10:49:17 +0000 (UTC)
Received: by mail-vb0-f52.google.com with SMTP id w8so3069996vbf.25
        for <linux-wireless@vger.kernel.org>; Sun, 14 Apr 2013 03:49:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1365869899.1089.0.camel@jlt4.sipsolutions.net>
References: <1365849071-2389-1-git-send-email-jogo@openwrt.org>
 <CAJ-VmokacZUw1Wru_0w1XaVRoZWP6nOMcdKo=1yhP-C9rbifHg@mail.gmail.com> <1365869899.1089.0.camel@jlt4.sipsolutions.net>
From: Jonas Gorski <jogo@openwrt.org>
Date: Sun, 14 Apr 2013 12:49:05 +0200
Message-ID: <CAOiHx=mMgJv5t9QDHj9JFXH2TUdiqtM63NnQye429WoUwjKTqQ@mail.gmail.com> (sfid-20130414_124941_045241_8A0AD3F3)
Subject: Re: [RFC/RFT] mwl8k: don't expose non-standard rates
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Adrian Chadd <adrian@freebsd.org>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Yogesh Ashok Powar <yogeshp@marvell.com>,
	Lennert Buytenhek <buytenh@wantstofly.org>,
	Paul Fertser <fercerpav@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 April 2013 18:18, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Sat, 2013-04-13 at 07:29 -0700, Adrian Chadd wrote:
>> Hi,
>>
>> On 13 April 2013 03:31, Jonas Gorski <jogo@openwrt.org> wrote:
>> > Do not advertise the non standard rates 22 Mbps and 72 Mbps to mac80211,
>> > they will make it into the probe responses and cause clients checking them
>> > to refuse association, e.g. wpa_supplicant says:
>>
>> Are these "turbo" mode rates? ie, 40MHz wide channels with pre-11n
>> rates on them?
>
> 22 actually *is* a standard rate, it's just that almost nobody
> implements it.
>
> The original problem seems a bit strange though, seems those should just
> not be marked basic?

After looking at the standard, it became clear that it is only the 72
Mbps rate that's creating the havoc:

It will be put in the extended rates, but since 72 * 2 is 144, it will
overflow the data rate field and set the basic rate flag/MSB, causing
the bogus 8 Mbps "basic" rate.

I'll respin this patch with just removing the 72 Mbps rate.


Jonas
