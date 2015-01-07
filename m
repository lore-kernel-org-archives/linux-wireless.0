Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:38332 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493AbbAGPEc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Jan 2015 10:04:32 -0500
Date: Wed, 7 Jan 2015 20:34:16 +0530
From: Rajkumar <rmanohar@qti.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix build error when hwmon is off
Message-ID: <20150107150413.GA13894@qca.qualcomm.com> (sfid-20150107_160540_854596_1FD9EA66)
References: <1419420240-11208-1-git-send-email-rmanohar@qti.qualcomm.com>
 <871tn6u0c5.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <871tn6u0c5.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 07, 2015 at 04:33:46PM +0200, Kalle Valo wrote:
> Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:
> 
> > Place hwmon APIs inside CONFIG_HWMON switch to fix undefined
> > errors when hwmon is not enabled.
> >
> > ERROR: "devm_hwmon_device_register_with_groups"
> > [drivers/net/wireless/ath/ath10k/ath10k_core.ko] undefined!
> >
> > Reported-by: Kalle Valo <kvalo@qca.qualcomm.com>
> > Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
> 
> Thanks, but this has too many ifdefs for my taste. I have another idea,
> let me send v2 shortly.
>
Got you ;)
Having seperate register/unregister APIs for hwmon ops reduce switches.

-Rajkumar
