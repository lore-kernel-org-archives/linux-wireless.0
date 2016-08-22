Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.134]:64110 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752410AbcHVLr3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Aug 2016 07:47:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Cc: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
        devicetree@vger.kernel.org, robh+dt@kernel.org,
        mark.rutland@arm.com, chunkeey@googlemail.com, nbd@nbd.name
Subject: Re: [PATCH 2/5] ath9k: Set the "big endian" bit of the AR9003 EEPROM templates
Date: Mon, 22 Aug 2016 13:47:05 +0200
Message-ID: <3744898.ltfZjZgAjj@wuerfel> (sfid-20160822_134733_590841_8B52F18B)
In-Reply-To: <20160821144906.30984-3-martin.blumenstingl@googlemail.com>
References: <20160821144906.30984-1-martin.blumenstingl@googlemail.com> <20160821144906.30984-3-martin.blumenstingl@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday, August 21, 2016 4:49:03 PM CEST Martin Blumenstingl wrote:
> We will default to the system's native endianness for the eepmisc value.
> This may be overwritten by the actual calibration data. If it is not
> overwritten we interpret the template data in it's native endianness,
> meaning that no swapping is required.

I'm still skeptical about this one. What is the significance of "native
endianess" here? You are keying the endianess of the eeprom tables off the
way the CPU operates, but for a PCI device there is no correlation between
those two.

	Arnd
