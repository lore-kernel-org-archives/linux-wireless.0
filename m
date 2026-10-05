Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D38377EAC
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 20:50:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791233403; cv=none; b=Lv2tnDiBxwwAN/n11ad1817wYadMFpUNPDX912Hf2/dQoSp5vGpMG2Cc0XuZXVYB+rdG3Mjc3snS1MwVxnPV2HYfDiM/EHEvY6BqAbwq02UcA1LhlZHgKKEIZ4mQPUrnX1p9YmEopDsTK1UC8KKzwPB7zQAB0YU6CHuthfkA0s8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791233403; c=relaxed/simple;
	bh=YsLPm5TlSpFGAtpj5+xfChb4msLDjRjgSfdo+zTKmdA=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=PwT7PsMfm83MD6LmK8Hx7pDVm5lXUst9zzQ+kA8OGMYqTwZOGLFgMEZOTe+wmnz9GJR0rZnZ0YZRKTHCyoB8CWAYwlzEc+ZcbLKVLZhvTSj8aFMizpWbEYQvkClt302PfVy6X+CC96b7oGJm2VE6V6b7s/JUmjWDGpGuAoDEJLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=YfXCxqSI; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="YfXCxqSI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=YsLPm5TlSpFGAtpj5+xfChb4msLDjRjgSfdo+zTKmdA=; t=1791233401; x=1792443001; 
	b=YfXCxqSImfKh9tWPfHU53xyURdRr3Z38ED/49aPiro+m+L7mM1L8p7EGCRSmlqR4akJT6pKNsBO
	ep36yf3w2HDWak5XX/j1avJfgh5K0vS+29YqX4qVqlubTTFVex2VmldwbxIe+4bKy/mmj1Xh+AC7U
	PLeWCwXWYgjnblXjDWY11PQM7Ds5NyyoP20IaxiXODczeEKhQpRC7iIM82b5vqhxuuAKLq9FpWMUt
	jZI3/ZyHFpVLiUu9KMoSIkmU7Xmv4/0YtwxJU3ytjsVP3kzHoyiWHEi/oTy3vx8zv3XDVpc7Y261B
	ZZMcxmHUpr1DAlCaIuJKezbr34Zf0v4hEC7Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xDpdB-00000005cw8-2jIt
	for linux-wireless@vger.kernel.org;
	Mon, 05 Oct 2026 22:49:53 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [PATCH 00/10] wifi: nl80211/mac80211: Sashiko fixes
Date: Mon,  5 Oct 2026 22:47:51 +0200
Message-ID: <20261005204950.2303430-12-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.55.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

So Sashiko started reporting bugs (in private) now, I took
a look and knocked down the obvious ones...

johannes

