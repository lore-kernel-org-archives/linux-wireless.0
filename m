Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f54.google.com ([74.125.82.54]:33306 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751022AbbDRHSI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Apr 2015 03:18:08 -0400
Message-ID: <55320529.6000106@gmail.com> (sfid-20150418_091834_322481_8C1E26F0)
Date: Sat, 18 Apr 2015 08:18:01 +0100
From: Malcolm Priestley <tvboxspy@gmail.com>
MIME-Version: 1.0
To: gregkh@linuxfoundation.org
CC: linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] staging: vt6655: Fix TX retransmission race condition
References: <1428796042-3390-1-git-send-email-tvboxspy@gmail.com>
In-Reply-To: <1428796042-3390-1-git-send-email-tvboxspy@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 12/04/15 00:47, Malcolm Priestley wrote:
> With high tx flow the same buffer can transmit  more than
> once and get stuck in loop.
>
> Reset TCR to zero in device_tx_srv.
>
> Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
> Cc: <stable@vger.kernel.org> # v3.19+
> ---
>   drivers/staging/vt6655/device_main.c | 3 +++
>   1 file changed, 3 insertions(+)
>
> diff --git a/drivers/staging/vt6655/device_main.c b/drivers/staging/vt6655/device_main.c
> index c5f8233..9b5d840 100644
> --- a/drivers/staging/vt6655/device_main.c
> +++ b/drivers/staging/vt6655/device_main.c
> @@ -963,6 +963,9 @@ static int device_tx_srv(struct vnt_private *pDevice, unsigned int uIdx)
>   			vnt_int_report_rate(pDevice, pTD->pTDInfo, byTsr0, byTsr1);
>
>   			device_free_tx_buf(pDevice, pTD);
> +
> +			/* Done with TCR reset to avoid retransmission */
> +			pTD->m_td1TD1.byTCR = 0;
>   			pDevice->iTDUsed[uIdx]--;
>   		}
>   	}

Hi Greg

Please could you drop this patch, it causes a regression in driver.

Thanks

Malcolm
