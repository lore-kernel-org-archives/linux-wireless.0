Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793028584;
	b=JjGjkq3//C5HIldHHSd2Vj7VtO5OLpt7Z5W4p94whY7TPVweFRbnPooRfb76ntQU3woj
	 EAj8YMlimdK1gco348Qu87ootuN8vFpSoyjJz5B8Vz0xekLeVQZFVPayYDwrZUPEvHiAv
	 0eRflTfWnnDEtJTPm/yA/2H5bbaHDajdouvQjgxU84VwxT07LTvGS6gySEH7GVfjOUrMo
	 //7fn/pLKvj+vW3G8K6EAXCdoCCHPIIBYiDtt9/PHuP7zkJmmDT4n4LvHyaE/PTeVGp6r
	 jpTRxEwUMxFaqs6sRkBeINfuwIlsWHDBK/BzczjbXlU2wJvVq0kz1MNyl6OLAfJa57w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793028584;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=b5/mpfor9lzhd6qW41OVwjvn8a0P7vQyjwQNovlhxas=;
	b=XfL2C+4oQvNMGOkTtRnxajbq6r5oWuWkDt3RxtRH9ZaofE28PjUltFSpLfqJ8CRtTGCc
	 j/5vp3l4W4cmZdH94nsaiW155jNLXN3BWEH1IFaCdzW3oJkNzkPGqYOjFob2QB7/zY0xg
	 iXXCx9HfufdGxyfCqUhNLr5BP/31RShbdzdxXAf25/Y8nj3/8SQyxZhAhxLOLsIp67MTG
	 FCkWpV1/utDknYu1nsFpJL+f/8/dkF+HH9vneyqtVVeRHvyIevXkre0rMW9NtRL0l29zi
	 AWt8e4AonGiH3mjD4339twAIvoZzpEbWlCqOtnmu8XPfTda2ir31eTsxRhmqeY/0klQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=nXE9DVfY;
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A4F606A31A
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 15:29:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85A4F606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=nXE9DVfY
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a20bdaf39cso32822415e9.1
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 08:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793028582; x=1793633382; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=b5/mpfor9lzhd6qW41OVwjvn8a0P7vQyjwQNovlhxas=;
        b=nXE9DVfY/o0KbrJlGWEaR+umvxDleNZKraPkJguhl0SPe9OCOyRP7kn84e8JGvjAsz
         BapOpZNd24dQLzBvE8jS4WZOtY/VMb5izV26tdwqQHPcz2dclkEB8+DT85eWRXfYzHvy
         /symw6y3B99SkTcFrnryAPCcRod56Uk9jtG6KgowgmAMVk2YrYAwEh1Yj1BDkLa/dTD8
         MLIe+tljnjtSIjiOavxYx9Glm8lpsizY/57R8Q+Opy0u3xVBhwaaCs/cmwBSOAGQQ+ZI
         ysC9pcMRrwdhC4KyA1okaPbl4tXz1Gd2Rz7Kz3JS+mqva/nKoLLtZXr7DzLQIy3xrtlV
         0NbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793028582; x=1793633382;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b5/mpfor9lzhd6qW41OVwjvn8a0P7vQyjwQNovlhxas=;
        b=GHjG9YPLoCYaRqnNhAcJu8vTXlARMcT7GQxFHAJOWDBQCou1hbXP6NMWTvjWaE4JA2
         yFw//8coLVcxrdhefq5mtzDVF/ffcOU4nRYwfG2+0//TTgAldvpafWitgitOk0LrSx4I
         f6t88nCQ4UB9Vwi7dRXJu6daR4v2oiEcxJCsbIHW8YVN6fOvvR8IUZhLBmpVZqh15lYg
         HuVd+0ksOhnNvNsjAh4OkK5TdJspuJqD5uvbPHTsa+u5BWdUDB5Nu/w6i6uZQnzUbIhd
         SK69pnD0TTxkUsntx7pfYsLkMdThuDikWFkXlBFIAvnWc/NE9xCtgCRIa1plMEvVn2/Y
         DhZg==
X-Forwarded-Encrypted: i=1; AKwUvBxkPWpx0dcd9EmN3bgogXbN+BtII180sGccpB52JNRFSXUMiOFGlfqYm+mrkZLfecKkT6eqO855x9w7/3511g==@vger.kernel.org
X-Gm-Message-State: AFq9FYLVaI9DYqU9ZOIhMZPmFE28rP3TWEikQnoCIC2QkRUKAeLuP13W
	N8WGuS9Ns+TR0e047JMFu1D8hdMo55stecaWDxHAlGqW3zoVq+ni9wS9bpO0Qc65
