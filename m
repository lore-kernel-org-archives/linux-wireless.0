Received: from mail-yb1-f178.google.com (mail-yb1-f178.google.com [209.85.219.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A2541B812
	for <linux-wireless@vger.kernel.org>; Sun,  7 Jul 2024 11:47:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720352833; cv=none; b=cXC3QxKWBoIfj1EnkvORsMH4sJbrG50W27D1RNntW27JY5A3wh7kSukJpTTMoAmlq/eIcb9n+JsrVOkhPGqc5p/pkQcadzzYVQqSoyrWRCymnMcZmk95CRJWBLVXy9u0lt31z7O7Jcco1hvL8C/Zx/+0OnvnqOGdFb9u5r/PCqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720352833; c=relaxed/simple;
	bh=hlpr77o0KjX2X+mZ1mt5vhbcM/4B3GhEtV0sv7HsF0Q=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=IhGRVSmEiXn5c7UwVJyfwlhoZjSOwPfLUJDs39I1jHc1tiORP2BJIysPRhGSNP6DLWNzIS2FvFRWIoS3MXepbzOUY724Hc/v5msj/ViVlTdm+1oVT12kMZqXc1XKGaz1a3ub1uHCyu0JIqUwv5HKVWVBA2I8cghzMTn8WQJv/yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e4DGGxmw; arc=none smtp.client-ip=209.85.219.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e4DGGxmw"
Received: by mail-yb1-f178.google.com with SMTP id 3f1490d57ef6-e03caab48a2so1902846276.1
        for <linux-wireless@vger.kernel.org>; Sun, 07 Jul 2024 04:47:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720352831; x=1720957631; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=h1LHw2vyC1RS8RVkN1Ue3pUuAeMTdCT4rBbWggPI8os=;
        b=e4DGGxmw5RgLo4K2dojU4xzErTGgDgloBVyrxXa+he3JbIyCI3bQ9i5d3SVjptGD2z
         9rOe8XzNdE5z2BcqqkcS99LHK6evf/oqEtU3ZeuryIXAgBrCq1Mj6sewMB8blHeQrDXp
         ptfyigN7hzCwsDEPIJuf2Kn8jAvdZAVIGcd9ONQrimPQA3hydyyjy7Qw1OIliScmMT0E
         QiL70qKguuPb1GCo8ouDRV2G4iIeZyaM9HsYngu3Xw1n8EkkmhFghtvdVsofQlixS5u5
         XABAAXm9FEn54AlBKTcPiRRXukdg5IiLR2fENbnRKXTWxSWA6gdaY2mhiqu+11anVejI
         Pw7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720352831; x=1720957631;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=h1LHw2vyC1RS8RVkN1Ue3pUuAeMTdCT4rBbWggPI8os=;
        b=Aiv+F4U9lKhIxdczI8eQtmubxK7m1KVlceqqgEHbJQt/LymLoT7FERMOVVIRkkjpHK
         wW9TI4RFAtz4xg2TBM+jsQyJ97QD2xGXPkRqZgANzdn0cIhXn6MzF+2IODScSfzba91T
         txccQvOw6KAPB5HrjwK8oNdao2njkDQNtLqbmA6fH3qkg9RJtBrtDo2A70srZlqY/Q5H
         JizLtFMU/wC6M5D6dXuRt36CgRvAWRh9gvzxDxGqZJpKs3dThSWJ0jkBrTPaaPoRTAq0
         fNrE0hJZDln9LjRCg3xJ9IYugeWja9KVhWb92vYcR/lcF0LLEp0X+GglTE+hqQfuoT2A
         Gb9Q==
X-Gm-Message-State: AOJu0YwK5CjRVxLd99Ep/qnXywEZx2w8i3PDoP28FyD3GJZK6x5Kign9
	YwgGHumFMvdsUVE5kswqbk5/6Zrjzp9mZZ/Wboizb2ljP/KZQJOIY8qVbUs318BnqYeWSVQB0GI
	aG55e6xAQbdaPbvniAzBLkYxbtffLY4t1WAY=
X-Google-Smtp-Source: AGHT+IFpS0yM4FWB9OEjl7SUs183pbEm2fPT5sIvBGn0rEHnEe1xanS3FQHEadCVs6Vi/QhOn/hIqcInBA96cEId05M=
X-Received: by 2002:a5b:8c9:0:b0:e03:a40c:ea0d with SMTP id
 3f1490d57ef6-e03c29ecc95mr5861049276.16.1720352831432; Sun, 07 Jul 2024
 04:47:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Nikolay Nikolov <dobrev666@gmail.com>
Date: Sun, 7 Jul 2024 13:47:01 +0200
Message-ID: <CAHP5HDNpCywoyJA5pCzo1t_eS7FurYqa1Hr6Ac8fGgzfWZyKMg@mail.gmail.com>
Subject: [PATCH 1/1] wifi: brcm80211: brcmfmac: Prevent sdio bus going to
 sleep while transfering data
To: linux-wireless@vger.kernel.org, nikolay.nikolov@bench.com, 
	brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com, 
	arend.vanspriel@broadcom.com
Content-Type: text/plain; charset="UTF-8"

Use mutex to prevent sdio bus to be put to sleep by the sdio_bus_watchdog
while sdio dataworker handles sdio_dpc data transfers.

Signed-off-by: Nikolay Nikolov <nikolay.nikolov@bench.com>

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 6b38d9de71af..26d0bce6cedc 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -524,6 +524,7 @@ struct brcmf_sdio {
  bool txglom; /* host tx glomming enable flag */
  u16 head_align; /* buffer pointer alignment */
  u16 sgentry_align; /* scatter-gather buffer alignment */
+ struct mutex dpc_mutex;
 };

 /* clkstate */
@@ -3724,6 +3725,7 @@ static void brcmf_sdio_bus_watchdog(struct
brcmf_sdio *bus)
  }
 #endif /* DEBUG */

+ mutex_lock(&bus->dpc_mutex);
  /* On idle timeout clear activity flag and/or turn off clock */
  if (!bus->dpc_triggered) {
  rmb();
@@ -3748,6 +3750,7 @@ static void brcmf_sdio_bus_watchdog(struct
brcmf_sdio *bus)
  } else {
  bus->idlecount = 0;
  }
+ mutex_unlock(&bus->dpc_mutex);
 }

 static void brcmf_sdio_dataworker(struct work_struct *work)
@@ -3755,6 +3758,7 @@ static void brcmf_sdio_dataworker(struct
work_struct *work)
  struct brcmf_sdio *bus = container_of(work, struct brcmf_sdio,
       datawork);

+ mutex_lock(&bus->dpc_mutex);
  bus->dpc_running = true;
  wmb();
  while (READ_ONCE(bus->dpc_triggered)) {
@@ -3763,6 +3767,7 @@ static void brcmf_sdio_dataworker(struct
work_struct *work)
  bus->idlecount = 0;
  }
  bus->dpc_running = false;
+ mutex_unlock(&bus->dpc_mutex);
  if (brcmf_sdiod_freezing(bus->sdiodev)) {
  brcmf_sdiod_change_state(bus->sdiodev, BRCMF_SDIOD_DOWN);
  brcmf_sdiod_try_freeze(bus->sdiodev);
@@ -4525,6 +4530,7 @@ struct brcmf_sdio *brcmf_sdio_probe(struct
brcmf_sdio_dev *sdiodev)

  /* SR state */
  bus->sr_enabled = false;
+ mutex_init(&bus->dpc_mutex);

  brcmf_dbg(INFO, "completed!!\n");
