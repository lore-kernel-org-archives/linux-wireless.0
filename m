Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:45553 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751797Ab3IKID5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 04:03:57 -0400
Received: by mail-ie0-f176.google.com with SMTP id w15so2654357iea.7
        for <linux-wireless@vger.kernel.org>; Wed, 11 Sep 2013 01:03:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1378841057.4223.38.camel@porter.coelho.fi>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
	<1378218848-7853-3-git-send-email-eliad@wizery.com>
	<1378794898.4799.37.camel@porter.coelho.fi>
	<CAB3XZEdNkEAsC8mz_jpz8UmjnK_pBwfGSChZQLGiuhtd0Q9Wnw@mail.gmail.com>
	<1378841057.4223.38.camel@porter.coelho.fi>
Date: Wed, 11 Sep 2013 10:03:55 +0200
Message-ID: <CAB3XZEe8vJY4t7CbWAkzzCwsTqg0q=nGMqq9B_J-k=57feoP1g@mail.gmail.com> (sfid-20130911_100405_242419_DF7A0FE5)
Subject: Re: [PATCH 03/12] wlcore: disable elp sleep while in plt mode
From: Eliad Peller <eliad@wizery.com>
To: Luca Coelho <luca@coelho.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 10, 2013 at 10:24 PM, Luca Coelho <luca@coelho.fi> wrote:
> On Tue, 2013-09-10 at 16:04 +0200, Eliad Peller wrote:
>> On Tue, Sep 10, 2013 at 9:34 AM, Luca Coelho <luca@coelho.fi> wrote:
>> > On Tue, 2013-09-03 at 17:33 +0300, Eliad Peller wrote:
>> >> From: Yair Shapira <yair.shapira@ti.com>
>> >>
>> >> We now disable elp sleep during plt mode to allow normal operation of
>> >> plt tools such as calibrator.
>> >>
>> >> Having elp_sleep enabled during plt mode is actually not required and
>> >> in fact it disrupt plt operations such as rx statistics etc.
>> >>
>> >> Signed-off-by: Yair Shapira <yair.shapira@ti.com>
>> >> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> >> ---
>> >
>> > I also had a comment internally about this one.  Why do we need this?
>> > AFAICT this would never happen in real life, since the firmware is not
>> > even loaded at this point.  Is there any real life situation where we
>> > try to go into ELP while in PLT mode?
>> >
>> i'm not familiar with the whole plt process, but i guess some flows
>> might indeed end up in elp (e.g. via wl1271_cmd_interrogate(), in
>> order to read statistics)
>
> Well, I don't think this would ever happen.  The PLT stuff is a
> completely different firmware and, really, if it tries to go into ELP
> mode it is a bug.
>
i can see the calibrator calls various WL1271_TM_CMD_TEST commands, so
i guess they are likely to end up with ps_elp_sleep() calls (in
wl1271_tm_cmd_test()).

Eliad.