X-Gm-Gg: AYBFou1ocep6K3QIxGLGvRvw27lv9Xax62Kcx/Pk/wqpY6ynju3vPfBVusKSyHcFm1b
	5GMBg37vrFnc0SjnEKGPLDK5tDtmag/2c+RZJekl0p6rv/t/qrGys7Fwh/BoFFh5lnunsp7OLiM
	zrdKZAImFTktdFv1iKGmhbO/fj977QH4w9UE8kpFyh8pA+dY/tuGPdxCCFvEyBojOLTXs+WC0tn
	/O4tQDHPVa0uC99nc3PDe4ZnivoquRvs+bTYfi2azXT1PLxPjDKeUUbofP+NowKcz4SQ9wG+vqq
	h/nB8REw8RsBBTRIDmmd/UFMCJYX6nZNHP4W6n2pA7KpJ9l4wCd/IZZ3OsPahuM/fNqopE9OML/
	iQsIxM2+I5fxY0vqakpNtNaFb9k9pj0ggrfqzjSCOKUl+jkWXQIPGwy/l6j3/jbrshgJgrIODZp
	BhtvgevyC/p+wZNJMCp0Y1THkCumHmGv1RoNFSaewOSEypcGVLp4nT8v7WM25gMtKsrVoE23EiC
	GX/cJSRKHivQoBBmH9cHo/z8nDevr0O2UGItOTfGlKQrL7/EZ84B35vDiz/eA==
X-Received: by 2002:a05:600c:4e12:b0:4a2:be6:60aa with SMTP id 5b1f17b1804b1-4a35ac8d92emr126901785e9.10.1793028581772;
        Mon, 26 Oct 2026 08:29:41 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebd4ba7sm17255244f8f.33.2026.10.26.08.29.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 08:29:41 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next v9 0/3] wifi: rtw88: channel switch in AP mode
Date: Mon, 26 Oct 2026 16:29:37 +0100
Message-ID: <20261026152940.1274382-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

An rtw88 AP cannot change its channel: the driver does not announce
channel switch support, so hostapd's CHAN_SWITCH is refused and the
only way is to tear the AP down. The series fixes the beacon download
the reserved page build makes twice, implements channel_switch_beacon
on top of the firmware's beacon page, and times the countdown
downloads from the TBTT so that every count goes out on the air.

Tested on an RTL8821CU, an RTL8822CU and an RTL8822BU (USB) with
hostapd 2.10 as AP: switches with counts 1 to 100, scans during a
countdown, hostapd stopped and started, the USB driver unbound and
bound and a firmware crash during a countdown, IBSS switches, a
station interface on the 8822CU associating while its AP counted
down, and Windows and Linux stations following the switches without a
re-association. The 8821CU and 8822CU set was run on a PROVE_LOCKING
kernel without a lockdep report.

Patch 3 was tested on the RTL8821CU with a build that delays every
second countdown download: with a 60 ms delay every count still goes
out (sniffed from a third machine), with 95 ms the delayed count
stays out and the next download follows at once; the AP finishes at
the same time in both cases, and a Windows station followed the
switches with counts 10 and 50 without a re-association. With the
start forced to either side of a TBTT, and with iperf3 traffic, the
counts matched the beacon timing in every run on the RTL8821CU and on
the RTL8822BU, the first on a PREEMPT_RT kernel, the second on a
preemptible one without RT, both with HZ=250. The patch 2 fix was
checked with a build that queues a TIM update right after every
countdown finish: the WARN came before the fix and not after it.
Patch 1 is unchanged since v6.

v9 was run again on all three chips with the tests above, with counts
up to 50, the RTL8821CU and the RTL8822CU also with PROVE_LOCKING. The
WoWLAN resume change is built but not run: there is no RTL8822CE here,
and the USB driver has no suspend, so a WoWLAN resume never reaches it.

v9:
- 2/3: the countdown starts again after a WoWLAN resume that worked,
  which mac80211 follows with no replay (Luka); Ping-Ke's Acked-by is
  dropped for the new code
- 3/3: Acked-by from Ping-Ke on v8, Reviewed-by from Luka
- an IBSS left during its countdown and joined again kept csa_active;
  that is mac80211's, fixed by a separate patch [1] (Luka)

v8:
- 2/3: Acked-by from Ping-Ke
- 3/3: the TSF read retries once instead of looping, rtw_fw_csa_queue()
  reads the TSF once also on start, the port 0 comment is gone, empty
  lines where asked (Ping-Ke)

