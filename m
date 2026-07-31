Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5F81DFFD
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 09:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785490940; cv=none; b=apDrqjw0jQ0ocDfNBg4AWX4qAbmnkuSs+m+X8qPh8bVU1LeoU9QVMtbmBId+2sghF0RtXad5LMyagpeInNnA343zVNoVDKqP8Q6YNSnGZDylP6HxHtAi7czuYlFn56wd6Fl3Zq3+RCWETNyd5JI2B2Jng+7Wg6UT+/CENKQPu3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785490940; c=relaxed/simple;
	bh=/sMZ44Pocth7b2esot+iw8SG2kdoHCcebAi4HSABt0g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ojVgEI3lss+kMUMS/g5GzeNUBEaiR49DqUgSDF6Fo8x3xeUYscQOe27rcwkb1m+r7PbUoCnJLk8RuVknZEemaSaGAnsH+tdXG08cWl7/lb5c5ngPu+X5S18rHMQYsktKUrSePOW9nZo1aWwm3V0cHXEQb9XM3wVuAjPo7GVOAOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P+Pwn1GV; arc=none smtp.client-ip=209.85.167.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P+Pwn1GV"
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-5aeb8c19017so963473e87.0
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 02:42:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785490937; x=1786095737; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kndbL1WYWRnbylNGfVVjyaYdbj/n6MK/vKmn3IV2Im0=;
        b=P+Pwn1GVrCzMxJaK2xI7Xeoo7AIzscIfFbd/KElsrwaia0rBONvZeh4NOHy1aKZv8w
         ReRFGJR4qDcyfsHMpXrrLCxuVfkn54zjjS5Y6tYJHV/fKUfBcjOgy35+EETKhYYBKakz
         81ijdGM8iDqO4aoNKDYkOBRIO1RlCIGIZ1BOpucGsNRk4fXzeTo5kDc6FCPAeClSROns
         VkFhFjNU5hBD3kivg41mscyc40nSRgS2+MWvOynp6kQleQpBJTN3RufloMkAl9b7sFpn
         wy61wcSUAdc1Q4CNV8xVaRNe5ZaJcvQACr4qljlSe+tq1eDmrzHxaoR44YLykM6qhaMn
         AwDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785490937; x=1786095737;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kndbL1WYWRnbylNGfVVjyaYdbj/n6MK/vKmn3IV2Im0=;
        b=K5YJ+9M2TtO01ZQyDQZKFsCinGCKfw/6C2Qb3ooDbwJac4iPvo4rve+rYGV/n4VkGa
         fn+QwvdCIVa/wDy3M9g+dIhC5CP6JT+P6/NXoAYOyFWaYvSGjO5IMV2NpWk5P/XWRe0a
         p8xI0IhraGnh+FndLtvWGMw5IpZXtgOiRAwy1ropxnMnMeHzghrhyK1SVv4QGDRCfOzA
         H40rNpJCLh/DwSnd+/hOiz1QpH5wxZxr3iQV/Qw4S8dc9p5vcbwTPGfBZZkDQDsngLTh
         wY29ci8kqJWT6FiBIhfBh7dz7kkRrMBO44x0StL3184M2lKZ2+uJ69D2DKP9+WOJqMK9
         eXZw==
X-Gm-Message-State: AOJu0YwhyxdOH5HStw1Mv/vbS0luTwiKxSkjJWqbEyPhVSghEQvyytCu
	1qdSqRHvQBX4xb+mV12IAFRyIBlkvs3bOb8xCnCTYklHworY7POizCNMu4tQEw==
X-Gm-Gg: AR+sD12o/YkP2/Hop8AseS6JIRIpc7mgZ/VQ4b8cfYTITDBaFpqZYj7SdXTcAO0Ra/V
	JJvVWs+TZ/fb08sVKr9E4Wil7B0vk8RIyqC3R+/351SpMl8LTPnlgl3tZbwWeOjOjznD8bQY9Ss
	bMOr3XkpU9y9fio7JjnE+YDoGnlTSZKR3xfM+Q1ARFF5VRWi3hua63XIP30aOamS7cT3hcnCLa/
	m1cYlsXFcItAfSsnBpkF+Q3eGiPSWZgEaSCJ7JTrxbIA7pIMiv4L6J/dRjgBVZ6Nvn5syrTC2o8
	NwO9AIvRVy+0FQ4PHuFqtM7ANV8bI37Bfa1AeMW9QBsJYlEIICAZX8E0GyUS2gIUXJoIrNZpBOh
	N5GpzQYQi69Bc0GGBqyTECjAiWnIaK6NjzecQDDr8D53+1DY0nIi0DlD5WI8CooPzWZE6mrKm9h
	WiTpLHNwn1NITkxNlfswNvwDdbZr2SSG+f8qk45Hstwx5wseOMvSvqgqPwAhEMGXlBf1CIt5Aei
	eTM9XX2JIVQl9TGAS9b2tXRxI0=
X-Received: by 2002:a05:6512:3e10:b0:5b2:925d:6c6f with SMTP id 2adb3069b0e04-5b2e1ff0365mr320415e87.34.1785490936676;
        Fri, 31 Jul 2026 02:42:16 -0700 (PDT)
Received: from zbok.dom.lan (89-79-165-104.dynamic.play.pl. [89.79.165.104])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b2e23cb4f1sm204595e87.18.2026.07.31.02.42.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 31 Jul 2026 02:42:16 -0700 (PDT)
From: Kamil Bienkiewicz <perceivalpercy@gmail.com>
To: linux-wireless@vger.kernel.org,
	Jeff Johnson <jjohnson@kernel.org>
