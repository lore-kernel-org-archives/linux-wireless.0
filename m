Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8FA3A5E71
	for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2026 05:25:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787894730; cv=pass; b=JFuEEnQjVcJyo10gxuEcJHnCC4dsgnB4vPjbzdOgI/XC0dAxsE/YyXF4R3JxonzcGU4CyDAk5wJALFIWoSslC6ANOWUo6g4Qb7KhZBGMSrr7mo6/yMMznTha1rq/U6CJI7CalFsRnkp6aMggfICKNLPaoDMMvhd0WbIIGtCjJ4c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787894730; c=relaxed/simple;
	bh=+Z2wmbjzuF9Zhx+bZruklzKVeL6Bf+IooszdmREeZr8=;
	h=From:MIME-Version:Date:Message-ID:Subject:To:Cc:Content-Type; b=LAjt67VZ0VWNRWz/ezpBmfgj9189eqDMLLQzgs+H40FuTabohgYRUEG/xphPrY1oXDMWBtslf33Y0tmD7BPcOwfLrLLBiWREJeBUPBSlMnYYNuHZccVCb8yX18/FDXg0pA3QRyYODpAPZM9rhPoAFOiyEFdgpKckWQZpSpshx1M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu; spf=pass smtp.mailfrom=berkeley.edu; dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b=N2jm9UrP; arc=pass smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=berkeley.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=berkeley.edu header.i=@berkeley.edu header.b="N2jm9UrP"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2d71ae3455aso9173435ad.1
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2026 22:25:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787894729; cv=none;
        d=google.com; s=arc-20260327;
        b=MO8l2sBEFfxHKWh/rzBHZQESdW/nTEEID1YaBGgIz098obOlFyj/Afhd+1+W9iM63t
         oPzT72uuZBj5WWNDl+M3Q52xBhuf5kmrsjZQZFx36XLrLQWTHg5pu4GVvDf6fZwCGIgI
         JiDmNSqiONtfHquD6JWoIVHpIxE7f7CHk65f1FgHG3PDpu/jWvvlEbmfpLcY13Lbq4JP
         7ZuqA4j5rBW0DHkAtK7jK3f4iT544CHEEeLr91XL2t05SbdZdglcSswmTIzrgGpkbF+u
         ltBzkSsTRS11XXbRTUWS5T+lagLsSzW3F7w2QezgMlXMtM1OlpZ/XpN//HOdL5aoxaYc
         HuZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=mGN/lRZxU29BbpBQ8ZOdkFlQFbCpaIXAxgjyVfKXT/4=;
        fh=11q8Xi0cDPzeF2zU07HwoZAzdoyUNzKWkaCvDkgp7Mw=;
        b=HimTA2zksMMHo8szCOv5FeXZDobx1e7GxoZRBzNj9fFWe9EQ421xGmHR+MZgvu0fTm
         4LameJryA2NcPDYFhVOo0A9Q5XJzjwM5vmxWDhH5gaMcfCqBRYPq6Q9is9h6MA8YmWnD
         e3G0eeQ8i+p2w6m2cv+bQWxdQUvzdn12oESWbdUKoYspTFeapZvP7ZcxA3Ykub4z7fLl
         ltcUqSiYgPHikxtmBnWC11F4tP1rigFhjQEgX8v0ZLZ2Zzgyp4SdxqI31JUvLQBgIWMJ
         wGIgYYuorT9XW0NcRGUDoQz7WNzyrcixvnICTtB4ay59yMca1Pc17Zn/ehD0MlQfq1yr
         Td+g==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=berkeley.edu; s=google; t=1787894729; x=1788499529; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=mGN/lRZxU29BbpBQ8ZOdkFlQFbCpaIXAxgjyVfKXT/4=;
        b=N2jm9UrPLVhxvtvu3ebc3dhSn/kAt6ZwDixbaNgjPKCATj9EBiiQPwkB130NXW38XR
         zTqinY/C9iHPauBxU0m0lZn1duSsfO94KVEyrLLoFJejZXXeJnmnctEgSg5QwTj/5E/d
         IDzLaKAHGXkeSx3iquOHa8pl2ME5jBLBY9zPSqM/4A/fT2fE8X/GBrRts8/NhNA40WqF
         rXOhYFmSfFzJesUbSineOCl6/YTcW/v3AnyhfBxMvnMTICGgEoNNdPWIuvlM7HfCLcWu
         HZ0lt+zReTf3dzXSSqj6YI7w9maByG/VI3NnEqJfkw+F5K3SdGM4oE/+kJCLmZkFUqsD
         IRDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787894729; x=1788499529;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=mGN/lRZxU29BbpBQ8ZOdkFlQFbCpaIXAxgjyVfKXT/4=;
        b=HtQNcov4BVn9/44PQu7OBKvRUEwPCAZ+LCdC5Qe+zsnJdiWgosxjhU+Q2JlSPxt+fF
         LeiberqJaxzrZg00AtFkIHVtyvRojpMAOmE3TPpUxqEa7IaNZCoNTy/hFeyc95P9Y4I8
         tR4Sr8vcmiuXX1D9D2t0VQ1r8ft0UGHKRIHt5WBJKPHv6a7PuhfvKuPo3K8aPq4w+Qdv
         m2pQAqViwFCovehcGZqDkY2uCIiRkiao5qdVzHK4GQU7wHWOlkHM/Xw+ifybRVFNJR94
         top5jJi1KobgvDgHmuEbQcbtai1C+09hrVes9fkYtNEFXTQSGHxBGI7pL0Y2gzpOTXLg
         EBWg==
