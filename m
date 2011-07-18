Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog111.obsmtp.com ([74.125.149.205]:37429 "EHLO
	na3sys009aog111.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745Ab1GRIrH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Jul 2011 04:47:07 -0400
Received: by mail-ww0-f48.google.com with SMTP id 14so3102799wwi.29
        for <linux-wireless@vger.kernel.org>; Mon, 18 Jul 2011 01:47:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABB-i1fk3i5HOWEsgVSaQcE2-Bu8cYdnDH9pKjP7eeRS2oaUxg@mail.gmail.com>
References: <1310647673-10144-1-git-send-email-geryk@ti.com>
	<1310647673-10144-2-git-send-email-geryk@ti.com>
	<874o2nx16b.fsf@purkki.adurom.net>
	<CABB-i1foCSozXa1ZacqNPf_-vEUrw9uv+V6rraFhM-FoNoo3qg@mail.gmail.com>
	<CABB-i1eXpgA7iiHmrstFBnNjGntUtydQFBL17SJELqt5HU8g3A@mail.gmail.com>
	<87aaccvaxr.fsf@purkki.adurom.net>
	<8762n0ukdu.fsf@purkki.adurom.net>
	<CABB-i1fk3i5HOWEsgVSaQcE2-Bu8cYdnDH9pKjP7eeRS2oaUxg@mail.gmail.com>
Date: Mon, 18 Jul 2011 11:47:04 +0300
Message-ID: <CABB-i1e0T0CX6L9N003XniuKyDubUR9whBuAncM8ftZa7s=xxQ@mail.gmail.com> (sfid-20110718_104710_965996_97D71FCC)
Subject: Re: [PATCH 2/2] wl12xx Export chip id to sysfs
From: "Kahn, Gery" <geryk@ti.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: linux-wireless@vger.kernel.org, Luciano Coelho <coelho@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 18, 2011 at 11:39, Kahn, Gery <geryk@ti.com> wrote:
> On Mon, Jul 18, 2011 at 10:18, Kalle Valo <kvalo@adurom.com> wrote:
>> Kalle Valo <kvalo@adurom.com> writes:
>>
>>>> After some investigation, found that ethtool's ioctl interface doesn't work
>>>> at this case.
>>>
>>> This reminds me: I have patches for these issues but I never sent them
>>> upstream. It's too late for me now, but I'll search them tomorrow (or
>>> today to be exact..) and send them for testing purposes.
>>
>> Here's the patch I used:
>>
>> diff --git a/net/core/ethtool.c b/net/core/ethtool.c
>> index 74ead9e..0836aa3 100644
>> --- a/net/core/ethtool.c
>> +++ b/net/core/ethtool.c
>> @@ -1185,7 +1185,7 @@ static int ethtool_get_regs(struct net_device *dev, char __user *useraddr)
>>  {
>>        struct ethtool_regs regs;
>>        const struct ethtool_ops *ops = dev->ethtool_ops;
>> -       void *regbuf;
>> +       void *regbuf = NULL;
>>        int reglen, ret;
>>
>>        if (!ops->get_regs || !ops->get_regs_len)
>> @@ -1198,18 +1198,24 @@ static int ethtool_get_regs(struct net_device *dev, char __user *useraddr)
>>        if (regs.len > reglen)
>>                regs.len = reglen;
>>
>> -       regbuf = vzalloc(reglen);
>> -       if (!regbuf)
>> -               return -ENOMEM;
>> +       if (reglen > 0) {
>> +               regbuf = vzalloc(reglen);
>> +               if (!regbuf)
>> +                       return -ENOMEM;
>> +       }
>>
>>        ops->get_regs(dev, &regs, regbuf);
>>
>>        ret = -EFAULT;
>>        if (copy_to_user(useraddr, &regs, sizeof(regs)))
>>                goto out;
>> -       useraddr += offsetof(struct ethtool_regs, data);
>> -       if (copy_to_user(useraddr, regbuf, regs.len))
>> -               goto out;
>> +
>> +       if (regs.len > 0) {
>> +               useraddr += offsetof(struct ethtool_regs, data);
>> +               if (copy_to_user(useraddr, regbuf, regs.len))
>> +                       goto out;
>> +       }
>> +
>>        ret = 0;
>>
>>  out:
>>
>
> Tested-by: Gery Kahn <geryk@ti.com>
>
I wanted to add thank you for sending your and reviewing my patch.

It is good to have you around.

Gery
