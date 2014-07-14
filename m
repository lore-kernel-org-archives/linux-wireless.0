Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:10390 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754683AbaGNNK2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Jul 2014 09:10:28 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <ath6kl@lists.infradead.org>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 6/6] ath6kl: properly null terminate the firmware string
References: <20140617093836.22040.99081.stgit@potku.adurom.net>
	<20140617094121.22040.35356.stgit@potku.adurom.net>
Date: Mon, 14 Jul 2014 16:02:24 +0300
In-Reply-To: <20140617094121.22040.35356.stgit@potku.adurom.net> (Kalle Valo's
	message of "Tue, 17 Jun 2014 12:41:21 +0300")
Message-ID: <874mykm6u7.fsf@kamboji.qca.qualcomm.com> (sfid-20140714_151030_943741_52417AC3)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo <kvalo@qca.qualcomm.com> writes:

> The firmware version read from the firmware image is not null terminated and
> because of that there were few bytes of garbage after the firmware string:
>
> [10420.164632] ath6kl: ar6004 hw 3.0 usb fw 3.5.0.300-1^A api 4
>
> Add proper null termination to ath6kl_fetch_fw_apin() clean the firmware
> version string.
>
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>

This one introduces a new warning and I need to drop it:

drivers/net/wireless/ath/ath10k/debug.c:671:2: warning: right shift count >= width of type [enabled by default]
drivers/net/wireless/ath/ath6kl/init.c:999 ath6kl_fetch_fw_apin() error: buffer overflow 'ar->wiphy->fw_version' 32 <= 32
wmi.c:(.text+0xd96373): undefined reference to `ath10k_dbg_save_fw_dbg_buffer'

-- 
Kalle Valo
