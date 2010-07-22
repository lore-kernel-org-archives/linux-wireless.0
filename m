Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58049 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751166Ab0GVXOA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jul 2010 19:14:00 -0400
MIME-Version: 1.0
In-Reply-To: <4C48287D.1000603@nokia.com>
References: <1279733634-21974-1-git-send-email-ohad@wizery.com>
	<1279733634-21974-11-git-send-email-ohad@wizery.com> <20100721175930.GD10930@sirena.org.uk>
	<4C48287D.1000603@nokia.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Fri, 23 Jul 2010 02:13:38 +0300
Message-ID: <AANLkTin2dyLNo1RMQgLG-4DtN-CsXqNNLAfITXDbMIvl@mail.gmail.com>
Subject: Re: [PATCH v2 10/20] omap: zoom: add fixed regulator device for wlan
To: Roger Quadros <roger.quadros@nokia.com>,
	Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 22, 2010 at 2:16 PM, Roger Quadros <roger.quadros@nokia.com> wrote:
> On 07/21/2010 08:59 PM, ext Mark Brown wrote:
>>
>> On Wed, Jul 21, 2010 at 08:33:44PM +0300, Ohad Ben-Cohen wrote:
>>
>>> +static struct regulator_consumer_supply zoom_vmmc3_supply = {
>>> +       .supply         = "vmmc",
>>> +};
>>
>> This looks like a misconfiguration on the consumer - I'd strongly expect
>> the consumer to have a dev_name specified also with the name being in
>> terms of the consumer device.
>
> you need to add something like
>
> .dev_name       = "mmci-omap-hs.2"

I already set the .dev member of the consumer in a similar manner to
how all other regulators are configured in this board - please check
out patch 13:

https://patchwork.kernel.org/patch/113418/

Does this look reasonable to you ?

Thanks,
Ohad.

>
> regards,
> -roger
>
