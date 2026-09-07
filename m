Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A294483A5;
	Mon,  7 Sep 2026 09:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788772221; cv=none; b=QglbBfU7TbXm5JHNifzyzNqMIWbt8AcytgFh2Z2VKE5Hcalcm94TtbSrBuJdfe6s6vuJKANtT7csYsB3rIYGbc7YB6wXFqvIf3NfqiBwNgqyEVCGPk6lJJGXl9VxGbTc9SJNqb2ocj1VtSfM7an8yaPR5nzLEhictUf4CQgEZVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788772221; c=relaxed/simple;
	bh=YejfvrcVApfTPko6Ew4mm+xI4YgC6S4azs74d0WnpOs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AMT0CLmHknKWcqub+mM5BJ9mND+P/RqKccMIOyyVsIObf0yLOZR7A5b0yh4xCujRcDS3jE+/EfgYF8UD2wfhjrO3FBeRR54DvBXnRNxD1d12m7ZRKD+NDTbNjoeJ0UCT8j34R6Y7injZH+sGApis2Nljx9Dnfrv7hc0k+0t3XuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DBvLVtam; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DBvLVtam"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2AB1F00A3D;
	Mon,  7 Sep 2026 09:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788772220;
	bh=1emP0cFw/KcTNGkjkupGjM+UOv9S2UiuNhamk0iP0Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DBvLVtam79FKC40PUlFhIj0d2jIstyCQdVs+uX2OGe7eca5n18E128oESbt0vspL7
	 YUs7/DQX11ST3+ewjkdh/s/oIajMan5hLslm8af74ohm3xlBLcCaGWlK9hy08mReVb
	 qbXFpJzeyrOQBuoXq1ZZah6IvdUfK7AdvxkpYdcnqlzjpg6bBJzIrjBPS1XXIpnvUe
	 46w7nhHzckGAt3giPRwMxxW+NdFQgMkxgVHlqPiSFTkuzzTn0hCj2MdG4S7jmk6fIo
	 g00qh4mavu9vOcMwxBCsV61PnNmQ6O7jeFNx2DRjtP+Z4HfYKt1Xo4NYMTRk6AQXht
	 x0z5uB4cYoJ3g==
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
	linux-wireless@vger.kernel.org,
	Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 1/2 v7] gpiolib: turn off legacy interface by default
Date: Mon,  7 Sep 2026 11:09:55 +0200
Message-ID: <20260907090956.2825703-2-arnd@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260907090956.2825703-1-arnd@kernel.org>
References: <20260907090956.2825703-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Arnd Bergmann <arnd@arndb.de>

All users of the legacy interface now select CONFIG_GPIOLIB_LEGACY,
so it can be turned off by default and only get built on platforms
that still have one unconverted driver.

Allow turning it on manually for compile testing, in order to keep
the build coverage of the legacy drivers in allmodconfig and
randconfig.

Acked-by: Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>
Acked-by: Dmitry Torokhov <dmitry.torokhov@gmail.com> # for input
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/gpio/Kconfig | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
index a48586bb8edb..2b1f6f4c7446 100644
--- a/drivers/gpio/Kconfig
+++ b/drivers/gpio/Kconfig
@@ -4,7 +4,14 @@
 #
 
 config GPIOLIB_LEGACY
-	def_bool y
+	bool "Legacy GPIO interfaces" if COMPILE_TEST
+	help
+	  There are a few legacy platforms that use the traditional GPIO
+	  number based interfaces instead of GPIO descriptors.
+	  Say Y here to enable build testing drivers that are specific
+	  to those platforms.
+
+	  If unsure, say N.
 
 config HAVE_SHARED_GPIOS
 	bool
-- 
2.53.0

