Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:48165 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758676Ab1GMKEt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 06:04:49 -0400
Date: Wed, 13 Jul 2011 15:34:27 +0530
From: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
To: Dan Carpenter <error27@gmail.com>
CC: Kalle Valo <kvalo@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>, <devel@linuxdriverproject.org>,
	<gregkh@suse.de>
Subject: Re: [PATCH 00/24] ath6kl cleaned up driver
Message-ID: <20110713100426.GA32707@vasanth-laptop> (sfid-20110713_120453_856114_5FFA4DE2)
References: <20110713013023.8517.15940.stgit@localhost6.localdomain6> <20110713092257.GN18655@shale.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20110713092257.GN18655@shale.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 13, 2011 at 12:22:57PM +0300, Dan Carpenter wrote:
> Nice.  :)
> 
> There are a some smatch warnings you might want to take a look at:
> 
> drivers/net/wireless/ath/ath6kl/sdio.c +373 ath6kl_sdio_setup_scat_resource(42) warn: 's_req' was already freed.
> drivers/net/wireless/ath/ath6kl/htc.c +2480 htc_create(74) warn: possible memory leak of 'packet'
> drivers/net/wireless/ath/ath6kl/txrx.c +156 ath6kl_powersave_ap(76) error: we previously assumed 'conn' could be null.
>   (The line number is off on that one.  Should be +142.  Odd)
> drivers/net/wireless/ath/ath6kl/txrx.c +758 ath6kl_alloc_amsdu_rxbuf(33) warn: can 'packet' even be NULL?

Thanks a lot. W'll fix them.

Vasanth
