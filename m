Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36603 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751743AbcL3JQE (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Dec 2016 04:16:04 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: ath10k: ignore configuring the incorrect board_id
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1482447757-23577-1-git-send-email-ryanhsu@qca.qualcomm.com>
References: <1482447757-23577-1-git-send-email-ryanhsu@qca.qualcomm.com>
To: Ryan Hsu <ryanhsu@qca.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <ryanhsu@qca.qualcomm.com>
Message-ID: <d97a54233b874e629fd27cd98025030e@euamsexm01a.eu.qualcomm.com> (sfid-20161230_101607_382687_7D6E0AC6)
Date: Fri, 30 Dec 2016 10:15:57 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ryan Hsu <ryanhsu@qca.qualcomm.com> wrote:
> From: Ryan Hsu <ryanhsu@qca.qualcomm.com>
> 
> With command to get board_id from otp, in the case of following
> 
>   boot get otp board id result 0x00000000 board_id 0 chip_id 0
>   boot using board name 'bus=pci,bmi-chip-id=0,bmi-board-id=0"
>   ...
>   failed to fetch board data for bus=pci,bmi-chip-id=0,bmi-board-id=0 from
>   ath10k/QCA6174/hw3.0/board-2.bin
> 
> The invalid board_id=0 will be used as index to search in the board-2.bin.
> 
> Ignore the case with board_id=0, as it means the otp is not carrying
> the board id information.
> 
> Signed-off-by: Ryan Hsu <ryanhsu@qca.qualcomm.com>

Patch applied to ath-next branch of ath.git, thanks.

d2e202c06ca4 ath10k: ignore configuring the incorrect board_id

-- 
https://patchwork.kernel.org/patch/9486941/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
