Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793038745;
	b=Nmk9sBxkQts7cV0CIAgk0hy5FgVD/ZT8AYgLhXmKkWQ1hp5cBMisBnX9YL1hmqnIhdBc
	 IUmbvaQogh9ZRKNtxV/GnuOSOmEb7vWyWAvLq4Q6lsaQr/+WQfQeUN7dh3hDVO4lBohWJ
	 e9rhvA2kDg/8RtOMH1KCD0XL0LpzAFNUmCbsTj3vlnhU444nRVaKHZVChkiE9PrYbqEt7
	 jE50w4nPZT82Tu/Dhd5J0DlLhsjF99I0VYHCRRCdPKWNGLynmWMNpUpjQHkA6B5KyxkMv
	 V4VGmyiaFS/STSbAelz8CgZKs1GfwykW6suybganVCQ59YXDQX23+UB2hnnr+0fq1vQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793038745;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Received:From:
	 MIME-Version:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type;
	bh=q4zljUo/WokZ9ZcS0OuLFAaAoXOMyCY40p9IAtD1yUI=;
	b=DBejQ/3J3uyjiilzGnV/Tlg4tsOcjcXIwhLtR84qcZujFF9xDyoQymlgzf5bUafiLykU
	 as+kIbmPdhFr5yWa19yxNvsM49xQaB/hfqhKP4eYXILqf3DMgF48Oa2GQ9IqsRbHzbm2V
	 ie8cPi4CPTsI0Zl1O7qmP+WNwnAHifmfhzS0E+rvUph8PVAH0sNdczWtaT2WVlOzkKH3D
	 zYrMbFSAUjO1FCLFMaqWTHPVj0+TzAyoG8+TfvkpPMBYOO/Z812wtAsYarcAAJEvg68J/
	 BdIm9IC7mrqCUADJZ2nw/Cc63m9U+imwmOWUjcxy2EL1JrtLc0VFvxycIcA+xZyZ8ew==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=YO6o2UWh;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2EAE606A31D
	for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 18:19:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F2EAE606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=YO6o2UWh
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6af9a90e4bbso3594468a12.0
        for <linux-wireless@vger.kernel.org>; Mon, 26 Oct 2026 11:19:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793038743; cv=none;
        d=google.com; s=arc-20260327;
        b=Qb51x8TXjvCX47XJh7vMcmTmchJ3rI2R2/YeB/ZfT3DcObqes1a1uR/CAtVa1vb4mf
         SVUiZVcAQv8x51nc0HIgKtePEfwzz8O+ce+kPyeAgCESnkKxn/31i/kaeAgHietnvjUk
         wD/vqNePl6bKui5RLP9/7/HyeQTS9PezgtFv9s/Zg3e18kmAueZYcNm5NqfESvXJofp2
         dihmOve4J0jdtCRWbMZ6isq+t7CjU1QJioutTJcSayRWoa9buTy29t5AZX71Z1V5lWfB
         MDe6ihvowzKX2dYwf/hHED5k3Z+R7POLRMav+Z5kHI8n5r5ysQ1bffyT1nz3L3iVkGvW
         Q6vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:from:dkim-signature;
        bh=q4zljUo/WokZ9ZcS0OuLFAaAoXOMyCY40p9IAtD1yUI=;
        fh=18jRy6CEx0zBe1u/txeaf9Zh0AfMoIPOFwSHNAfM7eM=;
        b=OgMbPQH742DxOioiiN6QZwlrCEj5Y1rs4JYahkq+ICxBMf2MfveLwm790/vqvBFO1m
         fE1UPsd24zH74TZo0Vna1w0FzqhkfoZH9Z4UyfaHmmxaDU6nPo79ZRxfjwiCPaTCgBno
         pGF8t9879691UZd5eAf0Wjoj9W9GEFMQW8TB/xOwVw3EMO8+bRfi+e4b50zOEoWHreDt
         LiQgRxhJoq6a6fIoREukM0Ya9zlJMXYO6gktkn0Sftu7I+8vT8u2tgOhzioVdMWdi3Pm
         vBF3DankmZJiKu/WSqIDw54yStd2XIiBB5OZrNFBYY9yCtrqWJIZwbpdhpBkiUaQBDoY
         tlMQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793038743; x=1793643543; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:mime-version:from:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=q4zljUo/WokZ9ZcS0OuLFAaAoXOMyCY40p9IAtD1yUI=;
        b=YO6o2UWhnZal/jIxQhDAZyGMq+3ad8NQaAHXtAB8i74Ah6mEwJJNpe37X/jwC2ISQK
         bexaJ64o7gqfS1A8sf0Q9+3ukfmG+7seVaNvOtaC+6hysw5LW224dJf4+yG4RtF7tfrn
         Y27k18s1lVt/3DackF2QWeR4RTDiV4zxG0Q3HmtNYpH0jtKwjvLXvUgg0bR48KlrZqln
         jMYQIqVoljvh/2aIQOkO45H1/1TKs4cTcfKbxXvleK2jSCH5kJan2KZ/j4USCVphGpJW
         WSx0AweoHgJCEbEjKH3SCyfYNR7gRrXaKYHz77pUN60HpReBov5h0+2pcKtQOMwKImHs
         Pxvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793038743; x=1793643543;
        h=content-type:cc:to:subject:message-id:date:mime-version:from
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=q4zljUo/WokZ9ZcS0OuLFAaAoXOMyCY40p9IAtD1yUI=;
        b=G37e7pCf0ZQmA8MMLTIfjzcKggxwxJ7N7McMs4QRva8KJN7v/1jEJm+5PSI3kONJRi
         umD8ZbZmvOwF6fbMo+fZBvLczi32S18dMolWqHTEMiXdev+8+Ybrlh6rdVDHOZQu1Xv4
         3D31pq26V2wrNvA2zAKLdfZV3BJhkg+8WocE0dgfbgNiUAH1PGQ65yENBJvKJuO4Bvxj
         jkji8InVImyQn0AC/jbEH9gk8WxzEEETSlD1dTkacF399jT02ghRXbL9WIOHda3IIYhp
         WFva3KT4rzPzCK7HgJ9b0KSl9YbCaFQen1xRxYOocMrsFCCPJiqERHwzCB2Np/W3q7cs
         W9sA==
