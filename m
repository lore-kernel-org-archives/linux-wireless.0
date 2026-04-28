Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48418388E46
	for <linux-wireless@vger.kernel.org>; Tue, 28 Apr 2026 09:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777368436; cv=none; b=ZNAuwrVbmRtlb6HtgChxNVtlr2zw0ghuDRtXAeeI944a3F341/LnJJmuy5QL/w9+1c0PFAj3ZrUZqjI8FWyI8OJZRPJxY7xD2Fw2GiDzxaEYtnqsPUBZaF9415wfVBESq6TVJgJyMwTFzDBX2GWlgFd69AyECOeZLhzcBOCT1X0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777368436; c=relaxed/simple;
	bh=abERnnnVSMj8ugB/cErvrZkmpTpcwIUUmzm/9lZ21ZA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=sNaEZBc6cS4cqQ73l0jYXlel4uc0fg8UT9TpYq+nVIQ4da6/zvMIHUvAc5/302pklqKZLGOZa+OvGbBhLfw+R4hIr44AVoiR/Vpus4Yncm38o+m1x7+USGFOQrxeEvwyvJiSKXZphBJAu+mFpXCiTdiIWk9FF2ag35lNqFsnM38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=jq4J4A8r; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="jq4J4A8r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=e9P7vszTpCHLzj9OEsyNY+ObFWUk2MU5DZBnn4GTSs0=; t=1777368434; x=1778578034; 
	b=jq4J4A8rKHCEeqc1gFaCfoe0GAx2mdAnnGk6EoTqSZ503m/DuyfgYzVVCRooLYZqsZvzHnN4L9U
	Zf2tsHMPCHVs0A8VCsI9qKDpljriOsQRXmz+ruzzQU5MdLj0HZIqyO7e9hE0/wVqKAQ8Ipti2pgYQ
	YnOnqFNoC83eksB+I6Wq5zg++caQQkVfDPKFFMeY7sC/Z7N34mTIqvVSJ8iZ9Bt53SiXSLDQSIO7+
	8T+vQC2nuubMCy/4blxrKnFHegABIsLsjA7s4iRFiX72e3y0HS4o2bPqizLmnnZZZ6+Ip2R5914TP
	V1G/XpRzrmcdjUUnT06WjnERE2hpGYYzlRgg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wHeil-0000000HLwg-0vvk
	for linux-wireless@vger.kernel.org;
	Tue, 28 Apr 2026 11:27:11 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next 00/14] wifi: UHR non-primary channel access
Date: Tue, 28 Apr 2026 11:25:28 +0200
Message-ID: <20260428092708.71740-16-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series implements UHR NPCA (non-primary channel access) in general
(chandef etc.), for the AP side (just configuration values), and the
client (using it from assoc response.)

A few things to note:

 - I know that the 802.11bn draft is likely to change and use an 8-bit
   NPCA primary channel field, which changes the parsing. This will need
   to be adjusted once that finalizes.

 - This change will likely also come together with allowing NPCA to be
   used inside the DBE rather than only inside the BSS bandwidth, but
   we'll see how this will play out in the spec.

 - I have, at least for now, deliberately opted to keep more patches
   rather than squashing "don't parse full UHR operation from beacons"
   and "separate NPCA validity from chandef validity" as I think it may
   be easier to follow, but we can change that. It reflects my thought
   process more than anything I guess.

 - In addition to this I also have preliminary DBE (dynamic bandwidth
   extension) patches, but I've opted to not include them here for now.

 - For the AP side, I've only made "fake NPCA" patches that allow
   advertising it with specific values in hostapd, rather than handling
   the client request to enable it and updating the BSS values. I don't
   really know how "real AP" vendors want to handle this, so I'm
   deliberately leaving it out.

johannes

