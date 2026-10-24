Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792854855;
	b=waj3u4YJAfd3QrdHGy5xwVzMJQQ6Kq3OZ/h4FcPM6wnFOHrNrF1rlxcbfYPG0BFBhin0
	 EQhq6FVKDJI15gUQkGM5Rz8jqwnw1LhfNj12XNV/IFuIt6cdkL4igfwgyyiHNDesluets
	 fTLirc8udD/bWkfnL5q6yNjoABT8AETOGZSVbALYy2y3vTKdVHtSIjPvhrasSXSbYBBQD
	 xBYliWC+T2jyAVa1hnMwNp1d8M41I395fQfA+mKq3hksq1YWzxheck0iEU1s4Q4bB62jN
	 SsAoNrAjeh9PAVgpWr7MzPKujRFt9zWc2Y4vslvlN+ByJAsC5pAAQNZxGSVqICd991A==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792854855;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=5aZKiMNsNuKoIYNElmMYyQbFoWSz4nPaUddhoQAfS7E=;
	b=2dSSZInkb9ZD6GIAVvTE4fIMH2xqtSj8FX0JOt315tAwgLTT2iClpgZxFaW5fZ71xU1A
	 UabqsGVF25LTkUK0F7vnQh5lpJjXL2MYP2xJAYzXXukTX5CpDi5tolMrF9Wj6xxaLKAla
	 0PWZPUKsPMbiJbMXpXLD+LZb2qotsQDfvw7Lpcb7fN64jt/8JR6e5S2eVNvITTKZpC6yO
	 wjIi6O5NGV75T35RS0QdNlDlfC8QUuYUF2wwk/vEqIEVr51zYI8xrHbZRrVeeRzvYJ1DP
	 RFWAEc6S5OVN+wyQ0K+OfzTLuQpcxutw9fIzU+sCNBeineHwYkdnjvJpZ3JvbmdQpog==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JlkXiCQm;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.46
