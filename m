Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.uni-rostock.de ([139.30.22.72]:56087 "EHLO
        mx1.uni-rostock.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751688AbdLKNCg (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 08:02:36 -0500
Subject: Re: [PATCH v2 3/5] mac80211_hwsim: add generation count for netlink
 dump operation
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
References: <20171121121744.23422-1-benjamin.beichler@uni-rostock.de>
 <7ee141a4-8983-4da6-9c0f-f070fa6e5611@MAIL2.uni-rostock.de>
 <1512994493.26976.74.camel@sipsolutions.net>
 <8264ae6e-7db6-53b0-88c0-4ac4e51d0ba3@uni-rostock.de>
 <1512996543.26976.76.camel@sipsolutions.net>
From: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Message-ID: <5afe6ce9-5d7a-2b8e-f2bc-32088aacb9fe@uni-rostock.de> (sfid-20171211_140239_557896_E6E4EE77)
Date: Mon, 11 Dec 2017 14:02:56 +0100
MIME-Version: 1.0
In-Reply-To: <1512996543.26976.76.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 11.12.2017 um 13:49 schrieb Johannes Berg:
> On Mon, 2017-12-11 at 13:37 +0100, Benjamin Beichler wrote:
>> Am 11.12.2017 um 13:14 schrieb Johannes Berg:
>>> On Tue, 2017-11-21 at 13:17 +0100, Benjamin Beichler wrote:
>>>> Make the dump operation aware of changes on radio list and correspon=
ding
>>>> inconsistent dumps. Change the dump iteration to be independent from=

>>>> increasing radio indices on radio list.
>>> Looks like this should use nl_dump_check_consistent()?
>>>
>>> johannes
>>>
>> It is called in mac80211_hwsim_get_radio, I didn't changed that.
> But you added this:
>
> +       /* list changed */
> +       if (cb->prev_seq && cb->seq !=3D cb->prev_seq)
> +               goto cleanup;
>
> which is mostly just a copy of the inline.
>
> johannes
Year you are right, but for nl_dump_check_consistent() I also need a
header struct to write the flag to it and I thought a ghost header only
to this function is also misleading. But if you think this is better, I
can do that. Or we introduce a function, which really only check
consistency and not also set the flag. I also thought the line is
readable at it's own, because it's simply inconsistent if the sequence
numbers are not equal.

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
