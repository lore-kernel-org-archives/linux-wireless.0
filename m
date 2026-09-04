Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AB28525A84
	for <linux-wireless@vger.kernel.org>; Fri,  4 Sep 2026 19:03:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788548628; cv=none; b=QIyep0m38gDX6VRqIiiEyepWH9xFyVwyW/dUZstBYa9Df6nO096XRYZs3BJgEp28qlsXDpiZZEOjKNyTBRWuR/zP/PZx+gcbTBjAGVIufrBdnUiDIBIJ/eGn+HoApt5vi4SwfWEtqImtChCdKEsTVLPY9GBD5J0LpUTsUjVfnLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788548628; c=relaxed/simple;
	bh=A9m0mh8f8IjC95C1zkUbGFWy89TvGySuHobeN9QBoX0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=gaWmAr3HFYhNxofK25aaqcRg1eM0uvMw9xlvVRzsDJi1XG3CojOGCBbLS2YJqK4hjICc4Yk/bcK2AvB13O7QF+yqrUXwxPJcFrAXJ3M8LsGDyOm5edz/6bKArzrDIklH+3zYMLyr5GEhnsI8cP2SJd87exetuyJR06Und8kvQe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XM+tpk/l; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XM+tpk/l"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-498028b3d5eso12782585e9.1
        for <linux-wireless@vger.kernel.org>; Fri, 04 Sep 2026 12:03:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788548617; x=1789153417; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=sRadvJkA6sgMBOr6kXGejRWQtN1yeGZ40ycoOtIUIEg=;
        b=XM+tpk/lRu2df499Giyb1E5V78kZ4IZQr8hT0+ror06fT881fL0E6Oo0hFsT67ftuG
         FQhkM3ae6Ogk2RD5LWtCd1LHJdtd7snXpGDhCghetyVGWu5BW44jztsCBVEm7PbRfa3e
         iUWxPq3o/I4kMilCXU1OZx/GxfYumeVSaIZ/u7LhLfFKYtDKhxGHUhMovo4yJ8wGLYRA
         aYrnS++jlSdz2ZvglMCQ0+iZlhp4vK+SchayAYzdCHvplRsI0Iw2hnYj5O3Sybuxlp2C
         e1vwEfL7x0m6oaWMTv4XqKXJZSZDZ8UIQHSJlGRr9F9LR0/w2Q/JRFcgYeSwBO17+TwX
         la5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788548617; x=1789153417;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=sRadvJkA6sgMBOr6kXGejRWQtN1yeGZ40ycoOtIUIEg=;
        b=dkuy9bre8TuzGcM9fbu+XCYq+WXg83MkVxPEEVf42g+kj1v+6LCqKKGZb5GFOA1sg1
         4pomhHGqeIc6U7VOt6uZxv/5ovdS3rqlbicnDF124IiqCCDhC58iQKXWFm8kEXQXYU/D
         aSKyvv6zcgvNcNkfp9jMF4WIxrW2rhbXvss4z3hwY6X7n+/R8tMFgbsm31cB2KavCZlm
         iul1K4aq4y2mdEjM318vZCpQrCz/Z2qSb5ILbaRsOI1ragXCNoq2HqQcSPfEDrI+ztQL
         q1N5yXe2LODA0fLI+IlNQc/QB5/BazMuYBYzOJ25I1TOhwlUINmD8tgBB9ftNEF2Tbpk
         4zRA==
X-Forwarded-Encrypted: i=1; AKwUvBzjTiM6hEugpppmJ9rdoIZ2fZZJdthKYOWCw7P69MhUVI2Zzo68aswOKqD/sRof1ZcAja7KoMagv194rlV5Jg==@vger.kernel.org
X-Gm-Message-State: AFuF++khmdzOKiDfDFW0R/T+Vl7Oe3bZSCdVG4zpHeH6sGxIofXTHqzw
	8gE2NrZ7VrRekU+XdllAzaCUW9YZlBjQYvftecNcf2yssTBPugK2jaA=
