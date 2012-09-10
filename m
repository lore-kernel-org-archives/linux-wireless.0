Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:34852 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046Ab2IJNKU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 09:10:20 -0400
From: Kalle Valo <kvalo@adurom.com>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: Larry.Finger@lwfinger.net, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, sameo@linux.intel.com,
	yongjun_wei@trendmicro.com.cn, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] NFC: pn544_hci: move the dereference below the NULL test
References: <CAPgLHd-DabDrNN9KpQjG+XiXJDA38_VA2jeiF+O-7QBqNhEogA@mail.gmail.com>
Date: Mon, 10 Sep 2012 16:10:16 +0300
In-Reply-To: <CAPgLHd-DabDrNN9KpQjG+XiXJDA38_VA2jeiF+O-7QBqNhEogA@mail.gmail.com>
	(Wei Yongjun's message of "Sat, 8 Sep 2012 11:34:33 +0800")
Message-ID: <874nn658hz.fsf@purkki.adurom.net> (sfid-20120910_151027_796302_9D45B10F)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Wei Yongjun <weiyj.lk@gmail.com> writes:

> -	BUG_ON(!info);
> -	BUG_ON(irq != info->i2c_dev->irq);
> +	if (!info || irq != info->i2c_dev->irq) {
> +		WARN_ON_ONCE(1);
> +		return IRQ_NONE;
> +	}

You can even simplify it to this:

if (WARN_ON_ONCE(!info || irq != info->i2c_dev->irq))
	return IRQ_NONE;

I don't know if it matters here but if it's important to know which test
is failing having two different tests makes that easier, as the line
number will be different:

if (WARN_ON_ONCE(!info))
	return IRQ_NONE;

if (WARN_ON_ONCE(irq != info->i2c_dev->irq))
	return IRQ_NONE;

-- 
Kalle Valo
