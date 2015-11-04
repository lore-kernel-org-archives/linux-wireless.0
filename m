Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth02.qualcomm.com ([65.197.215.38]:21290 "EHLO
	sabertooth02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060AbbKDRq3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Nov 2015 12:46:29 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix invalid NSS for 4x4 devices
References: <1446531693-23453-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Wed, 4 Nov 2015 19:46:11 +0200
In-Reply-To: <1446531693-23453-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Tue, 3 Nov 2015 11:51:33 +0530")
Message-ID: <87pozpbqu4.fsf@kamboji.qca.qualcomm.com> (sfid-20151104_184632_913403_34E9C6CE)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> The number of spatial streams that are derived from chain mask
> for 4x4 devices is using wrong bitmask and conditional check.
> This is affecting downlink throughput for QCA99x0 devices. Earlier
> cfg_tx_chainmask is not filled by default until user configured it
> and so get_nss_from_chainmask never be called. This issue is exposed
> by recent commit 166de3f1895d ("ath10k: remove supported chain mask").
> By default maximum supported chain mask is filled in cfg_tx_chainmask.
>
> Cc: stable@vger.kernel.org
> Fixes: 5572a95b4b ("ath10k: apply chainmask settings to vdev on
> creation")
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

I'm planning to send this to 4.3-rc releases.

-- 
Kalle Valo
