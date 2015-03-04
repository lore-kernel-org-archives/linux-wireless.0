Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:47808 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932150AbbCDObI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Mar 2015 09:31:08 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Jim Davis <jim.epost@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
	linux-next <linux-next@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>, zajec5@gmail.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: randconfig build error with next-20150303, in drivers/bcma/driver_pcie2.c
References: <CA+r1Zhio+Kp30y4DHS0SW20PjZrAY3PZLXjskykpa8CY0tcrMA@mail.gmail.com>
Date: Wed, 04 Mar 2015 16:31:00 +0200
In-Reply-To: <CA+r1Zhio+Kp30y4DHS0SW20PjZrAY3PZLXjskykpa8CY0tcrMA@mail.gmail.com>
	(Jim Davis's message of "Tue, 3 Mar 2015 09:11:39 -0700")
Message-ID: <87d24o7s2j.fsf@kamboji.qca.qualcomm.com> (sfid-20150304_153219_596372_36281CAF)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jim Davis <jim.epost@gmail.com> writes:

> Building with the attached random configuration file,
>
> drivers/bcma/driver_pcie2.c: In function 'bcma_core_pcie2_up':
> drivers/bcma/driver_pcie2.c:196:2: error: implicit declaration of
> function 'pcie_set_readrq' [-Werror=implicit-function-declaration]
>   err = pcie_set_readrq(dev, pcie2->reqsize);
>   ^

This should fix it:

bcma: add missing includes

https://git.kernel.org/cgit/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=2264fc857decd45798368f46861d9aecac23546f

-- 
Kalle Valo
