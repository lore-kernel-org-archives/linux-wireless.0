Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E0F3FCB00
	for <linux-wireless@vger.kernel.org>; Mon,  6 Jul 2026 14:54:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783349696; cv=none; b=XJVmPY2JgpyxDkxKHNkJrmd5fYALaBJIXYEbWYCbJdXdb1DeO+Oy2X4qxn0A1pCKrfFV3gA3fLgxaYj3xK1T/09aCCYxi908OT13UKydozchZTiz33+qMoXOpBnUrHz3IMM01X/qRDtLeQRf4BZs1QMi9ZmELwnZ7zhnKYGkfxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783349696; c=relaxed/simple;
	bh=Kksx9x3KD/QqVq9g+mgo2v0oF2B9zffbFhWAvCAV2Jg=;
	h=Message-ID:Subject:From:To:Date:Content-Type:MIME-Version; b=CS2w+9u94uSXFwjyI033+/HwyKdFRhVqBL2dF2tWGrL6ddhVZU9of1NNPNSbD7+XxeQFWV6MJIQaAAMtHKdoDnOT0iGYDsfD3GzHofnVSysIBKFiafqiXcw/1Ty4mMHC5OvK8dxdQdwmOu6HxzTlmOJWo+yLFaERtejDHgzU7hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=JhYf8Kff; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="JhYf8Kff"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:Date:To:From:Subject:Message-ID:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=Kksx9x3KD/QqVq9g+mgo2v0oF2B9zffbFhWAvCAV2Jg=; t=1783349695; x=1784559295; 
	b=JhYf8KffoofAo1zVqxVNdyXmFtBBw12ya6lf1dkkmyhE5eU7wdFKJOVqsxRvfYYAfjUuinaRDYz
	A1LDvHENgod1K7Muy5HgbgeBoJYKOwH2/zlP+SPlsyDIsyvL5Oyh5Z5dj6Sa78Zo7Ri6DQH94rI8d
	ewFUJuahcGWNnEGxNyT5UBdu1hVDHjDzL8ozX3EFjpZi7J0a+4K9bmyCiyz2tFQw5Rnwbi/l5sCd2
	KYhah+BclFNFf89l4HTJGG+wmRDE/PLmYb3tTD8Ab2ZBilW/oBtjXF2z2btpciaA2soDM8oxlFYnp
	E+ibZYzNhzh2yHdLzzZBv6oGepRDa9wg4+dg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wgkih-0000000DUli-3vSZ
	for linux-wireless@vger.kernel.org;
	Mon, 06 Jul 2026 16:54:52 +0200
Message-ID: <cfb943ff3d7bd273d0f46293177824a7f839636b.camel@sipsolutions.net>
Subject: FYI: wireless & wireless-next rebased
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Date: Mon, 06 Jul 2026 16:54:51 +0200
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

As much as I like to avoid it, given the linux-next reports I've rebased
both of the trees. The heads are currently:

wireless: 4a360c6e18df ("wifi: mac80211: validate deauth frame length
before reason access")

wireless-next: f9202a374ec3 ("wifi: cfg80211: support MAC address
filtering in station dump for link stats")

If you have prior versions of those commits, sorry, please rebase as
well.

(neither of the prior versions were live for very long, but I figured
I'd give a heads-up anyway)

johannes
