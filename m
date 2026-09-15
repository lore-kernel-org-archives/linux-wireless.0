Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CAB1496D5E
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 12:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.225.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789476965; cv=pass; b=QZy6Z3mczDhGFe0rkxwQWwiNUrUoQTj7ETpzL3PX6dcGwuLPWuD+LWOCWNpQZfE6+WRTeaLMNumXXRV1o7+QeXRc2UEXFs9aEZ34glkYJQLd+D0R568BzLS2tZjMFRTJZ9Amtg0trUllUORUMwxaFt6BLIhjLbXZLgs3asQhwqw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789476965; c=relaxed/simple;
	bh=baaMnT89cPNVqXPQkVQWSMDLhlUPki/GSZrEtdhqx8c=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=VBPjYeFUS5QS1wRnH/cUS3Mj9JD6Qnpiq0Mda0C6vS7GYc5zKIDzk4vWUwhbi89h8a6Uq6a+Qs/ZUaqb2J+ya1DKgYTteQQDot9edmQx1KPNLj9UUAavN/dHJc5aErqlQmFxMof708M74ouaFliLL2pgzZPx62aHbDpLYw0xJ70=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jbjVc63F; arc=pass smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jbjVc63F"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cd4ba9f68so3243005e9.1
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 05:56:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789476962; cv=none;
        d=google.com; s=arc-20260327;
        b=iXVXh0DO6L84eWAA1/+lWVvcVcxv/+ZVGjW47S8gQtaERm3Vw/c8THu721eQLMbzJ2
         V2xFKJtYmWRzaSNftZL8+n9wiakCutvkebiB+DFiXQ+HfWWsMKIW/syrTW3+52YBgIpy
         n1p5ru+QWM/lTTJ+1Bje6jUPDxkMzZyfu/AsGz9joNvkzOexg27rzBa5Emctz37Ch+gV
         LpR3EkeRH0U/SSTdnEVuDYCmRtqiOL6qGB79862nmZbXzkrB9K5kG0Cr1zByf1JIzTgf
         3fbtWlasMhzpYtI68DijtpCzUjnsQt4AbKdcr0aEaWfm2O3jJb+hRUXrBgYaU1mdn3dL
         uiFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=8n0Js45vU35PZzaaYN/E5RF/R2jkrIXUS/+MZ49aY4c=;
        fh=JLMsAX/di76OVF4DOvwbV1oTNKCB/WUryKItQYkTrZY=;
        b=BAgjvSUxAI5p0uKjnjFwERVshPnMIp70gSMmokLZt5oFWmjqKUtLIlDILo2oaPsjTN
         ETOIKd4/uf+C5vav4h2xW2WPhVs1gbP4ldhSPHY2d7GOhHCJEvveyV/l6DygysPkYek6
         wXczbMorOZmRqPlVCyCZEP1GLrh5OMKncyfJRiyErUnQIFxipHip1Mh84MLyssWCvAsz
         bo7foWbGmlsuhZlnqyIkEa71rR146cFuI202hLXMfUeG/Nc6qP8vCmH4RbfGOgxn7mFP
         Ps2f6H9MKVdhYWXAa6Qud14NqkwyyXyXCXAwJYBbykIfgrvvhSTj3htz4b5s+VfEvZlm
         UGuw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789476962; x=1790081762; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=8n0Js45vU35PZzaaYN/E5RF/R2jkrIXUS/+MZ49aY4c=;
        b=jbjVc63FTAP+KcLS8lU33bcQMA+/XSFxrQumMs+uP5NSOyE6QAy/mVtGGDaE8DRF2M
         0tMpoaC1CVI6kkvkd6KMSneiQ3k9gW8+LTrGgdvxMdQ4meJpSThOMAhC3l9Zz488rTQx
         Kbmf1ZI/SutGEn8qYzXrA08fT82W5FvJrSKWkA8yQyLAt+3GErNSMJwE1zLVQCw/2bzJ
         vWdEbekDRcgegLzR3DN3DOOyPxwY4lpIWG1DgJrpR571h+pMefdndgcpymwS2HY5tFuA
         4dA+aNg51CRiRYPuFH/cYNE/y2r3YM6uAO99oh3zDsbdxB68uDWDL3GtrepA4/2IKkzG
         5djQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789476962; x=1790081762;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=8n0Js45vU35PZzaaYN/E5RF/R2jkrIXUS/+MZ49aY4c=;
        b=i33pXRfCGWHA+IMos//BVRaeKFLl3jfv4eL19CLVSraWRiri009UOfOQv2lfB5wDdu
         XMfcDyRrDnqN1paz5Ze/rYn4GPpJ65t4gFFhv7t00BxCBFop5j9taf4yCJUgLFrs5/Ct
         qswY//AeLBqI7TNB01NqhT9QSBF2r0lGy0Q50l/DSVPnK8bbALDXMjl0WFSQ6aWYN7RJ
         7b0evQonVzZNEMz+0UcP4KaJKUoJdUGS+AHmvHX0dTkPgSYTJE/YX/eB0EyIudZYiKAl
         LerWYxhtFgWTp1Do6+L76aZpSy6h/kL/O1ZUQGPv2WoT11evX7+pHJ42nAbVl5h7pDh9
         EC6g==
