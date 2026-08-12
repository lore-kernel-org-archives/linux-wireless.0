Received: from mta0.migadu.com (out-77.mta0.migadu.com [91.218.175.77])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D46470135
	for <linux-wireless@vger.kernel.org>; Wed, 12 Aug 2026 15:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.77
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786550302; cv=none; b=WZByx+Dv/7qAQYsHR1Ux73XdbDr4i0e+FbQ+LyYMHLIhp+ghjT80m/6hBOubiSvhHh7xc3PcT1sUK+/cJazFen1KquZZdu+n2TmUG5UOV04uAL7IWvHmH3Rd+vNBJMp/VAVyQvZc5Kp6P544FPmizUP6K1ComlhWmdUmUbxDriU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786550302; c=relaxed/simple;
	bh=6Om2oyAaZk+iPjfVlIinvElzTUwWq7tFMyDXcSXpRl4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SL7/YpF2mwGY2byeVbaOHb/3UXJLpg4ZVqr1Bwjl6IZ4G8vOvS2cwzaw3rjjKU2uu22jJiGdDnhRbloZgZgLVeYcqrrawj7Kd1FMeN/KKAN/bu9zTaggCafFmDp3Xd0/4dy8spkbquitwA1aLFlZCcI3T1Ia78OTVPMhAgeU4cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca; spf=pass smtp.mailfrom=justthetip.ca; dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b=AjuvSxgl; arc=none smtp.client-ip=91.218.175.77
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=justthetip.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=justthetip.ca header.i=@justthetip.ca header.b="AjuvSxgl"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=6Om2oyAaZk+iPjfVlIinvElzTUwWq7tFMyDXcSXpRl4=;
 c=simple/simple; d=justthetip.ca;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786550296; v=1; x=1787155096;
 b=AjuvSxglkZEOnt/kOKtWUDoLzw1uZi3t6RFYCWmZIv4rqT+DOKE0suU5kKnDKR3foFWjXnVM
 nK/Prp9z9zMEiiSSqS+SJ/Ax7uRkhBRFCrXxKYv2k0NrZceaQEBExu6iesc/jXIs+qb8Kk4uEQ1
 d8ybjyM+xuCZtRK2m4I8GbDxfUtyhfz+w2yuV+YEKnQKnY7RvtxUkPjPtWetmTNWOhUPhKJT6US
 9l6VHK5AxHTxzY1qonDoDS6HqPy94bY1Wx/Pk7G78n9ZLnv4BuIUII6CxDEVB5mlSzJVmtBbSYI
 hcnJHnqaEcmys1MrE6TLZ0WSyGIGkt8QGoW/QDXsCP9xg==
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from fedora (2001:569:be59:c500:b340:3f2c:4486:21c1)
	by smtp.migadu.com with ESMTPS id 6eb947314bb2fb15;
	Wed, 12 Aug 2026 15:58:16 +0000
X-Migadu-Flow: FLOW_OUT
From: Devin Wittmayer <lucid_duck@justthetip.ca>
To: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Johannes Berg <johannes@sipsolutions.net>,
	Paolo Abeni <pabeni@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Ryder Lee <ryder.lee@mediatek.com>,
	JB Tsai <jb.tsai@mediatek.com>,
	Charlie-cy Wu <Charlie-cy.Wu@mediatek.com>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	regressions@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: Re: wifi fixes that might be good to have in 7.2 final
Date: Wed, 12 Aug 2026 08:58:11 -0700
Message-ID: <20260812155811.10950-1-lucid_duck@justthetip.ca>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <7e66ca09-fa70-4a3c-948a-0c46b268655c@leemhuis.info>
References: <7e66ca09-fa70-4a3c-948a-0c46b268655c@leemhuis.info>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On 12/08/2026 13:57, Thorsten Leemhuis wrote:
> P.S.: I wonder if "wifi: mt76: mt7921: refactor regd update to fix
> recursive mutex deadlock") (which is as 1f83a8378eb26c in net-next [...]
> ) would be good to have in 7.2, too.

It is the same bug, and that patch fixes it. I ran it A/B on an MT7922
with mt7921e, swapping only mt7921-common.ko: stock deadlocks on a 6 GHz
association, patched associates at 5975 MHz in four seconds with no splats.

The fix is in wireless-next, not in wireless.git. v7.2-rc7 still takes
dev->mutex unconditionally in mt7921_mcu_regd_update(), so 7.2 ships the
deadlock unless it moves trees.

Nothing is owed to stable: e88098133ed4 is in v7.2-rc1 and not in v7.1.

Devin
