Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78B343DCD9C
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 05:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791349216; cv=none; b=gTdpKEfb/0X6RR5Tl6d5947LixG8IqCzcR5fbVOQ+p6Vek0ZbEWXZCAIntT9aj/dpxkv7//Gc44RtSO+JH33aiE2Nw0xEwK46TbOr7OnqiKQZ7MYd35wlkEapOyr3t7lM2Sxq2md9AKwjj1oBL50aSimHNvFwOEdJQMl+o6aMh0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791349216; c=relaxed/simple;
	bh=L5brfeGrP2theR6ZyKEa7iQbw+QfikttYeTwnJ98f9g=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KZDPrSJcDPg5VBJw7mjitbv+kvJS6LEv6mKz/P6DpiiXcVuyTR2VX/JhXlRKnt3xsJrG7UbJr5sx2psWNKT9qWe3+YOgVnVriRHENfH3PqMvxWmjFYrT634plYiISNsnAWVhCmY+AE6zJ9HOQ0HQBSSCck5rjAVKp/DI/fDnHj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=hhewfKvL; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="hhewfKvL"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-3a4cdc9025bso1037224a91.0
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2026 22:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1791349208; x=1791954008; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=0TGO0BEMxKmYnIDIL7KgbbzkyafE02n8s6QCWeRrwnM=;
        b=hhewfKvLuPnGxD+bALmqLyNUnglWv8bFXbX1PJqBwA0Hog6dnyf2v8ZXHE/5UOnsuw
         N/9xu18dFH/YxiEg2j+8elHhh1xiijBcOisNo8Vbmhpnb1ACty1GT2XftOKgMuXDpwdc
         9lgNIR5eiOgUGwdJs7UFDU4ishzWyHSfi9cANGyuvS1tN2b1sgbxfwjYfJ3JPt4TgyZ+
         WRUBfOcnN84kWHPU8XacsigHvezrA6z7kg4Px8TSRhQ0nA62Uia8WqbEPxWldrHJmJk9
         ElBKJtCGvw4Af7YJIUHZagacWCwAGtO13ECr/6iydbVK2iJ/TB9H22g4JMfky5f+iGTU
         2IAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791349208; x=1791954008;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0TGO0BEMxKmYnIDIL7KgbbzkyafE02n8s6QCWeRrwnM=;
        b=GMH9oXARyzezLNfsjAVDfhpZ1AfjrbHOFgJpQ9UlJZ83qCzihk2ZgF/yrrPFRGAqAr
         IyC0deqkrHhZe9axYrq8SQfHadyCMktXPX5QDwYUDdudKwkIA6uiBvabqrE/fo52R22S
         UrghKMkUOrbXe364iReFZxtm6HEipcoVh5TB86iErA0F9mXsk8eOQ3fdGMmUejPlFBZ9
         tm5isabpZh9JPLqQ/JRNbqo2ECYmaV6hB+mLmYDjaXjuIhMGGONlM/8W4m+OrtjSVi+W
         G/4QuuReIukPsARqZ93EFiKa/7dEmcRv/p3MXh88s6k8PocX8gnGHaWfb18I1GmXPpzy
         8ONw==
X-Forwarded-Encrypted: i=1; AKwUvBxUKfTFpUzPk2tSAMenFrNpLzeM/EXL1oJNzbGVBYSiODaPQOKDM65y/rJHVRaXL+L2AUKzk7UoVD11IW5Law==@vger.kernel.org
X-Gm-Message-State: AFq9FYI9nHt3QRO6co9O+DgE65c4Ud7tpj0frzgSE5saq4wC28b0/l43
	2yHBHYSpY6sjuXZqwz97c+PQbvC8gTATQtRiuwkhCyjWBMb5nhjxOwoPdCKxtAh85dt4Gry0wx2
	M0RFhokg=
X-Gm-Gg: AYBFou3CLcoH8FwrHX6de4trCktuB9RPn6Hg29bZOSHZ/j+bx1yfsDzy/3yweA6uFFU
	bJgHlHpFn7xXAPGsXOhkXSguUYkf5eAIWiXlXZ/KMe4aRBhU3OrgE0BzdR4TId5Uz+oUcwMw1zW
	AZCbk0CHF3wlwJ7OoRRCMxNtADbHuZhVLwLg2b+VLn4vB+PLOV+/C0OneobUQrlAIthQaDbuzOr
	u/rHX+qsTmmCa8K68T6+qM/8NbYUMB5Lm0wClXNQyq1mYCXWh+5uZJGkmOX8vX/eOLvx28m13EB
	Q7jxSPyI99jue9GoaHaCAjq/A17wIqQmE6AtDqIyDETLnIzSrWAgv3sWFWswCCLhR9mZI2Ouyll
	aWV/mK9TmkqewVBVTS4LZvwSDfhfnMeuHER4OAmW+daxUT+sxLDfK8kYRaaZbAp/e/GWuTb2XJN
	v6Skwr4ZV9RTKt/lNHrC9y3HCTc4GXzW7kz32ju48g8g6ctA+rYrcP9aQOBzUuu/n1KapKEEmDd
	UZpZUydWDVHMZ05NzpSngQR8X7PVNwB10+btA+n7Y5hLGKkHHAUnCW16xSSuTG5i6Zwr6o60hZa
	Z1DFgJ/OXdBpSm4c
X-Received: by 2002:a17:90b:1a8a:b0:3a8:21e4:9584 with SMTP id 98e67ed59e1d1-3a8a15314eemr794046a91.60.1791349208322;
        Tue, 06 Oct 2026 22:00:08 -0700 (PDT)
Received: from mma-H9MHD44.sydney.mm.lcl (60-242-93-14.static.tpgi.com.au. [60.242.93.14])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8a4b1abbfsm696011a91.4.2026.10.06.22.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2026 22:00:07 -0700 (PDT)
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: lachlan.hodges@morsemicro.com,
	dan.callaghan@morsemicro.com
Cc: arien.judge@morsemicro.com,
	linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 0/3] wifi: mm81x: monitor mode and rx improvements
Date: Wed,  7 Oct 2026 15:59:57 +1100
Message-ID: <20261007050000.127009-1-lachlan.hodges@morsemicro.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This set adds basic S1G monitor mode reporting and some improvements
to the Rx path and bug fix for sharing sband across modules.

lachlan

Lachlan Hodges (3):
  wifi: mm81x: provide the station to mac80211 on rx
  wifi: mm81x: add monitor mode support
  wifi: mm81x: copy new sband for each module

 .../net/wireless/morsemicro/mm81x/command.c   |   5 +-
 drivers/net/wireless/morsemicro/mm81x/core.h  |  16 +-
 drivers/net/wireless/morsemicro/mm81x/mac.c   | 285 ++++++++++++++----
 3 files changed, 246 insertions(+), 60 deletions(-)

-- 
2.43.0

