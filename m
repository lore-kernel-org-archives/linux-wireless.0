Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35923 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753148AbcHUOtZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 21 Aug 2016 10:49:25 -0400
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: kvalo@codeaurora.org, ath9k-devel@qca.qualcomm.com,
        linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
        devicetree@vger.kernel.org
Cc: robh+dt@kernel.org, mark.rutland@arm.com, arnd@arndb.de,
        chunkeey@googlemail.com, nbd@nbd.name,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH 0/5] ath9k: EEPROM swapping improvements
Date: Sun, 21 Aug 2016 16:49:01 +0200
Message-Id: <20160821144906.30984-1-martin.blumenstingl@googlemail.com> (sfid-20160821_164930_361511_50046255)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

There are two types of swapping the EEPROM data in the ath9k driver.
Before this series one type of swapping could not be used without the
other.

The first type of swapping looks at the "magic bytes" at the start of
the EEPROM data and performs swab16 on the EEPROM contents if needed.
The second type of swapping is EEPROM format specific and swaps
specific fields within the EEPROM itself (swab16, swab32 - depends on
the EEPROM format).

With this series the second part now looks at the EEPMISC register
inside the EEPROM, which uses a bit to indicate if the EEPROM data
is Big Endian (this is also done by the FreeBSD kernel).
This has a nice advantage: currently there are some out-of-tree hacks
(in OpenWrt and LEDE) where the EEPROM has a Big Endian header on a
Big Endian system (= no swab16 is performed) but the EEPROM itself
indicates that it's data is Little Endian. Until now the out-of-tree
code simply did a swab16 before passing the data to ath9k, so ath9k
first did the swab16 - this also enabled the format specific swapping.
These out-of-tree hacks are still working with the new logic, but it
is recommended to remove them.

The last patch in this series allows enabling the EEPROM endianness
swapping via devicetree. This should be fine now since it addresses
the concerns raised by Arnd Bergmann in in the original OF support
patches: [0].

This series depends on my other series (V5):
"add devicetree support to ath9k" - see [1]


[0] http://www.spinics.net/lists/linux-wireless/msg152634.html
[1] https://marc.info/?l=linux-wireless&m=147178988827847&w=2


Martin Blumenstingl (5):
  ath9k: Add a #define for the EEPROM "eepmisc" endianness bit
  ath9k: Set the "big endian" bit of the AR9003 EEPROM templates
  ath9k: Add an eeprom_ops callback for retrieving the eepmisc value
  ath9k: Make the EEPROM swapping check use the eepmisc register
  ath9k: Make EEPROM endianness swapping configurable via devicetree

 .../devicetree/bindings/net/wireless/qca,ath9k.txt | 16 ++++++
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     | 21 +++++---
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.h     |  7 ++-
 drivers/net/wireless/ath/ath9k/eeprom.c            | 57 ++++++++++++++++------
 drivers/net/wireless/ath/ath9k/eeprom.h            |  5 +-
 drivers/net/wireless/ath/ath9k/eeprom_4k.c         | 10 +++-
 drivers/net/wireless/ath/ath9k/eeprom_9287.c       | 10 +++-
 drivers/net/wireless/ath/ath9k/eeprom_def.c        | 10 +++-
 drivers/net/wireless/ath/ath9k/init.c              |  6 ++-
 9 files changed, 110 insertions(+), 32 deletions(-)

-- 
2.9.3
