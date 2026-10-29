Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.217.47
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793262608;
	b=JVcFhGgwyvUGf1gTKw2rPNWjRqhMEhd7h0PPc0ascCU76dwVTqRvPuhvf50J9b6174b1
	 6aZ45guxPLzSSsToQnLrFj32LTqag2caKhG2SL45y9RJzXe7F3uY7yWq6gPl9TWgCQEQg
	 zxIDSWXQVfNUDwRn2VhzKZqoiVRMzICAWhCpOmuu5Zh2Fi0M+Cd9vQvq9J0l6SXEpW+Dh
	 DWMhShkJasp8ue7nU4hKAZ0d21Bn7hZE04TsrnCNlIdJjyf38QQdNY3bXbU/Z3TcnKxYS
	 7L+sszR+seQm7XpzuzzecnS509ZRPukwPA8nHhR3RxtiZbYqCIlrLDXEBMVdoLEWinQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793262608;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=0tJCH4+9yUTROO3nKwmYaq2yYki3Jr1t2NglbEqv+j8=;
	b=G74K0sJ/51hztImhyy9g+h3YiAyc1RElhZcON+AJMHXx7oQQeHcfYGiEoMBDRMK5BX1G
	 ZeFQW4dpnEl6VtF1tJNYS3zsY5yzp89W6g9yNSiqzDII4ZXzNNXnUuZgykGsiM4fXwnAq
	 CL+jKGRR9s8f1r8WnEzNHVH/qaEIj7lmm1CSh0Gf/Eqqyd0t/pP8qixkF9NI17WoeMHg0
	 Covz4a92DL1GAukKMtq0bAkb8sQV2/GMt67dW0QKvts2JQgFuzZYSe9b8VtE4UcAk6XO+
	 9Q1/CpildCznzC32lMLQVRr11ptGaVMyDzHK3Z1GVvSD549Pu4ehEDe9rzrjJ5tdG1g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eaFHxDc6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.217.47
Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BC9F606A326
	for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 08:30:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1BC9F606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=eaFHxDc6
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-77bf892b496so616661137.0
        for <linux-wireless@vger.kernel.org>; Thu, 29 Oct 2026 01:30:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793262607; cv=none;
        d=google.com; s=arc-20260327;
        b=FxRTXspZCEcwCGrgtaA1xnPF4vL5Q2lF9W9+dT2OivvRTEqfmGByudh1DKk6+mb4pM
         RZ4/qWm6k4X3tCkmTs/P7bUAed/gfynHb8obSPNTkPLpSrA3zZgfqMZ6nFLKvsbL12AC
         CxVYeBwZbDNimQF4zFSgZrQDBUgSVHBqpUnjGuTR4HwE30TetmBGDX5u8W0GSxwZzVmF
         4OzPdIjC5XqW/4BIOIhAxHm2uQr2BuNEIw4r39EmuhqrqitTrWT0iExIQDBHnGMJjc5D
         WkaSiP9dnfamsph6gIs/Q2xVPY4KEkysWsWPRT+PmjAbwxNmR0kiON4xo6py637ONRKF
         VuZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=0tJCH4+9yUTROO3nKwmYaq2yYki3Jr1t2NglbEqv+j8=;
        fh=unOd+iR/s4g3ccNRscfqoIvCvfbfQt24cpkffWnNbx8=;
        b=nlFUcbJTMSaxuYnC79mQx/i5lQh/rRcH4ZV/Xyrz3AVae8evOT5oLdUinuL/NHaPth
         Aac68gQImkQY23t7Bf+wRR6Up0Ml3060cKeA8rEwcvkhi9Eo6PTcV7Exux5vrApLQQWx
         2IjM/JTgNXvhh9/+aYmGx6fG/6XDIascs58EKmI+15uSU0Ya/AEAG0uS0ZROimsHWdcE
         jAM9jfJ90pQueYXgpiLkHFLoCcK1evV2DuZxG396x33/lhLoh1wrQuv7HW1waLcgCnXg
         nKiRgQSOLc1sjQFkWmqG90f8YCgcqQVm9TZ8GUD6ILMoB43/+UYX2KEdzF1i9Ger2I/c
         lCBg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793262607; x=1793867407; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=0tJCH4+9yUTROO3nKwmYaq2yYki3Jr1t2NglbEqv+j8=;
        b=eaFHxDc6TTbweKZY07mLqIGidnJ8sGI70mHeA+zi9L5odrtdIv73qxN8FKK22iM3DZ
         GENlz7hSmt402PYfQ8/x455TftJEQPW9BVkJBJs4HZ4RQ9snMXNoCAC+EVbv+gUNI4pJ
         m+9ei/DrFF4ei9FaGsehPrN6okEG6Wz0shMPyo6runJomSHhLqf2wgyb8EBIBowvsrga
         1iZ+HcWaql56qkwElOOEf0jjEGKM05EndebGakgwQ2zcl97uSE6Oj+6MBJBgQmXG5QxZ
         5CFz05OXt5RQU+z5Jalt3BBtvh5QXfsK7fgTw8Nhnhc1YHuHFoVe8JdUHFWFGKDmHjDo
         W7Rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793262607; x=1793867407;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=0tJCH4+9yUTROO3nKwmYaq2yYki3Jr1t2NglbEqv+j8=;
        b=iYvaEjwkLhTESFAOgu98BrbxMnx1U5IhQYYqfIKU3kTnMw3UviJjbWxqrXlA3V7Bmw
         zm4efWAxqUpwTahaIHoZgGLlob3ocI89RRzNdSdky6o8n7BJ2hLse6SLjCBSrIz7T/Fq
         bYrL74P/+l0Mpq6NDNQ9u6u9zCF0DuHg9y5Jpg/v4Y/GFoXd69BKe7jAcCowjGI/92vH
         HDh8P8Ni6k2RLAB8rbSJlFvoGJo/BsydbPLcQWtsyie98DEy5L7XTaohAXMO8Pzrb1Xt
         yN0t3agLHrRrFRhGfxiqxaa9YcNHJvq6ufickTOQY/o0tjbXkS/W57yylIqofE6qwOEm
         rO2g==
