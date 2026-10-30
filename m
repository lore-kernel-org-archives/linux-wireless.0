Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.176
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793394236;
	b=vONevsy/hqqZEC9a7bYjiJhJbuHF37mmFDO8WxyW0sv7TQF7oVTNTelRshHwbNIl2mmx
	 OtwDAKvkQuCD9ejnm8xu9KNsW4O3eHFJeQ+RTzbCvYBHJ86CJEnp6tIscy6UWjuz91En3
	 QhoLRD8rSaxyiyLFe6sPc+kuXLOx/LeRSi4Lqo8vhIaxh9mg/v3PTgD4LOoQWe4Anz4TA
	 UlVGlMmXi18dqpmqxA9CFY9K2v2jxorVpxm0Dkw71mM3eLUdQfLCddflV4nwiE5ypgJBD
	 NPx3M8tEL/5h968aYx3VSWaRedagrrztBOL5sFrgZXpDKrroV5edFfkph3aJWjTf7bw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793394236;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Content-Type;
	bh=8cw2VznT115t7XvjisUuqdBWNpKN4PUjAu1fVe5hJRw=;
	b=yv29l9Tnm91T+OWURi4cd4IA0Kw/UnwGseQI0oYj34nDXXwdI8cCMKSDDkKTG7G3VYly
	 PEHPwA2OkuN5tn3aTIyuYct/fOWYoS4hh+LXAqhdwtSWFOD15qY2yo0EC/ml/VB17uBR/
	 +88f7PJ9rZJc/+j8GiOhi5WfyNIJ8wf6Yma3myOIr4kj+tCcStSvcKaH/UmL8wLCMscJB
	 ZM8fSapTJhnBG9ss3R3uScRCWKVohjMrLGGrs49JHZnRx21M4A4v3z2R8bOBda+fjMTAg
	 qMa+zhTb+OX9jkij6JhXAwOdIgbwYNgxO5QhzxiM4OA3IGPCZ/jbf2fEF9KbTTAWTuw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YGUTD3fg;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.221.176
Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 681A5606A31D
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 21:03:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 681A5606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=YGUTD3fg
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-5eafaeb8684so372300e0c.3
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 14:03:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793394235; cv=none;
        d=google.com; s=arc-20260327;
        b=ado/mJF1MTrNWaMtZITl64InveebRRHxE3CPZDnJ+kHC4SpIQZtVq5PiKXgf5s10oG
         aWsaCz5A2RlM17kF3cm429SoD5VF0L7/h1D6wqZ9bgLWLGqvpREvt+ugFXi4OtQbRW7l
         eej+D89wqIcKRgeIVSuFoHGq0iAqqezTAweaAWUkTxRRuKg46D9XhW488ZLqjdggYIUY
         KTkue3jexdim/UeDK/+kNTNJ4j06Jx8rRMPs4Dxfi0cboMjEH4LlwfNVdChi684kbKfr
         FdScpM0zmjrDVwh0KCWH91CRTRrxJL1RhqQUza2LEIMIq38wwYBtlbWI3I2l14bqLaQ6
         x5HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=8cw2VznT115t7XvjisUuqdBWNpKN4PUjAu1fVe5hJRw=;
        fh=BOBxn3vZOTDitorcGFvbeWPHWPTm8fcHGhxz3wt6muU=;
        b=fYKFd/9Mqyj3uJCNn+zbZxYjlaGwyixXYC2pyk42AVlMswg+UQji52W4cqpOwqyOGD
         h+ntCnkjjunVfeZ/UmDyrj4o7pg9y0jc36FYcDmWG2lNOIiNCeqTSePwQ1GoVHuXCT4X
         r8T/imM3ipOJichqvmnwBKgZdGjUWTQG6gNt2zJSVCzpJuNjNmQfoDGiShcRkIFKsZ6O
         VAsAsdepkVqdfYLcVM9qytooJGniCWgMtOcu1AOdDIlpIs0KSma44YVYiF+Ti7cVROD1
         KC0mesRdEmMeXSZMzD30Zoc6AOLO/UBUh03jqo4EX96y5X+MXuc6p+MOjbA1v+NWVEq5
         whtA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793394235; x=1793999035; darn=vger.kernel.org;
        h=content-type:to:subject:message-id:date:from:mime-version:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=8cw2VznT115t7XvjisUuqdBWNpKN4PUjAu1fVe5hJRw=;
        b=YGUTD3fgG1qop0rdN/EpjxxnlovfKVhyX4+IZpX5Q2RB9cRbvDaHA9BXRiWGiAROcR
         /6CVBz5UHIKTtdj27eWoWlx35ZumEmAAKtym0i8ouSrHcaJ7qh/WliVtvTpud6PnEHIz
         N9S7uxO/on45kQnjEn8efl1t6L5ZPyVKI5PJCKi7i28MqjYI8XuAA0oMp5OfL9mYYJ83
         xGbcxfQwyGixOkP6GHQULjw/T6+hS7TtWLCDMOiD9rW+DK4hUaJL5F2go0nA4CliaE8O
         7EO9py3gjPcb+Ur9ugO5GYQtOqHkW8S0NqJ4i/rLwcNm91QtxF3SToJbsi5Y0w/HjfwU
         hM/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793394235; x=1793999035;
        h=content-type:to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8cw2VznT115t7XvjisUuqdBWNpKN4PUjAu1fVe5hJRw=;
        b=ieTPocUSw6mzoBaSaFIAWJCtr15Djp93TsijwvynHFPWsFAztdS7xFjwmxwMWSj7BH
         V1cN8sayQK8miPJbMJJP5CA5JK/NsGYu58o/A0buFWqqfwuYWfmn06t2ZSLveslX1blq
         DxVL1gTxe9ZdR3t5ZTUCE6+GICB1xoIKUXRzh5n1Lcetx4ueu7HXTZQ8t8BtgJ/ME9G8
         HhCVgrrtLvEZIjOKd5SrKNnc6eybmDMZxSoxZRT4jbb5xZIlX5e0Y4kKKmrHiY6ZHF4y
         MUOtZit/UO63VNGMkY6CRXw/xltXBnRUqVSvg1gJ6vjwfP1pkFk7R0p8X8c6ZSTcW0bg
         8i9w==
