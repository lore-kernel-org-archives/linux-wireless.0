Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:56913 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755563Ab0GVLXZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 07:23:25 -0400
Message-ID: <4C48287D.1000603@nokia.com>
Date: Thu, 22 Jul 2010 14:16:13 +0300
From: Roger Quadros <roger.quadros@nokia.com>
MIME-Version: 1.0
To: ext Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Ohad Ben-Cohen <ohad@wizery.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
	"linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
	Kalle Valo <kalle.valo@iki.fi>,
	Pandita Vikram <vikram.pandita@ti.com>,
	"linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
	Nicolas Pitre <nico@fluxnic.net>,
	Tony Lindgren <tony@atomide.com>, San Mehat <san@google.com>,
	Chikkature Rajashekar Madhusudhan <madhu.cr@ti.com>,
	"Coelho Luciano (Nokia-MS/Helsinki)" <Luciano.Coelho@nokia.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"linux-arm-kernel@lists.infradead.org"
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2 10/20] omap: zoom: add fixed regulator device for	wlan
References: <1279733634-21974-1-git-send-email-ohad@wizery.com> <1279733634-21974-11-git-send-email-ohad@wizery.com> <20100721175930.GD10930@sirena.org.uk>
In-Reply-To: <20100721175930.GD10930@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/21/2010 08:59 PM, ext Mark Brown wrote:
> On Wed, Jul 21, 2010 at 08:33:44PM +0300, Ohad Ben-Cohen wrote:
>
>> +static struct regulator_consumer_supply zoom_vmmc3_supply = {
>> +	.supply		= "vmmc",
>> +};
>
> This looks like a misconfiguration on the consumer - I'd strongly expect
> the consumer to have a dev_name specified also with the name being in
> terms of the consumer device.

you need to add something like

.dev_name       = "mmci-omap-hs.2"

regards,
-roger