X-Gm-Message-State: AFq9FYLwkk/uThbw820+kAvnzecmzjWb+hEEUolIaszLrDBk7gAUh0Jd
	X+PmZs75laaAFXcxE67DrImrCS/ADj+v4ggeQH1IYNuze9NQJ97hMT+Jqs1xS6ALSr0Ux6KCRAp
	fGTwqEXbHHHd41sqhkaehyMT5P1kNNfYsB4wJ
X-Gm-Gg: AYBFou0of10NcImZu6yjW6Koq+g3hpDIKSB0lTXhX1dIdaM78AcYidMfA7GG3zIT74q
	SMLxqK7FK1u17YboNNjbNaDl2hLbECYoraoMsV40iA2PvQZDEwFHFlp5MDstrFGLno+yRemxIGM
	bsx5qazCTsU01WHq2WJSErpIEG12zusYh+wjUbU7xj5XrfaTOiZ8FoiQrXbFICO8v7T38IlI/S/
	ysQDRZek4t4IqSJgQrLn/2I7RzKeo1supul7F1esTWbjI0iLwaTywTU1l/52yjrpg71HvCIb3Xk
	zWJAc6Pz9OxKSSxTbHt5PD1f07JFQ6UdMxaXEHhq2ovbq9ffQNDylq0Jw9HTqxqbh3f/3o4FqeP
	TzWv3S8HjOcBiUQWGo1WPYkH/EbadcGpqHGPN3aLj99QcI2/Kkj9XlobV
X-Received: by 2002:a05:6102:c4a:b0:7c3:91f5:26f1 with SMTP id
 ada2fe7eead31-7d03a50cf96mr2079444137.6.1793262606857; Thu, 29 Oct 2026
 01:30:06 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Edward Boyd <foxhis11@gmail.com>
Date: Thu, 29 Oct 2026 16:29:55 +0800
X-Gm-Features: AclHuK-LCpv1UrJxeSfaJV1Q51uJcXCwjy4BnFQK-rtfQapJhBq59VgGFQKZtPQ
Message-ID: <CA+oFqMhOBTPTXB5nG_Ls_UD+j_ODmBX1Uh7RM7aKJZ4ZF9+oZQ@mail.gmail.com>
Subject: [BUG] wifi: ath12k: Oops on rmmod when one device of a hw group
 failed firmware bring-up (QMI_FAIL)
To: ath12k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

On a board with three QCN9274 (PCI) in one ath12k hw group, removing the
driver after one of the devices failed QMI firmware bring-up crashes the
kernel (NULL pointer read) and the system reboots. Reproduced twice.

Setup
- Askey SBE1V1K: IPQ9570 + 3x QCN9274 hw2.0 on PCIe
  (0001:01:00.0, 0002:01:00.0, 0003:01:00.0)
