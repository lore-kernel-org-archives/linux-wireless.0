Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58308 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab1JKKq0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 06:46:26 -0400
Received: by iaek3 with SMTP id k3so479497iae.19
        for <linux-wireless@vger.kernel.org>; Tue, 11 Oct 2011 03:46:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+XVXfdM7=G1YdWVYpzfKajRYu+sAJcfKSFkbtgneUPTPabQ=w@mail.gmail.com>
References: <1318326555-13905-1-git-send-email-eliad@wizery.com>
	<CA+XVXfdM7=G1YdWVYpzfKajRYu+sAJcfKSFkbtgneUPTPabQ=w@mail.gmail.com>
Date: Tue, 11 Oct 2011 12:46:25 +0200
Message-ID: <CAB3XZEeYm6k6ux-j1LiKNzHzAZq0ERcjiXb89_kX0jnmmLHCzA@mail.gmail.com> (sfid-20111011_124632_917795_610F6891)
Subject: Re: [PATCH v2 08/29] wl12xx: configure sleep_policy according to
 active roles
From: Eliad Peller <eliad@wizery.com>
To: Arik Nemtsov <anamtsov@gmail.com>
Cc: Luciano Coelho <coelho@ti.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 11, 2011 at 12:16 PM, Arik Nemtsov <anamtsov@gmail.com> wrote:
> On Tue, Oct 11, 2011 at 11:49, Eliad Peller <eliad@wizery.com> wrote:
>> If there is an active AP role, stay always on.
>> Otherwise, allow chip to enter elp.
>>
>> (Note that this is a global configuration, so if the
>> device is already configured according to our policy,
>> we don't have to configure it again)
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>> v2: use ap_count/sta_count instead of iterating
>> +       if (!wl->ap_count) {
>> +               if (is_ap) {
>> +                       /* Configure for power always on */
>> +                       ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_CAM);
>> +                       if (ret < 0)
>> +                               return ret;
>> +               } else if (!wl->sta_count) {
>> +                       /* Configure for ELP power saving */
>> +                       ret = wl1271_acx_sleep_auth(wl, WL1271_PSM_ELP);
>> +                       if (ret < 0)
>> +                               return ret;
>> +               }
>> +       }
>
> Probably need to add a symmetric part on remove_interface(). If ap was
> shutdown we can return to normal ELP.
>
right. that's why i added:
+       /*
+        * consider all existing roles before configuring psm.
+        * TODO: reconfigure on interface removal.
+        */

> btw, elp_work() still gets called even in AP-mode. I'm guessing it has
> no effect, but if you want to prevent the SDIO transaction from taking
> place (like you said on IRC), you can check for it :)
> (Just nitpicking here)

we are not in idle-on while beaconing, so elp_work should return
before configuring the chip.

Eliad.
