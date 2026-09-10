Received: from mta1.migadu.com (out-241.mta1.migadu.com [95.215.58.241])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEC373803DE
	for <linux-wireless@vger.kernel.org>; Thu, 10 Sep 2026 03:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.241
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789009886; cv=none; b=g6LhWfmnQYD3bdgUzVuZUdnoj3d6g/ezd7bnv0QjmBIfYsg474R04//RT+FTA+nXd/3NMK5mvtx73SdnGmfNQEWUibN3PMn8suuMv3Vd/l6vmNNzWnUDF4iBCz9i/L9qP9aQpQKQPybGPoR0J5dFxyvpKkMBVTxiakh4tYVc2Xg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789009886; c=relaxed/simple;
	bh=HHaP3JdzC+XP4NNFD+TmeX4WXk/1Ya5ezPKmN80QIVQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=FcTZIBdM4feBjPIj7DzRKRatkBURCa3IzUOaVBehlnVaPCjsySugngIcavWhFdL3LSu3iXIhq9Ia/DeNsW0jLBJXyMydaCt9SeNKK6HxCIY4FmmU7NM7055cDC8Ut3OxUsZmSd2r/tT4wkBM2/sAoCkbBk6TtxIdhqFE1sDuA+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=fK5ccWAA; arc=none smtp.client-ip=95.215.58.241
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="fK5ccWAA"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=HHaP3JdzC+XP4NNFD+TmeX4WXk/1Ya5ezPKmN80QIVQ=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789009879; v=1; x=1789614679;
 b=fK5ccWAAoUaohBdINGZjrvG0d+V5X3SkxC9C8bpEgEzx2ELlDo6EknTkBXX0Jzws2/fKM8CO
 MNPUlUhwHj/gXdod1oB2NPLb/+v+0jCKToUfdYN4WzayWedd2LdPlWUGpvy39OjaUQweOO23H1o
 vLfwyEEesHLbtWhmNdXEcuNdBGDrv44e4FxwgSkthDQTJA6W0HnGkitOPXYnGlZgMPeWAW+DHBS
 //IZpzacLn/gtDs1OivtKBluTEYCql7yhOtDenr8TQC+D1m/4qoBf/wPgdUdmoMSaD+8eZ4vqOR
 E/IuOPfC+ZXhf42ggEBH7m4abUu0XNfAnXOeVbhTahpIA==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 15a374e8e8a4eb93;
	Thu, 10 Sep 2026 03:11:09 +0000
X-Mizu-Trace-ID: 15a374e8e8a4eb93
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: stable@vger.kernel.org
Cc: Felix Fietkau <nbd@nbd.name>,
	Wentao Guan <guanwentao@uniontech.com>,
	linux-wireless@vger.kernel.org
Subject: [PATCH 0/6] wifi: mt76: mt7925: cancel mlo_pm_work at teardown
Date: Wed,  9 Sep 2026 20:11:00 -0700
Message-ID: <20260910031106.25906-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

These two are marked for stable and were not picked up:

  81faf578320d ("wifi: mt76: mt7925: cancel mlo_pm_work on stop")
  2889e84282dd ("wifi: mt76: mt7925: cancel pending mlo_pm_work")

The second is Wentao's and catches five paths that mine did not, so
thank you for that.

They reached mainline on 31 July and first ship in 7.3. Neither applies
to 6.18.y, 7.1.y or 7.2.y, so backports for all three follow, two per
tree. Each applies cleanly and builds with no new warnings.

On a multi-link connection the driver schedules a job five seconds out
while setting up power saving. Nothing cancelled it when the device went
away, so a removal inside that window leaves the job to fire afterwards.
The code has been in every release since 6.15.
