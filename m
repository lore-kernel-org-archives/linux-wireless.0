Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46144 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228Ab0KGKZ4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Nov 2010 05:25:56 -0500
Received: by iwn41 with SMTP id 41so2752941iwn.19
        for <linux-wireless@vger.kernel.org>; Sun, 07 Nov 2010 02:25:56 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87d3qhzbb6.fsf@purkki.adurom.net>
References: <1288822429-24541-1-git-send-email-notasas@gmail.com>
 <1288822429-24541-3-git-send-email-notasas@gmail.com> <87d3qhzbb6.fsf@purkki.adurom.net>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 7 Nov 2010 12:25:35 +0200
Message-ID: <AANLkTinqr6iJdQcWGSjaf4F9i8+2MvjavgKUT8R0bsHK@mail.gmail.com>
Subject: Re: [PATCH 2/3] wl1251: add runtime PM support for SDIO
To: Kalle Valo <kvalo@adurom.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 7, 2010 at 12:18 PM, Kalle Valo <kvalo@adurom.com> wrote:
>> +static int wl1251_suspend(struct device *dev)
>> +{
>> +     /*
>> +      * Tell MMC/SDIO core it's OK to power down the card
>> +      * (if it isn't already), but not to remove it completely
>> +      */
>> +     return 0;
>> +}
>
> Sorry, I'm not familiar with pm_ops and I don't fully understand the
> comment above. Does the comment mean that by returning 0 we can
> accomplish all that?

Yes. By returning 0 we let the MMC core power down our card, but not remove it.

> Or instead is it a fixme comment that we should
> do that, but it's not implemented yet?
>
> --
> Kalle Valo
>
