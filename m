Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C0CD4477F5;
	Thu,  6 Aug 2026 10:35:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786012522; cv=none; b=nh5PIVX4noAd72OLJpog9GQqmc1ddyxWLuIr0J+EDinXXeYaJqkNrqkA74h49yuRGJ7qevrM7JWsMGfioAD7sp5/zB13zQ6GpqPetUhhDmblpHzNdH76hpVoyhaJ9BePgn8jfL+8PzeQP+1DM4oxH3mMbZw/4uYtKZw5/7U+7Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786012522; c=relaxed/simple;
	bh=NFBKZhbY3HsASV/vW+tEFdgd6xq+w9xesjJca5IXly8=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=QxivTV0+CT5mfGtUzXj/QrQh+cZurDoxOI24YdQ9pw0HHvztIvmBo2hqo9ht5flybugFf7SvYsTt4KhKJ+phPogWyYpGollzznI6Ncaz8mBhy7gLmVZSVI6zFiAkIJ+03AT+y2Zy0ayt8QWXBwcMRBKb4O9IfX7/C9Qvy7IHP+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 403691F00A3D;
	Thu,  6 Aug 2026 10:35:18 +0000 (UTC)
From: Geert Uytterhoeven <geert+renesas@glider.be>
To: Sumit Garg <sumit.garg@oss.qualcomm.com>,
	Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	Arnd Bergmann <arnd@arndb.de>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Linus Walleij <linusw@kernel.org>
Cc: linux-arm-msm@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	Geert Uytterhoeven <geert+renesas@glider.be>
Subject: [PATCH] firmware: QCOM interfaces should depend on ARCH_QCOM
Date: Thu,  6 Aug 2026 12:35:15 +0200
Message-ID: <888efe8e63b6a18fae4acd5a90a1e0e69dcdf2ca.1786012495.git.geert+renesas@glider.be>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The various Qualcomm firmware interfaces are only present on Qualcomm
systems.  Hence add dependencies on ARCH_QCOM, to prevent asking the
user about them when configuring a kernel without Qualcomm SoC support.
Make QCOM_PAS invisible instead, as it is already selected by its users
when needed.

Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
---
I wondered whether QCOM_SCM should be made invisible, too, as it seems
to be selected by its users? But apparently commit 5c1a2975d23c51c0
("firmware: qcom_scm: Migrate to generic PAS service") in net-next/main
and soc/for-next made it visible on purpose?
---
 drivers/firmware/qcom/Kconfig | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/firmware/qcom/Kconfig b/drivers/firmware/qcom/Kconfig
index c7f8413ab996cf12..691db0ded8e8cf63 100644
--- a/drivers/firmware/qcom/Kconfig
+++ b/drivers/firmware/qcom/Kconfig
@@ -7,7 +7,7 @@
 menu "Qualcomm firmware drivers"
 
 config QCOM_PAS
-	tristate "Qualcomm generic PAS interface driver"
+	tristate "Qualcomm generic PAS interface driver" if COMPILE_TEST
 	help
 	  Enable the generic Peripheral Authentication Service (PAS) provided
 	  by the firmware. It acts as the common layer with different TZ
@@ -16,6 +16,7 @@ config QCOM_PAS
 
 config QCOM_PAS_TEE
 	tristate "Qualcomm PAS TEE interface driver"
+	depends on ARCH_QCOM || COMPILE_TEST
 	select QCOM_PAS
 	depends on TEE
 	depends on !CPU_BIG_ENDIAN
@@ -26,6 +27,7 @@ config QCOM_PAS_TEE
 
 config QCOM_SCM
 	tristate "Qualcomm PAS SCM interface driver"
+	depends on ARCH_QCOM || COMPILE_TEST
 	select QCOM_PAS
 	select QCOM_TZMEM
 	default y if ARCH_QCOM
-- 
2.43.0

