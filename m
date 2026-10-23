Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792796243;
	b=shPJenJt4vjKNh0AQdYjnXSYj3QDoIjkqBv9ObxlX3kLmvgFfOhazPG9da7jt3dy1sim
	 k69D4SRiVGLwiYkKgWTU4HRrZXAochmBkFDhPfPcIeo7lRq2M/tv8B3pw8WqJFZmgPpaR
	 APt5DJfagpz+pvSQuJjCituDa0LuMNu+BwJCK6HPjJmxn+VTvK1qgeWqlZxV5lF3/qLEC
	 o7vfyPFoXSDK9H2ooMoU/vqhyMF8gfN+59GMYCeAF2RN1qHt0QCok7ZWyqVDQYc115psz
	 uOFccsHa+UXq3p/WRvBKSZKVy+FQB1/f20vFfEBCa9z3XHX6j58x6wQswBNxvV/deqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792796243;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Content-Language:To:Cc:From:Subject:
	 Content-Type:Content-Transfer-Encoding;
	bh=h44v1e4CjKH/NnlHWkiGhCiMhc8FFZTwqKeIHHelRtE=;
	b=Tw0FusrOkttWatx9mYzOb37iHHjs4UF5UJIu4txfcWGOANnetBdTlvcBhnm72PP4d9e7
	 WPYWhoDeEs0XgTecZn9m5a767Uad7gg+6MRYzDisPFCb7vs+6RQBZaBeDHX3Msyw39RVu
	 p8xPHo+4p0qp+QnJPhhZCvJLThbUKtmoX0+26PsSgjOI2knP7NWviTCX56+uesnvFvfLP
	 ERJOskI7SCAZ7Z/UMNL2A65afVJGvnZlJW+d1/hK317ZAH8FW+hT7+oL2bXtnOZOlp2bQ
	 fG/OcV/cjkOYhxHO17DZW6auzBa0oHZhq3Nn9vkj67pfVz6FMV6hMTLDIW287BnCaRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=iMpDJQD6;
	arc=none smtp.remote-ip=209.85.128.44
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED369606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 22:57:22 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org ED369606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=iMpDJQD6
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a35ac4475dso616185e9.2
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 15:57:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792796241; x=1793401041; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=h44v1e4CjKH/NnlHWkiGhCiMhc8FFZTwqKeIHHelRtE=;
        b=iMpDJQD69mSfMNdH/3lFR8Ua6UEgwRnENcq9aTKDGdJT9NODPo2k+DQ7T2uTr0hHuz
         D2GXnh3AkknxQxlFCIEJVVwtd/D/mU+wa8jflkuT5WPoKbMTowrgcCpiR/RjxffPIfJx
         oDEue6echCDf3oWWHCOB10Bl0H6Ssk7D6gOaWG/RDcAvVSHPhmVWtNdzrPuXVqd3Dcr0
         dWdXsSHleRUxoxyvAXEGUxRDFaDdzDtV1UIa75CwChxZjAJBbrjhDfMarbPxIKaP4ORT
         hlFtP3UIAUmacvGi2Zpr1/lQ2KhcQ0DCt6GrnKZc3haEbKmoo34g7GRUbIDchmd7UYL6
         T24w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792796241; x=1793401041;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=h44v1e4CjKH/NnlHWkiGhCiMhc8FFZTwqKeIHHelRtE=;
        b=IJJltStwVuJF3kg8uZSz7MtdGJ/zsd4ah5V10gOOBkuZ5s2d46AgC1Pn/rO/EMBOyc
         dhIJBgLv5pHlJO2O7ouzAPsyCEXcdlysvQyuuRNggbpZurA3CHYWMk7C+TPMkXzNntYS
         WODmzPv6uRHuMeoKCap9By8pBiRGrCXgK3GBZ6bMyipPFAI16wHBP7eU2jFg6071W5kb
         wuyDBgn6yAnmfM2CMz4gtQivZft33LyGJS3B0/W7NGnDlEGZTTtYtLszgrxWs07szXJe
         6KGgcu2hAG52LamRG8zhCUiexOzHK0fYYEHKEpbzJAxmygYHapyO/eVBpCd59ncIH7I5
         CiBA==
