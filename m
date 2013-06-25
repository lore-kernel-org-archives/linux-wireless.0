Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:38943 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab3FYPIX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Jun 2013 11:08:23 -0400
Received: by mail-wg0-f48.google.com with SMTP id f11so9454247wgh.27
        for <linux-wireless@vger.kernel.org>; Tue, 25 Jun 2013 08:08:22 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1372171926-2686-1-git-send-email-zajec5@gmail.com>
References: <1372171926-2686-1-git-send-email-zajec5@gmail.com>
Date: Tue, 25 Jun 2013 17:08:22 +0200
Message-ID: <CA+BoTQnda59qziwwjVfH7zCmQipED7TuxsDg0RgWA7ZK78gALQ@mail.gmail.com> (sfid-20130625_170832_288573_AEB1D6B2)
Subject: Re: [RFH][PATCH] bcma: add support for BCM43142
From: Michal Kazior <michal.kazior@tieto.com>
To: =?ISO-8859-2?Q?Rafa=B3_Mi=B3ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 25 June 2013 16:52, Rafał Miłecki <zajec5@gmail.com> wrote:
> I got following problem with the patch:
>   CC [M]  drivers/bcma/driver_chipcommon_pmu.o
> drivers/bcma/driver_chipcommon_pmu.c: In function ‘bcma_pmu2_pll_init0’:
> drivers/bcma/driver_chipcommon_pmu.c:128:5: warning: large integer implicitly truncated to unsigned type [-Woverflow]
>
> This is caused by:
> mask = ~(BCMA_RES_4314_HT_AVAIL |
>          BCMA_RES_4314_MACPHY_CLK_AVAIL);
>
> Any idea why
> u32 mask = ~(BIT(28) | BIT(29))
> causes that? :|
>
> I could expect that in case of using BIT(31), but not 28/29...

Are you perhaps compiling for a 64bit target? If so then I you're
dealing with a 64bit bitmask here. Negating ends up as an overflow as
you try to cram it into the 32bit var.
