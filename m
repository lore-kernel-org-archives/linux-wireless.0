Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:23550 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751609AbeBSHto (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 02:49:44 -0500
Date: Mon, 19 Feb 2018 13:19:36 +0530
From: Ajay Singh <ajay.kathat@microchip.com>
To: Claudiu Beznea <Claudiu.Beznea@microchip.com>
CC: <linux-wireless@vger.kernel.org>, <devel@driverdev.osuosl.org>,
        <gregkh@linuxfoundation.org>, <ganesh.krishna@microchip.com>,
        <venkateswara.kaja@microchip.com>, <aditya.shankar@microchip.com>,
        <Adham.Abozaeid@microchip.com>
Subject: Re: [PATCH 6/6] staging: wilc1000: fix line over 80 chars in
 wilc_spi_clear_int_ext()
Message-ID: <20180219131936.3e1cbfc2@ajaysk-VirtualBox> (sfid-20180219_084948_739645_9EE54A3F)
In-Reply-To: <63adcc58-bdd1-9fe7-6774-3ea1d626858b@microchip.com>
References: <1518606615-14404-1-git-send-email-ajay.kathat@microchip.com>
        <1518606615-14404-7-git-send-email-ajay.kathat@microchip.com>
        <63adcc58-bdd1-9fe7-6774-3ea1d626858b@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 16 Feb 2018 20:16:02 +0200
Claudiu Beznea <Claudiu.Beznea@microchip.com> wrote:

> Or you could use:
> 	unsigned long expected_irqs, unexpected_irqs;
> 
> 	expected_irqs = val & GENMASK(g_spi.int - 1, 0);
> 	unexpected_irq = val & GENMASK(MAX_NUM_INT - 1, g_spi.int);
> 
> 	for (i = 0; i < g_spi.nint && expected_irqs; i++) {
> 		if (expected_irqs & BIT(i)) {
> 			ret = wilc_spi_write_reg(wilc, 0x10c8 + i * 4, 1);
> 			if (ret) {
> 				dev_err(...);
> 				goto _fail_;
> 			}
> 		}
> 	}
> 
> 	for (i = g_spi.nint; i < MAX_NUM_INT && unexpected_irq; i++) {
> 		if (unexpected_irqs & BIT(i))
> 			dev_err(...);
> 

Thanks for suggestion.
I will take this input and make use of GENMASK macro to modify the
function. In a separate patch will submit these changes. As there are
other functions,where same macro can be used so will include them
together in separate patch.
