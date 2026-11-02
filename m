Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.179
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793630249;
	b=26zWzFdXXKGIdE6HN8hUHH3Pvn8kAWn+OvoQTrycz/ACCIPP/j/+Ofvd/qBe4rcOsmut
	 hCjLQ4VL75om1y2AyFZx52TRKcwoxsCBJoLvpQTGaDEJktFj+aP9jmq8BPu5FG3z+aUIU
	 w1v5JIFBYsOSmDA0Lbb7IN6U9vS7jQ5ly6PI5yzCpLqwt3NUCMlxGswikFu1eAQB6cB2W
	 AvGm7uSaLl/sjbqPWjtkDmpOsFdT5gtptRpfMi5c6jqITqYSAL4eMeEm93SN6vC4yE2MR
	 jfwSzjLTN6hqdjecjCXL2XY3W5N3R71icE1LyTbBDZbzyVJThM6Rqv112QrX7wYQl1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793630249;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=w0m7B6qxePknJP+pcWTG3AkgD5pRq3pC5fs9XEyNxNE=;
	b=BdFdsbWoxH3OGpdGdTSpatF/KdP6/hbd5PeCglkJp5miMCtYZqELfX1Y/Ev8BGjxFQtC
	 AQGrVW8djYwGNhEg7uiS4yLkIGs8QN/lVVJ3Jnbg9p6tahppN5yLFl/FrprI9hQx0wx/P
	 x1GQ1xp4HKUlFp2y1NKVts0U0ok2f9dKi3G4948S7tqwZGkSWymuZCM9CWFWDbBkpXgjs
	 jE7H8Ifo1zVWhMZw1sbTb92wtzsv30TfKYSeMEb+Xo/ivdYYk60y3bWbwNCGvYOu4oFXZ
	 gAcR8jOokQH0pXloH9OstdwFUMWhwFsdQwcerH7RznH0oElN2AUi6K26oPF9ERShPvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nSk4BSud;
	arc=none smtp.remote-ip=74.125.82.179
Received: from mail-dy1-f179.google.com (mail-dy1-f179.google.com [74.125.82.179])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C7A606A336
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 14:37:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 36C7A606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=nSk4BSud
Received: by mail-dy1-f179.google.com with SMTP id 5a478bee46e88-3550c917fd3so4233976eec.0
        for <linux-wireless@vger.kernel.org>; Mon, 02 Nov 2026 06:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793630248; x=1794235048; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=w0m7B6qxePknJP+pcWTG3AkgD5pRq3pC5fs9XEyNxNE=;
        b=nSk4BSudI2H8XwKrIQyVADJPRNIROK+K+FtPVZzeMqocnmN7Ycy1dCOdccff+4vbzS
         r+fPA3dAqUD6Yjyh0R+IWedzC8zR1AJdUJN7d/hPBLWlZBQkTMiASEsx581Ura62Cmq/
         1LBDiIoxP/dJLtQF2QBal5iPAGlPw9xH1ALlahuI0+O60OQtKRjtHAYayFRCeUuh+ySv
         eHb/1FQwEL/uEIkK+04l1JGrL5SYFzqLiHnhaRj3EeuKONJyZmKgafCRZLDi85qNfQaQ
         AtoBYi2CDcwPECFcPly21Sfe20OCDxLFwFSZvqls3ZdxfECGFuVu0y4OlCS8Qu92tPQU
         Q8xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793630248; x=1794235048;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=w0m7B6qxePknJP+pcWTG3AkgD5pRq3pC5fs9XEyNxNE=;
        b=QTkALTK4F65VqXnzrVzrKtnh6tX95kHrykTiNV/kce1HEQSjulqvsCZFA/RDQUEQgg
         6d/6ocZg0reQUD3gj9lCcMwtlRSl0kfh3VVbfE1KbA4hToc3pVTrBsbz/FL853o0gzKL
         B1s9OrLi6PHtws40h8NU7CJOAwXbn5DHLDsYz4xQ7klS3qIPi7BYath+R2a3KfMHSeDb
         X+13fcdTalsy1TDjFO5P/VsPwKNYIVRLl4QSjuSPwGwDrQm9sfn84zW70ETAuC/7tDzs
         VpIMOKFphrjL0SPeTNDYJrzWj05LFQZ8XF5Ytz6JbYd2DOcarPXx9Oc85NyMlqxA3Sxj
         uOSQ==
X-Gm-Message-State: APuU4Z/PYvdX6aMJX2LdzYry1ZFiZFaKM4CHsmptY9XLSvWMhij3m1y8
	hq/rug49KtrGtUM4qfgGmLJQp8gbRPblexE+erGgf/1/9g6u/JQDdwWC
