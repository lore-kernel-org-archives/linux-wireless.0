Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:40571 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754554Ab3IJGsO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Sep 2013 02:48:14 -0400
Received: by mail-pb0-f44.google.com with SMTP id xa7so7165336pbc.3
        for <linux-wireless@vger.kernel.org>; Mon, 09 Sep 2013 23:48:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1378794813.4799.35.camel@porter.coelho.fi>
References: <1378218848-7853-1-git-send-email-eliad@wizery.com>
 <1378218848-7853-2-git-send-email-eliad@wizery.com> <1378794813.4799.35.camel@porter.coelho.fi>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 10 Sep 2013 08:47:58 +0200
Message-ID: <CA+XVXfdiudFgdXVAugkHVBLPVgLyrsokosCyhpNd5c5G7DOcOg@mail.gmail.com> (sfid-20130910_084820_415647_E11B67FD)
Subject: Re: [PATCH 02/12] wlcore: add new plt power-mode: CHIP_AWAKE
To: Luca Coelho <luca@coelho.fi>
Cc: Eliad Peller <eliad@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 10, 2013 at 9:33 AM, Luca Coelho <luca@coelho.fi> wrote:
> On Tue, 2013-09-03 at 17:33 +0300, Eliad Peller wrote:
>> From: Yair Shapira <yair.shapira@ti.com>
>>
>> Under this mode the chip is powered on including sdio
>> but no FW is downloaded and run, interrupts are not enabled, etc...
>>
>> This mode is intended to allow RTTT to bridge sdio as a transport
>> to the chip.
>>
>> Driver only provides sdio access using the dev_mem debugfs file.
>>
>> Some fixes done to the code that ensures that PLT mode and normal
>> driver power mode (ifconfig/add_interface) are mutually excluded.
>>
>> Signed-off-by: Yair Shapira <yair.shapira@ti.com>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>
> I had some comments to this patch internally while I was still at TI.
> Namely, I asked why do we need a new way of doing this if this is
> already possible via debugsfs (using the gpio_power file)?

Are you commenting on the correct patch? Seems this is just a patch to
prevent "ifconfig up" during PLT mode..
