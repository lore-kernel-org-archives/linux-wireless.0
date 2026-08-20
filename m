Received: from mta1.migadu.com (out-7.mta1.migadu.com [95.215.58.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586B72417DE
	for <linux-wireless@vger.kernel.org>; Thu, 20 Aug 2026 16:13:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787242410; cv=none; b=LYotAHTwijVjyQr2W7MBB7Buw2W+rZ70bqQ5frJxqquGNlXnfCmrFv2eEsNHBZFJTV48iwIUgZX/sEa7P2Bymh6vr93qy+77lMhjrZQ1ad8mAm5nYMJaCtRNGeDtSbnpQwdnBvT2JvwC+YfLga5RWArx/V6appuBM+hiqfyc7Ic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787242410; c=relaxed/simple;
	bh=GSbd9eXn+aBkKA8yfc5E9UP0zZYOKacQHj+I0EFsxQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f5dh1dDH2yaoUooVEGlaCCJ+6FVBZ0CJ50+ONyzwJtPsC8HZTRJxkjCjqt2dQVgXzj+O0TCXm+o89h0c5/PqEb9Uyia3KvFHZ0cqyQnYMfYZEbcqwpjqBSVdbHfUCNethZNUhnIQwAtCR8oZg9S/oqxN/qR9R0dG48470AuXhvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=wYqk/VAq; arc=none smtp.client-ip=95.215.58.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="wYqk/VAq"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=GSbd9eXn+aBkKA8yfc5E9UP0zZYOKacQHj+I0EFsxQs=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787242406; v=1; x=1787847206;
 b=wYqk/VAqDjpe7MVCJz3hb5zNPmuMZST4CnikLvkhmBBd1og/2tCzBSWK0tc3HoVMFhBjPwan
 VUZnz4wma6LjogM6HA8o5dF7sOtSHRVmsjLypFvPv05VKwJcBozAs0SytENP23h8+4kKjRB9LRq
 NW8K+5BQjclmFU3f2j5cwrAsFooZcd2Tmsc3oIwINIT8ZeZHa5S6Wm68US4yg30sQv1olk6Awyg
 OdZGGumf97NNFL9/SfIcziqoRd9Zp6hIew454ZzTcY2tfv4IFD5rK5jOIiuc55qCSFPIVd6nQo3
 12binpycUqIsb9MfG+QP51x8nrsPIWXh6wevJM1wo0ArQ==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from fedora (187.15.154.68)
	by smtp.migadu.com with ESMTPS id 7cf7a057dfa13fa4;
	Thu, 20 Aug 2026 16:13:26 +0000
X-Mizu-Trace-ID: 7cf7a057dfa13fa4
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Benjamin Berg <benjamin@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Jeff Johnson <jjohnson@kernel.org>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Benjamin Berg <benjamin.berg@intel.com>,
	ath11k@lists.infradead.org,
	ath12k@lists.infradead.org
Subject: Re: [PATCH wireless-next v3 2/8] wifi: mac80211: change public RX API to use link stations
Date: Thu, 20 Aug 2026 09:12:07 -0700
Message-ID: <20260820161207.125743-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260819155703.af6d319e6b61.I4a2d45609e94b52654b10ec572e59a45d09c41f4@changeid>
References: <20260819135703.4072215-10-benjamin@sipsolutions.net> <20260819155703.af6d319e6b61.I4a2d45609e94b52654b10ec572e59a45d09c41f4@changeid>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Wed, Aug 19, 2026 at 03:57:06PM +0200, Benjamin Berg wrote:
> -	*sta = wcid_to_sta(mstat.wcid);

This moves inside the wcid check, so it no longer happens for every frame.
mt76 uses one variable for a whole receive batch, so a frame with no wcid
keeps the previous frame's station instead of being cleared.

Frames with no wcid are normal rather than rare. On an MT7922 they were
about 98% of everything received, and 16 frames out of roughly 4000 ended
up carrying a leftover station.

No harm that I could show. None of those 16 were data frames, and that is
the only kind mac80211 reads the link station for. Clearing it when there
is no wcid still looks worth doing.

Devin
