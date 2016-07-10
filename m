Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:65147 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757207AbcGJUsx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jul 2016 16:48:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: ath9k-devel@lists.ath9k.org, devicetree@vger.kernel.org,
	linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
	mcgrof@do-not-panic.com, galak@codeaurora.org,
	ijc+devicetree@hellion.org.uk, mark.rutland@arm.com,
	pawel.moll@arm.com, robh+dt@kernel.org, kvalo@codeaurora.org,
	chunkeey@googlemail.com, arend.vanspriel@broadcom.com,
	julian.calaby@gmail.com
Subject: Re: [PATCH v4 1/3] Documentation: dt: net: add ath9k wireless device binding
Date: Sun, 10 Jul 2016 22:52:03 +0200
Message-ID: <1746957.vJhcHQMZVi@wuerfel> (sfid-20160710_224859_911067_3092B478)
In-Reply-To: <20160709232834.31654-2-martin.blumenstingl@googlemail.com>
References: <20160624123430.4097-1-martin.blumenstingl@googlemail.com> <20160709232834.31654-1-martin.blumenstingl@googlemail.com> <20160709232834.31654-2-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, July 10, 2016 1:28:32 AM CEST Martin Blumenstingl wrote:
> +- qca,check-eeprom-endianness: When enabled, the driver checks if the
> +                               endianness of the EEPROM (based on the two
> +                               magic bytes at the start of the EEPROM)
> +                               matches the host system's native endianness.
> +                               The data will be swapped accordingly if there
> +                               is a mismatch.
> +                               Leaving this disabled means that the EEPROM
> +                               data will be interpreted in the system's
> +                               native endianness, regardless of the magic
> +                               bytes.
> +                               Enable this option only when the magic bytes
> +                               are known to indicate the correct endianness
> +                               of the EEPROM data, because otherwise the
> +                               EEPROM data may be swapped and thus may be
> +                               parsed incorrectly.

Defining properties in terms of "native" endianess is usually not a good
idea, as some architectures (ARMv6+, PowerPC, ...) allow running either
big-endian or little-endian without changing the endianess of device
registers in the process.

It's better to document the property as defaulting to a specific endianess
unless you have an override or the autodetection flag, regardless of
the CPU endianess.

	Arnd