X-Gm-Message-State: AFq9FYLnGV/kyiDZwEKHq+5W7ZsLOzQxpFm7X3XirkxsNaoAiuOp1pBm
	wMhjQA2TZ8gGZj4MVqflp6hOF8XcebVhgOhEbbdyIY5bSMpVFz9S2U8cR51/Iw==
X-Gm-Gg: AYBFou0/7arebX5VmSiP13FvJiZnX37CxhbSEOYCl24jb47dl+p4uPe9kb9SXSjlMiI
	d8XFIY9i2lbY5XFUY78+suwJi12HefPBxrno71eKxPugbrdwhczInSNdtnq6cWEYwhiCA6Wzn2q
	88V68dUswHaOb3uDLpYYKImHvPhxMEtgdSxk/lshY2on+AUcojmd6OOLPIt06S1vvAPBKqCLc5J
	CyIkJoDFGCHxsrREP7mnTcJtqWEFx962cl68GCdGZ4YwMI6CUsLbTMJc8XsB49SvUcH172pJcOY
	nKGYx7KfNZPH8ndVuEwWMZopFPMuxD4BJ6vErsUfBCcYiVZPuTpJB2X60Wx/sEq+e3nk21MEKY4
	xdc6fKeWUh4iVtyRYSuDXGqIzt/yTaQu8dBTSB8oJRrGFfg4I5sjPBmZJDtOFPmvaupYKI5eTKp
	XwDhH5fpkI4Ul5FvR00lrcfsIvd2FUbUwXZwEBla5vVfryOi6nWFud+yL429cXDUQCWZeB3HpBg
	D2JSIWWi1kOZl5BUpgbIr2j4uwK8cNpRowAUCsdvynpZLsrayQmybevzo5AgEYT
X-Received: by 2002:a05:600c:4e87:b0:4a1:f7f4:7cf2 with SMTP id 5b1f17b1804b1-4a35acaa046mr5900205e9.17.1792796241126;
        Fri, 23 Oct 2026 15:57:21 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebcb8d5sm819348f8f.28.2026.10.23.15.57.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 15:57:19 -0700 (PDT)
Message-ID: <2033f1b1-fb12-4a04-aef4-923590e64463@gmail.com>
Date: Sat, 24 Oct 2026 01:57:18 +0300
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Ping-Ke Shih <pkshih@realtek.com>
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: [PATCH rtw-next 0/5] wifi: rtw88: pci: Support an older design, like
 RTL8821AE/RTL8812AE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

This series extends rtw88_pci to support an older design, like
RTL8821AE, RTL8812AE, RTL8723BE, etc.

After this, another ~20 small patches can enable support for RTL8821AE
and RTL8812AE. Then rtl8821ae can be deleted from rtlwifi.

Why delete rtl8821ae?

 * RTL8821AE loses the connection on 2.4 GHz several times a day when
   using Bluetooth headphones. Most of the time it's not noticeable
   because it reconnects immediately, but sometimes (once so far) it
   stays disconnected because it can no longer find any networks. No
   clue what causes this.

 * The mouse cursor can stutter when running iperf3.

 * RTL8812AE has a strange problem with TX: iperf3 TX test shows
   drops to 0 Mbps every few seconds, which can last several seconds.
   This happens often.

 * Most of the code for these chips is already in rtw88.

Theoretically rtlwifi supports WOWLAN, but it doesn't work for me with
RTL8821AE or RTL8812AE. rtw88 doesn't support WOWLAN with these chips.

