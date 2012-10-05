Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2869 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756250Ab2JEQ31 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 12:29:27 -0400
Message-ID: <506F0AD9.70200@broadcom.com> (sfid-20121005_182936_791385_704FBAE7)
Date: Fri, 5 Oct 2012 18:29:13 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Sven Eckelmann" <sven@narfation.org>
cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mcgrof@qca.qualcomm.com,
	"Simon Wunderlich" <siwu@hrz.tu-chemnitz.de>
Subject: Re: [PATCHv2] ath_hw: Use common REG_WRITE parameter order
References: <1349366701-23154-1-git-send-email-sven@narfation.org>
 <1349372595-19966-1-git-send-email-sven@narfation.org>
In-Reply-To: <1349372595-19966-1-git-send-email-sven@narfation.org>
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/04/2012 07:43 PM, Sven Eckelmann wrote:
> All defines for REG_WRITE in Atheros wireless drivers use the order "ah",
> "register" and "value". hw.c is the only file using the order "ah", "value" and
> "register".
>
> drivers/net/wireless/ath/ath9k/hw.h:#define REG_WRITE(_ah, _reg, _val) \

Just to bad you did not catch the next line in hw.h.

Gr. AvS

> drivers/net/wireless/ath/key.c:#define REG_WRITE(_ah, _reg, _val) (common->ops->write)(_ah, _val, _reg)
>
> This inconsistent definition can easily lead to implementation errors. The
> modification doesn't change the behavior of the driver or the generated code.
>
> Signed-off-by: Sven Eckelmann <sven@narfation.org>
> Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
> ---
> Changed commit message
>
>   drivers/net/wireless/ath/hw.c |   20 ++++++++++----------
>   1 file changed, 10 insertions(+), 10 deletions(-)


