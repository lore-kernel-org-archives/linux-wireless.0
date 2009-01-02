Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f21.google.com ([209.85.218.21]:50310 "EHLO
	mail-bw0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759165AbZABUDS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Jan 2009 15:03:18 -0500
Received: by bwz14 with SMTP id 14so20400392bwz.13
        for <linux-wireless@vger.kernel.org>; Fri, 02 Jan 2009 12:03:16 -0800 (PST)
Message-ID: <da94abde0901021203u68b58f3ej3a1f7127ef3b665e@mail.gmail.com> (sfid-20090102_210322_195400_96C33853)
Date: Fri, 2 Jan 2009 22:03:15 +0200
From: "Kalle Valo" <kalle.valo@iki.fi>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH] ath9k: Enable Bluetooth Coexistence support
Cc: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>,
	"Vasanthakumar Thiagarajan" <vasanth@atheros.com>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Luis.Rodriguez@atheros.com, Jouni.Malinen@atheros.com,
	ath9k-devel@lists.ath9k.org
In-Reply-To: <200901022031.24460.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1230890746-3075-1-git-send-email-vasanth@atheros.com>
	 <69e28c910901021052m63f63a1ep704a4d8aa8b4ca9@mail.gmail.com>
	 <da94abde0901021106l721ad722w9eb857ed41214377@mail.gmail.com>
	 <200901022031.24460.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 2, 2009 at 9:31 PM, Michael Buesch <mb@bu3sch.de> wrote:
> On Friday 02 January 2009 20:06:08 Kalle Valo wrote:
>> On Fri, Jan 2, 2009 at 8:52 PM, Stefanik G=E1bor <netrolller.3d@gmai=
l.com> wrote:
>> > Probably a NOBTCOEX modparam might be a good idea - when implement=
ing
>> > BT coexistence in b43, a lot of non-BT-aware cards failed to work
>> > because the BT GPIO line was connected to the TX preamplifier,
>> > breaking all TX.
>>
>> It would be nice to have a common interface for this, for example
>> through nl80211. Lots of drivers have BT coexistence support. But th=
is
>> is just an idea.
>
> Well, why? If btcoex works correctly (=3D is not buggy), the user doe=
s not
> notice it at all. I see no reason to turn it off. Except if it's bugg=
y.

Working around buggy implementations was the primary reason why I
suggested this.

> But then we should simply fix it or always disable it at compiletime,=
 if
> it's not possible to fix.

It would just make it easier for the users if the drivers would have a
unified interface for this. Having a different modparam for each
driver is ugly.

But this just an idea, let's not waste too much time on this. Someone
(not me) will send a patch if she feels this is a good idea. Most
probably no one will.

Kalle
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
