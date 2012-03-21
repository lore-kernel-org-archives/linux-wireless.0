Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:52023 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab2CUJPF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2012 05:15:05 -0400
Message-ID: <4F699C13.4030806@qca.qualcomm.com> (sfid-20120321_101510_313468_124CF12C)
Date: Wed, 21 Mar 2012 11:14:59 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH] ath6kl: Dump htc header when invalid Rx frame length
 is detected
References: <1332321107-25671-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1332321107-25671-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/21/2012 11:11 AM, Vasanthakumar Thiagarajan wrote:
> Dump htc header along with the warning message when the request
> to Rx with invalid frame length is detected.
> 
> Signed-off-by: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>

[...]

> -		ath6kl_warn("Rx buffer requested with invalid length\n");
> +		ath6kl_warn("Rx buffer requested with invalid length"
> +			    "htc_hdr:eid - %d, flags - 0x%x, len - %d\n",

No need to split the format string, that's an exception to the long line
rule. Also please minimise the message a bit:

"Rx buffer requested with invalid length htc_hdr: eid %d flags 0x%x len
%d\n"

I try to keep the log messages as small as possible so that they are
easier to read.

Kalle
