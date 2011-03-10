Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:33560 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752181Ab1CJPOD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 10:14:03 -0500
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	David Gnedt <david.gnedt@davizone.at>
Subject: Re: [PATCH 1/2] wl1251: remove wl1251_ps_set_elp function
References: <1299432217-32139-1-git-send-email-notasas@gmail.com>
	<1299432217-32139-2-git-send-email-notasas@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 10 Mar 2011 17:13:55 +0200
In-Reply-To: <1299432217-32139-2-git-send-email-notasas@gmail.com> (Grazvydas Ignotas's message of "Sun\,  6 Mar 2011 19\:23\:36 +0200")
Message-ID: <87zkp3ypn0.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grazvydas Ignotas <notasas@gmail.com> writes:

> wl1251_ps_set_elp() only does acx_sleep_auth call and takes the chip
> from/to ELP, however all callers of wl1251_ps_set_mode() have already
> taken the chip out of ELP and puts it back to ELP when they finish.
> This makes ELP calls (and register writes they result in) superfluous.
>
> So remove wl1251_ps_set_elp function and call acx_sleep_auth directly.

Thanks, makes sense to me.

> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>

Acked-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
