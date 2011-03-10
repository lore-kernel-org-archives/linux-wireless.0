Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:33566 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751852Ab1CJPQA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Mar 2011 10:16:00 -0500
To: Grazvydas Ignotas <notasas@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	David Gnedt <david.gnedt@davizone.at>
Subject: Re: [PATCH 2/2] wl1251: fix elp_work race condition
References: <1299432217-32139-1-git-send-email-notasas@gmail.com>
	<1299432217-32139-3-git-send-email-notasas@gmail.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Thu, 10 Mar 2011 17:15:58 +0200
In-Reply-To: <1299432217-32139-3-git-send-email-notasas@gmail.com> (Grazvydas Ignotas's message of "Sun\,  6 Mar 2011 19\:23\:37 +0200")
Message-ID: <87vczrypjl.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grazvydas Ignotas <notasas@gmail.com> writes:

> While working on PS I've noticed elp_work is kicking rather often, and
> sometimes the chip is put to sleep before 5ms delay expires. This
> seems to happen because by the time wl1251_ps_elp_wakeup is called
> elp_work might still be pending. After wakeup is done, the processing
> may take some time, during which 5ms might expire and elp_work might
> get scheduled. In this case, ss soon as 1st thread finishes work and
> releases the mutex, elp_work will then put the device to sleep without
> 5ms delay. In addition 1st thread will queue additional elp_work
> needlessly.
>
> Fix this by cancelling work in wl1251_ps_elp_wakeup instead.

Thanks for debugging this.

> Signed-off-by: Grazvydas Ignotas <notasas@gmail.com>

Acked-by: Kalle Valo <kvalo@adurom.com>

-- 
Kalle Valo