Received: from mail-yx1-f46.google.com (mail-yx1-f46.google.com [74.125.224.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32490606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 15:14:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32490606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=JlkXiCQm
Received: by mail-yx1-f46.google.com with SMTP id 956f58d0204a3-676804a3a22so1718783d50.1
        for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 08:14:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792854854; cv=none;
        d=google.com; s=arc-20260327;
        b=S7GIGBxx3EsxmzHBbGY5GBpUQaGP0z8DIl0SffuHcvb9jBTqL0XcP5TsW5NXhz/eg0
         FvLgu509BuHrVC7UuXVDK1br9SBt+5dOp5NowuWs/8j7ZDdA+9pHMRU7SKvhlzMxN+xi
         ORii3bwf1Sa/mAa+cCx47Y6qBTSd/K/0Bz+vX+eA/vOxR0CI2qXCBHRvBwu3KJ5YOv3g
         nFmUnLTeXv/t51QaIFX6c+t374WNQFIKw7SVObVaeywdgBbPx5OO9wJknK8JayFr1Xcj
         lxnT6LOg4X9rtfJHmUyf8IkLFW4CAJvLlzSKqr5achMzfARgbDcAYRgkcIZtYemEMJbR
         ktlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=5aZKiMNsNuKoIYNElmMYyQbFoWSz4nPaUddhoQAfS7E=;
        fh=ODRIe49YN1GEYy1hSj1jRgZxpqaZQDfiP8iZXA7CtQo=;
        b=VPoCFYT/LfT65c6nRVto/xexA2XKSkSmrtfNk5fMzyWp77XESOSzYNTUiosvTtxpD8
         ISN5xLHvVycm1NyXjwxyLlo8dXEZU3n5FiQeLhKeLdVJPuKPA4blNXwSw4fi+7DtSCba
         sajnnYHASaJxkSgV4VajUmtgrsG0Kny967juH5kE1eOBXq4XeBbi3lIBvAfBpHVbUdQy
         oEn3nmHK10lTie9EBI5kYeSjsQO482vuhAwM/KE33PEZaNjefwu3LXRvTLd0e2CchzFs
         0fVSTmQ9vGvfyqU0/7LB8b2DLtCOc20r/CKhtSv6kGi54FTDk5TH2sL5L8mj0zFsGmhT
         55WQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792854854; x=1793459654; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=5aZKiMNsNuKoIYNElmMYyQbFoWSz4nPaUddhoQAfS7E=;
        b=JlkXiCQma/ox0VHd2geOnXzgDRSHukdEtvJskRW5KyNppvIO0vdj5C3nUAVHFKr4ex
         6IC+WqNWWJ43zqY0cmdaY3AHcM2WO/3IwIR9080HCGOnroa2injAQ/sqRP14Gn8eveUd
         XtP+7Nbm2ybJ3V+VBlLdPJTgIQBjFKqeh6DQpiv71ao8KuBQE+JEWfwaoZFfRA/ZzYVc
         vHJI1wiGSwMLOIsM65NAZ71SpGl3olojy0GwY/dFE2DbpDdM8eNAGSnN6NzAPuIz2M96
         Kg6JLOAs3BPWAx6srp7uz/4INzPvMeYGDAFb3CSvPgvQ3CVGtC5j0akqBpeQ0+V6giTd
         Th4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792854854; x=1793459654;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=5aZKiMNsNuKoIYNElmMYyQbFoWSz4nPaUddhoQAfS7E=;
        b=YSp044S7cGgxTUq/9hazvuV432V8cG/KFQBfyhaQ3wo5pvXRjSmwgI9uu8fqvmxVLj
         OTjnj4/HPvOKRZLPP8dXetJONomwHcR848hh3djpUy6KmzTzFpbYXhP/PvxXsUfhLJCY
         M4gilyvoQvDhTR0tbN6i/Iv1P3kU3JH49cgWa20G0RSeut2ij+YKJfjGwcBXX9Q2vtPY
         vwYiINI8EpI7XicMfkvHNVf8acReGISiuDizdwVgxd8iD8hLn2E8/lxVNie/ppSfG5SC
         8YC/LZ/PwUMNXsai8rjTkU33AucZX5T3uwHgmwRcCUf5UkVHBhx/Y78+fYihAT6r7zXb
         IFqw==
X-Gm-Message-State: AFq9FYIoU4y4X+O3vZ2Q1srmugqCab/C+YSfyvfA7ZxJy9ZveslDzaO6
	TvNp9Qwvs+k7/4hZX0/MZo4NcNiorpno/1dKYwvJ3QrHueDQsam0mxBUkUPeN3iWjWbSybD9rg9
	j4/NIAjW/hymYMPKUpmAC9NCuXuVDYxRik9a4TN0T5A==
X-Gm-Gg: AYBFou02GMoYEKofTWikMfJ684OlOMsI0VKRmsCVhB7qlWYOO9cFrgXDp9DaiIBEP64
	yn0uAAPvyWH9Pg2WikroKL+FAvlKSc/WixUkg2Mgnspfg9fEmkTBLtPnzGIivmOeN1eC55nPnRh
	HsZ5B5fo1r3IqftVPzYQgNQY79tUphtJkpdsBx/l4csTDWGVr2OP6JbSEf/onORqJgR1Zgm0Mbq
	mIX0Fmrb+W+dz0eQQ00smXXt5vyKRB216IZCcnWesvSYtGA48Hn/8ixo1NswgxAZOEJTtwztKVN
	Lmn7Hb+vhOWa7+zhSOpNyOEMMYYLbiq7+PN6O1CzkBanw5WUBLB4ENpRi4kngdxHXPJab06DRJt
	wS2yuoNZo9BIOHTYQyGFaSCnKtAFdMQnkb2GE
X-Received: by 2002:a05:690e:d8c:b0:679:c4a2:8bd3 with SMTP id
 956f58d0204a3-67a453db9d1mr1506244d50.41.1792854854115; Sat, 24 Oct 2026
 08:14:14 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Hedi Hamida <hedihamida096@gmail.com>
Date: Sat, 24 Oct 2026 11:14:02 -0400
X-Gm-Features: AclHuK8gSz0-ZRGHS3FgSF93zaOok558gy07hn_qlQbIKVtCMTWUA6GyuJJCEQM
Message-ID: <CAOjjH0397TDVqnOgwXdFg5LjvSQ3t_19Q-GjY4d9+-dXx-1JdA@mail.gmail.com>
Subject: [BUG] mt7921e: HIF_CTRL timeout after S3 resume on MT7922
To: linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org
Cc: Felix Fietkau <nbd@nbd.name>, Lorenzo Bianconi <lorenzo@kernel.org>, JB Tsai <jb.tsai@mediatek.com>, 
	Quan Zhou <quan.zhou@mediatek.com>, Ming Yen Hsieh <mingyen.hsieh@mediatek.com>, 
	Deren Wu <deren.wu@mediatek.com>, Sean Wang <sean.wang@mediatek.com>
Content-Type: text/plain; charset="UTF-8"

Hardware:
  03:00.0 Network controller [0280]: MEDIATEK Corp. MT7922 802.11ax PCI
  Express Wireless Network Adapter [14c3:7922]
  Subsystem: AzureWave Device [1a3b:5916]
  Driver: mt7921e (mt76)

Kernel: 6.12.113+deb13-amd64 (Debian 13)

Firmware tested:
  20241106163310  (Debian firmware-misc-nonfree 20250410-2)
  20260724143402  (current linux-firmware, 2026-07-24)

Problem:
After suspend-to-RAM (S3), resume fails:

  Oct 24 09:43:17 kernel: PM: suspend entry (deep)
  Oct 24 09:46:11 kernel: mt7921e 0000:03:00.0: Message 00020007 (seq
13) timeout
  Oct 24 09:46:11 kernel: mt7921e 0000:03:00.0: PM:
dpm_run_callback(): pci_pm_resume returns -110
  Oct 24 09:46:11 kernel: mt7921e 0000:03:00.0: PM: failed to resume
async: error -110

00020007 is MCU_UNI_CMD(HIF_CTRL), sent by
mt76_connac_mcu_set_hif_suspend(mdev, false, true).

What I tested:
1. wait_resp=true: the command times out as above. The driver then
   calls mt792x_reset() and Wi-Fi recovers, but the PM core reports
   the resume as failed.
2. MT7925-style event handling: I added a handler for
   MCU_UNI_EVENT_HIF_CTRL and sent the resume command with
   wait_resp=false. No event is received at all.
3. wait_resp=false and no event wait: the card is left unusable.
   It reinitializes/reset but never reassociates:

     Oct 24 11:01:17 kernel: PM: suspend entry (deep)
     Oct 24 11:02:11 kernel: mt7921e 0000:03:00.0: HIF resume sent
without waiting
     Oct 24 11:02:11 kernel: mt7921e 0000:03:00.0: HW/SW Version: 0x8a108a10 ...
     Oct 24 11:02:11 kernel: PM: suspend exit
     Oct 24 11:02:28 kernel: wlp3s0: authentication with ... timed out
     ...

   Only a reset recovers it.

4. S4/hibernate: the same HIF handshake is not used. A .restore
   callback that skips it and resets the device works reliably.

The latest linux-firmware 20260724143402 behaves exactly like the
2024 firmware: no response, no event.

Question:
Is MT7922 firmware supposed to answer HIF_CTRL after D3, or send
MCU_UNI_EVENT_HIF_CTRL? If a different resume sequence is required,
what should the driver do instead of resetting? Is this fixable in
firmware?

Workaround under review (reset on timeout):
  https://patchwork.kernel.org/series/1192671/

I can provide full dmesg logs or test patches if useful.

Thanks,
Hedi Ben Hamida
