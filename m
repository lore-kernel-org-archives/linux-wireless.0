Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4284 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab2LEVA7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Dec 2012 16:00:59 -0500
Message-ID: <50BFB605.2020000@broadcom.com> (sfid-20121205_220102_598115_D1827881)
Date: Wed, 5 Dec 2012 22:00:53 +0100
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
>> +	if (radio_led->gpio != 0xf) {
>> > +		int gpio_out = 1 << radio_led->gpio;
>> > +		/* enable out */
>> > +		bcma_cc_set32(cc_drv, BCMA_CC_GPIOOUTEN, gpio_out);
>> > +		if (radio_led->active_low)
>> > +			bcma_cc_set32(cc_drv, BCMA_CC_GPIOPULLUP, gpio_out);
> Same for these register accesses.
> 

For the pullup register there is not bcma_gpio_ function. With the stuff
coming in from the mips tree I prefer to drop this patch for now.

John,

Please drop this patch from the series.

Gr. AvS

