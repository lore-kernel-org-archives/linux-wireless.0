Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.uni-rostock.de ([139.30.22.71]:50156 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752925AbdLKN2z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 08:28:55 -0500
Subject: Re: [PATCH v2 3/5] mac80211_hwsim: add generation count for netlink
 dump operation
To: Johannes Berg <johannes@sipsolutions.net>
References: <20171121121744.23422-1-benjamin.beichler@uni-rostock.de>
 <7ee141a4-8983-4da6-9c0f-f070fa6e5611@MAIL2.uni-rostock.de>
 <1512994493.26976.74.camel@sipsolutions.net>
 <8264ae6e-7db6-53b0-88c0-4ac4e51d0ba3@uni-rostock.de>
 <1512996543.26976.76.camel@sipsolutions.net>
 <5afe6ce9-5d7a-2b8e-f2bc-32088aacb9fe@uni-rostock.de>
 <1512997665.26976.78.camel@sipsolutions.net>
From: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
CC: <linux-wireless@vger.kernel.org>
Message-ID: <8a26e55c-83ce-1395-ff9d-723e5b9fc82b@uni-rostock.de> (sfid-20171211_142859_557349_EFF4A717)
Date: Mon, 11 Dec 2017 14:29:15 +0100
MIME-Version: 1.0
In-Reply-To: <1512997665.26976.78.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 11.12.2017 um 14:07 schrieb Johannes Berg:
> On Mon, 2017-12-11 at 14:02 +0100, Benjamin Beichler wrote:
>>> But you added this:
>>>
>>> +       /* list changed */
>>> +       if (cb->prev_seq && cb->seq !=3D cb->prev_seq)
>>> +               goto cleanup;
>>>
>>> which is mostly just a copy of the inline.
>>>
>>> johannes
>> Year you are right, but for nl_dump_check_consistent() I also need a
>> header struct to write the flag to it and I thought a ghost header onl=
y
>> to this function is also misleading. But if you think this is better, =
I
>> can do that. Or we introduce a function, which really only check
>> consistency and not also set the flag. I also thought the line is
>> readable at it's own, because it's simply inconsistent if the sequence=

>> numbers are not equal.
> It's readable, but there should be an indication to userspace in this
> case, no?
>
> johannes
>
Mhh, OK you are totally right.

I think we need to send something like an empty message, containing the
flag. Because there exist the corner case, that while a dump is
interrupted the complete list is deleted. Currently this could not
happen because of non-parallel netlink callbacks, but maybe in the
future parallel callbacks are enabled.

Would it break things, if I simply create an header with
HWSIM_CMD_GET_RADIO, but put no other information in it? Or how could it
be done correctly?

--=20
M.Sc. Benjamin Beichler

Universit=C3=A4t Rostock, Fakult=C3=A4t f=C3=BCr Informatik und Elektrote=
chnik
Institut f=C3=BCr Angewandte Mikroelektronik und Datentechnik

University of Rostock, Department of CS and EE
Institute of Applied Microelectronics and CE

Richard-Wagner-Stra=C3=9Fe 31
18119 Rostock
Deutschland/Germany

phone: +49 (0) 381 498 - 7278
email: Benjamin.Beichler@uni-rostock.de
www: http://www.imd.uni-rostock.de/
