Received: from mail-lr2-f12.google.com (mail-lr2-f12.google.com [74.125.230.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98DC5265623
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 08:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.230.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789546931; cv=none; b=LXZzlG6mAMylWpmJZvAM2QGrYS8pnrsUpCmSLwfAxijwn1NBPMJODbfRFwBICSYigZ+CEHCC5gy54EEiA0KajG0mHv699XEA05yaC05KHKPOY7IYpjUYXaSD3BU4woT5iNkjeVufDyNetkgfnC5OSHE4hTM+S29SZWedB9QTuAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789546931; c=relaxed/simple;
	bh=SCOCbvNrWnbN1Yu1T17TfLV2d7QBtjYHAj2t6DmsxzA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aJvnseTgIzSgJBgOxKowDQ0hvtLjvemJIpXRwQLzo6mgGcTnrQQlVH5yoyDPNJh8iqbmF8dRjksABsFF/RVsG9SiE30AHS0anKyBzIrCSgoTXGEWVKt0tivJQSFAaFXDxzeKnXOjgP+hrOZHyd74fsSPrMHavHK+cEFmqQX5o6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YKbOJaa9; arc=none smtp.client-ip=74.125.230.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YKbOJaa9"
Received: by mail-lr2-f12.google.com with SMTP id 38308e7fff4ca-3a5919af2eeso4932901fa.3
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 01:21:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789546914; x=1790151714; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=S1bPcOfCr9q3oqfiBwdzS97TJhehFi6OIxwiT+uhuBc=;
        b=YKbOJaa93VL89VoXuP6BRYL0W8c3A6gq4dF6tn43QpE7J4ZiHPXlJESuPx4o2zStzU
         u//CwRcWKW73lFbiWNAREFcEfB/L36mQtcDyXNivSgqzzpgl65jv2vrSzpAt+LPgtUVV
         oXjq66Dveo4MW8MrCOboJZqbq1Su8kzQE01S8MOySr0Jc9yVHd1xzvYa8ROfSM72G5oR
         fUIvxX5Fwtw1vMCHzTyhyDMaPPG1/4C1ncjwO0PC1ENsqATR7XpSKx+CKYpthHXI6Ns3
         ScVpcWd5zwJlM/OJAbAzWHHR39XZ+HUAQpXjEcmIeKyalhX8KCqb1yWsPlvEq4AN/6gx
         +5Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789546914; x=1790151714;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=S1bPcOfCr9q3oqfiBwdzS97TJhehFi6OIxwiT+uhuBc=;
        b=wLvrzl4ZBH8VASBKXECNE3/P2/Q+kJgE2CGK68YD17RyoZ9fEi9KhkNXrYhKcPir/p
         rsK6PSUi5xVYETM88e2GutAhYeGhfwGIzqy8uMIT0CeRZViUX1oCG2/bJ0S31sHD/IUU
         rd87NEwUSJp3O8IQOEzcpKAhUb89Ehpsi6DkdSkltEjuun26YWczuANalqArCKFNfy8+
         JOM2zdnUVseykwMi9/ij3Ta8fqPKLxm8LS34Lx9gijlkq2r4OrghYUzWY8qOsI1zsdAW
         uxqOKjKBr4bwrUIUIYXPOamAykN9yIZo9gvJqf0DSL9w8wBAEtN6UqvcwTEPL4+hh2Hz
         x18w==
X-Forwarded-Encrypted: i=1; AKwUvByVYpxIhBcZHXLYU6g6O0XhmphQKDXgTxdGHGBbfw7g/+cNNeIvuImtyqwiXCM8IqTqQw55vXELiXbIq4112w==@vger.kernel.org
X-Gm-Message-State: AFuF++k6cCJq93TEtBEo8c/L/0T3lnyBXHKOSVPTmn6AD1bvLfBw/ZgD
	Rko+t4egiaDc5Enk2FWnitwzrbrqUUA27RSdMgeEKjT8IPl0rIzJ3NJx
X-Gm-Gg: AYBFou2RTfbu4raartXp2s9XVZmfhKbNprEWA1Fycq4QaK++/j6OhZ+YVInmsfl0MP4
	tobNkNXxvqiRPSrjbpaQwT30Dph81Yvoz8ekS93nU1OUI1HomBXuBzdQRtMRne/6p8LQveSKjqD
	VT/Jvafo3lupU9uMiXDFYIu0uqmWlyfnh+8NjkRXTDwGEouKpNe1GBWjv7XyOudycqMbs0Hd9fA
	2xNI5QqTfICrTXuemZ2/Tkl2w99FCyFjV6h8TdlmDW167B8BuXPqbDfFVAjqM8eEQxA5e+TpF2f
	ulQdtepPojaRYTDk0IMV/q+ZAaQa8CDZahxJ8thRNm1yHUO0E5b22afFHo4xxPcdihW3oIQejg+
	+mhV6sMGa0jVw1TMEE7ZoIkSm4ZPtrnPKhn25yeKPfHW/yhVH8ZvQ54b+IOqQSIUhJkwBmLhhzX
	aHZK8hgkMEGU7a7Ektt/I66WYr9fMZfJuWsBNe9KCJMZHKfIvPWg2YuSwfpH9A4JN4eDZMkillt
	j14Yfsmt+aO900F
X-Received: by 2002:a05:651c:1508:b0:3a3:1eba:a892 with SMTP id 38308e7fff4ca-3a5dc99f535mr3127741fa.11.1789546914096;
        Wed, 16 Sep 2026 01:21:54 -0700 (PDT)
Received: from localhost.localdomain ([80.66.93.83])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a5dafa9510sm4100771fa.24.2026.09.16.01.21.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Sep 2026 01:21:53 -0700 (PDT)
From: Maxim Skokov <skokovmaksimevg@gmail.com>
To: pkshih@realtek.com
Cc: gary.chang@realtek.com,
	linux-wireless@vger.kernel.org,
	Maxim Skokov <skokovmaksimevg@gmail.com>
Subject: Re: [PATCH rtw-next] wifi: rtw89: 8851b: avoid using CPUIO feature with old firmware
Date: Wed, 16 Sep 2026 11:21:35 +0300
Message-ID: <20260916082135.8854-1-skokovmaksimevg@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260916074000.65960-1-pkshih@realtek.com>
References: <20260916074000.65960-1-pkshih@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

RTL8851BE, WL_FW 0.29.41.5, so the new entry applies. Applied on 7.3.0-rc1
and rebuilt the rtw89 modules only, one suspend/resume cycle per run with
WoWLAN armed for magic-packet and disconnect.

Without the patch:

  [ 1582.387887] PM: suspend entry (deep)
  [ 1586.067431] rtw89_8851be 0000:02:00.0: c2h reg timeout
  [ 1589.406222] rtw89_8851be 0000:02:00.0: c2h reg timeout
  [ 1592.742446] rtw89_8851be 0000:02:00.0: c2h reg timeout
  [ 1594.422876] rtw89_8851be 0000:02:00.0: Unknown wakeup reason 0
  [ 1597.737909] rtw89_8851be 0000:02:00.0: c2h reg timeout
  [ 1601.043919] rtw89_8851be 0000:02:00.0: c2h reg timeout
  [ 1604.353105] rtw89_8851be 0000:02:00.0: c2h reg timeout
  [ 1604.538816] Restarting tasks: Starting

With it:

  [ 1635.641438] PM: suspend entry (deep)
  [ 1637.703234] rtw89_8851be 0000:02:00.0: Unknown wakeup reason 0
  [ 1638.871251] Restarting tasks: Starting

Six timeouts gone, and the cycle spends 3.2 s instead of 22.2 s between
suspend entry and task restart.

"Unknown wakeup reason 0" is still there in both runs. That is a separate
matter and not what this patch is about, so I mention it only so the tag
is not read as covering it.

Tested-by: Maxim Skokov <skokovmaksimevg@gmail.com>