X-Gm-Gg: AYBFou36rgg+2GTh18dH2LeU6u9T25i3WytbNrMKDOYXIF6uw12tpe4MmaM/bEpq4K7
	urkLYuFtt2zZ+BN4JOvtJXSXcXN+ndmCzd4kVEp0TdpK3u2IZZXLiVl0cAR2VLzRIelBvmdpXm5
	55mlOBQxJw6Ehm3RMbtmz8FDUytJ29zMLL5U6cCX535qHTaMChU7e02Vfkk87YXamN3kHos+VF9
	7MJbxoUwDcIkf3R+k3ySnR7Pdiho2McYY+PUl+ZfEfAYRiiiH66V6xIenGDycEbSRKwuhWO7oj+
	oeqBgMD3tze/b8JcTn7vMp4qsB+UyV8sZhbq7TPgjQJ5WbYdH8etdDNxhYKxSzQc9DDiZLuMhS0
	vSmA4zFB3O+PTpn/vfP5OaYiLddKOt1MnKFUx6PXub6NHGcL6rztCvwlH3aA1DWCeamNZ8TT9ek
	m6EX0GN4jUAzzWW1kRaxZ/id/ix3IoValrIiZK17mtYgR/SqjE+pRGRyBAu8gjaBuFBPE5qvZtj
	r1JKme42Zshh5jdV77RbzZI3/qPUFEfaryBadT2Anu+i4aJsDgk+iLh5MUjSV+G3UtrUjG2oKmg
	CGQmGwX3ubZrt0Z/2YitRCuKwZVAN1i1Gd2RqaltgXTOv9//+EdVXJnd8A==
X-Received: by 2002:a05:7300:cd90:b0:34b:4b99:24ab with SMTP id 5a478bee46e88-36a42454b8emr23775126eec.22.1793630248138;
        Mon, 02 Nov 2026 06:37:28 -0800 (PST)
Received: from xploitoverload ([2406:b400:f11:1bac:4040:640b:8a1:8629])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42952e1csm40546368eec.20.2026.11.02.06.37.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 06:37:27 -0800 (PST)
From: Kalpesh Solanki <skalpesh942@gmail.com>
To: pkshih@realtek.com,
	kvalo@kernel.org
Cc: linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Kalpesh Solanki <skalpesh942@gmail.com>
Subject: Re: [PATCH 2/2] wifi: rtw88: ps: Trigger firmware recovery when failing to leave LPS state
Date: Mon,  2 Nov 2026 20:07:02 +0530
Message-ID: <20261102143702.24902-1-skalpesh942@gmail.com>
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

Hi Ping-Ke,

Thank you for reviewing the series and for the Ack on patch 1/2!

Please find my responses inline below:

> After patch 1/2, does it still happen?

No, after patch 1/2 is applied (with PCIe ASPM and deep LPS disabled via the
DMI quirk for HP Laptop 15s-fr5xxx), this issue no longer occurs during
normal operation. 

The stall was observed before patch 1/2 (when deep LPS and ASPM were enabled),
where the firmware became unresponsive upon attempting to wake up. Patch 2/2
was therefore conceived as a general safeguard/watchdog for rtw88 in case the
firmware fails to exit LPS on any device (either unquirked hardware or due to
unexpected power-management glitches).

> Is it helpful if you enlarge timeout time of __rtw_fw_leave_lps_check_c2h()
> or __rtw_fw_leave_lps_check_reg()?

In our testing, enlarging the timeout did not help. When this failure occurs,
the on-chip microcontroller / PCIe link is completely deadlocked. It does not
clear the register or complete the C2H handshake even with extended wait
times. Subsequent H2C commands continuously fail with "failed to send h2c
command" because the firmware has locked up rather than simply being slow to
respond.

> or retry 3 times to leave PS with below three steps?
> 
>     rtw_fw_leave_lps_check_prepare(rtwdev);
>     rtw_fw_set_pwr_mode(rtwdev);
>     rtw_fw_leave_lps_check(rtwdev);

Because the microcontroller is locked up, resending H2C commands via
rtw_fw_set_pwr_mode() also fails to get processed by the firmware.

However, retrying 2-3 times could be beneficial as a first-line remedy for
transient timing glitches on other hardware before resorting to recovery.
If you think that is a better approach, I can update patch 2/2 to retry 3 times
first and only trigger rtw_fw_recovery() if all 3 attempts fail.

> Call rtw_fw_recovery() when rtw_fw_leave_lps_check() fails so the driver
> can automatically reset the hardware and re-sync without requiring manual
> user intervention.
> 
> Is this a real case? I'd just want to confirm this is real case it can help.

Yes, this was a reproducible real-world case observed on this RTL8822CE
platform.

Prior to calling rtw_fw_recovery(), once rtw_fw_leave_lps_check() failed, the
driver only cleared REG_TCR and logged the warning. The hardware remained in
an unresponsive state with 100% packet loss (traffic hung indefinitely while
NetworkManager still reported "Connected"), requiring manual user intervention
(cycling the interface down and up) to restore connectivity.

Calling rtw_fw_recovery() triggered the recovery workqueue and
ieee80211_restart_hw(), successfully resetting the hardware and reloading
firmware state, which automatically restored network connectivity without
requiring the user to restart the interface.

> failed to apply, because rebase to rtw-next.
>
> https://github.com/pkshih/rtw.git

Understood. I pulled your 'rtw-next' branch and saw the conflict in ps.c
(rtw-next uses rtw_warn() rather than rtw_warn_once()). I have rebased both
patches onto pkshih/rtw-next, and both apply cleanly now.

Please let me know if you would like me to submit a v2 patch series rebased on
rtw-next (either with the 3-retry fallback or with rtw_fw_recovery() directly),
or if you prefer to proceed with patch 1/2 alone.

Thanks,
Kalpesh
