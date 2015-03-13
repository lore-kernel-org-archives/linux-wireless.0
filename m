Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:3811 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751589AbbCMQsb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 12:48:31 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: move driver state check before setting throttle
References: <1426097094-6225-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Fri, 13 Mar 2015 18:48:21 +0200
In-Reply-To: <1426097094-6225-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Wed, 11 Mar 2015 23:34:54 +0530")
Message-ID: <873858rgh6.fsf@kamboji.qca.qualcomm.com> (sfid-20150313_174835_058497_11C6265A)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> Since thermal daemon is unaware of the device state, it might
> try to adjust the throttle state when the device is powered down.
> So the driver caches the value and will configure it while
> powering up the target. The cached value will be programed later
> once the device is brought up. In such case, returning error
> status is confusing and misleading the user application. Hence
> moving the driver state check before sending wmi command to target.
>
> Reported-by: Matthias Kaehlcke <mka@google.com>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

What tree do you use as the baseline? Three-way merge doesn't work as
sha1 ids are not found:

Applying: ath10k: move driver state check before setting throttle
fatal: sha1 information is lacking or useless (drivers/net/wireless/ath/ath10k/thermal.c).
Repository lacks necessary blobs to fall back on 3-way merge.
Cannot fall back to three-way merge.
Patch failed at 0001 ath10k: move driver state check before setting throttle

-- 
Kalle Valo