X-Gm-Message-State: AFuF++ka18ItFEkFCuy2DlDvbmV8VvzhtJN+61ATZBKysQl7WMJcw5mx
	kPcxB5D/uzBKQc1TFMO4gT8fDmp68uR6SOB0DHuPnV/Da5RZbs5W7kNW/I1dxKAnfHGHWB41Mj6
	JIks1TLxrJzvttvI1T7k65n4IObAoWnCI+bJKPlbr2l16
X-Gm-Gg: AYBFou2zBMduWtntWe0CIo2biuGzL6eOcvfl/Bh8/AADVY3XKcRjB+bOXvqOuN/P3zJ
	uYXdwA7zSQCpC2/sqmqvB/0ZihX5ocdU/IkOWX2TLQuqJP6j7Eh70X4iRUQZ+500ahLCmoiUpDm
	fpiCBEqFTVSAeoKbHJiLjsHw4WGjAeVyjU4ZE8VAfI0VB5VW+YDVQugaAVsBx0Y5+5bmFwbcXUc
	YjXkWtp+f6sjcFM23GFrLRFc9TmiA2mUC2imUSLylEGlGYGouvMxi1uktH1Whgbf9XiO0+GL1GK
	moRVoJv4TfamgUra51JVTj0kJ5NBaDJlzSmzWk98jadbc5IgzwZEq2d8wUeu8Lc+mw==
X-Received: by 2002:a05:600c:b95:b0:49c:fc6e:8cb1 with SMTP id
 5b1f17b1804b1-49e8227eb91mr13643015e9.21.1789476961737; Tue, 15 Sep 2026
 05:56:01 -0700 (PDT)
Received: from 830778650420 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 15 Sep 2026 05:56:01 -0700
Received: from 830778650420 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 15 Sep 2026 05:56:01 -0700
From: Ruslan Vagner <rusya92266@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Tue, 15 Sep 2026 05:56:01 -0700
X-Gm-Features: AcwNN1U1zKPKTXLYb4Q6VhkYyH8PU4_T-WqkIvrARQCYc7twGttHvS_jSM2ig-E
Message-ID: <CAF9RqJ7DS5LU7+8N+=cWZdi1P1Z-X583Ue9n2uHT4xopkeadpg@mail.gmail.com>
Subject: [PATCH] wifi: rtlwifi: fix comment typo in hal_btc.c
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com, Ruslan Vagner <rusya92266@gmail.com>
Content-Type: text/plain; charset="UTF-8"

Fix the spelling in comments. No functional change.

Signed-off-by: Ruslan Vagner <rusya92266@gmail.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
index b34dffc6a30c..b36f958a7363 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8723ae/hal_btc.c
@@ -889,7 +889,7 @@ void rtl8723e_dm_bt_set_bt_dm(struct ieee80211_hw *hw,

 	/* Note:
 	 * We should add delay for making sure
-	 *	sw DacSwing can be set sucessfully.
+	 *	sw DacSwing can be set successfully.
 	 * because of that rtl8723e_dm_bt_set_fw_2_ant_hid()
 	 *	and rtl8723e_dm_bt_set_fw_tdma_ctrl()
 	 * will overwrite the reg 0x880.
-- 
2.54.0.windows.1
