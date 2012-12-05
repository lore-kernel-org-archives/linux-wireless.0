Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4220 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752102Ab2LERuB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 12:50:01 -0500
Message-ID: <50BF893E.5000208@broadcom.com> (sfid-20121205_185006_499396_E111C3DF)
Date: Wed, 5 Dec 2012 18:49:50 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Hauke Mehrtens" <hauke@hauke-m.de>
cc: "John W. Linville" <linville@tuxdriver.com>,
	"Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Piotr Haber" <phaber@broadcom.com>
Subject: Re: [PATCH 04/11] brcmsmac: radio on led support
References: <1354717564-7183-1-git-send-email-arend@broadcom.com>
 <1354717564-7183-5-git-send-email-arend@broadcom.com>
 <50BF63A5.9050504@hauke-m.de>
In-Reply-To: <50BF63A5.9050504@hauke-m.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/05/2012 04:09 PM, Hauke Mehrtens wrote:
>> +	if (state)
>> > +		bcma_cc_set32(cc_drv, BCMA_CC_GPIOOUT, gpio_out);
>> > +	else
>> > +		bcma_cc_mask32(cc_drv, BCMA_CC_GPIOOUT, ~gpio_out);
> Could you use bcma_chipco_gpio_out() instead, in the mips tree is a
> patch adding locking around the gpio registers. bcma_cc_set32 and
> bcma_cc_mask32 are not atomic. Two threads are accessing them in
> parallel will cause problems. The patches in the mips tree are adding
> full libgpio support, so it should also be possible to register the gpio
> from the generic gpio system and use the generic gpio functions.
> 

Sure. I will rework the patch.

Gr. AvS

