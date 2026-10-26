Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.215.173
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792993006;
	b=OkCOa1Z7uPE4WI+AdplgSQ5i5yd6Q/qvIq60ZwVwZW9/M7ab4UoE/5KRwo+JdYYPXwC4
	 4h9pDe/ATX+0QXGPyTnqduhDaAwmLryODvkz4NxKKxVBURPm8vik5AS+VSR/ySW7AU+Py
	 JmvpSNPTQZ1n188jd7IRKwgd4ox8jI2tPTS4Lhg6Wujb87qsmbtRO00rcJdLf1yu+wG/m
	 4mIWNO9Ws2fpqAZn/cVB/y70mvL5XEyTc9EbJ4LEFWZO9rSeD+eQx8GCiPSt+nXxzrCvc
	 Ri2EVtF7m4XR0mW3z9HNBXLBU/X+FzNTa+GW1Qq2H8MxjDJKxjLEksKQ9n0oqQ1et6Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792993006;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=6gzFO8XXzg0k4ZAcZpWqWJXV202MH2eZbj0US5jOWjs=;
	b=zpnid3WykMuk12ttvafp49vBpmFJq0mPauEOydzNHx+9ciutIikGCYe/S7o2V4xI2AZz
	 01KK/MQ9YoG33tdiiUbVr/B57zX7rpyXoKl1dxuVM746oiQYOt3UkeaLCTeD27JX0dvZU
	 cEvaG9b/f5Pr2sKLTYl9ngAXeDvVYpIQ9dO+LAQcbAH3tk7ncom5bB0xd5bG3KjzhLAAC
	 DtU11waBp1DL6Tb8n/3tSAs5b6hX/r1bbx56tQsZC/mwRL7XxLa4OrYtJL1tbmPBK5YzO
	 ZdA6kqC0K1my0FB7FyMKBLSMVQl3I1SguhBs4hx0dQ1SBkAykjowveDyO5rvEn7SNNQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bGeSbvyZ;
	arc=none smtp.remote-ip=209.85.215.173
Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA8D606A327
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 05:36:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DA8D606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=bGeSbvyZ
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-cd67cc518a6so1771025a12.1
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 22:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792993005; x=1793597805; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6gzFO8XXzg0k4ZAcZpWqWJXV202MH2eZbj0US5jOWjs=;
        b=bGeSbvyZQxhL3k4dHxa4zpMHaEGMN9jyhC+/dCDQ3jjj3P67K4/Hk7BoltHg+jKIeo
         /z9a5pxVM+tSlGmcoQvL+L4tW+7t4PppUDCuSfYvTRUrJYpeOESHKDh+Y/z0gYPujIWD
         EIoOFob+bL05zi2pG4jWYoNeqZbZ1uv+e1SbHm9jd2HfKpfZUZAv6LkofjFsccPFLRt2
         HDXbv7cdYYJhMSPWdc8RqkfpkUTsn4aEXG7wgsg1MawrqKdyC5klTir2ns0CxijnMCjd
         dl4PdKXQJGqHNMfwj82QFPekFCMWR1emiyd/4BHVzgM4lxppwwc4WdQ4kUj5i1OeGBPA
         U/Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792993005; x=1793597805;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6gzFO8XXzg0k4ZAcZpWqWJXV202MH2eZbj0US5jOWjs=;
        b=UnhyNrrp+dMh2ZkfM68a4JRcRtjg8pnTrYAmBL2/9e4vf/rFkcRP7HR9pvPl1dHbZb
         YLTTsFU4KAgxRPJ660r09SwIIguEz8GPOrFMFJz7J3K32iJ0OwLFmP9bD32ZmdLui6BM
         2Ab1eorq/+HRnofEIS9dlyhQydUa/+wtuaFIDuoCVCFzT/CrqvViXIvgI8c5Y6zkHzxL
         id8w4SQbNr0WcDJxIft8bmmWvVmdxK+SYlZDDzra2C5Yuc+FmA8DZoxtcbcN2Vu37rkE
         jHGQJfJwdGfiTQV9DShfuq7w8Ti5HdF+E5FiJQfT7mKLbiMa161aeOvY/E7sEAaYOARb
         yuOQ==
X-Gm-Message-State: AFq9FYKGL1//4i11Yv1AI5yL1gPslQOxm1Wf7XXkuGSEUto74KRkGjBD
	zJ7osSEaDDJQz/CiThV9DMQ1+86s1neA3mZi7zodZN/ypEIca+oEnjG9wrVVlq29feU=
