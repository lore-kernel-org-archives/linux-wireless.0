Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653F04477FE;
	Mon,  7 Sep 2026 09:10:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788772218; cv=none; b=HouH/Ksa59o2dqj0hJK7y1NihQu/gTeEKYAm5ArQ45RJFz08Bwp1MJpzLPPZYfHXy/AYjUFjN3oCEjODjFIWcD844hHiJAHI/EUCnE2Y8N9uPlkVIzj4Fhjrbu2LF+lS+p9TB7L3JyBONcfdKV9tbCk+Dcz7TYQ0ck5TD8EPHIQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788772218; c=relaxed/simple;
	bh=mbxKEGoFYvjtDaAhmiOJVGF7Zj5q6Op8IccCyO/qPW4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=E7HFkOjShCukuo8jdcyylp4T26S1xAPTnoXjn+zv3DyD7p0HJ1FGA/sWIQQGab6ZIRYn1KsknS5nUOqynzHxpBK3FAJHyBph/7IU97A7DhnaEqctAdDaxE/kTAl5PQQF2Dd16Srygca5isYnz8QIVsDZP0SUjF3XpiLeaza8zes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bbEABYk1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bbEABYk1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D5771F00A3A;
	Mon,  7 Sep 2026 09:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788772216;
	bh=qO1o8A20WwuxzTdItOHMbelkygBgtuXCBMOMdofNeh0=;
	h=From:To:Cc:Subject:Date;
	b=bbEABYk1aQWzaiQFlEYMl4fDKkcaOp1rgrWnyYq0mVv3G0dLN6fP9d2jkWPmNuB46
	 GnhA5xCYf9L19R/qTRCBVqDOrql9MUN+fYMlWf5HsV7Q36Lp3cfYZW6lfkaGW2nzuE
	 A+fGaBUlAwWUBADVWpcMPgT9c0kENUQjyrgAl3IZot27KorzGcgXLJudrNdH2cRRKI
	 bzEutkV3wcHYKSk9tspN/D5pT69Sqi4w61eGCS2++w5+hbRhZRlEML4ZjoiRMk3efE
	 UPcLssAm++05qUHjBWx+Bit4KoNgVbl8IzuwXn/vlYhj5ODZXBB0GSi5VteMwwDNRT
	 AE1aTqLSXGM1A==
From: Arnd Bergmann <arnd@kernel.org>
To: Linus Walleij <linusw@kernel.org>,
	Bartosz Golaszewski <brgl@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
	Kent Gibson <warthog618@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-kernel@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-sh@vger.kernel.org,
	linux-gpio@vger.kernel.org,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/2 v7] gpiolib: finish the legacy cleanup
Date: Mon,  7 Sep 2026 11:09:54 +0200
Message-ID: <20260907090956.2825703-1-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

These two patches are left from my cleanup series, finishing off the
work to turn off CONFIG_GPIOLIB_LEGACY by default, and removing the
include/linux/gpio.h header.

I had originally planned to send these during the merge window after all
the prerequisites made it in, but didn't finish that before my vacation,
so I'm sending it now.  I suppose this makes them 7.4 material now,
but at least the first one could stil be fast-tracked to 7.3 if there
is a good reason.

The second patch has to remove a few more leftover <linux/gpio.h>
inclusions that made it into 7.3-rc1 either from new code or from
conflicts with other changes.

Arnd Bergmann (2):
  gpiolib: turn off legacy interface by default
  gpiolib: remove linux/gpio.h

 MAINTAINERS                                  |  1 -
 arch/mips/txx9/rbtx4927/setup.c              |  2 +-
 arch/sh/boards/mach-rsk/devices-rsk7203.c    |  2 +-
 drivers/gpio/Kconfig                         |  9 +++++++-
 drivers/gpio/TODO                            |  4 +---
 drivers/gpio/gpiolib-cdev.c                  |  2 +-
 drivers/gpio/gpiolib-legacy.c                |  3 +--
 drivers/gpio/gpiolib.c                       |  2 +-
 drivers/net/wireless/morsemicro/mm81x/hw.c   |  1 -
 drivers/net/wireless/morsemicro/mm81x/yaps.c |  1 -
 include/linux/gpio.h                         | 22 --------------------
 11 files changed, 14 insertions(+), 35 deletions(-)
 delete mode 100644 include/linux/gpio.h

-- 
2.53.0

Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Kent Gibson <warthog618@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-kernel@vger.kernel.org
Cc: linux-mips@vger.kernel.org
Cc: linux-sh@vger.kernel.org
Cc: linux-gpio@vger.kernel.org
Cc: linux-wireless@vger.kernel.org

