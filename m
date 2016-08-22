Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([217.72.192.74]:61692 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752840AbcHVLwv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 07:52:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, chunkeey@googlemail.com, nbd@nbd.name
Subject: Re: [PATCH 5/5] ath9k: Make EEPROM endianness swapping configurable via devicetree
Date: Mon, 22 Aug 2016 13:52:07 +0200
Message-ID: <2303906.Xe1WvCfP0V@wuerfel> (sfid-20160822_135256_271249_8813A50D)
In-Reply-To: <20160821144906.30984-6-martin.blumenstingl@googlemail.com>
References: <20160821144906.30984-1-martin.blumenstingl@googlemail.com> <20160821144906.30984-6-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, August 21, 2016 4:49:06 PM CEST Martin Blumenstingl wrote:
> +- qca,check-eeprom-endianness: When enabled, the driver checks if the
> +                               endianness of the EEPROM (using two checks,
> +                               one is based on the two magic bytes at the
> +                               start of the EEPROM and a second one which
> +                               relies on a flag within the EEPROM data)
> +                               matches the host system's native endianness.
> +                               The data will be swapped accordingly if there
> +                               is a mismatch.
> +                               Leaving this disabled means that the EEPROM
> +                               data will always be interpreted in the
> +                               system's native endianness.
> +                               Enable this option only when the EEPROMs
> +                               endianness identifiers are known to be
> +                               correct, because otherwise the EEPROM data
> +                               may be swapped and thus interpreted
> +                               incorrectly.

The property should not describe the driver behavior, but instead
describe what the hardware is like.

A default of "system's native endianess" should not be specified
in a binding, as the same DTB can be used with both big-endian or
little-endian kernels on some architectures (ARM and PowerPC among
others), so disabling the property means that it is guaranteed to
be broken on one of the two.

If we have no reliable way to check the endianess in all combinations,
could we have two properties "eeprom-big-endian" and
"eeprom-little-endian" and mandate that one of them is always used
when discovering the device using DT?

	Arnd
