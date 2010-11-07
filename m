Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:52031 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251Ab0KGKbd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Nov 2010 05:31:33 -0500
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Grazvydas Ignotas <notasas@gmail.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/3] wl1251: add runtime PM support for SDIO
References: <1288822429-24541-1-git-send-email-notasas@gmail.com>
	<1288822429-24541-3-git-send-email-notasas@gmail.com>
	<87d3qhzbb6.fsf@purkki.adurom.net>
	<AANLkTinqr6iJdQcWGSjaf4F9i8+2MvjavgKUT8R0bsHK@mail.gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Sun, 07 Nov 2010 12:31:31 +0200
In-Reply-To: <AANLkTinqr6iJdQcWGSjaf4F9i8+2MvjavgKUT8R0bsHK@mail.gmail.com> (Ohad Ben-Cohen's message of "Sun\, 7 Nov 2010 12\:25\:35 +0200")
Message-ID: <87zktlxw58.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ohad Ben-Cohen <ohad@wizery.com> writes:

> On Sun, Nov 7, 2010 at 12:18 PM, Kalle Valo <kvalo@adurom.com> wrote:
>>> +static int wl1251_suspend(struct device *dev)
>>> +{
>>> +     /*
>>> +      * Tell MMC/SDIO core it's OK to power down the card
>>> +      * (if it isn't already), but not to remove it completely
>>> +      */
>>> +     return 0;
>>> +}
>>
>> Sorry, I'm not familiar with pm_ops and I don't fully understand the
>> comment above. Does the comment mean that by returning 0 we can
>> accomplish all that?
>
> Yes. By returning 0 we let the MMC core power down our card, but not
> remove it.

Good, thanks for confirming that.

-- 
Kalle Valo
