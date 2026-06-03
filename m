Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35EEE44E038;
	Wed,  3 Jun 2026 11:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780486335; cv=none; b=BkwP+KmXqdtL72rCS7d6UdMpcGuXrgwcWj/8+VasdX4jRVOP57ukMTYJYPKljlLsa24itEHlKjJ/isI+hNHAneADj8eBBoMaaixqw00t4CRLfwRZluZ5kXZD6CW9JFhWqE3xeUfxEJ5QEhXB8E43d+E7AIKWYmQ/6RH7E+6nKs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780486335; c=relaxed/simple;
	bh=pCDoyBf5uPusqtWnqqYqcwcm/dibKpLzPR3UQtm+MqA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qUbWPiwHxJ2MqB9+vlNrWnxVi2h1p4cLTywG/R5aEN8sBxUwuZa4eiJGhU+fPlRcOHhCepSOo7WFVZoYbp6pOi6M8TOj54kmE9KunXdMkQEOHAk7QhT39cxR/HJPl9emSoicstsXzREy71UHaFtuTn+8OU72d/v5jl2i2KL0yIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=bUzjJYbp; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="bUzjJYbp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Content-Type:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=wq1BxYgyTqInpfevdpxaUw/6SPUNQSybMXqUxDLHxcs=; t=1780486334; x=1781695934; 
	b=bUzjJYbpinjKL85bfU3YegKlS4u42IudQVKSLcyeQtL5B67mSwQp5pI5K60iZaZO6wNmo7eWPtO
	LcBka5rneCyNtEz7EZD3F/BmONKOhOGl3vctSddOGp4ZyJkGtC0QSzbBKpR/YQc4kUIRhArUfG5Q/
	a/l2WmQUbw3IReK4YzcFdUPqB9L2SFJTmZr27qRlW5evIIHi1VWbMeO0Gt5gEfe7nLlc9suWeasmo
	D8w0OuvxoajkmgJV2lk55YFuCl5MexzHSYrnkOACWfFXGr13IN0hnLxuDkJXAPxV0X0v5qSpqu/x6
	cFYYrdUEugsJe3gwXq+SPulCsXJ2Dm4upN0g==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wUjpT-0000000H5Ij-1Pa7;
	Wed, 03 Jun 2026 13:32:11 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: [GIT PULL] wireless-2026-06-03
Date: Wed,  3 Jun 2026 13:31:24 +0200
Message-ID: <20260603113208.171874-3-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

And yet more things ... I'm going to defer a number of driver
things to wireless-next though, e.g. a PCIe device IRQ race.

Please pull and let us know if there's any problem.

Thanks,
johannes



The following changes since commit f3be0c984ecbcb82b0bec408022c4ef738cb3843:

  Merge tag 'net-7.1-rc6-2' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net (2026-05-29 15:46:40 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git tags/wireless-2026-06-03

for you to fetch changes up to cb9959ab5f99611d27a06586add84811fe8102dc:

  wifi: cfg80211: enforce HE/EHT cap/oper consistency (2026-06-03 13:25:19 +0200)

----------------------------------------------------------------
Things are finally quieting down:
 - iwlwifi:
   - FW reset handshake removal for older devices
   - NIC access fix in fast resume
   - avoid too large command for some BIOSes
   - fix TX power constraints in AP mode
 - cfg80211:
   - fix netlink parse overflow
   - fix potential 6 GHz scan memory leak
   - enforce HE/EHT consistency to avoid mac80211 crash
 - mac80211: guard radiotap antenna parsing

----------------------------------------------------------------
Deepanshu Kartikey (1):
      wifi: mac80211: limit injected antenna index in ieee80211_parse_tx_radiotap

Emmanuel Grumbach (3):
      wifi: iwlwifi: mvm: don't support the reset handshake for old firmwares
      wifi: iwlwifi: mvm: avoid oversized UATS command copy
      wifi: iwlwifi: pcie: simplify the resume flow if fast resume is not used

Fedor Pchelkin (1):
      wifi: fix leak if split 6 GHz scanning fails

Johannes Berg (2):
      Merge tag 'iwlwifi-fixes-2026-05-31' of https://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next
      wifi: cfg80211: enforce HE/EHT cap/oper consistency

Pagadala Yesu Anjaneyulu (1):
      wifi: iwlwifi: mld: send tx power constraints before link activation

Yuqi Xu (1):
      wifi: nl80211: reject oversized EMA RNR lists

 drivers/net/wireless/intel/iwlwifi/mld/ap.c       |  4 --
 drivers/net/wireless/intel/iwlwifi/mld/mac80211.c |  7 +++
 drivers/net/wireless/intel/iwlwifi/mld/power.c    |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/fw.c       | 28 +++++++++---
 drivers/net/wireless/intel/iwlwifi/mvm/ops.c      |  6 +++
 drivers/net/wireless/intel/iwlwifi/pcie/drv.c     | 56 +++++++++++++----------
 net/mac80211/tx.c                                 |  4 +-
 net/wireless/nl80211.c                            |  9 ++++
 net/wireless/scan.c                               |  9 +++-
 9 files changed, 88 insertions(+), 37 deletions(-)
