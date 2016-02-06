Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:53531 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751442AbcBFL4R convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 6 Feb 2016 06:56:17 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: =?utf-8?Q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky \(Zhenhui\) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH] brcmfmac: treat NULL character in NVRAM as separator
References: <1454238874-20118-1-git-send-email-zajec5@gmail.com>
Date: Sat, 06 Feb 2016 13:56:09 +0200
In-Reply-To: <1454238874-20118-1-git-send-email-zajec5@gmail.com>
 (=?utf-8?Q?=22Rafa=C5=82=09Mi=C5=82ecki=22's?= message of "Sun, 31 Jan 2016
 12:14:34 +0100")
Message-ID: <87io22uk6e.fsf@kamboji.qca.qualcomm.com> (sfid-20160206_125619_956288_7CB4EE02)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rafał Miłecki <zajec5@gmail.com> writes:

> Platform NVRAM (stored on a flash partition) has entries separated by a
> NULL (\0) char. Our parsing code switches from VALUE state to IDLE
> whenever it meets a NULL (\0). When that happens our IDLE handler should
> simply consume it and analyze whatever is placed ahead.
>
> This fixes harmless warnings spamming debugging output:
> [  155.165624] brcmfmac: brcmf_nvram_handle_idle warning: ln=1:col=20: ignoring invalid character
> [  155.180806] brcmfmac: brcmf_nvram_handle_idle warning: ln=1:col=44: ignoring invalid character
> [  155.195971] brcmfmac: brcmf_nvram_handle_idle warning: ln=1:col=63: ignoring invalid character
>
> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>

Manually applied to wireless-drivers-next.git, thanks.

-- 
Kalle Valo
