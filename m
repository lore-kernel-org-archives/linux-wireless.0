Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36144 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753367Ab1FZLvL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Jun 2011 07:51:11 -0400
MIME-Version: 1.0
In-Reply-To: <1307662827-16618-1-git-send-email-ohad@wizery.com>
References: <1307662827-16618-1-git-send-email-ohad@wizery.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 26 Jun 2011 14:50:50 +0300
Message-ID: <BANLkTi=JcXG04coTJCA=fvwxXzuRsYzT4Q@mail.gmail.com> (sfid-20110626_135353_584962_2AF1AE9F)
Subject: Re: [PATCH] mmc: sdio: fix runtime PM path during driver removal
To: linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Chris,

On Fri, Jun 10, 2011 at 2:40 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> After commit e1866b3 "PM / Runtime: Rework runtime PM handling
> during driver removal" was introduced, the driver core stopped
> incrementing the runtime PM usage counter of the device during
> the invocation of the ->remove() callback.
>
> This indirectly broke SDIO's runtime PM path during driver removal,
> because no one calls _put_sync() anymore after ->remove() completes.
>
> This means that the power of runtime-PM-managed SDIO cards is kept
> high after their driver is removed (even if it was powered down
> beforehand).
>
> Fix that by directly calling _put_sync() when the last usage
> counter is downref'ed by the SDIO bus.

Can you please take this 1-liner into 3.0-rc ?

It fixes SDIO runtime PM after a breakage was introduced in 3.0.

Thanks,
Ohad.
