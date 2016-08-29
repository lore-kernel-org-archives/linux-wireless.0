Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:52946 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753564AbcH2V0I (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Aug 2016 17:26:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: Re: [PATCH 5/5] ath9k: Make EEPROM endianness swapping configurable via devicetree
Date: Mon, 29 Aug 2016 23:25:37 +0200
Cc: nbd@nbd.name, kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
        devicetree@vger.kernel.org, mark.rutland@arm.com,
        chunkeey@googlemail.com, robh+dt@kernel.org
References: <20160821144906.30984-1-martin.blumenstingl@googlemail.com> <201608291410.44338.arnd@arndb.de> <CAFBinCCSBE8KsLgP3t=FzB-2jgjfQBtuF+EjqQEk-7mmmps_Pg@mail.gmail.com>
In-Reply-To: <CAFBinCCSBE8KsLgP3t=FzB-2jgjfQBtuF+EjqQEk-7mmmps_Pg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201608292325.38091.arnd@arndb.de> (sfid-20160829_232611_441510_D2FE635F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 29 August 2016, Martin Blumenstingl wrote:
> > and then do a swab32() on them. I suspect these should just be __le32
> > (and __le16, respectively where needed), using appropriate accessors
> > everywhere that those fields are being read instead of having one function
> > that tries to turn them into cpu-native ordering.
> I'm not sure if we want those fields to be __le32:
> BIT(0) in the eepMisc field indicates whether to interpret the data as
> big or little endian.
> When this bit is set we would want these fields to be __be32 instead -
> so I guess the current implementation is "OK" for this specific
> use-case.

Ok, I see. It's still confusing because it's different from how other
drivers handle this (case in point: I was very confused by this). 

Do you see any downsides in changing the code to consistently annotate
the eeprom as either __le or __be (whichever is more common), using
the respective endianess accessors, and then doing the swap if the
data we read is the opposite way?

	Arnd