X-Gm-Gg: AYBFou0VoJKQ79DWTfSqSSzGcvGyAsVbcDjr7RciMA6ev/7ZgQjf7cZ3JUpQB3cHC2u
	x2ev92pxe77di/8LezN70Xd13JLGuN7i9WL3KhwrUrNkxb0puiD1d+FSCL/ieIbRriF3ScKYdq8
	dC0UtIK+VwQZt1+77FfCSoCuMVF0FsqMgXwCuPXax2QeCm20meKQrq72uFuD7YCk88l8oLYUbls
	q8cJc6rLIwDAxc/ANNGkDJAwekyas7qY6KNAMTNGamYsaUcJMEsqiYOQH1rplT4H8J5o7gZCKpD
	w3iBNYJVzPrvWD2H6kDFoCnUJwr7sfUhh7ALcSo8l25AZdIdQE/XoCjPSCc/wqHtnnYIY7mbLPS
	4iZB+3JctIxmZ0mngz1SQGl7crn2eJTybywIVLYeyOa+r3TrL5WYVDWNEh6nKJTmsRPak/ytPeE
	wxQ09bnK/MXLL77XoG/zHicUPH6qCnhlqzO9/Rq19AfFWfSDIHZOMcUGOvVX1PyPqSjnGV0QO5p
	IyPtWbGrTiw04HnN6KHeWp1ubQwbGcQm4R4ShtExZEB9/NK3DG93f2Pt64T5VBW2Xte0RQkGhuB
	nnlo
X-Received: by 2002:a05:6a21:4e0b:b0:3e1:8890:8400 with SMTP id adf61e73a8af0-3e7bfbdb8dcmr4954301637.15.1792993004740;
        Sun, 25 Oct 2026 22:36:44 -0700 (PDT)
Received: from acemagic-m1.tail4fb79.ts.net ([2401:7400:c804:b668:673b:a930:e065:eca])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a368d867a0sm927851b3a.2.2026.10.25.22.36.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 22:36:44 -0700 (PDT)
From: Ragul Balaji <ragulbaby@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	brcm80211@lists.linux.dev,
	Ragul Balaji <ragulbaby@gmail.com>
Subject: [RFC PATCH wireless-next 00/17] wifi: add a driver for Broadcom BCM4323x USB adapters
Date: Mon, 26 Oct 2026 13:36:06 +0800
Message-ID: <20261026053633.361454-1-ragulbaby@gmail.com>
X-Mailer: git-send-email 2.53.0
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

This series adds support for the following 802.11n USB adapters:
- Broadcom BCM43231 (Netgear WNA3100, Dynex DX-NUSB)
- BCM4323 (Netgear WNDA3100v2, Belkin F9L1101 and others)


The protocol was inferred from USB captures of the vendor's
Windows driver, cross referenced with code from brcmsmac, brcmfmac and b43.
The code which are copied almost as-is from the referenced drivers
are indicated in the comments of the code

The driver supports:

- station, P2P client and monitor interfaces
- HT20 and HT40, A-MPDU and A-MSDU transmission
- 2.4 GHz channels 1-14 and, on the BCM4323, 5 GHz channels 36-165
- hardware CCMP with management frame protection
- the LEDs and the WPS button

Power save, AP, P2P GO, IBSS and mesh interfaces and hardware
TKIP/WEP can be added in later patches

The series
----------

Patches 1-10 prepare brcm80211, so that the driver shares brcmsmac's
and brcmfmac's code instead of copying it:

- 1-2 make d11.h self-contained and move it, with the transmit frame
  ID masks, to the shared include directory;
- 3-4 prepare brcmsmac's rate tables and rateset helpers for brcmutil;
- 5 fixes brcmsmac's L-SIG length of short-GI frames, which could be
  one symbol shorter than the frame;
- 6-7 make the PLCP and frame timing helpers take the band instead
  of brcmsmac's state, and move them to rate.c;
- 8 moves rate.c, with all of these tables and helpers, to brcmutil;
- 9 moves brcmfmac's USB bootloader definitions to a shared header, as
  these adapters boot through the same bootloader.
- 10 exports ieee80211_get_bssid() from mac80211 again, reverting
  391234eb4831 ("wifi: mac80211: unexport ieee80211_get_bssid()")
Apart from patch 5, these patches change no behaviour; patch 6 only
drops the device name from the helpers' error messages. The brcmsmac
and brcmfmac changes are compile-tested only.

Patches 11-17 add the driver, with the Kconfig, Makefile and MAINTAINERS
entry coming last.

Firmware
--------

The driver requires brcm/bcm4323x.bin. As captured from the 5.100.68.46
version of the Windows driver.
sha256 cc286a529396434a38e59382dcd46fa92a57f1cd1a38eea20d2b24dec028cf29
This firmware needs to be in linux-firmware.

Testing
-------

On a Belkin F9L1101 associated to a 5 GHz HT40 WPA2 access point,
single-stream TCP ran at 107-128 Mbit/s in both directions.

