Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A16C3939D0
	for <linux-wireless@vger.kernel.org>; Sat, 10 Oct 2026 16:05:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791648311; cv=none; b=Fj6Lf0qOdl+nmmmE6OA4CxF7gN3vuLPkKGEKL1Jd7fsOnHZKk+HMWIZGIs4eDqsgQvEZfrm6I3d57exmtAFb3REnHC+YLXCz5lC4+VHHIRzOB58hjzD40hs03oE8dTaYYxkUH3akDm++aPOmjTLadKi3kV/78u/e7Ybf3EvEPTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791648311; c=relaxed/simple;
	bh=nfJTI5J9BgHohycoY3QBEQHZGSLjJmenySECg2qXSI8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=S4Plz2yaF+45CAOvPBF4h60ykj49WcdpkSBdAM3KdPOLprX5cc1BwOf0FMI0LE2dltnqjiedr/0Pbtr+OstLscZSoBAvdwme2U76L8ueTq+hYCxJ3468NoQn0zU2oQXm5xD1IWBADp7VBXHNhXbe2lUR+lEjiSUlflUKFrT4Fws=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=R5JwKM0u; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="R5JwKM0u"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=nfJTI5J9BgHohycoY3QBEQHZGSLjJmenySECg2qXSI8=; t=1791648310; x=1792857910; 
	b=R5JwKM0uMhFak5BR2w3zqdaGfW07O8HakmfHt54V3V9PAD3yjeka/Nx8AsBN2K/N7TPam1NY8hU
	h1W3LqC9oynnJf6qdvrm2O1+eah6uFc7h1+HSwGyPQmW1N9R2FvcS1iSetEP9ApMDusVvNeG9zDXZ
	VAtX0oW1UMZRi8K/rq/mTAeUCOphLB0Ol5M6DizXM0eZyrvQMQMNuamjVHMflAzT0sVDLgOhqJ8SL
	+ppMCm6Qt9M46KbiBls5y6ZPlhvlIi7IIJWRtbz2ZMaw9scIggERFeIWQnjz3CIBNAx+li57bdU2O
	rGEnGVetHFMCNne5nF7nmrcXAtLnSjh2L2sQ==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFZZF-0000000CP1z-211j
	for linux-wireless@vger.kernel.org;
	Sat, 10 Oct 2026 18:05:01 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH RESEND wireless-next 0/9] wifi: further RTNL redux
Date: Sat, 10 Oct 2026 18:04:12 +0200
Message-ID: <20261010160459.229064-11-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Somehow NIPA didn't manage to apply the previous round, likely
because I sent it too quickly after pushing, it was here:

https://lore.kernel.org/linux-wireless/20261009145703.243031-11-johannes@sipsolutions.net/

So this is just a resend, since I'd probably ask anyone else to
do that too if NIPA didn't run :)

johannes