X-Gm-Gg: AYBFou1hyXeQYKCsY6J84FphjinjiNP1SlTiNxLK0dYgnpLcmpj6yt3GKyWftxvpEHs
	LIQfolqoNzq+zPfHse0nbYT/bzBtlNqaeQOjdiTxGS64AWnD7GX+pWHBeDfqOv9YuVKxNmGH5cz
	CITJ5hBPzWlJ6GunDWpDgcfAhk+YqthR/+7Svxe0jiyX5vKFmqkUS4Rn1A0pTJoIRqLy1oNVYeQ
	s9auWOYwGvyYcIzOECH2Atpz379zr7m/dIrimo9cSMPOL47WJju5yPQJQhKBcIIxm+8DlVe5fdV
	hHulDdCZuvcBJP5nWpnpF60G3M/2wfNb7dj5o60/fox174iloXnTSHo5WQBFTH/vajnyNPSXMI5
	B5s3qLpSAr+i4CN2s1EOZOtmV6qSdoYYadNs5XM7QnG1dkmg3dKEF3jTb0rK2z3hzs9D/5yGpE+
	zapn14ueswOnSCmNV1nZdKBGwMNSvuaKBuvs3TQdNimxoQF9ToqbwE2FgFGD0YlIgAhCmuezcFk
	K3CoOzzMNwTSpIPRtLCqa84k8ndr0XD/E5iYIAvrdiTVK5hxHjdmMX/ZgczW1HpE63wyOFw1yID
	UyAJ
X-Received: by 2002:a05:600c:8b05:b0:49c:edd2:855 with SMTP id 5b1f17b1804b1-49cf823c411mr86248715e9.6.1788548617299;
        Fri, 04 Sep 2026 12:03:37 -0700 (PDT)
Received: from nn ([2001:1ab8:1003:0:5454:f357:ba89:4e22])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cf7710aa5sm89643535e9.7.2026.09.04.12.03.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2026 12:03:36 -0700 (PDT)
Sender: N B <gen.benner@gmail.com>
From: =?UTF-8?q?Nerijus=20Bend=C5=BEi=C5=ABnas?= <nerijus.bendziunas@gmail.com>
To: =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] wifi: ath9k_htc: cope with lost WMI reads
Date: Fri,  4 Sep 2026 22:03:30 +0300
Message-ID: <20260904190332.815525-1-nerijus.bendziunas@gmail.com>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On the USB devices every register read is a WMI round trip that can
time out, and ath9k_regread() reports a timeout as -1, the same as an
all-ones register. Two patches already on the list handle the reads
that caused the most damage: the spectral trigger no longer reads the
filter back [1], and a failed multi-read returns all ones [2].

Patch 1 stops ath9k_htc_calcrxfilter() reading AR_RX_FILTER and
AR_PHY_ERR back to find out whether a spectral scan set the PHY error
bits, and sets them from spec_priv instead. Patch 2 counts WMI commands
issued and timed out in a new debugfs file, so a timeout can be seen on
a kernel without debug output.

[1] https://lore.kernel.org/linux-wireless/20260904181709.788886-1-nerijus.bendziunas@gmail.com/
[2] https://lore.kernel.org/linux-wireless/20260904185253.809209-2-nerijus.bendziunas@gmail.com/

Changes in v2:
- Drop the length-drop counter patch from the series; it is sent on
  its own, it has nothing to do with WMI reads.
- Patch 2: the counter is named "Issued", it counts commands that were
  handed to the device.
- Add Assisted-by, rewrite the commit messages, rebase onto ath-next.

Nerijus Bendžiūnas (2):
  wifi: ath9k_htc: derive the PHY error filter bits from software state
  wifi: ath9k_htc: count WMI commands and timeouts in debugfs

 .../net/wireless/ath/ath9k/htc_drv_debug.c    | 25 +++++++++++++++++++
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c | 12 ++++-----
 drivers/net/wireless/ath/ath9k/wmi.c          |  2 ++
 drivers/net/wireless/ath/ath9k/wmi.h          |  2 ++
 4 files changed, 34 insertions(+), 7 deletions(-)


base-commit: 1d8e73163ef933624341075f576e2f36ef9133f7
-- 
2.55.0

