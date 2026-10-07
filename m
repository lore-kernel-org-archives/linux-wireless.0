Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D552F616A
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 06:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791353478; cv=none; b=NhbWhpQ+dqtAvWR/CHALLqE48hnexleDpok/4eMkOevRxQWAPOo60cKJgrURibV9PBaFlag957kjRjCjCkjbuDhbj0YFImXFe56aGV7AqmlrTox3dkkiW/tVJhiwZpvCuY572VumDSMNYBa9llMIrdM6linued0cwMLfSfdhqL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791353478; c=relaxed/simple;
	bh=RQ9w9H5mWAmGFvTpnXEFj+HVjb8RInsVAMSCAhAd4fw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=nuZSlP/JwCwUDQIVemlejeGIwti88s2clFvkonqYwrNAa0Tay4PBKIaCFau5Hq4rEOCwd8uu0jyrdZepKS7zGJIZBdIxZCyEOqfue/yP+4qqNbbQSwAieLUFUPTJdPD+w7/8g9dVr/WwK8AV1/s5pdJ2IavaFjtLdO9wAPUWZRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c06zlvMg; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c06zlvMg"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4a17f65ab8bso2203355e9.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 23:11:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791353475; x=1791958275; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=91navFBvh8WHQCdL07R9IxmQivqiPLa9aAiph3O8Ll8=;
        b=c06zlvMg6+IWk6c83ie1pp9KHpSwpSmyw9DH2MZ1otL3NACFFpjbigG/YHnFdhxdRz
         VldR+VU+9sRCFT8HJNMZgzIm3ky+Go8/FjTp/9xJggo4FO+5O+DQ7/VO9deBqS79L1bk
         TKaQGbuo3Ir7YpqsPasKqXc+N0xVOYkg7HGblSiusdTXOQMgWaNbheW/OQH7S4/QvLBc
         E/WvPYcwSAHUeOWTiYbSjLuFFnxcIdFV2w513LcNJmiSBiZmz2njlxIA9g9ceP3a0GsK
         G9Rm0tFNKSIA1IPNbX2vGlLT/CqwNzhJS8syv1qQ8WLaiu1WQ565/8mDpL/u/kCVuiXL
         uPGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791353475; x=1791958275;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=91navFBvh8WHQCdL07R9IxmQivqiPLa9aAiph3O8Ll8=;
        b=seWGky4LaIFnRfVPV6rDZljGhf18sOYy4rgzIPy5PuNqYLiJPjWu/vAtunowpzvHAF
         ekGFLSSSaKZlQvNE8lt5dWtQ+ZxtbCcqVWLoVQiGsfJD2IMoZGHD78LxgDt0+F8DXk4v
         cjwos0XeTBFE+jMYo9lTlYEWDdIKAlIVtALJpYVkc0FRzGAH7USkZKM5RO7finDNOz6I
         EcKFP+sjKzf5ZSlY16ltHpXbE2BTS770w0HLQvwMxZo/K4N2IS6QQ6KipJ+pv3MCUvMK
         nfpQzR3Pvvh2RTRX/71SRw+Ob7ZblmQSh6uQSx4I72mmHg/9+BQI2++cwmu4ncgZVi+A
         KrNg==
X-Forwarded-Encrypted: i=1; AKwUvBxctMASqAzwF7FKYRy9Dh9vRI1JuwqqnNX5XJStoZpEX3ZRPwV2mSc38uvD6dfDYN0N2dM7FEoA3gGxeE6pcg==@vger.kernel.org
X-Gm-Message-State: AFuF++l9X0BiznlsxmXNgZe4fvne+zJN5KHcxqdaaWWgmcXW64Yz0STV
	0SQn44s6xTXxBmtQSc1yJaiPZ5KlabWt+H4v7Hr21J5nASPWjkB6WQmB
X-Gm-Gg: AYBFou0o3J/EoUJ6oofXWkT+f/xAzAE5OydiMMrkC+ecvXNKQC40iEpGRVEtnjVSzJt
	T5CRit+HTgg3rnK9ZhD6LES2/QHQGs0QjoXTS61Fafs4cCTYEGxPhmADizzfo7J5NQsqSVwRZoc
	FUvjD/fPLU8o6r0R4xjIg2jR7XFB5JDib4msKxJb2C0IdleAROEYgyqhEIUSYMQ5tjq1LPhgtoz
	k9+p0e9q9hJA4Rv1pPTIU91UvuM29WWtJ7raCzaVYz8PzdYQvgufaqfi6dwlM9MRGRZUc/my40+
	0kpKjMOslxXcjvUc5Kge3v0RZRiqGo/MzBtQ2x/0AToGh0ooOL+jeTDBojo1DBhwA8iaYpqC2sC
	23S9HV3HxjZ2ziZQz11/iRqvrBnWtTPSPzPT+F8s9O1bJ9QHbb58Jm3MUPGKShzf0hcMTpXXtav
	E4+0GHmHOyOuoW8kr/BjO4X1YrSbIrSSm0SQoMOskQouBGsKXVqYKD7nvnVVNcZpvKilqCORitY
	3Lc
X-Received: by 2002:a05:600c:4687:b0:4a1:7811:6cc4 with SMTP id 5b1f17b1804b1-4a180650943mr16927825e9.34.1791353474904;
        Tue, 06 Oct 2026 23:11:14 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a17fce07a3sm18949995e9.1.2026.10.06.23.11.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 23:11:14 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: [PATCH rtw-next v4 0/2] wifi: rtw88: channel switch in AP mode
Date: Wed,  7 Oct 2026 08:11:11 +0200
Message-ID: <20261007061113.2083449-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Mehmet Fide <mehmet.fide@screeningeagle.com>

An rtw88 AP cannot change its channel: the driver does not announce
channel switch support, so hostapd's CHAN_SWITCH is refused and the
only way is to tear the AP down. The series fixes the beacon download
the reserved page build makes twice, then implements
channel_switch_beacon on top of the firmware's beacon page.

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
- tested on an RTL8821CU and an RTL8822CU as AP (counts 1 to 5,
  switches aborted and restarted, 50 switches with a station attached)
  and as IBSS

v3:
- 1/2: the beacon out-pointer is initialised in the caller (Luka)
- 2/2: the countdown work lives in the interface, remove_interface
  cancels it unconditionally, the queue wrapper and the comments are
  gone (Ping-Ke)
- 2/2: the TIM update and the PG backup on set_key skip the page
  download while a switch is announced; every beacon fetch advances
  the countdown (Luka)
- 2/2: the commit message names the refused hardware scan (Ping-Ke)
- the hardware scan path ran on an RTL8822CU, whose firmware has scan
  offload: a scan with the AP up keeps the beacon and the station, a
  scan during a countdown is refused

v2:
- 2/2: a hardware scan is refused while a switch is announced
- the rtw89 mention is gone from the cover

Mehmet Fide (2):
  wifi: rtw88: download the beacon the reserved page was built with
  wifi: rtw88: support channel switch in AP mode

 drivers/net/wireless/realtek/rtw88/fw.c       | 96 ++++++++++++++++---
 drivers/net/wireless/realtek/rtw88/fw.h       |  4 +
 drivers/net/wireless/realtek/rtw88/mac80211.c | 47 +++++++--
 drivers/net/wireless/realtek/rtw88/main.c     |  9 +-
 drivers/net/wireless/realtek/rtw88/main.h     |  2 +
 5 files changed, 136 insertions(+), 22 deletions(-)

-- 
2.55.0

