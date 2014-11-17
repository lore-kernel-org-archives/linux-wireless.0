Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:16077 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaKQOlw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Nov 2014 09:41:52 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/2] ath10k: add modpram 'skip_otp' to ignore empty otp error during BMI
References: <1415366205-11672-1-git-send-email-rmanohar@qti.qualcomm.com>
Date: Mon, 17 Nov 2014 16:41:47 +0200
In-Reply-To: <1415366205-11672-1-git-send-email-rmanohar@qti.qualcomm.com>
	(Rajkumar Manoharan's message of "Fri, 7 Nov 2014 18:46:44 +0530")
Message-ID: <87a93pq47o.fsf@kamboji.qca.qualcomm.com> (sfid-20141117_154155_654417_E0D7E712)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Rajkumar Manoharan <rmanohar@qti.qualcomm.com> writes:

> This patch would help bring up wifi interface with default board
> data in case of failures in otp download. It is useful for initial
> caliberation.
>
> Signed-off-by: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>

[...]

> --- a/drivers/net/wireless/ath/ath10k/core.c
> +++ b/drivers/net/wireless/ath/ath10k/core.c
> @@ -31,12 +31,15 @@
>  unsigned int ath10k_debug_mask;
>  static bool uart_print;
>  static unsigned int ath10k_p2p;
> +static bool skip_otp;
>  module_param_named(debug_mask, ath10k_debug_mask, uint, 0644);
>  module_param(uart_print, bool, 0644);
>  module_param_named(p2p, ath10k_p2p, uint, 0644);
> +module_param(skip_otp, bool, 0644);
>  MODULE_PARM_DESC(debug_mask, "Debugging mask");
>  MODULE_PARM_DESC(uart_print, "Uart target debugging");
>  MODULE_PARM_DESC(p2p, "Enable ath10k P2P support");
> +MODULE_PARM_DESC(skip_otp, "Skip otp failure for calibration in testmode");

I added back the newlines:

--- a/drivers/net/wireless/ath/ath10k/core.c
+++ b/drivers/net/wireless/ath/ath10k/core.c
@@ -32,10 +32,12 @@ unsigned int ath10k_debug_mask;
 static bool uart_print;
 static unsigned int ath10k_p2p;
 static bool skip_otp;
+
 module_param_named(debug_mask, ath10k_debug_mask, uint, 0644);
 module_param(uart_print, bool, 0644);
 module_param_named(p2p, ath10k_p2p, uint, 0644);
 module_param(skip_otp, bool, 0644);
+
 MODULE_PARM_DESC(debug_mask, "Debugging mask");
 MODULE_PARM_DESC(uart_print, "Uart target debugging");
 MODULE_PARM_DESC(p2p, "Enable ath10k P2P support");

-- 
Kalle Valo
