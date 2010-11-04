Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61014 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab0KDWFU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Nov 2010 18:05:20 -0400
Received: by iwn41 with SMTP id 41so8131iwn.19
        for <linux-wireless@vger.kernel.org>; Thu, 04 Nov 2010 15:05:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTik0tawXfer2DMSKFXZwFbjYWLoG3nRBYMAMO8WL@mail.gmail.com>
References: <1288822429-24541-1-git-send-email-notasas@gmail.com>
 <1288822429-24541-3-git-send-email-notasas@gmail.com> <AANLkTimfXO9r=DTW3CAiVswmsoKES2qxEiYz4JBOTGu_@mail.gmail.com>
 <AANLkTik0tawXfer2DMSKFXZwFbjYWLoG3nRBYMAMO8WL@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 4 Nov 2010 18:04:58 -0400
Message-ID: <AANLkTimtryH0HTWk0ymK6EY1XcCPv6eLDYM-GzuJxhEy@mail.gmail.com>
Subject: Re: [PATCH 2/3] wl1251: add runtime PM support for SDIO
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: linux-wireless@vger.kernel.org, Kalle Valo <kvalo@adurom.com>,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 4, 2010 at 10:37 AM, Grazvydas Ignotas <notasas@gmail.com> wrote:
> On Thu, Nov 4, 2010 at 3:51 PM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
>> On Wed, Nov 3, 2010 at 6:13 PM, Grazvydas Ignotas <notasas@gmail.com> wrote:
>>> Add runtime PM support, similar to how it's done for wl1271.
>>> This allows to power down the card when the driver is loaded but
>>> network is not in use.
>>>
>>> CC: Ohad Ben-Cohen <ohad@wizery.com>
>>> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>
>>> ---
>>>  drivers/net/wireless/wl1251/sdio.c |   62 ++++++++++++++++++++++++++++++++++--
>>>  1 files changed, 59 insertions(+), 3 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/wl1251/sdio.c b/drivers/net/wireless/wl1251/sdio.c
>>> index 0285190..0a5db21 100644
>>> --- a/drivers/net/wireless/wl1251/sdio.c
>>> +++ b/drivers/net/wireless/wl1251/sdio.c
>>> @@ -26,6 +26,7 @@
>>>  #include <linux/platform_device.h>
>>>  #include <linux/wl12xx.h>
>>>  #include <linux/irq.h>
>>> +#include <linux/pm_runtime.h>
>>>
>>>  #include "wl1251.h"
>>>
>>> @@ -173,10 +174,36 @@ static void wl1251_disable_line_irq(struct wl1251 *wl)
>>>
>>>  static int wl1251_sdio_set_power(struct wl1251 *wl, bool enable)
>>>  {
>>> -       if (wl->set_power)
>>> -               wl->set_power(enable);
>>> +       struct sdio_func *func = wl_to_func(wl);
>>> +       int ret;
>>>
>>> -       return 0;
>>> +       if (enable) {
>>> +               /* Power up the card */
>>> +               if (wl->set_power)
>>> +                       wl->set_power(true);
>>
>> Why do you still need that ->set_power() handler ?
>
> On pandora besides power, we also have a GPIO to control clock buffer
> for wl1251, so I thought I could enable it here.

Oh, I see. The name set_power then is a bit misleading.. ;)

>  Perhaps it could be
> set up as regulator too, but I'm not sure how to set it up so that
> clock is enabled before main power. Also it's not really a power
> supply so it somehow felt wrong to set up regulator for it.
>
