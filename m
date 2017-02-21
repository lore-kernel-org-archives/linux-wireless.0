Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:60290 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751208AbdBUVAO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 21 Feb 2017 16:00:14 -0500
Date: Tue, 21 Feb 2017 16:00:07 -0500 (EST)
Message-Id: <20170221.160007.633338603929529207.davem@davemloft.net> (sfid-20170221_220018_250825_9622D507)
To: kvalo@qca.qualcomm.com
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Subject: Re: [PATCH] Revert "ath10k: Search SMBIOS for OEM board file
 extension"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1487706426-31172-1-git-send-email-kvalo@qca.qualcomm.com>
References: <1487706426-31172-1-git-send-email-kvalo@qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Tue, 21 Feb 2017 21:47:06 +0200

> This reverts commit f2593cb1b29185d38db706cbcbe22ed538720ae1.
> 
> Paul reported that this patch with older board-2.bin ath10k initialisation
> fails on Dell XPS 13:
> 
> ath10k_pci 0000:3a:00.0: failed to fetch board data for bus=pci,vendor=168c,
> device=003e,subsystem-vendor=1a56,subsystem-device=1535,variant=RV_0520 from
> ath10k/QCA6174/hw3.0/board-2.bin
> 
> The reason is that the older board-2.bin does not have the variant version of
> the image name and ath10k does not fallback to the older naming scheme.
> 
> Reported-by: Paul Menzel <pmenzel@molgen.mpg.de>
> Link: https://bugzilla.kernel.org/show_bug.cgi?id=185621#c9
> Fixes: f2593cb1b291 ("ath10k: Search SMBIOS for OEM board file extension")
> Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
> ---
> 
> Dave, please take this directly if you can.

Applied, thanks Kalle.
