Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from softlayer.compulab.co.il ([50.23.254.55]:48943 "EHLO
	compulab.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752218AbcAMGAp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jan 2016 01:00:45 -0500
Subject: Re: [PATCH v4 3/3] wlcore/wl12xx: spi: add wifi support to cm-t335
To: Kalle Valo <kvalo@codeaurora.org>,
	Uri Mashiach <uri.mashiach@compulab.co.il>
References: <1451482533-8624-1-git-send-email-uri.mashiach@compulab.co.il>
 <1451482533-8624-4-git-send-email-uri.mashiach@compulab.co.il>
 <87io35lq2p.fsf@kamboji.qca.qualcomm.com>
Cc: Rob Herring <robh+dt@kernel.org>, Tony Lindgren <tony@atomide.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Kumar Gala <galak@codeaurora.org>, bcousson@baylibre.com,
	Eliad Peller <eliad@wizery.com>, devicetree@vger.kernel.org,
	linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux-wireless@vger.kernel.org
From: Igor Grinberg <grinberg@compulab.co.il>
Message-ID: <5695E802.7050909@compulab.co.il> (sfid-20160113_070054_146114_EEBEC5F9)
Date: Wed, 13 Jan 2016 08:00:34 +0200
MIME-Version: 1.0
In-Reply-To: <87io35lq2p.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle Valo,

On 01/07/16 11:02, Kalle Valo wrote:
> Uri Mashiach <uri.mashiach@compulab.co.il> writes:
> 
>> Device tree modifications:
>> - Pinmux for SPI0 and WiFi GPIOs.
>> - SPI0 node with wlcore as a child node.
>>
>> Cc: Tony Lindgren <tony@atomide.com>
>> Signed-off-by: Uri Mashiach <uri.mashiach@compulab.co.il>
>> ---

Uri, please document the dependencies next time. Thanks!

>> v1 -> v2: Replace interrupts and interrupt-parent with interrupts-extended.
>> v2 -> v3: Move the pinctrl-0 = <&wifi_pins> to the wlcore node.
>> v3 -> v4: replace interrupts-extended with interrupts and interrupt-parent. (revert v2 modification).
>>           According to Rob Herring and Documentation/devicetree/bindings/interrupt-controller/interrupts.txt,
>> 	  interrupts-extended should only be used when a device has multiple interrupt parents.
>>
>>  arch/arm/boot/dts/am335x-cm-t335.dts | 55 ++++++++++++++++++++++++++++++++++++
>>  1 file changed, 55 insertions(+)
> 
> To what tree should this patch go? My wireless-drivers-next tree doesn't
> even have this file.

Right. It will hit the mainline during this merge window through Tony's and
arm-soc trees.

Do you think it will be sensible if you take 1/3 and 2/3 patches and Tony
will take the 3/3 (there is no code dependency between first two and the last one),
or we can just wait till arm-soc hits the mainline, so you will have the
needed code?

> 
> https://patchwork.kernel.org/patch/7933441/
> 

-- 
Regards,
Igor.