AI USE
------
Reverse engineering is done with assistance from LLMs.
Code has been reviewed us manually.

Ragul Balaji (17):
  wifi: brcmsmac: make d11.h self-contained
  wifi: brcm80211: move d11.h to the shared include directory
  wifi: brcmsmac: look up OFDM rates in rate.c
  wifi: brcmsmac: give the rate tables and helpers a brcmu_ prefix
  wifi: brcmsmac: round short-GI L-SIG lengths up to whole symbols
  wifi: brcmsmac: pass the band to the PLCP and frame timing helpers
  wifi: brcmsmac: move the PLCP and frame timing helpers to rate.c
  wifi: brcm80211: move the rate helpers of brcmsmac to brcmutil
  wifi: brcm80211: move the USB bootloader definitions to a shared
    header
  wifi: mac80211: export ieee80211_get_bssid() again
  wifi: bcm4323x: add the shared definitions
  wifi: bcm4323x: add the USB transport and firmware setup
  wifi: bcm4323x: add the receive path
  wifi: bcm4323x: add the transmit path
  wifi: bcm4323x: add the mac80211 operations
  wifi: bcm4323x: add LED and WPS button support
  wifi: bcm4323x: add Kconfig, Makefile and MAINTAINERS entry

 MAINTAINERS                                   |    7 +
 .../net/wireless/broadcom/brcm80211/Kconfig   |    1 +
 .../net/wireless/broadcom/brcm80211/Makefile  |    1 +
 .../broadcom/brcm80211/bcm4323x/Kconfig       |   12 +
 .../broadcom/brcm80211/bcm4323x/Makefile      |    6 +
 .../broadcom/brcm80211/bcm4323x/bcm4323x.h    |  258 +++
 .../brcm80211/bcm4323x/bcm4323x_core.c        |  545 ++++++
 .../brcm80211/bcm4323x/bcm4323x_led.c         |  221 +++
 .../brcm80211/bcm4323x/bcm4323x_mac.c         | 1495 +++++++++++++++++
 .../broadcom/brcm80211/bcm4323x/bcm4323x_rx.c |  317 ++++
 .../broadcom/brcm80211/bcm4323x/bcm4323x_tx.c | 1386 +++++++++++++++
 .../broadcom/brcm80211/brcmfmac/usb.c         |   68 +-
 .../broadcom/brcm80211/brcmsmac/Makefile      |    1 -
 .../broadcom/brcm80211/brcmsmac/ampdu.c       |   34 +-
 .../broadcom/brcm80211/brcmsmac/dma.h         |   27 -
 .../broadcom/brcm80211/brcmsmac/mac80211_if.c |    2 +-
 .../broadcom/brcm80211/brcmsmac/main.c        |  687 ++------
 .../broadcom/brcm80211/brcmsmac/main.h        |   26 +-
 .../broadcom/brcm80211/brcmsmac/phy/phy_cmn.c |   17 -
 .../broadcom/brcm80211/brcmsmac/phy/phy_hal.h |    3 +-
 .../broadcom/brcm80211/brcmsmac/pub.h         |   35 +-
 .../broadcom/brcm80211/brcmsmac/rate.c        |  514 ------
 .../broadcom/brcm80211/brcmsmac/stf.c         |    4 +-
 .../broadcom/brcm80211/brcmutil/Makefile      |    2 +-
 .../broadcom/brcm80211/brcmutil/rate.c        | 1027 +++++++++++
 .../broadcom/brcm80211/include/brcm_usb_rdl.h |   77 +
 .../{brcmsmac/rate.h => include/brcmu_rate.h} |  160 +-
 .../brcm80211/{brcmsmac => include}/d11.h     |   43 +-
 include/net/mac80211.h                        |   12 +
 net/mac80211/ieee80211_i.h                    |    2 -
 net/mac80211/util.c                           |    1 +
 31 files changed, 5649 insertions(+), 1342 deletions(-)
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/bcm4323x/Kconfig
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/bcm4323x/Makefile
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x.h
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x_core.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x_led.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x_mac.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x_rx.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/bcm4323x/bcm4323x_tx.c
 delete mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmsmac/rate.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/brcmutil/rate.c
 create mode 100644 drivers/net/wireless/broadcom/brcm80211/include/brcm_usb_rdl.h
 rename drivers/net/wireless/broadcom/brcm80211/{brcmsmac/rate.h => include/brcmu_rate.h} (53%)
 rename drivers/net/wireless/broadcom/brcm80211/{brcmsmac => include}/d11.h (97%)


base-commit: 734bef548a96e8774d6eef5dfa2026c6edc4e80b
-- 
2.53.0

