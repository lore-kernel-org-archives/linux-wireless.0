Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48016361949
	for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 16:26:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787761588; cv=none; b=r7x5oTqtM/isQZjEm3zmew3IgMlscYX55U/RB99qSvcEUUw8EPA2Arktbxwt9CnphkP1XRWmcPoSrtPd8twgb0uzkWr3xBQQsWB0mxdatzGJoxKcKJlvAxMLkDvYLpSUrSmtBY012GUoxytkOW5nxEhMrJGBDcyB9DWotXB+UzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787761588; c=relaxed/simple;
	bh=2zI0maYxWQmbVfi8SDLlURIufds3iuftGNMOTM3Ds3g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=W+W8DPiBZEvqeHy+IerJSM3Gd9b5sKqyDhxvFlIpvnkDJDaHHU4nMfS8fUi+X82RNRj/G/esK5uvDIqL7DWLWrWLGcJqqyRBaYNccoHtwyE5u+p+3H5dW0IH08RSwwzi248izVrH6an5Urx4KC6ZM/UAqIMd4EfHpyeYQSrjL+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ne7AmyHt; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ne7AmyHt"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-6a374bea882so1565896a12.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2026 09:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787761585; x=1788366385; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RDbvHVv3Ay54T2tqN3gQcI6X5SmfuqhA1DB/PfpL0po=;
        b=Ne7AmyHti4JHKCP1TtKi8YBmkLPhZ89cZ+msMS8F/JIqjxrdR6l9cbnbTFd/gafDzd
         W8Uk9yCdCRXlayvRFvWhSOsAEUGHQ+RbMUIGIepFp/RSL7tjIe13rVsFjU7FCVbbMNiy
         PWZqRzNJm5FcAogb79Og7vfecyupg7BYGpe5g/G07SkH6ufOJGQ8Qba/rTrtoCtBb6CS
         zBNwxAS8V+0q73A03T2Ur4g8bObCsz9DTFF5VVtXGjOhj4PcuAolpyePdPUPkZTkR35d
         uIwTcknuRaeHiVyIFffXotRcc/FhRWLOl+Yvd+35y/yY2dVMpru517tjQoX41tU/S/kd
         Z9ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787761585; x=1788366385;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RDbvHVv3Ay54T2tqN3gQcI6X5SmfuqhA1DB/PfpL0po=;
        b=WHo5Hoz2feA90BgJpoXfcqTVDVUihVx71D4MtpGoVmvgV6C5A8FmaJxZNa/lRsHK5f
         i10I3oKsWUIsXiZKyz/iMwvYuljifp23+GeQfWnB70oxD7pmHaTWAN+kH1HYGez7w3WC
         jvwlebBrB7J9zDUOkDgxCNdOKyDWehmafuFj65++raXGoH7t3iQt/cOkcSL9BsZG15I4
         milK8dLlYbpjXlFt0Bjxus49nvLCb6sCdYymcaPnvlmyB66Z920kCskkjbCxQeMb1T0w
         NaUXFE2F1joO3WFHVx5gfB+50kKM81Fe7tmroiUqrgewhANeIB9Bc0dWAiZkn6oQvHTS
         e12A==
X-Gm-Message-State: AFuF++lMLcw60DBNgZn5Q3gy/Hj7OfH9P65JnijQgPAj0xzK7QNXYLTu
	TyzoLWd1PNTXwv+7qKuW41Z4vKrjMrUuJSSC0OEyqWaAZE9EcqZPoPJAqF4LpMh8
X-Gm-Gg: AR+sD13wmFv1e/1FVx0k+5OX5zl0mDQ9nfu6ZwK7YD0B4RpjUx2Gzn1spD29LKD6ZXO
	kcsituwgQIkpQEJK4ajsDoZlGfbYLQ72q6pz5VJvhcl5kGi8XfNbdn7VB0FVL9rvc1xPiDQP1QU
	L25q2FRsTgxUjle1ZSA46y91d4LjoBhUlccj8OurKMvUxIQKvX/jzuFrbkp22oELUvJr22DTuOd
	gVqi7rETi56XmMm4KSPS/gylpkEhTi/G+Q1RzZZjAfeU7qK9fp5/6OqiqoMzIMe1g03sZRHpo3X
	noOlcrWkCMH9P9my8zVVbI8kS7ftuvBx7H+eL5x1uEsDr045xUVFi3gBb0Q5bgHyJyOVaLGar0X
	2UumYFE1lyMmnxCDOegfZyN/aD1TNmNFZmLDXTkcTnFObV5WCGDTjMkbFTaOFtrxb7w64LC4ogz
	jKhpkjsC7i92IeFMNgdR2XD6skidxFCCVlT482UOhrlh1CsGeoKCj+G/TsBKU2uCDNoZxos8V6/
	/eTiaXlYtUQYra8PQC182yQOx/WSwOb8couJyOetiKcavtBs5+yCBdzq4Eua656+rZNZqcGLyrw
	6ZSSttA=