X-Gm-Message-State: AFq9FYIwBD/d9QcnjRzlWKo+/HWKlUA9tyv9OHFOl2v100U/prZiE5Tf
	+lfQfwfgZIK9w886gLQXWqaBD3kGBwdNo+SvToxhRoGi0fJt9u9yeVvlaqg1AXk+JR+vVa1oiHY
	mn2xzo9ExYY0ogOpjahj1WZoHjzveG7R1f6o5
X-Gm-Gg: AYBFou0OrttQutJGqnQif8AWluuYVs2nnazHN7jSPksNSLzs/LSZIlOC8hHfGLbqt8q
	cNQbccnHJX1y2s5gglcJYQ15rBOMDnm5hjvjeYu/FgGTmA4PfDJ/5MvcZ4SkFyoYnopXb21Ndi4
	mUz7U42Nty7glEi7DxPj/tWgTyufbKRUj4K+S23qLc9+7Xjz9/7LIP2C4QAzcTxqWKY9Bh0jxY+
	8F+BalcJIoVhLhc31YehWquNJapS3RfSqMwc3DAAvZU0BBKivZLA9u+ldM6nsF4eEMTDbK0/bEo
	8qLVTFmlTU/7whH+SddDSufOxHfv6hutOYHWcQsQdCCbnbqEMan2pBfmNPvQ8do02CwSPnRmJbo
	hU+FMAvDbQ9AlPpKJmxi2Oc1gNw82MA3h/xir
X-Received: by 2002:a05:6402:11cb:b0:6b1:c34b:f1de with SMTP id
 4fb4d7f45d1cf-6b442fe01e4mr8023274a12.23.1793038743182; Mon, 26 Oct 2026
 11:19:03 -0700 (PDT)
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 26 Oct 2026 11:19:02 -0700
Received: from 511566560828 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 26 Oct 2026 11:19:02 -0700
From: Ivan <ivan.vin.ctf@gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Mon, 26 Oct 2026 11:19:02 -0700
X-Gm-Features: AclHuK-ipMP5mANTbqHhxLeL7nhQ9xloN8pId4pHJHix7hbFR8bNuox2OXTaCOs
Message-ID: <CA+hZKY+MDvp5rn-F=wJAP2HR8PAXBkLHiK==4ESeZ6uU2zADoA@mail.gmail.com>
Subject: wifi: mac80211: two more check-sdata-in-driver WARN sites
 (drv_bss_info_changed, __rate_control_send_low) - same family as the 2026
 set_bitrate_mask fix
To: linux-wireless@vger.kernel.org
Cc: johannes@sipsolutions.net, syzkaller@googlegroups.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi all,

While fuzzing 5.15.216 (KASAN, mac80211_hwsim + USB ath9k emulation) we hit
two additional "Failed check-sdata-in-driver check" WARN sites, same
underlying pattern as the recently patched set_bitrate_mask site:

1) WARNING: net/mac80211/driver-ops.h:172 drv_bss_info_changed+0x4d8/0x580
   message: "wlan0: Failed check-sdata-in-driver check, flags: 0x4"
   trigger: syz_usb_connect_ath9k + NL80211_CMD_SET_INTERFACE (iftype=7)
   racing interface teardown/bringup; 16 crash instances collected.

2) WARNING: net/mac80211/rate.c:371 __rate_control_send_low+0x6ca/0x7e0
   message: "no supported rates for sta (null) (0xffffffff, band 1) in
   rate_mask 0x0 with flags 0x0"
   trigger: scan_work path with a NULL sta.

Both are the "sdata running but IEEE80211_SDATA_IN_DRIVER clear" class:
the driver callback would run against driver state that may be freed or
not yet allocated (the guard prevents a use-after-free class). Following the
set_bitrate_mask fix pattern, early -ENETDOWN returns in the calling paths
would close these.

C reproducers and crash logs available on request.

Thanks,
Ivan Vinichuk

Reported-by: Ivan Vinichuk <ivan.vin.ctf@gmail.com>
