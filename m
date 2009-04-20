Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f163.google.com ([209.85.218.163]:37919 "EHLO
	mail-bw0-f163.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728AbZDTU00 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Apr 2009 16:26:26 -0400
Received: by bwz7 with SMTP id 7so1422878bwz.37
        for <linux-wireless@vger.kernel.org>; Mon, 20 Apr 2009 13:26:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1240257188.4632.19.camel@johannes.local>
References: <20090416111723.904720021@sipsolutions.net> <20090420194430.GG3369@tuxdriver.com>
	<1240257188.4632.19.camel@johannes.local>
From: Davide Pesavento <davidepesa@gmail.com>
Date: Mon, 20 Apr 2009 22:26:09 +0200
Message-ID: <2da21fe50904201326m3d843b64u1c3b56d2593bb7cb@mail.gmail.com> (sfid-20090420_222651_059133_FB461D0F)
Subject: Re: [PATCH 0/4] mac80211 powersave work
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 20, 2009 at 21:53, Johannes Berg <johannes@sipsolutions.net=
> wrote:
> On Mon, 2009-04-20 at 15:44 -0400, John W. Linville wrote:
>> On Thu, Apr 16, 2009 at 01:17:23PM +0200, Johannes Berg wrote:
>> > This is pretty much unchanged from my previous v2 RFCs,
>> > except that I added a default of 500ms for the dynamic
>> > powersave timer.
>> >
>> > The fourth patch is new, it adds beacon filtering to
>> > mac80211 -- for the reasons explained in that patch.
>> >
>> > For 2.6.31, we should make MAC80211_DEFAULT_PS default
>> > off instead. John, how do you want to handle that?
>>
>> I'm not sure I understand. =C2=A0Your patch (which would go to 2.6.3=
1)
>> has it turned-on by default. =C2=A0Which way do you want it?
>
> I want it turned on by default, at least in wireless-testing; Kalle
> thinks that we should turn it off for a .31 release.
>
> I would think that since an easy workaround is available ("iwconfig
> wlan0 power off") and it doesn't affect most hardware yet anyway (onl=
y
> those supporting powersave) we should turn it on by default anyway,
> since otherwise we won't find any bugs -- but maybe that's just me.
>

As I've already reported [1][2], ath9k is currently broken when power
saving is enabled, at least on AR5418 hardware. So please don't turn
it on by default yet.

Thanks,
Davide

[1] http://marc.info/?l=3Dlinux-wireless&m=3D123816406913599&w=3D2
[2] http://marc.info/?l=3Dlinux-wireless&m=3D123999864507104&w=3D2
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
