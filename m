Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792583147;
	b=hpGT+k5gibYQNkYNtmqbHScAE6uL2bwHxaNwZ0eWsLaSnXOfbATkvYykLEoHV7H15vU9
	 EDJa9h6Yu2c4wpZBKDHxhGkLeU2ew3LgTi9RnuLmbY7z+KGOLqqIEdhxjgGn9SQkBYmKN
	 XV6+OrE4ohPtajlV7KzNMEoClW4rUD5sjOa6gvXzEb3HtUTzshqUl6yQPb0baf6JhYer7
	 BK3IZ7SGPNYzkNZVfidfRTsa8WpWPJVjWsnodQAXp+2GPaM+B+7101Q2KJaENOjuWn9k8
	 UX4Qs45pKN33ACnag+yG/+TzVFFqx787m/yYL47kiDUnGzjEAJp5Dt3kAVe1d1Xejpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792583147;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:MIME-Version:
	 Content-Transfer-Encoding;
	bh=FHbThYz167MEuXs9w/+Hau2h5HTGZ7DYbXa22SkueE8=;
	b=wnLMM30iUKTE7pUFkhoJP+0r3sj5D+VqO3O4T6PJJ1ax6Bw4tFxpLCa8mfpCye9eHoHd
	 XCx2VF6wpzzmUjOeUaJIoF6qHTpbk5tKD5s//vsmYvOP9fi/yDp2V/BPCtvJwd7VR/v27
	 DgtrMm3FoYem/6od1iL0UDxRhloa8ZnpcWshhnUVJWlNvBUTl8mdiOJ9k5UFSWoHQC/9b
	 12gs+Blk69ZEMBJxrCFHJuBQAjh4dVAoe+5EPtyFwjOR6lw+Ea3WxvTQaODbFqXwFb9E/
	 JGLguHY8DqeU6jxq20Ova1dqlP5OIeloQNipGTvb507WeMO0roSq55pxYsg1FXuz4CA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=oSuZqhOH;
	arc=none smtp.remote-ip=209.85.221.43
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B846F606A33D
	for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 11:45:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B846F606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=oSuZqhOH
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-48e20ed3b9dso637381f8f.2
        for <linux-wireless@vger.kernel.org>; Wed, 21 Oct 2026 04:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792583145; x=1793187945; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=FHbThYz167MEuXs9w/+Hau2h5HTGZ7DYbXa22SkueE8=;
        b=oSuZqhOH51CC/JiGAn5+S/PWA8RvzyyWo7+NvEPVpENg5NgughMt+lIDDK9vQEz7Py
         VlKYmVH2trCc8oeMdC862cXgVcX9dL9MoKx2St78mxsoRHlqhGjrqaBn1uuTW6XeStQx
         xbxPQAYhWwhPAbNJfvaF6X3cmyStd7XG1HiiDPdoMy66Z2PV/rwDRrWLDbrXAJhqgEk9
         uzWp5kmNRFyLA5q4mt6MGfdihtoO6aIzFYUzPpdoyZOiCGzGmN70ae+jFYQW30o3ygim
         KuaXW1hdgc5XQhkE2Qbawq/3iXtG4gGT558+Pfh0+oIdRG/CG1p4VRg8xUt92tsQJ/Vk
         XOkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792583145; x=1793187945;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FHbThYz167MEuXs9w/+Hau2h5HTGZ7DYbXa22SkueE8=;
        b=ker/MX7KAWPd6218HyV2mbjfEc7E03MkXsYqDyn5lxouFITR6qqVS7XxxPy2Mh4fzQ
         rHC4Ha/Q9iK+GNogsYYOlRopYKZNq4bVBTpWICPVg0sT+pxg2HGvBS/69ioCiTD4ha4P
         NGY6l60nCW1P8CzAUfH6AhL9xJ0msdCv+IhjCKCoOcA54ehgiH/3pcY1NFRpBu/Afv1K
         bcIx9Y/l+mCoOkFdryVfdyZ3KiP3IA5Rl5aoaPy8YZ7m30pqPglOwgkDa9H2E9MYd5fZ
         o3XblVC+uRNBLOCI8yTK007C0txYnEko7W1VH3BAw100fh8LkJ66e1quad7QtEQyxqZ3
         zbfA==
X-Forwarded-Encrypted: i=1; AKwUvBySYCSLCmkUNWyY/d4UB7DRlGaMnvFG6G0axuq7xvueDG85h2UvHNxyhIFpTy7nlRHLXWKKmtrQ4acI/n51IQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYKTbo3qelBO4C857OZkkauaWphoFFwuL51Ku8c0i8fVGff87yCn
	aJVVgP0Tr53Qigjo0cfXF72vj9le2vfKYXZPuKAkEEM+HvLyO8U2ooWs
X-Gm-Gg: AYBFou0V3m3QnF7YkRRoPfaw41WNjqC6iPQ7IbhCLC26g+sEwwLzi+tosnsyuw90A7A
	RatugwwR+7tH8lDDtU1RS1daTlG5Dmt/E+RsTLkJK0js+ZSG/QJeB01yQr04syPMzHqCbP0xy2L
	3nEDaR/U02jk4OEvBvCJMkbpjjX5oTEimiLwgtqME21jls2v7v2/R6UCJY/YBjjKwgZ9VojIPXi
	7lqRc0GoZUwIJE8LEq43W6BsivC+seBO0IY6viRIzE7oTKKHYBU8ehRmr4Xtis/rwmuQLhGhF5D
	n3czL2AHUCbdmNHFJZVcRF5+/FRUDN801b30KCRo0NqagYUrgVlw8bjxpIaTZsBdIi7CK/kaGU4
	Gd7VLmhmXzqQVxu+0pM5weoDQVm0gDlofgYtbRvP1FW1ZDB89Q32TULbo8oPwDZmKxNEl35RXWd
	i7vOOqE2sZFSKRO8/W8noFBbxXLTFv85qQzNSlbVtBXUhKYPfaUALHUMdJ05PF7soK4hqqLm4x7
	DOq8gNdczzNrshPyitHvtUcB3ELtpYOceKfZ+buFij5a9s48NumzQ873LRlQREL1Vz5bTa9eku7
	/NeDcpp5
X-Received: by 2002:a05:6000:4283:b0:48e:bf0:35c with SMTP id ffacd0b85a97d-48e264a636amr3684083f8f.13.1792583144832;
        Wed, 21 Oct 2026 04:45:44 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e25828ca3sm4944112f8f.25.2026.10.21.04.45.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2026 04:45:44 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next v8 0/3] wifi: rtw88: channel switch in AP mode
Date: Wed, 21 Oct 2026 13:45:40 +0200
Message-ID: <20261021114543.4132776-1-mehmet.fide@gmail.com>
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

Mehmet Fide (3):
  wifi: rtw88: download the beacon the reserved page was built with
  wifi: rtw88: support channel switch in AP mode
  wifi: rtw88: time the countdown downloads from the TBTT

 drivers/net/wireless/realtek/rtw88/fw.c       | 151 ++++++++++++++++--
 drivers/net/wireless/realtek/rtw88/fw.h       |   4 +
 drivers/net/wireless/realtek/rtw88/mac80211.c |  39 ++++-
 drivers/net/wireless/realtek/rtw88/main.c     |   6 +-
 drivers/net/wireless/realtek/rtw88/main.h     |   3 +
 drivers/net/wireless/realtek/rtw88/reg.h      |   1 +
 6 files changed, 183 insertions(+), 21 deletions(-)


base-commit: 9b0be45d4d52fd223994e151f169743a97abd290
-- 
2.55.0

