Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:44072 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330AbaI2GZH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Sep 2014 02:25:07 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sujith Manoharan <sujith@msujith.org>
CC: John Linville <linville@tuxdriver.com>,
	<linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH v2] ath: Add support for tracing
References: <1411804665-6954-1-git-send-email-sujith@msujith.org>
Date: Mon, 29 Sep 2014 09:25:00 +0300
In-Reply-To: <1411804665-6954-1-git-send-email-sujith@msujith.org> (Sujith
	Manoharan's message of "Sat, 27 Sep 2014 13:27:45 +0530")
Message-ID: <87vbo72bb7.fsf@kamboji.qca.qualcomm.com> (sfid-20140929_082512_828365_765FCA79)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan <sujith@msujith.org> writes:

> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/Kconfig  |  8 +++++
>  drivers/net/wireless/ath/Makefile |  4 +++
>  drivers/net/wireless/ath/ath.h    |  1 +
>  drivers/net/wireless/ath/main.c   |  3 ++
>  drivers/net/wireless/ath/trace.c  | 20 +++++++++++
>  drivers/net/wireless/ath/trace.h  | 71 +++++++++++++++++++++++++++++++++++++++

Why add it to ath.ko module? What drivers are going to use this?

Because all ath* drivers are different, I suspect there is not that much
to share between drivers and that's why it would be better to have the
trace points per driver.

And I just checked that currently we have trace points for ath10k,
ath5k, ath6kl and wil6210. IMHO adding more trace points to ath.ko just
makes this confusing.

-- 
Kalle Valo
