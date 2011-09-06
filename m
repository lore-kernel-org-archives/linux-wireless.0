Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63993 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752936Ab1IFHWH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Sep 2011 03:22:07 -0400
Received: by gxk21 with SMTP id 21so3758648gxk.19
        for <linux-wireless@vger.kernel.org>; Tue, 06 Sep 2011 00:22:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E65C0EB.105@qca.qualcomm.com>
References: <1315215774-13931-1-git-send-email-nataraja@qca.qualcomm.com>
	<4E65C0EB.105@qca.qualcomm.com>
Date: Tue, 6 Sep 2011 12:52:05 +0530
Message-ID: <CAJqpcCTQa2m413JgrS8qqcNNguEUPz3oRP0V5cTBKEfWn1Q5OA@mail.gmail.com> (sfid-20110906_092210_553839_2815F28F)
Subject: Re: [PATCH] ath6kl: Process regulatory requests from firmware.
From: Vivek Natarajan <vivek.natraj@gmail.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: Vivek Natarajan <nataraja@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 6, 2011 at 12:12 PM, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> On 09/05/2011 12:42 PM, Vivek Natarajan wrote:
>> Process the regulatory code from eeprom and pass the
>> country information to cfg80211.
...
>> +     else if (!(((u16) reg_code & WORLD_SKU_MASK) == WORLD_SKU_PREFIX)) {
>> +
>> +             regpair = ath6kl_get_regpair((u16) reg_code);
>> +             country = ath6kl_regd_find_country_by_rd((u16) reg_code);
>> +             printk(KERN_DEBUG "ath6kl: Regpair used: 0x%0x\n",
>> +                             regpair->regDmnEnum);
>
> ath6kl_dbg() is more approriate here.
>
>> +             regulatory_hint(wmi->parent_dev->wdev->wiphy, alpha2);
>> +
>> +             printk(KERN_DEBUG "ath6kl: Country alpha2 being used: %c%c\n",
>> +                             alpha2[0], alpha2[1]);
>
> Please use ath6kl_dbg() or, if we really need to log this, you can use
> ath6kl_info(). But is there a reason to log this everytime?

I had kept this print similar to ath9k. Anyhow, cfg80211 also prints
the country code from the driver. So, I will change this to
ath6kl_dbg.

Thanks
Vivek.
