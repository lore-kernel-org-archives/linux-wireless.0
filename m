Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1E573E2AB0
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 19:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792006360; cv=none; b=cHjtddeVC2I1IQAlhrxd2LBkrF9eTOMHYAfB6MCFhutnvi504ATuwgaR8Q3lmQS4dmpd9E7Ual7/umtqSAU1CIJWgpCUPTI48K6Wp8zglqT9SaP6Zaupv54/kekR6kj9CePhyh/zmS/qasCANv+zhEqBsRSlpNha3RxRm/PO4XE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792006360; c=relaxed/simple;
	bh=rtA53JoqRP6EqlHMPwk3mTfr3fQ1zt+A87lqOnquRpk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=bPjgb0CzWErEhiouPWOjkFZz+kJ8TziW5gocHbeqbZK8ELcjqF58Cr+vEj6mftGJ/5+XQxcsk/W0cdf0IZFVbPT0CsSxg0M9WGB7GTIzpKr33BIv6hSN30v+lrpCVXRgd4vnnGS8fhY7JVE+dPJkxil05Cy9S1+t95CJ2nlPEvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=o/ED/8Yq; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="o/ED/8Yq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=rtA53JoqRP6EqlHMPwk3mTfr3fQ1zt+A87lqOnquRpk=; t=1792006358; x=1793215958; 
	b=o/ED/8YqEpo5cDTkjWLWwQeJ+55VC1UpznYl26rkN2yTG1TRXGfiyn9N5iNmZumOnX1rllQipx3
	Vap7UcwqgcbNQzzgAdqd4IGbNTRFcmshra/t2QqQUuM651ZlxnOGH/XXuu9Lyw6pg+FolNmvh0IcW
	uSCEzNkmHaVmQSxEswUxrC7vZuVU1Fj9tSWYRD4T4I/zeBpGke4eHzp5Z0boKVhezrMfxQ1MzrIrj
	HMnskF3Ie+s5FEJLM27SKUG+TTR6gKJOwHBvMN0QUcjZx3iIDf1s8jQYmqErECD/jlvaErkbvF76p
	q+kzSYB06j6Q1d3usfBRBSKrYWYhjI+SvNQw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xH4iJ-000000020zZ-2vWQ
	for linux-wireless@vger.kernel.org;
	Wed, 14 Oct 2026 21:32:35 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC PATCH 0/4] wifi: mac80211: remove RCU sync on key updates
Date: Wed, 14 Oct 2026 21:30:30 +0200
Message-ID: <20261014193231.886495-6-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This RCU sync has been a pain for everyone I think, we got hit with
NAN. My previous patches

https://lore.kernel.org/linux-wireless/20261013150605.65fbe249d82e.Ie6b44dfeb421691898e1e181f38a6adfc780290d@changeid/
https://lore.kernel.org/linux-wireless/20261013150605.02513cd5b9cf.I8e30528b787541241c5709178d7de643d70e7dc8@changeid/

partially addressed this, but it's not great either way, and just
adds more complexity.

So here's the different approach I outlined before: just accept the
race and make SW crypto handle it in the case that it happened.
Gets rid of a bunch of code too.

This patchset applies on top of patches 1-9 of the earlier series:
https://lore.kernel.org/linux-wireless/20261013130604.254393-13-johannes@sipsolutions.net/

johannes

