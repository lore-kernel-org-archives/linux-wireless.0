Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:60899 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932080AbcEKSX0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 May 2016 14:23:26 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: Christian Daudt <csd@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list@broadcom.com,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH] brcmfmac: Fix 'did not remove int handler' warning
References: <1462405280-5947-1-git-send-email-csd@broadcom.com>
Date: Wed, 11 May 2016 21:23:19 +0300
In-Reply-To: <1462405280-5947-1-git-send-email-csd@broadcom.com> (Christian
	Daudt's message of "Wed, 4 May 2016 16:41:20 -0700")
Message-ID: <87d1ose9ns.fsf@kamboji.qca.qualcomm.com> (sfid-20160511_202329_870878_2C1D7A34)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Christian Daudt <csd@broadcom.com> writes:

> brcmf_sdiod_intr_unregister call that removes both func1 and
> func2 interrupt handlers only called when brcmf_ops_sdio_remove
> is called for func 1 (which is the 2nd call) but sdio is expecting
> it to be removed at the end of each sdio_remove call.
> This is causing 'rmmod bcmrfmac' on a 4356-sdio chip to complain
> with:
> WARNING: driver brcmfmac did not remove its interrupt handler!
>
> The modification makes calling brcmf_sdiod_intr_unregister multiple
> times harmless by clearing the variables that track if interrupt
> handlers have been installed, and then calls it on every
> brcmf_ops_sdio_remove call instead of just remove for func 1.
>
> Note: this needs to be applied on top of
> "[PATCH] Fix kernel oops in failed chip_attach"

If you submit two patches at the same time, and where one patch depends
on another, it's best to submit them in the same series ([PATCH 1/2] and
[PATCH 2/2]). So please submit v2 as a series, I'm dropping this.

-- 
Kalle Valo