X-Gm-Message-State: AFq9FYLCr2hX3+97OantvoNxFkSMtjhA5a/85AAcN2U86ZIz3m3jSm19
	6bcV0czqP9HOP9BwRgEWYmBoxDDBrL3e0q0BME3/4p9E8S6xZ3NRTatHvyOPkIfEVgLOdNzhhUZ
	MjaNjCZr7cLdcIJvjq8fsLRsx1N0g7nnWTp0x
X-Gm-Gg: AYBFou0VdqdAhcXLREb/AqtBZ2Vp+x7s81We7Q9QchTJ52Q66WyL732oFcfGLIybhAO
	SJZuDtvsZBvx62C6rbuJ2HUKnZpTub5DZ601uN/Dg1MwonlKuh0Y0NnQAdJUCQHecIDPJ0CsrVp
	ptbISB0SbaVRjXG/dnMYbcaumTWa1x2Yey+31+Nivd0CoIRWTDRHvV7WWrKjTEUXI+MXkDUVYkl
	TxPoxVpwU21D/Jb0yblA+9k7Y8rOWIA7n3iymQrhNqPSA95Wj/T30jDlkC/w9y/mADvsJT7cIZq
	rRdnB3yuLylndAHjFxapdV7BYuuReibFeuScmoap2VN9jjY+PfqBuYkX9TfAXS0QZHv+cQvKJ1c
	gAWRgxycMQcDgsAKwd0ooncIj5vVkGPaRHWWr75sd5n+6VU0O/Uiln27FIWkcTeakMAHEjDvgVI
	6FVAiKbRfmD9BKDvgU
X-Received: by 2002:a05:6122:4b86:b0:5ea:f220:fd6e with SMTP id
 71dfb90a1353d-5ec6881fc37mr2433469e0c.11.1793394235358; Fri, 30 Oct 2026
 14:03:55 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Work Money <work62153@gmail.com>
Date: Fri, 30 Oct 2026 23:03:43 +0200
X-Gm-Features: AclHuK9R0WB1q7BU-kTmrsOlmQbI-jyrnFyfsmVGDjzJ7zODOf5dHRMCYPJhA7Y
Message-ID: <CAEVijA0t2UkokNOpKN-Uje4n-ub9CwZrZN0evhWnn2eL1CvzPQ@mail.gmail.com>
Subject: MT7925 (Netgear A9000 / MT7925U): UNI_CMD_CSI 0x4A acks but STA
 firmware emits no CSI reports
To: linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org, 
	nbd@nbd.name, lorenzo@kernel.org, ryder.lee@mediatek.com, 
	shayne.chen@mediatek.com, sean.wang@mediatek.com, deren.wu@mediatek.com
Content-Type: text/plain; charset="UTF-8"

Hi all,

I'm trying to get CSI (Channel State Information) out of a Netgear
Nighthawk A9000, which is an MT7925U (USB, WiFi 7, connac3). My end
goal is WiFi-sensing research.

What I've found so far:

- Chip: MT7925U, mt76 driver, station (STA) mode.
- Firmware: stock WIFI_RAM_CODE_MT7925_1_1.bin, build
  t-neptune-main-mt7925-2249 (MT7925_E1_ASIC_ROM_RAM_CE_2249,
  dated 2026-10-16). All code regions are encrypted (ENCRYPT
  feature flag, ~8.0 bits/byte entropy), so static RE of the
  blob isn't an option.
- Command path: I'm using the connac3 UNI_CMD_CSI_CTRL /
  UNI_EVENT_CSI_REPORT (both 0x4A) from the mt7996 SDK CSI patch.
- Behavior: sending CSI_START (tag 1) returns a success ack, but
  the firmware never emits any UNI_EVENT_CSI_REPORT events. This
  matches an earlier linux-wireless report [1].
- Kernel side is already built and tested: vendor netlink
  interface, ring buffer, debugfs, and event handlers. The only
  missing piece is the firmware actually emitting reports.

Questions:

1. Does the MT7925 STA firmware include a reachable CSI emission
   path, or is CSI reporting only wired up in AP builds
   (mt7996 / mt7981)?
2. If a handler exists behind the ack, is there a specific TLV
   parameter, sub-command, or precondition (monitor mode,
   bandwidth, sounding/beamforming enabled) that triggers it?
3. Is there an MT7925 firmware build or roadmap that enables CSI
   control in STA mode? Since the mt7996 SDK already implements
   0x4A, is a port to the MT7925 STA firmware feasible?
4. Any alternative route to per-subcarrier channel estimates on
   this chip -- ICAP / spectrum-scan mode, or RX descriptor
   fields -- that doesn't depend on the CSI command?

I'm happy to run tests, share full dmesg/mt76 debug logs, capture
traces, or try patches on real A9000 hardware. Thanks for any
pointers.

[1] https://ratatoskr.run/linux-wireless/2026/04/15794137
