Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f219.google.com ([209.85.218.219]:51081 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753869Ab0DMVea convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 13 Apr 2010 17:34:30 -0400
Received: by bwz19 with SMTP id 19so7541bwz.21
        for <linux-wireless@vger.kernel.org>; Tue, 13 Apr 2010 14:34:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87fx2znuzq.fsf@purkki.valot.fi>
References: <1271110884-18545-1-git-send-email-notasas@gmail.com>
	 <87fx2znuzq.fsf@purkki.valot.fi>
Date: Wed, 14 Apr 2010 00:34:28 +0300
Message-ID: <q2k6ed0b2681004131434ma73a9d77yf13e2469e8c49def@mail.gmail.com>
Subject: Re: [PATCH] wl1251: read default MAC address from EEPROM when
	available
From: Grazvydas Ignotas <notasas@gmail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 13, 2010 at 8:05 PM, Kalle Valo <kvalo@adurom.com> wrote:
> Grazvydas Ignotas <notasas@gmail.com> writes:
>
>> Some wl1251 hardware configurations (like in WG7210 module) have
>> EEPROM attached where NVS data is kept, which includes MAC address.
>>
>> In such configurations, let's read default MAC address from EEPROM,
>> instead of using random one.
>
> This also looks good, just one comment:
>
>> +static int wl1251_read_eeprom_byte(struct wl1251 *wl, off_t offset, u8 *data)
>> +{
>> +     unsigned long timeout;
>> +
>> +     wl1251_reg_write32(wl, EE_ADDR, offset);
>> +     wl1251_reg_write32(wl, EE_CTL, EE_CTL_READ);
>> +
>> +     /* EE_CTL_READ clears when data is ready */
>> +     timeout = jiffies + msecs_to_jiffies(100);
>> +     while (1) {
>> +             if (!(wl1251_reg_read32(wl, EE_CTL) & EE_CTL_READ))
>> +                     break;
>> +
>> +             if (time_after(jiffies, timeout))
>> +                     return -ETIMEDOUT;
>> +
>> +             udelay(200);
>> +     }
>
> Is the udelay() really needed here? In my opinion msleep(), for
> example with a value of 5 ms, would be nicer from system point of
> view. It doesn't matter if this function takes few milliseconds
> longer, because this is called only in op_start(). What do you think?

It normally takes something like 700-1000us, so I guess I can replace
with msleep(1) if you think it's better.
