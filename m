Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37067 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797Ab2LQKB7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Dec 2012 05:01:59 -0500
Received: by mail-vc0-f174.google.com with SMTP id d16so6830210vcd.19
        for <linux-wireless@vger.kernel.org>; Mon, 17 Dec 2012 02:01:59 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALx5=V8SgDV+R8YGNgP3=_qNMJgf9AC82fA1vr9yCyW8n8T4NA@mail.gmail.com>
References: <1355737393-8143-1-git-send-email-machen@suse.com>
	<CAOZOX0VGuDecDuVXZZcTucPLJ6Pkm-EPZacLA4quCxvt4CwZMA@mail.gmail.com>
	<CALx5=V8SgDV+R8YGNgP3=_qNMJgf9AC82fA1vr9yCyW8n8T4NA@mail.gmail.com>
Date: Mon, 17 Dec 2012 11:01:59 +0100
Message-ID: <CAOZOX0Vum6pFV5qWuabrP3i8qLyj6CDGu-zxkzfCecC-wXQ1sA@mail.gmail.com> (sfid-20121217_110204_369165_7638B1F8)
Subject: Re: [rt2x00-users] [PATCH] rt2800lib : Add a patch to disable/enable
 power save mode.
From: Ivo Van Doorn <ivdoorn@gmail.com>
To: Matt Chen <machen@suse.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	rt2x00 Users List <users@rt2x00.serialmonkey.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 17, 2012 at 10:57 AM, Matt Chen <machen@suse.com> wrote:
>
>
> 2012/12/17 Ivo Van Doorn <ivdoorn@gmail.com>
>>
>> On Mon, Dec 17, 2012 at 10:43 AM, Chen, Chien-Chia <machen@suse.com>
>> wrote:
>> > This patch is to enable/disable power save mode. rt2800lib
>> > disables PCI WLAN module power save mode default. It allows
>> > to enable the power save mode.
>>
>> And what is wrong by doing this using the 'iwconfig'/'iw' tools?
>
> Compared with iwlwifi [modinfo iwlwifi], it provides the parameter in
> driver.

I don't consider that a valid excuse.

>> > Sign-off-by: Chen, Chien-Chia <matt680209@gmail.com>

NACK

There is no point on having this as module parameter, there are sufficient
userspace tools to control it already. Having it as a module parameter, is
just redundant.

Ivo

>> > ---
>> >  drivers/net/wireless/rt2x00/rt2800lib.c |   10 +++++++++-
>> >  1 files changed, 9 insertions(+), 1 deletions(-)
>> >
>> > diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c
>> > b/drivers/net/wireless/rt2x00/rt2800lib.c
>> > index 197b446..8ddbf83 100644
>> > --- a/drivers/net/wireless/rt2x00/rt2800lib.c
>> > +++ b/drivers/net/wireless/rt2x00/rt2800lib.c
>> > @@ -44,6 +44,13 @@
>> >  #include "rt2800.h"
>> >
>> >  /*
>> > + * Allow power save mode to be disabled.
>> > + */
>> > +static bool power_save_disabled = true;
>> > +module_param(power_save_disabled, bool, 0444);
>> > +MODULE_PARM_DESC(power_save_disabled, " Disable power save. (default:
>> > disable. 1=disable, 0=enable.)");
>> > +
>> > +/*
>> >   * Register access.
>> >   * All access to the CSR registers will go through the methods
>> >   * rt2800_register_read and rt2800_register_write.
>> > @@ -5079,7 +5086,8 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev
>> > *rt2x00dev)
>> >         /*
>> >          * Disable powersaving as default on PCI devices.
>> >          */
>> > -       if (rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev))
>> > +       if ((rt2x00_is_pci(rt2x00dev) || rt2x00_is_soc(rt2x00dev)) &&
>> > +           power_save_disabled)
>> >                 rt2x00dev->hw->wiphy->flags &=
>> > ~WIPHY_FLAG_PS_ON_BY_DEFAULT;
>> >
>> >         /*
>> > --
>> > 1.6.0.2
>> >
>> > --
>> > To unsubscribe from this list: send the line "unsubscribe
>> > linux-wireless" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>> _______________________________________________
>> users mailing list
>> users@rt2x00.serialmonkey.com
>>
>> http://rt2x00.serialmonkey.com/mailman/listinfo/users_rt2x00.serialmonkey.com
>>
>
