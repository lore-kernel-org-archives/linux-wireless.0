Received: from mail-qk2-f41.google.com (mail-qk2-f41.google.com [74.125.230.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB08739DBD0
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 21:18:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790025502; cv=none; b=L4Id5yPgtJqkFtxyqhfiu9eK2uXP8ZaNCT7vir2uLKNxDDzrlz2u0fDh2RSIAah/YgSVS7rJvhdnihHH/joaBFQypPDLXCcIzRdSrbmzprrB1BVdawFJZypPlTsxZaVDvhX7jsd1oLrAB6oeqz/JV0AwX7qFaz0a2azhpKNUu+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790025502; c=relaxed/simple;
	bh=qqUhYyhh0lWhKWnrQLYI0jwX7c0FSpVeehdl6bHeJFk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=BHupFC4nhpB5tlrAJ5irCFss0c8J0xf1QYGfSXoeFxw0m0LS+LUfvkw+TVkvwS+5+Bx3NQn4q4pPSWGEquKpfA+qC6cjKnbQMfal4ZifLo5MpN08pyfb+jJgxvjpsZ2JMSWpx3rplF7JS1yqVPncjosKgEojj1faafwCW/Et2+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=brivo.com; spf=pass smtp.mailfrom=brivo.com; dkim=pass (2048-bit key) header.d=brivo.com header.i=@brivo.com header.b=chu4m58U; arc=none smtp.client-ip=74.125.230.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=brivo.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=brivo.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brivo.com header.i=@brivo.com header.b="chu4m58U"
Received: by mail-qk2-f41.google.com with SMTP id d75a77b69052e-532c7643bc4so14983691cf.3
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 14:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brivo.com; s=google; t=1790025500; x=1790630300; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q1DBFyCtj/TBpWi0ynhywHcDx+OLl9aX7xs9S/Wz1mw=;
        b=chu4m58UeURd4xSqS49PxM2rco7NOcsO28GC4zAfGhI2+A3xpdTiPmDtYnYMPo7VGZ
         VLzi+nxv6cHpeGmdi/yi9q7kb4tI/OxyQslj/m6lbTRfpziqAYxlTzdOCZTCYrRTBJqR
         IK0t3o6pO4+UvyqcnWfpSmysg7536hVBiYwRRoclDOgfcl80TgRf5qoOoJUyDMjABJmd
         K2pu7hR7aSirk6c/Cgvv2YQWQy7TF187m4A94tUrO4tEILjm7VNqsmZS6h4w2pU7lmDs
         dkyZWBEn8wG0T8QP5A55sP3oeiehime4B5KKs017Jf41BFOrIdSUFdQnYUCZRQ713jJ0
         85EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790025500; x=1790630300;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Q1DBFyCtj/TBpWi0ynhywHcDx+OLl9aX7xs9S/Wz1mw=;
        b=BqdYKRLwiZss1B/xaSXUyuBOu4VIY8w5+1W+lWvCKa7vRfh2Ou1ieDJP0Tc3QgUL5y
         /E+d31NYK0vJGMKoETMAXwEnvE4t6Ix3nnTdj/sgwLTJxjyZG682/n5op6wpTFA3M70Z
         jEP1aLX3hHhWbZCS3+mfVegTe0aaqAsgdqIrFdPlYGShOPxXnEYfeCRbhBRPfrY16PCi
         EY05gs1sEOTs/ellypsFnYoxsmUD+RKgksMw3sZi+X72SOL3DPrgDgnXobus+O3A4Y5V
         3s85W/esphcaeWQl7Fl2owXLAowrXCYVwBJki1nHkY1PJXYVXD/ojKn0X9mkoMytaOOd
         3ZAA==
X-Forwarded-Encrypted: i=1; AKwUvByhsyR1wTnanPzuQv3rtw5erWdfRfLwMV5X5I5JNDORMx5Q30lgJ5aebR8z8JtMR6cBiA2rglg7MjYCis2wzg==@vger.kernel.org
X-Gm-Message-State: AFuF++nnIJnP1xQOV51ajPyDAaX7+tlv8HqPit69tgJs+JtQGl0rv3l8
	VX40Q82mUsAEJ/s9a8pkX9Ko7MHnMfnLkmG22qm2gS+KKJg6ltBk8uSN7ykBPYjsZ0TbNh1p1zS
	ny89KWxKl2x9MKTbFTqftk9tvxGOwjvc0LyUGex7RJ+jRhOrbvRetFBROb2DyAA==
X-Gm-Gg: AYBFou0iaYw9Vzg+wimBVlfRWKejJa3XgnYV7wJ4rF4JyKwrPjofnCjJ2VYffA6MDnd
	VOdp34sG+RPBvhoH1ZptcNITUa8ZjeTSAgJNM5Yghz5QoEJW3JpHLkrQDNuBiSoZtQWPO9u+f2l
	gk9V2l8E7vnYBsWsOt1PlwO1bD16AJ74AybtBoaHwJF8bW7vD3L2qIKiBFhn7YQEePFtUVDcf/5
	fDIqJYeMSrzYVNd53MRSNVvofNP3HcmSX8VlfuZHDao0+evMYVly5AKH78E5sRJ6TBY+DgxNUSl
	a/AMVAm9MZfMBtPZ3pLGF+flTErod/kmKe6qCyisOEUrM38DPdRBXyF5wCm5GAmQdjS/3MTbyu7
	0qE7gripdr2pT5GJPdgjAZPOwYtWYOVIhNp6MigqiVAsDboFfVp3WF9KnpIOZIwRJfUieMaFJ8n
	56snchlJaZbs0hHlMTQr4FOYBa3eyd8+odhJX1YxP6OKZaaONWBB91YrbK6/GJVO0=
X-Received: by 2002:ac8:5882:0:b0:51c:fc4:a144 with SMTP id d75a77b69052e-532d8d3182bmr26212061cf.4.1790025499820;
        Mon, 21 Sep 2026 14:18:19 -0700 (PDT)
Received: from strozzi ([66.193.28.125])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532df63ab0dsm267121cf.26.2026.09.21.14.18.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 14:18:19 -0700 (PDT)
From: Sean Anderson <sanderson@brivo.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
	linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>,
	brcm80211@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	brcm80211-dev-list.pdl@broadcom.com,
	Sean Anderson <sanderson@brivo.com>,
	=?UTF-8?q?C=C3=A1ssio=20Gabriel?= <cassiogabrielcontato@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Franky Lin <franky.lin@broadcom.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	driver-core@lists.linux.dev
Subject: [PATCH 0/4] wifi: brcmfmac: Fix bugs when the device is removed before firmware is loaded
Date: Mon, 21 Sep 2026 17:18:10 -0400
Message-ID: <20260921211817.2432341-1-sanderson@brivo.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

I was working on a different bug, and I noticed that brcmfmac tends to
crash quite spectacularly when the device gets removed before the
firmware request completes. This is because brcmfmac does quite a lot of
initialization that would be normally be done in probe() only when the
firmware is loaded. I found two general classes of bugs:

- Some of the remove paths try to clean up things that the firmware
  request callback sets up, which doesn't work too well if the firmware
  isn't loaded (patches 1 and 2).
- The firmware request callback generally assumes that the driver is
  still alive and kicking. So if it runs after the driver is removed it
  will procede to access all sorts of memory after it's been free'd.

A fairly-reliable way to trigger these bugs is to edit really_probe in
drivers/base/dd.c and replace

    IS_ENABLED(CONFIG_DEBUG_TEST_DRIVER_REMOVE)

with

    !strcmp("brcmfmac", drv->name)

Alternatively, you can use the name of the bus's driver.

I have only tested these fixes on SDIO. I would really appreciate if
someone could test this series on PCIe with the above snippet in their
kernel (preferably with KASAN).

Right now if the firmware cannot be loaded for whatever reason then the
firmware request callback will unbind the driver. This is incompatible
with canceling the firmware request and waiting for it to complete in
the driver's remove() callback. As such, I removed this behavior so the
device now sticks around even if we can't load the firmware. If this
behavior is really, truly desired then we can drop device_lock while
waiting for the firmware request to complete and attempt to recover from
the consequences.


Sean Anderson (4):
  wifi: brcmfmac: Fix canceling uninitialized datawork
  wifi: brcmfmac: Fix brcmf_pno_detach NULL-pointer deference
  firmware_loader: Return status from request_firmware_nowait_cancel
  wifi: brcmfmac: Fix firmware requests racing against SDIO removal

 drivers/base/firmware_loader/main.c           | 11 +++++---
 .../broadcom/brcm80211/brcmfmac/bcmsdh.c      |  7 ++++-
 .../broadcom/brcm80211/brcmfmac/bus.h         |  2 ++
 .../broadcom/brcm80211/brcmfmac/core.c        |  3 +--
 .../broadcom/brcm80211/brcmfmac/firmware.c    | 26 ++++++++++++++++---
 .../broadcom/brcm80211/brcmfmac/firmware.h    | 16 +++++++++++-
 .../broadcom/brcm80211/brcmfmac/pcie.c        | 11 +++++---
 .../broadcom/brcm80211/brcmfmac/pno.c         |  2 ++
 .../broadcom/brcm80211/brcmfmac/sdio.c        |  8 +++---
 .../broadcom/brcm80211/brcmfmac/usb.c         |  6 +++--
 include/linux/firmware.h                      |  2 +-
 11 files changed, 75 insertions(+), 19 deletions(-)

---
base-commit: 587858367581b9c55c3690f4e63382ad622719d4
branch: brcmfmac_firmware_cancel

-- 
2.53.0