X-Received: by 2002:a17:907:3c90:b0:c25:58e:83ff with SMTP id a640c23a62f3a-c250bb126d0mr1040341966b.10.1787761585119;
        Wed, 26 Aug 2026 09:26:25 -0700 (PDT)
Received: from omarchy ([85.105.43.40])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c250a9ec343sm420526666b.57.2026.08.26.09.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 09:25:58 -0700 (PDT)
From: Abdurrahman Karadag <abdurrahmankaradag19@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: pkshih@realtek.com
Subject: [BUG] rtw88 8821ce: connection wedges (100% loss until reboot) with station power save
Date: Wed, 26 Aug 2026 19:25:14 +0300
Message-ID: <20260826162514.80580-1-abdurrahmankaradag19@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hardware:
  RTL8821CE [10ec:c821], subsystem AzureWave [1a3b:304a]
  PCIe root port Intel [8086:51be] (00:1c.6)
  ASUS Vivobook X1504ZA, firmware rtw8821c_fw.bin 24.11.0
  (feature word 0x7: SIG|LPS_C2H|LCLK, no TX_WAKE)
  Arch Linux, kernel 7.1.9 (also seen on 7.0.12).
  The same laptop had none of this under Windows.

Symptom:
  At some unpredictable point the connection wedges: traffic goes to 100%
  packet loss and STAYS there until a reboot. The interface still shows as
  associated (iwd/networkd report it connected, DHCP lease held), but nothing
  passes - gateway ARP goes INCOMPLETE and stays that way. It does not
  gradually degrade or self-heal; it is a hard stop that only a reboot clears.
  It tends to hit soon after boot / when joining a network rather than on a
  connection that has already been up for a long time.

  The one reliable workaround is disabling station power save:
      iw dev wlan0 set power_save off
  With power save off I have not hit the wedge; with it on it recurs. This is
  the strongest signal I have that the station-PS path is involved.

What I ruled out (each tested on this machine):
  - rtw88_pci disable_aspm=y      : no effect (the module param only gates the
                                    device DBI 0x719 bit; it does not call
                                    pci_disable_link_state, so host ASPM
                                    L1/L1ss stay on - link/l1* remain 1)
  - rtw88_core disable_lps_deep=y : no effect (firmware deep-PS off)
  - full cold power-off boot      : no effect
  - suspend/resume                : NOT the trigger - connectivity recovers
                                    fine after resume in my tests
  - The correctable PCIe "Physical Layer / RxErr" this card logs is DECOUPLED
    from the failure: I measured the link working perfectly both while RxErr is
    being logged and while it is absent. RxErr is not the cause.

Reproduction (honest):
  I could not reproduce the wedge deterministically. Controlled tests all
  passed on the stock driver: steady-state idle (minutes), long idle with an
  off-device pinger sending to the sleeping STA, and disconnect/reconnect
  loops. So it is intermittent and tied to station PS being active, but I have
  not found the exact trigger - which is why the reliable handle is
  "power_save off makes it stop".

Questions:
  - Is a hard wedge (RX/TX stops until reboot) with station power save a known
    failure mode on 8821ce? Does the driver have any watchdog/recovery for a
    firmware or RX-DMA stall on this chip, or does it rely on the firmware?
  - rtw_enter_lps_core() (ps.c) programs the same PS config for every chip
    (rlbm=1, smart_ps=2, awake_interval=1) with no chip-specific override.
    Given fw feature word 0x7 (no TX_WAKE) on 8821ce, could smart-PS mode 2
    be the problem, and would legacy PS-Poll (smart_ps=0) for
    RTW_CHIP_TYPE_8821C be worth trying?

  I am happy to test any patch and report back with Tested-by, and to capture
  logs, iw/AER dumps, rtw88 debugfs, or a PS/wake trace when it wedges.

Thanks.
