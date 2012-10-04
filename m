Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:43481 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751640Ab2JDUeH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2012 16:34:07 -0400
Cc: <linux-wireless@vger.kernel.org>, <linville@tuxdriver.com>,
	<rodrigue@qca.qualcomm.com>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Thu, 4 Oct 2012 13:35:43 -0700
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: Sven Eckelmann <sven@narfation.org>
Subject: Re: [PATCHv2] ath_hw: Use common REG_WRITE parameter order
Message-ID: <20121004203543.GR3354@lenteja.do-not-panic.com> (sfid-20121004_223413_537589_59112BD3)
References: <1349366701-23154-1-git-send-email-sven@narfation.org>
 <1349372595-19966-1-git-send-email-sven@narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1349372595-19966-1-git-send-email-sven@narfation.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 04, 2012 at 07:43:15PM +0200, Sven Eckelmann wrote:
> All defines for REG_WRITE in Atheros wireless drivers use the order "ah",
> "register" and "value". hw.c is the only file using the order "ah", "value" and
> "register".
> 
> drivers/net/wireless/ath/ath9k/hw.h:#define REG_WRITE(_ah, _reg, _val) \
> drivers/net/wireless/ath/key.c:#define REG_WRITE(_ah, _reg, _val) (common->ops->write)(_ah, _val, _reg)
> 
> This inconsistent definition can easily lead to implementation errors. The
> modification doesn't change the behavior of the driver or the generated code.
> 
> Signed-off-by: Sven Eckelmann <sven@narfation.org>
> Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>

Acked-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>

  Luis
