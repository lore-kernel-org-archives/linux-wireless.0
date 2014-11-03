Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:23299 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbaKCXDM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2014 18:03:12 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
CC: "John W. Linville" <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <ldv-project@linuxtesting.org>
Subject: Re: [PATCH] ath6kl: remove incorrect reset_resume handler
References: <1414180972-16413-1-git-send-email-khoroshilov@ispras.ru>
Date: Tue, 4 Nov 2014 01:02:58 +0200
In-Reply-To: <1414180972-16413-1-git-send-email-khoroshilov@ispras.ru> (Alexey
	Khoroshilov's message of "Sat, 25 Oct 2014 00:02:52 +0400")
Message-ID: <87h9yf7uql.fsf@kamboji.qca.qualcomm.com> (sfid-20141104_000322_276481_D210F6EA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alexey Khoroshilov <khoroshilov@ispras.ru> writes:

> Existing implementation of reset_resume handler just calls
> ath6kl_usb_remove() that deallocates all resources.
> It can lead to double free, etc. on disconnect.
>
> The patch removes reset_resume handler,
> so usb core could conservatively reset the driver.
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Alexey Khoroshilov <khoroshilov@ispras.ru>

Thanks, applied.

-- 
Kalle Valo
