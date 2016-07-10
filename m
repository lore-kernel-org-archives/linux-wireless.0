Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:47628 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753021AbcGJAWN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jul 2016 20:22:13 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: ath9k-devel@venema.h4ckr.net, devicetree@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	mcgrof@do-not-panic.com, galak@codeaurora.org,
	ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
	pawel.moll@arm.com, robh+dt@kernel.org, kvalo@codeaurora.org,
	chunkeey@googlemail.com, arend.vanspriel@broadcom.com,
	julian.calaby@gmail.com
Subject: Re: [PATCH v4 3/3] ath9k: parse the device configuration from an OF node
References: <20160624123430.4097-1-martin.blumenstingl@googlemail.com>
	<20160709232834.31654-1-martin.blumenstingl@googlemail.com>
	<20160709232834.31654-4-martin.blumenstingl@googlemail.com>
Date: Sun, 10 Jul 2016 02:19:36 +0200
In-Reply-To: <20160709232834.31654-4-martin.blumenstingl@googlemail.com>
	(Martin Blumenstingl's message of "Sun, 10 Jul 2016 01:28:34 +0200")
Message-ID: <87inwe9wfb.fsf@miraculix.mork.no> (sfid-20160710_022217_068367_403D161C)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Martin Blumenstingl <martin.blumenstingl@googlemail.com> writes:

> +	if (of_property_read_bool(np, "qca,clk-25mhz"))
> +		ah->is_clk_25mhz = true;
> +
> +	if (of_property_read_bool(np, "qca,disable-2ghz"))
> +		ah->disable_2ghz = true;
> +
> +	if (of_property_read_bool(np, "qca,disable-5ghz"))
> +		ah->disable_5ghz = true;

This is bike-shedding, but how about

	ah->is_clk_25mhz = of_property_read_bool(np, "qca,clk-25mhz");
	ah->disable_2ghz = of_property_read_bool(np, "qca,disable-2ghz");
	ah->disable_5ghz = of_property_read_bool(np, "qca,disable-5ghz");

instead?


Bjørn