Cc: ath12k@lists.infradead.org
Subject: [BUG] ath12k: NULL deref in ath12k_mac_op_hw_scan() when a scan is requested during firmware recovery (IPQ5332 + QCN9274)
Date: Fri, 31 Jul 2026 11:41:41 +0200
Message-ID: <20260731094141.2410630-1-perceivalpercy@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

A scan request that arrives while the device is recovering from a firmware
crash oopses the kernel in ath12k_mac_op_hw_scan(). Because the oops reboots
the AP and the same firmware crash tends to recur on the next boot, this
presents as a boot loop rather than a one-off crash.

Hardware:  GL.iNet GL-BE9300 (Flint 3) - IPQ5332 (ath12k_wifi7 AHB, 2.4 GHz)
           + QCN9274 (ath12k_wifi7_pci, 5/6 GHz)
Kernel:    6.18.39, OpenWrt build, ath12k as out-of-tree module (Tainted: O)
Firmware:  fw_version 0x160484db, build 2025-12-09 20:09
Trigger:   hostapd's 20/40 MHz coexistence scan (HT_SCAN) on 2.4 GHz

Sequence, single boot, kernel timestamps:

  [39.670790] qcom-wcss-secure-pil d100000.remoteproc: fatal error without message
  [39.670790] remoteproc remoteproc0: crash detected in q6wcss: type fatal error
  [39.684304] remoteproc remoteproc0: recovering q6wcss
  [55.548545] ath12k_wifi7_pci 0001:01:00.0: firmware crashed: MHI_CB_EE_RDDM
  [56.476959] ath12k_wifi7_pci 0001:01:00.0: Uploading coredump
  [57.777482] Unable to handle kernel access to user memory outside uaccess
              routines at virtual address 0000000000001508
  [57.836328] [0000000000001508] pgd=0000000000000000, p4d=0000000000000000,
              pud=0000000000000000
  [57.842705] Internal error: Oops: 0000000096000005 [#1]  SMP
  [57.889448] CPU: 3 UID: 101 PID: 3410 Comm: hostapd Tainted: G O 6.18.39 #0
  [57.929380] pc : ath12k_mac_op_hw_scan+0x2a0/0x714 [ath12k]
  [57.936322] lr : ath12k_mac_op_hw_scan+0x260/0x714 [ath12k]

  Call trace:
    ath12k_mac_op_hw_scan+0x2a0/0x714 [ath12k] (P)
    ieee80211_can_leave_ch+0x500/0x7a8 [mac80211]
    ieee80211_request_scan+0x10/0x20 [mac80211]
    ieee80211_scan+0x74/0x80 [mac80211]
    cfg80211_scan+0x178/0x1dc [cfg80211]
    nl80211_trigger_scan+0x4ec/0x754 [cfg80211]
    genl_family_rcv_msg_doit+0xcc/0x140
    genl_rcv_msg+0x1b8/0x250
    netlink_rcv_skb+0x60/0x130
    genl_rcv+0x38/0x50
    netlink_unicast+0x210/0x308
    netlink_sendmsg+0x178/0x380
    ____sys_sendmsg+0x1e8/0x250
    ___sys_sendmsg+0x80/0xc8
    __sys_sendmsg+0x60/0xc4
    __arm64_sys_sendmsg+0x24/0x34
    invoke_syscall.constprop.0+0x4c/0xc0
    do_el0_svc+0x40/0xc0
    el0_svc+0x24/0xd0
    el0t_64_sync_handler+0xa0/0xf0
    el0t_64_sync+0x180/0x184
  Code: 93407e78 f9435c15 b40000f5 f9400ab9 (f94a8720)

The faulting address 0x1508 is a small structure offset from a NULL base,
not a wild pointer, so this looks like a member being read off a pointer
that is NULL while the device is in recovery.

Why hostapd keeps asking:

Both radios go down first - the AHB q6wcss takes a fatal error, then the
PCIe QCN9274 enters MHI RDDM. hostapd is meanwhile bringing up a 40 MHz BSS
on 2.4 GHz, which requires the 20/40 MHz coexistence scan, and its scan
requests are rejected while the hardware is busy:

  hostapd: phy0.0-ap0: interface state COUNTRY_UPDATE->HT_SCAN
  hostapd: Failed to request a scan of neighboring BSSes ret=-16
           (Resource busy) - try to scan again

hostapd retries, so the driver is asked to scan repeatedly for as long as
recovery lasts, and one of those requests hits the window where the oops
occurs. This is why it reproduces most reliably on the first boot after a
flash, when all three radios initialise simultaneously.

Workaround that avoids the trigger entirely (does not fix the driver):
configure 2.4 GHz for 20 MHz, or set noscan=1 in hostapd, so no coexistence
scan is ever requested. Both stop the crash here.

Suggested direction: ath12k_mac_op_hw_scan() should fail the scan with
-EBUSY (or -ENETDOWN) while the device is in recovery / not fully
reinitialised, rather than proceeding to dereference. mac80211 and hostapd
both handle a rejected scan gracefully - hostapd already retries on -EBUSY.

I have the full pstore dumps (dmesg-ramoops with the complete log from boot
to oops, plus the previous boot's console) and can provide them, test
patches on this hardware, or run with extra instrumentation. The board has
no usable serial console, so the trace above was recovered via ramoops.

Thanks,
Kamil Bienkiewicz
