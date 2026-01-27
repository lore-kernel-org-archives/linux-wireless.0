Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F4471DBB3A
	for <linux-wireless@vger.kernel.org>; Tue, 27 Jan 2026 14:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769523011; cv=none; b=GDL2s84FdrICqI9fW62Sw4fagZ3vLaD88c8kZN/CfQVZ2NzanJwfQYChl1Xj0MvXp3LIsYfOibzVyUYKBOtIOWVQmXNh7y1XIaUZqnFg1dHJwm4cnlIC5FF5IwO9PMBNohNZziiQHu+TblauQnTdhaiupuDkSE4ErKNPVPN6INk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769523011; c=relaxed/simple;
	bh=jmcv7ln0u6D2gX4ZgxJc4xt/DBE1Js3GymS7kWas8eI=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=mEzhnMXn9lr7t//4vPCN76y+zmFYTHJ9cEksCsKCEEyoq6ZwG65SUZWO7RcC2CiVi7U8VDOKiFMu9G/XBuiRdLrt/Pj84p/RLfYRzEFJoIN9BkpWAQ8BFTd+SP3pwf8LmZ+LiwSphWKPMc7L/6CSCzr6T+lWlJyAREo6XhMXyv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=vAGlKXmG; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="vAGlKXmG"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=jmcv7ln0u6D2gX4ZgxJc4xt/DBE1Js3GymS7kWas8eI=; t=1769523010; x=1770732610; 
	b=vAGlKXmGtDRpfAdtM5ExyvEjPJprZl8A+g3Rn1Ob1zYX+YrmmCf6cNObJNK2tLOBHXImh16TwYp
	B0XUZXURNk/RSk0HVR3vEi1vldK5j9vqJFMXNi73p/4nL5bLDOfTSk3QMdeplc7OiNpQKtaxWmd8/
	V/xgUMn7cPmoeqewKtmtKqOOpWGRBfhEPJAA3JCHLH6uBkrMLTb42ay+Md0XgC61Wa8ptHI6cv9sm
	364Djsuzhfn3zOcphKNPsJm6t2oGFIZxN3iVTZFxvXGGNron5zaw/Xg+DzMyj6yNWsnD3EI5wrgOq
	6c4hTlWFxweNUJFrs5Wv7CDanw44ZubjPkYw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vkjlg-000000051Kx-0Gx2
	for linux-wireless@vger.kernel.org;
	Tue, 27 Jan 2026 15:10:08 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH wireless-next v3 0/3] wifi: initial UHR support
Date: Tue, 27 Jan 2026 15:09:18 +0100
Message-ID: <20260127141005.583581-5-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No major changes from the previous version, and I do expect some
fairly big changes to this will happen with future drafts, but it
seems like we should start having something to work together on.

johannes

