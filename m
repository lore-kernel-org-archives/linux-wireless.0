Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918B17E792
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 09:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791711197; cv=none; b=S+s+o0ZdFoLSMt0PP2kRFD91mvJDDBVMkWlFo2K1gxK296tpt0z+DeVtZPUTIbCM8Jvpax+QX6TyiX+iVjtVNdFnTsuhrVIdNs0emwrsDPpk/ytbKYeeaMT0493vjFxfFM2tIQB5h7Nmiw0LFdnnckD3cTI2YXAIa8DfLBvV3Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791711197; c=relaxed/simple;
	bh=8FYhtZjWIXPG2qidHmQXn33t9n3ElGfCTGQQgHMxMzY=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=GgzC2n69wKBX+OyKUoNCDD9Kgm71F2UJ15BBaI5rMVIjz4nQxQlc2wTWl10V/2BRhAFoU5aVox5xBGXWnrPiOX4mRjtooPT47GQfUUBKSufJgw/4dM5eCoV03apsNn8oC9SR5USh4WRqs3/WQ1lJTuZGDCGv/+8GUh54prQW61I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=gYnxsL6M; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="gYnxsL6M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=8FYhtZjWIXPG2qidHmQXn33t9n3ElGfCTGQQgHMxMzY=; t=1791711195; x=1792920795; 
	b=gYnxsL6MHjwVYs4ijgYwIMgSA13JWsgXPS7NuwqrA0VInsNcLuXx8/mFG32Z2Kx9cpvJmNtUgSw
	7LdaNSKmfC2O9IZGbkWfnz6QEsBwG9rnRxWFLxHHXoiqmbLvp4YoAGI4xgS3BjhTfAZJxwYc8mgAw
	LxXV91f/+/gap+UbqNBgGJNnZycTDC08y+D7QiuT3mKVnT+q4IfCBYOrbvEdh9zUy//LOPOYTjNIR
	tXJLXsiHTvBGjqKpaMjLgFKkBdOiDKvq6dyUvAWDPLQt4DEcFilMZHzQbeRsGkJGov4Epj4pvSYqC
	xFyBaIYRGl/dS7AvXv83Hptv14s4K+rWtk/Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xFpvc-0000000Dk5j-27CR
	for linux-wireless@vger.kernel.org;
	Sun, 11 Oct 2026 11:33:12 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next v2 00/10] wifi: further RTNL redux/fixes
Date: Sun, 11 Oct 2026 11:31:23 +0200
Message-ID: <20261011093308.49945-12-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.56.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v1:
https://lore.kernel.org/linux-wireless/20261009145703.243031-11-johannes@sipsolutions.net/
https://lore.kernel.org/linux-wireless/20261010160459.229064-11-johannes@sipsolutions.net/
(the latter resend)

v2: new patch 7 (hwsim)

Syzbot reported UAF in hwsim, which happened when the name clashed at
registration time, and wiphy_name() aka dev_name() was freed due to
changing the name. Grab it later in hwsim to avoid that.

johannes

