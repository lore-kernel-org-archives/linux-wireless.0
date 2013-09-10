Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f176.google.com ([209.85.223.176]:55086 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751654Ab3IJOE6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 10:04:58 -0400
Received: by mail-ie0-f176.google.com with SMTP id w15so471528iea.7
        for <linux-wireless@vger.kernel.org>; Tue, 10 Sep 2013 07:04:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1378794898.4799.37.camel@porter.coelho.fi>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
	<1378218848-7853-3-git-send-email-eliad@wizery.com>
	<1378794898.4799.37.camel@porter.coelho.fi>
Date: Tue, 10 Sep 2013 16:04:57 +0200
Message-ID: <CAB3XZEdNkEAsC8mz_jpz8UmjnK_pBwfGSChZQLGiuhtd0Q9Wnw@mail.gmail.com> (sfid-20130910_160501_568843_F23E5806)
Subject: Re: [PATCH 03/12] wlcore: disable elp sleep while in plt mode
From: Eliad Peller <eliad@wizery.com>
To: Luca Coelho <luca@coelho.fi>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 10, 2013 at 9:34 AM, Luca Coelho <luca@coelho.fi> wrote:
> On Tue, 2013-09-03 at 17:33 +0300, Eliad Peller wrote:
>> From: Yair Shapira <yair.shapira@ti.com>
>>
>> We now disable elp sleep during plt mode to allow normal operation of
>> plt tools such as calibrator.
>>
>> Having elp_sleep enabled during plt mode is actually not required and
>> in fact it disrupt plt operations such as rx statistics etc.
>>
>> Signed-off-by: Yair Shapira <yair.shapira@ti.com>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>
> I also had a comment internally about this one.  Why do we need this?
> AFAICT this would never happen in real life, since the firmware is not
> even loaded at this point.  Is there any real life situation where we
> try to go into ELP while in PLT mode?
>
i'm not familiar with the whole plt process, but i guess some flows
might indeed end up in elp (e.g. via wl1271_cmd_interrogate(), in
order to read statistics)

Eliad.
