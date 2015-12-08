Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:37439 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779AbbLHO42 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Dec 2015 09:56:28 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	ath9k-devel@qca.qualcomm.com, nbd@openwrt.org
Subject: Re: [PATCH V2] ath9k: Simplify and fix eeprom endianness swapping
References: <1444862012-25376-2-git-send-email-martin.blumenstingl@googlemail.com>
	<1446296252-11083-1-git-send-email-martin.blumenstingl@googlemail.com>
Date: Tue, 08 Dec 2015 16:56:21 +0200
In-Reply-To: <1446296252-11083-1-git-send-email-martin.blumenstingl@googlemail.com>
	(Martin Blumenstingl's message of "Sat, 31 Oct 2015 13:57:32 +0100")
Message-ID: <87oae19ega.fsf@kamboji.qca.qualcomm.com> (sfid-20151208_155631_170476_EAD35239)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Martin Blumenstingl <martin.blumenstingl@googlemail.com> writes:

> The three eeprom implementations had quite some duplicate code when it
> came to endianness swapping.
> Additionally there was a bug in eeprom_4k and eeprom_9287 which
> prevented the endianness swapping from working correctly, because the
> swapping code was guarded within an "if (!ath9k_hw_use_flash(ah))". In
> eeprom_def this check did not exist, so it seems that eeprom_def was the
> only implementation where endianness swapping worked.
>
> This patch takes the duplicate code and moves it from eeprom_* to
> eeprom.c. The new code is derived from eeprom_def, while taking into
> account the specifics from the other implementations.
>
> Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>

Applied to ath.git, thanks.

-- 
Kalle Valo