- kernel 6.18.55; ath12k / ath12k_wifi7 from backports 7.2 as packaged
  by OpenWrt (package/kernel/mac80211; image based on an ImmortalWrt
  snapshot, r42138-da63f7d6ac), no local changes to the driver
- firmware WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
- ath12k_pci_remove(), ath12k_core_hw_group_cleanup() and
  ath12k_core_stop() are identical in ath.git ath-next as of today.

Steps to reproduce
1. Boot normally; all three radios come up.
2. Put an invalid board-2.bin in place (I used 4 KiB of zeros in
   /lib/firmware/updates/ath12k/QCN9274/hw2.0/board-2.bin) and reload:
     rmmod ath12k_wifi7 ath12k; modprobe ath12k_wifi7
   One device fails at BDF/regdb download; the other two never get past
   MHI "Wait for device to enter SBL or Mission mode". This part is
   expected.
3. Restore a valid board-2.bin and run "rmmod ath12k_wifi7" again.

Actual (abridged, full excerpt at the end)

  [  203.584861] ath12k_wifi7_pci 0002:01:00.0: found invalid board magic
  [  203.600721] ath12k_wifi7_pci 0002:01:00.0: found invalid board magic
  [  203.618033] ath12k_wifi7_pci 0002:01:00.0: qmi failed to load regdb bin:
  [  203.618061] ath12k_wifi7_pci 0002:01:00.0: qmi failed to load
regdb file:-12
     (nothing more from ath12k on 0001/0003 for ~120 s)
  [  324.611930] ath12k_wifi7_pci 0002:01:00.0: Mode request failed,
mode: 4, result: 1 err: 90
  [  324.611967] ath12k_wifi7_pci 0002:01:00.0: qmi failed to send wlan mode off
  [  324.619100] Unable to handle kernel read from unreadable memory