X-Forwarded-Encrypted: i=1; AHgh+RoAM2A4O8wmbkDFtlqChp4DVl78sdgtVdMWrX4ap2fOQF1eLjzCtI8ZYSUDHp+TshzqZjZ1barNPzbDmRk0EA==@vger.kernel.org
X-Gm-Message-State: AFuF++ktOP2m67DC0KZR5joKqcPyk6g8zOfiX57KZjbBxj8Y5fIwHpwq
	bE7VnwSgvCsJKLPlgp0lQmJEoG2njIyyiRb7rZ6XixcE1eUQz5LFbwzsndfQ1FplaF5TZYQP8z9
	Xx9R88BfPl6WGqE1T5v35UdIDYSlszmSSWkHlxFTA
X-Gm-Gg: AR+sD113iZJA/W/py4m9PT4IIVwJUdT9iTtiRg+fOUNZaznvt3vpn2lIDGrgWJgLga4
	MbkUl3rGyN8HgnizYwU9bBUVfO4XZZK62f+8+Acu4eDVgr94Gz8sMVg/T/wK+zFo4vD1Xnpg6uP
	/RqWds0uER4/WT14MnVIcG6bLyR1dT3m8CRYQYzsKb09z+9z8+RGcChm9Xco8oB3LafVydRDpAC
	3hSAwao46Nxb5GZRjrA9/ca6it0cmQ0v8EB7Fhh0SbvybePoo1KISyVzEZ51QxBP8IDYssyhY+t
	iURUKRR+Rr0zU+Jq35uBiiloxp1/LiJ2E6IU0seWplwMnYidAivVwyoyKYUpuWdxOF3BE3fjelj
	wc0UvhWB8SixwmNeFp5Ry2EmkR3FgyR1X68SUS13kxHw=
X-Received: by 2002:a17:902:f705:b0:2ca:d9b3:715e with SMTP id
 d9443c01a7336-2d74ddc1f8amr83557495ad.9.1787894727597; Thu, 27 Aug 2026
 22:25:27 -0700 (PDT)
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 22:25:26 -0700
Received: from 474444807712 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 27 Aug 2026 22:25:26 -0700
From: Farhad Alemi <farhad.alemi@berkeley.edu>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 27 Aug 2026 22:25:26 -0700
X-Gm-Features: AcwNN1WpakcA9pl0JhjRkudW_kJKamE1iEzN7R2J-FKPFrJJjD_piymV01P_fhU
Message-ID: <CA+0ovCgiXX28Mdyu5xA4mDU2pPwoByEzEKgLn5JnfapEKg+PmA@mail.gmail.com>
Subject: [BUG] ath9k_htc_tx_cleanup_timer -- ODEBUG free-active-timer and
 use-after-free on USB unplug
To: =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@toke.dk>, 
	Jeff Johnson <jjohnson@kernel.org>
Cc: falemi@asu.edu, linux-wireless@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hello,

As part of the kernel research at ASU's SEFCOM
lab, we hit the crash below. Crash reports can be found here:

  https://github.com/farhad-alemi/public_bug_reports/tree/main/137-ath9k_htc-timer-outlives-wiphy/

  usb 1-1: USB disconnect, device number 5
  ODEBUG: free active (active state 0) object: ffff88811ead3940 object
type: timer_list hint: ath9k_htc_tx_cleanup_timer+0x0/0x4d0
  WARNING: lib/debugobjects.c:632 at debug_print_object+0xec/0x230,
CPU#0: kworker/0:3/2242
  Workqueue: usb_hub_wq hub_event
  Call Trace:
   debug_check_no_obj_freed+0x3a2/0x470
   __free_frozen_pages+0x5d1/0xd90
   device_release+0xc4/0x1f0
   kobject_put+0x228/0x560
   ath9k_hif_usb_disconnect+0x135/0x240
   usb_unbind_interface+0x26e/0x910
   device_release_driver_internal+0x4d9/0x870
   bus_remove_device+0x455/0x570
   device_del+0x527/0x8f0

  BUG: KASAN: slab-use-after-free in _raw_spin_lock+0x2e/0x40
  Read of size 1 at addr ffff888105d701c0 by task kworker/0:3/2242
  Call Trace:
   <IRQ>
   lock_acquire+0x84/0x350
   _raw_spin_lock+0x2e/0x40
   ath9k_htc_tx_cleanup_timer+0x57/0x4d0
   call_timer_fn+0x18d/0x5f0
   __run_timer_base+0x652/0x8b0
   run_timer_softirq+0xb7/0x170
   handle_softirqs+0x22c/0x860
   </IRQ>

Our reproducer.c is available upon request.

Happy to test a patch if that would help.

Regards,
