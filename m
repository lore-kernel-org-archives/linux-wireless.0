Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:35204 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935370AbcLOIep (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Dec 2016 03:34:45 -0500
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
CC: ath9k-devel <ath9k-devel@qca.qualcomm.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "chunkeey@googlemail.com" <chunkeey@googlemail.com>,
        "nbd@nbd.name" <nbd@nbd.name>
Subject: Re: [PATCH v2 0/7] ath9k: EEPROM swapping improvements
Date: Thu, 15 Dec 2016 08:34:37 +0000
Message-ID: <871sx9wpyb.fsf@kamboji.qca.qualcomm.com> (sfid-20161215_093449_475903_1707BCAD)
References: <20160821144906.30984-1-martin.blumenstingl@googlemail.com>
        <20161002222913.12223-1-martin.blumenstingl@googlemail.com>
In-Reply-To: <20161002222913.12223-1-martin.blumenstingl@googlemail.com>
        (Martin Blumenstingl's message of "Mon, 3 Oct 2016 00:29:06 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Martin Blumenstingl <martin.blumenstingl@googlemail.com> writes:

> There are two types of swapping the EEPROM data in the ath9k driver.
> Before this series one type of swapping could not be used without the
> other.
>
> The first type of swapping looks at the "magic bytes" at the start of
> the EEPROM data and performs swab16 on the EEPROM contents if needed.
> The second type of swapping is EEPROM format specific and swaps
> specific fields within the EEPROM itself (swab16, swab32 - depends on
> the EEPROM format).
>
> With this series the second part now looks at the EEPMISC register
> inside the EEPROM, which uses a bit to indicate if the EEPROM data
> is Big Endian (this is also done by the FreeBSD kernel).
> This has a nice advantage: currently there are some out-of-tree hacks
> (in OpenWrt and LEDE) where the EEPROM has a Big Endian header on a
> Big Endian system (=3D no swab16 is performed) but the EEPROM itself
> indicates that it's data is Little Endian. Until now the out-of-tree
> code simply did a swab16 before passing the data to ath9k, so ath9k
> first did the swab16 - this also enabled the format specific swapping.
> These out-of-tree hacks are still working with the new logic, but it
> is recommended to remove them. This implementation is based on a
> discussion with Arnd Bergmann who raised concerns about the
> robustness and portability of the swapping logic in the original OF
> support patch review, see [0].
>
> After a second round of patches (=3D v1 of this series) neither Arnd
> Bergmann nor I were really happy with the complexity of the EEPROM
> swapping logic. Based on a discussion (see [1] and [2]) we decided
> that ath9k should use a defined format (specifying the endianness
> of the data - I went with __le16 and __le32) when accessing the
> EEPROM fields. A benefit of this is that we enable the EEPMISC based
> swapping logic by default, just like the FreeBSD driver, see [3]. On
> the devices which I have tested (see below) ath9k now works without
> having to specify the "endian_check" field in ath9k_platform_data (or
> a similar logic which could provide this via devicetree) as ath9k now
> detects the endianness automatically. Only EEPROMs which are mangled
> by some out-of-tree code still need the endian_check flag (or one can
> simply remove that mangling from the out-of-tree code).
>
> Testing:
> - tested by myself on AR9287 with Big Endian EEPROM
> - tested by myself on AR9227 with Little Endian EEPROM
> - tested by myself on AR9381 (using the ar9003_eeprom implementation,
>   which did not suffer from this whole problem)
> - how do we proceed with testing? maybe we could keep this in a
>   feature-branch and add these patches to LEDE once we have an ACK to
>   get more people to test this
>
> This series depends on my other series (v7):
> "add devicetree support to ath9k" - see [4]
>
> Changes since v1:
> - reworked description in the cover-letter to describe the reasons
>   behind the new patch 7
> - reworked patch "Set the "big endian" bit of the AR9003 EEPROM
>   templates" as ar9003_eeprom.c sets all values as Little Endian, thus
>   the Big Endian bit should never be set (the new patch makes this
>   clear)
> - dropped "ath9k: Make EEPROM endianness swapping configurable via
>   devicetree" as it is not needed anymore with the new logic from
>   patch 7
> - added patches 4 and 5 as small cleanup (this made it easier to
>   implement the le{16,32}_to_cpu() changes where needed)
>
>
> [0] http://www.spinics.net/lists/linux-wireless/msg152634.html
> [1] https://marc.info/?l=3Dlinux-wireless&m=3D147250597503174&w=3D2
> [2] https://marc.info/?l=3Dlinux-wireless&m=3D147254388611344&w=3D2
> [3] https://github.com/freebsd/freebsd/blob/50719b56d9ce8d7d4beb53b16e9ed=
b2e9a4a7a18/sys/dev/ath/ath_hal/ah_eeprom_9287.c#L351
> [4] https://marc.info/?l=3Dlinux-wireless&m=3D147544488619822&w=3D2
>
> Martin Blumenstingl (7):
>   ath9k: Add a #define for the EEPROM "eepmisc" endianness bit
>   ath9k: indicate that the AR9003 EEPROM template values are little
>     endian
>   ath9k: Add an eeprom_ops callback for retrieving the eepmisc value
>   ath9k: replace eeprom_param EEP_MINOR_REV with get_eeprom_rev
>   ath9k: consistently use get_eeprom_rev(ah)
>   ath9k: Make the EEPROM swapping check use the eepmisc register
>   ath9k: define all EEPROM fields in Little Endian format

Applied to ath-next on ath.git, thanks.

(My automatic "accepted" email failed, so had to send this manually.)

--=20
Kalle Valo=