v7:
- new patch 3: the countdown downloads are timed from the TSF, 10 ms
  after each TBTT, so a download that runs late by less than a beacon
  interval still reaches the firmware before the next beacon; one
  later than that is followed by its successor at once. Ping-Ke's
  question on v6: with the absolute due time a late download and its
  successor could land in one beacon period and leave a count out of
  the air
- patch 3 takes a TBTT within the margin before the start as the one
  that sent the countdown template: a TBTT between the template
  download and the first TSF read made the stations see one count
  twice
- patch 2 keeps csa_vif until the beacon after the switch: a TIM
  update before it fetched one beacon past count 1 and hit the WARN
  in ieee80211_beacon_update_cntdwn()
- rebased on rtw-next

v6:
- the wiphy work patch of v5 is gone: the countdown work is an
  ieee80211 delayed work and csa_vif is driver state, both under the
  driver mutex, so rtw88 takes no wiphy lock anywhere (Ping-Ke)
- rtw_core_stop() cancels the countdown work and clears csa_vif, which
  covers the IPS path and the firmware recovery; the wiphy_lock() in
  the recovery work is gone (Ping-Ke)
- the BSS_CHANGED_BEACON path says why it starts the countdown, the
  replay after a hardware restart, and stops it when the beacon comes
  back without a switch announced (Ping-Ke)
- the downloads are paced from the first one with an absolute due
  time. Queued after each download, they drifted by about 10 ms per
  beacon interval on the ordered mac80211 workqueue; on a count of 50
  the AP switched half a second after its station had, and the
  station re-associated

v5:
- 2/3 is new: update_beacon_work becomes a wiphy work, so that it can
  look at the channel switch state under the wiphy lock; it checks
  RTW_FLAG_RUNNING instead of being cancelled in rtw_core_stop(), which
  runs without the wiphy lock on the IPS path (Ping-Ke); reverted in v6
- 3/3: rtw_fw_csa_active/start/stop() assert the wiphy lock (Ping-Ke);
  reverted in v6, they assert the driver mutex
- 3/3: hw_scan() takes the mutex with guard() (Ping-Ke)
- 3/3: a comment on the association download names the STA+AP
  combination it skips the download for (Ping-Ke)
- the whole set ran on a PROVE_LOCKING kernel without a lockdep report:
  switches with counts 1 to 100, hostapd stopped and restarted during
  a countdown, scans during a countdown, a firmware crash during a
  countdown, three stop/idle/start cycles, IBSS, 50 switches with a
  station attached, and on the RTL8822CU a station interface
  associating while the AP interface counted down

v4:
- 1/2: Reviewed-by from Luka
- 2/2: the countdown work is back in the device, initialised once,
  with csa_vif naming the interface; no interface iteration and no
  lookup through the reserved page any more (Ping-Ke)
- 2/2: the countdown is cancelled before a firmware recovery restarts
  the hardware, instead of guarding the work with flags (Ping-Ke)
- 2/2: the page download on association skips a running countdown,
  like the TIM update and the PG backup (Luka)
- 2/2: the scan refusal comes before the scan offload test, so that
  firmware without scan offload does not fall back to a software scan
  during a countdown (Luka)

v3:
- 1/2: the beacon out-pointer is initialised in the caller (Luka)
- 2/2: the countdown work lives in the interface, remove_interface
  cancels it unconditionally, the queue wrapper and the comments are
  gone (Ping-Ke)
- 2/2: the TIM update and the PG backup on set_key skip the page
  download while a switch is announced; every beacon fetch advances
  the countdown (Luka)
- 2/2: the commit message names the refused hardware scan (Ping-Ke)

v2:
- 2/2: a hardware scan is refused while a switch is announced
- the rtw89 mention is gone from the cover

[1] https://lore.kernel.org/linux-wireless/20261025193615.1123718-1-mehmet.fide@gmail.com/

Mehmet Fide (3):
  wifi: rtw88: download the beacon the reserved page was built with
  wifi: rtw88: support channel switch in AP mode
  wifi: rtw88: time the countdown downloads from the TBTT

 drivers/net/wireless/realtek/rtw88/fw.c       | 151 ++++++++++++++++--
 drivers/net/wireless/realtek/rtw88/fw.h       |   4 +
 drivers/net/wireless/realtek/rtw88/mac80211.c |  50 +++++-
 drivers/net/wireless/realtek/rtw88/main.c     |   6 +-
 drivers/net/wireless/realtek/rtw88/main.h     |   3 +
 drivers/net/wireless/realtek/rtw88/reg.h      |   1 +
 6 files changed, 194 insertions(+), 21 deletions(-)


base-commit: 9b0be45d4d52fd223994e151f169743a97abd290
-- 
2.55.0