rtw88 is not without problems, but in my experience it's more reliable
with these two chips. In the 6-8 months I used this code, I observed
these problems with rtw88:

 * The top speed is a bit lower: ~220 Mbps instead of ~300 Mbps. In the
   case of TX, the difference is due to the EDCA parameters. rtw88 uses
   the ones from mac80211 (rtw_conf_tx()), whereas rtlwifi uses its own
   "turbo" values when there are not too many non-BE packets
   (rtl8821ae_dm_check_edca_turbo()). Not sure why the RX speed is
   lower.

 * RTL8821AE RX speed gets limited to 70-100 Mbps sometimes. If I watch
   a Youtube video with Bluetooth headphones for 10 minutes and then
   switch to another wifi adapter while the video is playing, leaving
   the RTL8821AE's wifi side idle, usually within 20 minutes it will
   start to raise IMR_RDU when it reaches the end of the RX ring and
   goes back to the beginning.

   It uses RX descriptor number 511, then number 0, then it doesn't
   want to use number 1 for "a while". It raises IMR_RDU once or twice,
   and only then it moves on to number 1, 2...

   Usually when it raises IMR_RDU there are 510 or 511 RX descriptors
   available (out of 512), so it has no excuse.

   Once it has raised IMR_RDU the RX speed doesn't exceed 70-100 Mbps
   anymore.

   Powering off and on again, which happens a lot when the wifi
   interface is idle, doesn't help.

   The only thing that seems to help is reloading the driver, but even
   that may not always work.

   Switching to another wifi adapter while playing some video is the
   most reliable way to trigger the problem, but it can also happen
   randomly, it just takes many hours.

Bitterblue Smith (5):
  wifi: rtw88: Pass RX buffer to rtw_rx_query_rx_desc()
  wifi: rtw88: Pass TX descriptor to rtw_tx_fill_tx_desc()
  wifi: rtw88: pci: Introduce struct rtw_pci_gen
  wifi: rtw88: pci: Add functions to support older chips
  wifi: rtw88: pci: Handle more RX interrupts for RTL8821AE

 drivers/net/wireless/realtek/rtw88/Makefile   |   2 +-
 drivers/net/wireless/realtek/rtw88/fw.c       |   4 +-
 drivers/net/wireless/realtek/rtw88/main.h     |   3 +-
 drivers/net/wireless/realtek/rtw88/pci.c      | 167 +++---
 drivers/net/wireless/realtek/rtw88/pci.h      |  44 +-
 drivers/net/wireless/realtek/rtw88/pci_old.c  | 529 ++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/pci_old.h  |  39 ++
 drivers/net/wireless/realtek/rtw88/reg.h      |   3 +
 drivers/net/wireless/realtek/rtw88/rtw8723b.c |   2 +-
 .../net/wireless/realtek/rtw88/rtw8723de.c    |   7 +-
 drivers/net/wireless/realtek/rtw88/rtw8723x.c |   2 +-
 drivers/net/wireless/realtek/rtw88/rtw8723x.h |   4 +-
 drivers/net/wireless/realtek/rtw88/rtw8812a.c |   2 +-
 drivers/net/wireless/realtek/rtw88/rtw8814a.c |   2 +-
 .../net/wireless/realtek/rtw88/rtw8814ae.c    |   7 +-
 drivers/net/wireless/realtek/rtw88/rtw8821a.c |   2 +-
 drivers/net/wireless/realtek/rtw88/rtw8821c.c |   2 +-
 .../net/wireless/realtek/rtw88/rtw8821ce.c    |   9 +-
 drivers/net/wireless/realtek/rtw88/rtw8822b.c |   2 +-
 .../net/wireless/realtek/rtw88/rtw8822be.c    |   7 +-
 drivers/net/wireless/realtek/rtw88/rtw8822c.c |   2 +-
 .../net/wireless/realtek/rtw88/rtw8822ce.c    |   9 +-
 drivers/net/wireless/realtek/rtw88/rx.c       |   6 +-
 drivers/net/wireless/realtek/rtw88/rx.h       |   6 +-
 drivers/net/wireless/realtek/rtw88/sdio.c     |   8 +-
 drivers/net/wireless/realtek/rtw88/tx.c       |   4 +-
 drivers/net/wireless/realtek/rtw88/tx.h       |  15 +-
 drivers/net/wireless/realtek/rtw88/usb.c      |  21 +-
 28 files changed, 802 insertions(+), 108 deletions(-)
 create mode 100644 drivers/net/wireless/realtek/rtw88/pci_old.c
 create mode 100644 drivers/net/wireless/realtek/rtw88/pci_old.h

-- 
2.55.0

