Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:35861 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280AbbGLMRt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jul 2015 08:17:49 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Oleksij Rempel <linux@rempel-privat.de>
Cc: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] ath9k_htc: introduce support for different fw versions
In-Reply-To: <1434394689-18781-1-git-send-email-linux@rempel-privat.de>
	(Oleksij Rempel's message of "Mon, 15 Jun 2015 20:58:09 +0200")
References: <CAGRGNgUWJ-LDgdxe1TJw2YOroMKaYDj3ehUu7j_zoqX17BxbjQ@mail.gmail.com>
	<1434394689-18781-1-git-send-email-linux@rempel-privat.de>
Date: Sun, 12 Jul 2015 15:17:41 +0300
Message-ID: <87oajhvaca.fsf@kamboji.qca.qualcomm.com> (sfid-20150712_141752_863911_209F0FCB)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Oleksij Rempel <linux@rempel-privat.de> writes:

> Current kernel support only one fw name with theoretically only one
> fw version. By replacing fw with other version we will break compatibility
> with older kernels.
>
> To avoid this kind of regression this patch will reuse fw version model
> from iwlwifi driver.
>
> Signed-off-by: Oleksij Rempel <linux@rempel-privat.de>

[...]

> +int htc_use_dev_fw = 0;
> +module_param_named(use_dev_fw, htc_use_dev_fw, int, 0444);
> +MODULE_PARM_DESC(use_dev_fw, "Use development FW version");

The commit log is really vague, please document properly how the
functionality changes from user point of view. And especially what does
this module parameter do? I'm a bit concerned about that.

-- 
Kalle Valo
