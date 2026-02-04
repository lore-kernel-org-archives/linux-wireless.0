Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96AB325727;
	Wed,  4 Feb 2026 11:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770204953; cv=none; b=DzUKotO/yjT77UUzOYzF/h1m2vIgAdDrHO4DgYqyNj81ab1V/eZJvejAFtfDdTR0vXRvG0rB3WV+ZWqlxQkLIExw+9dxFkOWpvsq10RqPPmxlWTstjuAdFoX8X9mAQGqZcPxEdGw9tKiZKp1XfiRc2uXtK4ezmol2Epo2swq3gI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770204953; c=relaxed/simple;
	bh=HLFqF8w4YB18f2T/EMhFOWb+Sn2L0IXoXGA+El73BA4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=MrPh1id7yejeXuMz8j31bB+uKvOiR7T2b9EJZUEIbD2Dq6xsGx3QkQs7iVlKKtKIh0S+y2Ots09KSsJ8mrUtyYsKnGcwUfeOGIx+A41tyJJlEEr2kb+KgZH7roQ1IcL/i2ETEeXoHceRXMMLFvmJCk3jd7/mDJIq4hYNsJd0jzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Rb0tlSQR; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Rb0tlSQR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=pLNdq1aylyyBkW3ltLdMWYah6GHBbB3gFYGxGKA7BKI=; t=1770204952; x=1771414552; 
	b=Rb0tlSQRD/qtTVYaV7FS41zaKc7/7AYEc+pMyuoA3hVABhB+WcVPXIccdYWhxR26w3/H2AHs9YG
	b/S9AccrwT5yU4q8+ushm+2Q6127wL2J5s9/UUg1ISLh7UbTuNXI3wLaXAF9Bi/XnKUVRZnF/IzVE
	Mce1sxyzpdSxNqq6Tthm21gGzMhmD6UoEYYzjsfbwHBPukhzqmz1vpa2JalHhOvsn8r8NFM9rczlh
	TqRi8GyK7tfHR5Q4yu5QI+s6xsXP+VUB5NNDK3QTwro16d9o+5hJBXPyNklLXC/zAU4+R7n3A/Qf3
	iHNPLdOXeixS827HpGDjHVEACl2118P+5/cQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vnbAk-0000000EJrQ-1qqK;
	Wed, 04 Feb 2026 12:35:50 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: [GIT PULL] wireless-2026-02-04
Date: Wed,  4 Feb 2026 12:35:20 +0100
Message-ID: <20260204113547.159742-4-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

So famous last words and all that, but two bugs in
iwlwifi were reported and fixed in the last week or
so, and here we have those fixes.

Please pull and let us know if there's any problem.

Thanks,
johannes



The following changes since commit 1cac38910ecb881b09f61f57545a771bbe57ba68:

  Merge tag 'net-6.19-rc8' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-01-29 10:21:52 -0800)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2026-02-04

for you to fetch changes up to 45a66b75bf10c84060c9948e3be664e03454515d:

  Merge tag 'iwlwifi-fixes-2026-02-03' of https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next (2026-02-04 12:31:58 +0100)

----------------------------------------------------------------
Two last-minute iwlwifi fixes:
 - cancel mlo_scan_work on disassoc to avoid
   use-after-free/init-after-queue issues
 - pause TCM work on suspend to avoid crashing
   the FW (and sometimes the host) on resume
   with traffic

----------------------------------------------------------------
Johannes Berg (1):
      Merge tag 'iwlwifi-fixes-2026-02-03' of https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next

Miri Korenblit (2):
      wifi: iwlwifi: mld: cancel mlo_scan_start_wk
      wifi: iwlwifi: mvm: pause TCM on fast resume

 drivers/net/wireless/intel/iwlwifi/mld/iface.c    | 2 --
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c | 2 ++
 drivers/net/wireless/intel/iwlwifi/mvm/d3.c       | 6 +++++-
 3 files changed, 7 insertions(+), 3 deletions(-)
