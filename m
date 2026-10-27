Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=212.77.101.12
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793118975;
	b=BgRASflNWgmTJfaNe75P5skcpP2PCrPL4zKZs4lM3oXMDrs+2jbPMJZqRcRXfbDV/xCM
	 tpflfDOfIGDtdYhjWEFJJB6yxjWVAnfYGnqiYRNPSLqjrcz2QD/7tHKx/CKCIEFgOTptW
	 wy7g7oiR2yIfZMv+u0ll7YWnkKZtz2MV6MAmmzCJ5XsBkhd2iyI+Rc6XHqwk6mLhspcWG
	 CeHpPGN3ZHYK0rsptT8ZNdAfl6jihIsPEQmaSbILVrkGGRfvKGfF+4rxZ6sMgYeFVcodE
	 VZFcOaNmzuHHwy5LMTj/f1HiaHKB1dr/J25taJvLzwI3Qao9uDHyoo6nNmGo0aTS4Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793118975;
	h=DMARC-Filter:Received:DKIM-Signature:Received:From:To:Subject:Date:
	 Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding:
	 X-WP-MailID:X-WP-AV:X-WP-SPAM;
	bh=IO1laYvEds0abhW0TnR89Ta+YQwWmtFU4SqsuCCUXGk=;
	b=qakyUSuOscIryMSLboGMe2j4D38aV8BDRWy1x2BQnLekHH71Qj3sosDEyaT4VQ2Wywuy
	 hFMh4fp5ry7ATxWLxddRSUuYec4E0Jex1sgdab9lqKEmlcpxyQogrHUJHg6jLY+2NQvt6
	 8v0/GnVxZWN6XUN65TvWfPO/JGUsAKTTASqFB0WXYub5kf8ancUE+HXN/8YpKpbO05IId
	 KQEv7ChwBL1uUexqby/XCAfxB1B/IIeAw7lOO8wDGH/Hp+foXXgqnjELPtlOov4CqTFQd
	 CGM50JKfCJlu0SJ3LU9EyNbQmauy4zF00Yhhy0OqfE5NjqH1ERBK4mHCC/K72ulPl/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=wp.pl;
	spf=pass smtp.mailfrom=wp.pl;
	dkim=pass header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b="OG7/7lOw";
	arc=none smtp.remote-ip=212.77.101.12
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10B1B606A31F
	for <linux-wireless@vger.kernel.org>; Tue, 27 Oct 2026 16:36:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 10B1B606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=wp.pl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=wp.pl
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=wp.pl header.i=@wp.pl header.a=rsa-sha256 header.s=s20261001 header.b=OG7/7lOw
Received: (wp-smtpd smtp.wp.pl 9592 invoked from network); 27 Oct 2026 17:36:11 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=s20261001;
          t=1793118971; bh=IO1laYvEds0abhW0TnR89Ta+YQwWmtFU4SqsuCCUXGk=;
          h=From:To:Subject;
          b=OG7/7lOwiSL2V9niGYTIvY8RKsIZduHR2B1VwKDTxq8HMYwbHpUHpVQtkMLZq/d99
           4sMq00kTa85poSw1zBP9PQXQfB67+0dziGa1PS6WaUak8cLC/euk7P0htI8grbGu03
           ApKfD85PV3QqiIIKFKlkCtcrlbq14ICE5x/4SrqSg4zND2oIZ5b40K8dh6bV9qTkWY
           2b0bNwhgSmYriw/+kw5vwUYo1VFubF0IR2Dv8CmX0mr/paP1kT/BOkleBrjknYd+HD
           FeV2aCu6dHsePBtBo1Ve6ZcmEYSJ2nmibIz6/GnpJzhbCZxEJ2Y2YcFKDic6fXMPL8
           GD23Suti8wfwg==
Received: from localhost (77-236-11-144.static.play.pl [77.236.11.144])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with TLS_AES_256_GCM_SHA384 encrypted SMTP
          for <linux-wireless@vger.kernel.org>; 27 Oct 2026 17:36:11 +0100
From: stf_xl@wp.pl
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next v2 0/3] small debugfs cleanups
Date: Tue, 27 Oct 2026 17:36:08 +0100
Message-Id: <20261027163611.5161-1-stf_xl@wp.pl>
X-Mailer: git-send-email 2.25.4
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
X-WP-MailID: 7d595688cb784fb4d6722e5718701a00
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000001 [wRKd]                               

From: Stanislaw Gruszka <stf_xl@wp.pl>

Remove some no longer needed knobs that can change driver
behaviour.

v2: add wifi prefix to the topic

Stanislaw Gruszka (3):
  wifi: iwlegacy: remove configurable watchdog timeout
  wifi: iwlegacy: remove channels debugfs file
  wifi: iwlegacy: remove disable_ht40 debugfs file

 .../net/wireless/intel/iwlegacy/3945-mac.c    |   2 +-
 drivers/net/wireless/intel/iwlegacy/3945.c    |   2 -
 .../net/wireless/intel/iwlegacy/4965-mac.c    |   2 +-
 drivers/net/wireless/intel/iwlegacy/4965.c    |   1 -
 drivers/net/wireless/intel/iwlegacy/common.c  |  36 +----
 drivers/net/wireless/intel/iwlegacy/common.h  |  10 +-
 drivers/net/wireless/intel/iwlegacy/debug.c   | 149 ------------------
 7 files changed, 8 insertions(+), 194 deletions(-)

-- 
2.50.1

