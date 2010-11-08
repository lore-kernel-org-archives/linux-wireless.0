Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36000 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753684Ab0KHN0X convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Nov 2010 08:26:23 -0500
Received: by vws13 with SMTP id 13so1743486vws.19
        for <linux-wireless@vger.kernel.org>; Mon, 08 Nov 2010 05:26:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87zktlxw58.fsf@purkki.adurom.net>
References: <1288822429-24541-1-git-send-email-notasas@gmail.com>
	<1288822429-24541-3-git-send-email-notasas@gmail.com>
	<87d3qhzbb6.fsf@purkki.adurom.net>
	<AANLkTinqr6iJdQcWGSjaf4F9i8+2MvjavgKUT8R0bsHK@mail.gmail.com>
	<87zktlxw58.fsf@purkki.adurom.net>
Date: Mon, 8 Nov 2010 15:26:22 +0200
Message-ID: <AANLkTi=Mrzy1ELZ+gGehjN0irfkuvSGAFNg1PTrFr_sz@mail.gmail.com>
Subject: Re: [PATCH 2/3] wl1251: add runtime PM support for SDIO
From: Grazvydas Ignotas <notasas@gmail.com>
To: Kalle Valo <kvalo@adurom.com>
Cc: Ohad Ben-Cohen <ohad@wizery.com>, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 7, 2010 at 12:31 PM, Kalle Valo <kvalo@adurom.com> wrote:
> Ohad Ben-Cohen <ohad@wizery.com> writes:
>
>> On Sun, Nov 7, 2010 at 12:18 PM, Kalle Valo <kvalo@adurom.com> wrote:
>>>> +static int wl1251_suspend(struct device *dev)
>>>> +{
>>>> +     /*
>>>> +      * Tell MMC/SDIO core it's OK to power down the card
>>>> +      * (if it isn't already), but not to remove it completely
>>>> +      */
>>>> +     return 0;
>>>> +}
>>>
>>> Sorry, I'm not familiar with pm_ops and I don't fully understand the
>>> comment above. Does the comment mean that by returning 0 we can
>>> accomplish all that?
>>
>> Yes. By returning 0 we let the MMC core power down our card, but not
>> remove it.
>
> Good, thanks for confirming that.

Thanks, updating comments and resending this one in a moment.
