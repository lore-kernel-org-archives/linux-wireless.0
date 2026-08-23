Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B3F126299
	for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 09:47:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787478423; cv=none; b=m3agJvrHMKpd8O90Z8QxeuNdWzL96mvKNQqV8GjUc/eap5v1vgdBulHIeNVhUmV9KGE1ILFxH/todAeA0Nzw6yR1DWtn0D5DqoNDBKpZtnxRCPkGUvTylCAfKOzkRzDj8OCg116/CFvlABFzKJ4bpjN7p+uG4vZVT48fxaHwsDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787478423; c=relaxed/simple;
	bh=GqfhTtMJCzUksc4tDvLshgRslTc7w3T8/u0NikPA5u0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=TBmGl/omjd6lVXVxo0VbOB+LCaHgOOo1fa9Qh1nacZAD1nxuVU1i8vmId96+NodyahsAZpYq4xuNbqQeTEQc4kTcQUtKNh8DgFjkiTjfUROV2os471CjNcF5bQ5qJXWM4vyv34eNZCMinrdIQPjEI9POW9GZTYyLGdfD0bDldIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gHyY6hku; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gHyY6hku"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6a18e24ad25so3435650a12.1
        for <linux-wireless@vger.kernel.org>; Sun, 23 Aug 2026 02:47:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787478420; x=1788083220; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4Eb0FArlPSP0jjNeelItWla0WW3OSimofzp4gZfTLuM=;
        b=gHyY6hkuxq2N/97omLsbIWVaKUBj4nmKGjYISh6jsqkuV5Bz5KpRrkFMRUHYUA+vPf
         /9PoofgziUIIX8R9rzDjQ0Tmatfs90cUK7IIYxPvPKlFbb05IT46o508ffFJK9JbOjxX
         6mxMVAAo8/wYxSna7HOq1sEgzJO3FumAOEqj2GgC7OeTfjOddbCwPa2YxB/YXFJ9I4Wu
         KSGMYaBOsfATHnHr1tiziyXBpcrsT2Rt6ZwcWH0TUQOrg+1IHPuEvDBLT1O1tOfRBqHq
         IuG5slPlrlOpVfi95k0dumMxYI2Ql04pbqCMu6sya731C/l/hXuwjalfxbDfAGSOXDC8
         NGuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787478420; x=1788083220;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=4Eb0FArlPSP0jjNeelItWla0WW3OSimofzp4gZfTLuM=;
        b=Fwzz3z8HKoX1wBc+WEPXNd3nY8+PMGoeRYQKVav2nhzHpC/rSne9ubpwRgJZBck34F
         m9oozbLhLqivM5inDJc9gHwhLElgjUuRWZ9cSaC+NCb47Yno3MdCuWrqUdh/iB84T6A8
         HuLWdBUxar6NDfHxRGP9hQzu3kBjjbW2RyGTAnEOBQvP5nRN6/Ud7Wre8EEgAhz0nvob
         cu1EUXKqw6G7R1rl3hXaDLIo3Zm8bBpr1rv9KJxTJCArFstobkUHfEYsiQ8chsE4cPgR
         Jz49xODaOT+m7eBCP48TK+S6OUPlU0qsNO6wOCJQDxsKHgL9iaml7gc/D2Yp2eE625cY
         zAhQ==
X-Gm-Message-State: AFuF++nvSMJKJZkbHU5Fj6HTbrPQmih7onC+SBmgLuTI3VC2gBpgptdG
	1rDEtT5te+vo+auUEVYVIQp6lo1HgQ+7B4tfwqU4LXS6czsByfe1oZB9
X-Gm-Gg: AR+sD10V4jFxm7HO1JeZwJPTFAyJ2gN/+GBXT0FnkcU1Kbfl7lNCktQQOMhC4VuSsow
	Sy09+EL+42vA3wEenB3j8WMIleRN13pY3F8DJVe55pMgIxnqPf5M1IPWQiVDlwz2JtpPEd+0W7B
	kzU56xlEUXQnfz07bz5wlrbcZN8V2U3XmNjJe7a2YzkgeyDce57h3O0tIFAWZnEI4tyQotQOpo6
	kQCVqf4f+Xw86larOK9tOJydL03SRXAuAz1GQB8TJiTnz1hyg/ixvPxErjryrXq6KD5gOAA6aN1
	aQPRp1qhgMagkMBCd+GH5wINjsaBCIO6uPnnhrOWJSbiYqtsy+P1PORov0Jw8rXOqWWxOj7kKo5
	ErCqmdGl/FVy+Q2oIFJn+z6tflMd0iQSkH7MFxmCxAcu+VcZjtwcUU2Gbm4rXmpVoFALtwp1IUm
	aUhhIzsBKREZKgpbX0NZf/Jcdud0z/vb6XSXLNSB81xgHPyvIqQhb88HEGhx/368OidsDCdKo=
X-Received: by 2002:a17:906:730e:b0:c24:7cb5:d617 with SMTP id a640c23a62f3a-c249238c369mr1253075866b.1.1787478419600;
        Sun, 23 Aug 2026 02:46:59 -0700 (PDT)
Received: from NBLK-WAX9X.local ([81.214.177.121])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2496295632sm777783266b.18.2026.08.23.02.46.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Aug 2026 02:46:59 -0700 (PDT)
From: =?UTF-8?q?Ata=20=C4=B0lhan=20K=C3=B6kt=C3=BCrk?= <atailhan2006@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Ata=20=C4=B0lhan=20K=C3=B6kt=C3=BCrk?= <atailhan2006@gmail.com>
Subject: [PATCH v2] wifi: rtw88: disable ASPM for Lenovo IdeaPad S340-14IWL
Date: Sun, 23 Aug 2026 12:46:40 +0300
Message-ID: <20260823094640.22585-1-atailhan2006@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The Lenovo IdeaPad S340-14IWL (DMI product name "81N4") experiences
severe connectivity issues with the Realtek 8822BE rtw88 PCIe
wireless card when ASPM is enabled. Reported symptoms include
frequent disconnections, cannot resume after sleep, kernel panics,
and the driver failing to load time to time.

The issue can be worked around by either adding pci=noaspm to the
kernel command line or by reloading the driver with disable_aspm=1
via modprobe. Add a DMI quirk to disable ASPM automatically for
this device.

Signed-off-by: Ata İlhan Köktürk <atailhan2006@gmail.com>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index a30467228..4befc0eeb 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1779,6 +1779,15 @@ static const struct dmi_system_id rtw_pci_quirks[] = {
 		.driver_data = (void *)(BIT(QUIRK_DIS_CAP_PCI_ASPM) |
 					BIT(QUIRK_DIS_CAP_LPS_DEEP)),
 	},
+	{
+		.callback = rtw_pci_disable_caps,
+		.ident = "Lenovo IdeaPad S340-14IWL",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "81N4"),
+		},
+		.driver_data = (void *)BIT(QUIRK_DIS_CAP_PCI_ASPM),
+	},
 	{}
 };
 
-- 
2.55.0

