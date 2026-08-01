Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8821F30BB
	for <linux-wireless@vger.kernel.org>; Sat,  1 Aug 2026 07:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785571117; cv=none; b=F4gX0enr9F1KjHuebLGm1u8NqPvm9AHdLQhg8bj/RHMwhBugIliGRMA2x75xB4512qBJCTg4f6/bWhGedtVLfiQFT4T2svISvgDu0DdNWlue67yQ3zhNgFL6NNIA6wtux163aPg2IiPMaIg3AOvzWXVvX0o9JM9B94GlEV3SPDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785571117; c=relaxed/simple;
	bh=zKrDcNIxLj5I5Z1Lx0A42nznKS6zqRaEvUPzXg6ATvI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=XMjeaw5NHEhnKaXGiRmxkTaTkVA90GXkBeZObAvE4FNkFU9DPhX9bB5vPCl4JpFTSlHR3vBzziBmWWWAkHiVszliw6OjOudQgpjax2Ox5AUvKZqzbZA5qUkZevBQm0tO8yyRW9hf2jXpUdkfAYrWll2MSTbdE8HcJBB21Jpj4aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=qqUw05tX; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="qqUw05tX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=cH+mdCb6Lj65dQlLL6K78f9tWJ4BZa9q8kk/MKndRBs=; t=1785571115; x=1786780715; 
	b=qqUw05tXE08mCc5vqPN65iRIGL8qrerLLvWqvZ4Khj3fzQkXoDREGzg4tkZ/oOjD06WSROTa91k
	U2ZpA6Uw1T8KTNbgzUw4oYVRovDk7z7eIk0zvDE7myc7aOp42SXtuc0FywEOXPnYWruFarTxQcg47
	xL+vYGAxx0a60MHDdi93sv62U2Zv0rrfWiCd9hMWmBECBSyKWLlGU9nRdVH6TTclFmZ9QveAeH8T8
	UHS8hjqB6gC1UJUSebKVQ5AQE89NvDxfZeO6xzdNcEmBOn+UXRpIj4GVVad3EQNHIHz+x5P0VjwIo
	dOoLpnM7ifpIoAxGmDT92obmdsjUgXPM4pjg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wq4bx-0000000ErOv-0ocR
	for linux-wireless@vger.kernel.org;
	Sat, 01 Aug 2026 09:58:25 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCH 00/12] wifi: mac80211: install group keys to STA
Date: Sat,  1 Aug 2026 09:58:16 +0200
Message-ID: <20260801075822.645974-14-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

First of all, I should state that this requires Benjamin's CIP work:
https://lore.kernel.org/linux-wireless/20260731154006.7bddd2d85ff1.I49c0be0a1b05d625cc307e9bdd13c32a6c18667f@changeid/
(It's therefore going to fail NIPA, but as RFC ...)

There are multiple motivations here, obviously the first is the
"headline feature" here:
 - Prepare for SMD Transition: During SMD Transition, new group keys
   become available after ST Execution, well before really switching
   to the new AP (in current AP MLD execution mode).
 - Clean up the TX/RX internal key lookups by unifying RX group key
   handling across all interface types (at least IBSS and mesh already
   required to link it into a station).
 - And something Jouni pointed out yesterday: group keys apparently
   aren't (always?) correctly removed when disconnecting, this will
   clearly clear that up as well, somewhat as a side effect.

The design involves cfg80211 so that existing userspace (wpa_s) can
work as-is, without giving the station address for group keys. This
is clearly necessary, and it might perhaps continue relying on that
rather than getting special code paths for different kernels, though
of course SMD Transition group key installs will need to be with the
MAC address.

The debugfs file here is required for hostap tests, they currently
decide whether or not a key is pairwise or not based on the station
link/mac address in debugfs, but that breaks with this since it'll
always be present (and I decided breaking the debugfs API was OK,
rather than preserving that), so the tests will need to read this
new flags file to check instead - I have the necessary adjustments,
of course.

The last two patches are just something that we wanted for various
reasons and that fell out fairly easily after doing all the other
refactoring in this work, it's not critical for any of the stated
goals, it's a bit of a side quest. It could also be improved, but
the most important thing there for us was patch 11 for NAN.

And since I'm mentioning SMD Transition so much: I pretty much have
much of the remaining bits and pieces for client side in mac80211,
and Ilan has the wpa_s (and minimal hostapd, for testing) code too,
but it needs significant further work and cleaning up, and possibly
significant redesign of TXQ infrastructure in mac80211 to allow us
to transfer packets to the new AP queues.

johannes

