Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:32032 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751427AbcLALUM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 1 Dec 2016 06:20:12 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath9k_htc: don't use HZ for usb msg timeouts
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20161128042757.8609-1-anthony.romano@coreos.com>
References: <20161128042757.8609-1-anthony.romano@coreos.com>
To: Anthony Romano <anthony.romano@coreos.com>
CC: <linux-wireless@vger.kernel.org>, <ath9k-devel@lists.ath9k.org>,
        <ath9k-devel@qca.qualcomm.com>
Message-ID: <d939ddc18eb6496691cf06e4dfff9845@euamsexm01a.eu.qualcomm.com> (sfid-20161201_122015_845641_F02053B3)
Date: Thu, 1 Dec 2016 12:20:05 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anthony Romano <anthony.romano@coreos.com> wrote:
> The usb_*_msg() functions expect a timeout in msecs but are given HZ,
> which is ticks per second. If HZ=100, firmware download often times out
> when there is modest USB utilization and the device fails to initialize.
> 
> Replaces HZ in usb_*_msg timeouts with 1000 msec since HZ is one second
> for timeouts in jiffies.
> 
> Signed-off-by: Anthony Romano <anthony.romano@coreos.com>
> Acked-by: Oleksij Rempel <linux@rempel-privat.de>

Patch applied to ath-next branch of ath.git, thanks.

982a6151f6f1 ath9k_htc: don't use HZ for usb msg timeouts

-- 
https://patchwork.kernel.org/patch/9449097/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