at virtual address 0000000000000000
  [  324.634974]   ESR = 0x0000000096000005
  [  324.649897]   FSC = 0x05: level 1 translation fault
  [  324.683072] Internal error: Oops: 0000000096000005 [#1]  SMP
     (system reboots)

I don't have the call trace: there is no serial console on this unit,
the log was streamed from /dev/kmsg over the network and stopped at the
"Internal error" line. kernel.panic_on_oops=0 did not keep the system
alive either.

Expected
The driver unloads cleanly and the device that never came up is skipped
during teardown.

Analysis (from reading the code, not confirmed by a backtrace)
- "qmi failed to send wlan mode off" is printed only by
  ath12k_qmi_firmware_stop(), called from ath12k_core_stop() and from
  the error path of ath12k_core_hw_group_start(). During rmmod it has to
  be ath12k_core_stop() on 0002:01:00.0, the device that never finished
  firmware bring-up. The Oops follows about 7 us later, so it is in the
  rest of ath12k_core_stop() (dp rx reo cleanup / hif stop / wmi detach
  / dp deinit) or right after it.
- ath12k_pci_remove() skips ath12k_core_hw_group_cleanup() only for a
  device that itself has ATH12K_FLAG_QMI_FAIL. The first healthy device
  of the group to be removed calls ath12k_core_hw_group_cleanup(), which
  runs ath12k_core_hw_group_stop() and then ath12k_core_stop() on every
  device of the group unconditionally, including the one that never
  started. For that device ath12k_core_to_group_ref_put() just returns
  ("core already de-attached"), but ath12k_core_stop() carries on and
  tears down state that was never set up.

Suggestion
- In ath12k_core_hw_group_cleanup() (or at the top of
  ath12k_core_stop()), skip devices that never completed firmware
  bring-up, e.g. based on ab->hw_group_ref, ATH12K_FLAG_QMI_FAIL or
  ATH12K_FLAG_QMI_FW_READY_COMPLETE.
- Only do the mac unregister/destroy part of ath12k_core_hw_group_stop()
  if the group was actually registered (ATH12K_GROUP_FLAG_REGISTERED).

Side note: when one device of the group fails BDF download, the others
never proceed (they wait for host cap), so all radios of the group are
lost while the error is only logged for the failing device. That may be
by design.

I can test patches on this hardware.

Thanks

Edward.

---- full excerpt (from "rmmod/modprobe" in step 2 to the Oops) ----

  [  198.990367] ath12k_wifi7_pci 0002:01:00.0 wl0.1-ap0: left allmulticast mode
  [  198.990404] ath12k_wifi7_pci 0002:01:00.0 wl0.1-ap0: left promiscuous mode
  [  198.996288] br-lan: port 4(wl0.1-ap0) entered disabled state
  [  199.411627] br-lan: port 5(wl0.2-ap0) entered disabled state
  [  199.413182] ath12k_wifi7_pci 0002:01:00.0 wl0.2-ap0
(unregistering): left allmulticast mode
  [  199.416355] ath12k_wifi7_pci 0002:01:00.0 wl0.2-ap0
(unregistering): left promiscuous mode
  [  199.424470] br-lan: port 5(wl0.2-ap0) entered disabled state
  [  201.381848] ath12k_wifi7_pci 0002:01:00.0: BAR 0 [mem
0x20400000-0x205fffff 64bit]: assigned
  [  201.381974] ath12k_wifi7_pci 0002:01:00.0: Wi-Fi 7 Hardware name:
qcn9274 hw2.0
  [  201.389669] ath12k_wifi7_pci 0002:01:00.0: MSI vectors: 16
  [  201.402471] ath12k_wifi7_pci 0001:01:00.0: BAR 0 [mem
0x10400000-0x105fffff 64bit]: assigned
  [  201.402595] ath12k_wifi7_pci 0001:01:00.0: Wi-Fi 7 Hardware name:
qcn9274 hw2.0
  [  201.410783] ath12k_wifi7_pci 0001:01:00.0: MSI vectors: 16
  [  201.418504] ath12k_wifi7_pci 0003:01:00.0: BAR 0 [mem
0x18400000-0x185fffff 64bit]: assigned
  [  201.423210] ath12k_wifi7_pci 0003:01:00.0: Wi-Fi 7 Hardware name:
qcn9274 hw2.0
  [  201.431983] ath12k_wifi7_pci 0003:01:00.0: MSI vectors: 16
  [  201.490914] mhi mhi0: Requested to power ON
  [  201.490939] mhi mhi0: Power on setup success
  [  201.624426] mhi mhi0: Wait for device to enter SBL or Mission mode
  [  202.188190] mhi mhi2: Requested to power ON
  [  202.188228] mhi mhi2: Power on setup success
  [  202.321934] mhi mhi2: Wait for device to enter SBL or Mission mode
  [  202.885908] mhi mhi1: Requested to power ON
  [  202.885944] mhi mhi1: Power on setup success
  [  203.021013] mhi mhi1: Wait for device to enter SBL or Mission mode
  [  203.563737] ath12k_wifi7_pci 0002:01:00.0: using reserved
host-ddr-mem 0x0000000054100000 (0x0000000003102000 bytes used of
0x0000000003200000)
  [  203.569253] ath12k_wifi7_pci 0002:01:00.0: chip_id 0x0
chip_family 0xb board_id 0xff soc_id 0x401a2200
  [  203.575415] ath12k_wifi7_pci 0002:01:00.0: fw_version 0x160484db
fw_build_timestamp 2025-12-09 19:48 fw_build_id
QC_IMAGE_VERSION_STRING=WLAN.WBE.1.6-01243-QCAHKSWPL_SILICONZ-1
  [  203.584861] ath12k_wifi7_pci 0002:01:00.0: found invalid board magic
  [  203.600721] ath12k_wifi7_pci 0002:01:00.0: found invalid board magic
  [  203.618033] ath12k_wifi7_pci 0002:01:00.0: qmi failed to load regdb bin:
  [  203.618061] ath12k_wifi7_pci 0002:01:00.0: qmi failed to load
regdb file:-12
  [  324.611930] ath12k_wifi7_pci 0002:01:00.0: Mode request failed,
mode: 4, result: 1 err: 90
  [  324.611967] ath12k_wifi7_pci 0002:01:00.0: qmi failed to send wlan mode off
  [  324.619100] Unable to handle kernel read from unreadable memory
at virtual address 0000000000000000
  [  324.625962] Mem abort info:
  [  324.634974]   ESR = 0x0000000096000005
  [  324.637744]   EC = 0x25: DABT (current EL), IL = 32 bits
  [  324.641572]   SET = 0, FnV = 0
  [  324.647031]   EA = 0, S1PTW = 0
  [  324.649897]   FSC = 0x05: level 1 translation fault
  [  324.652943] Data abort info:
  [  324.657795]   ISV = 0, ISS = 0x00000005, ISS2 = 0x00000000
  [  324.660933]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
  [  324.666218]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
  [  324.671345] user pgtable: 4k pages, 39-bit VAs, pgdp=0000000063f20000
  [  324.676722] [0000000000000000] pgd=0800000064474403,
p4d=0800000064474403, pud=0800000064474403, pmd=0000000000000000
  [  324.683072] Internal error: Oops: 0000000096000005 [#1]  SMP
