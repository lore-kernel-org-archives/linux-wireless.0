Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6243F2BE639
	for <linux-wireless@vger.kernel.org>; Wed,  4 Feb 2026 12:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770206749; cv=none; b=L09zEXYWIhW5XjdaKIfPFXvdfD1KjCZePBW4VKXHI+8dSdJcFMtZJOfXMbz1wV6vIOLUjIVcmh/M0XLTGqoivgT1jAg8YaQ9kArVPAvYOJTkJgHSn1tvM+CsjuyloWwSBkNKLFELUQiMkUgcuL/dWnisVM01rVhwSoN9yNIlyKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770206749; c=relaxed/simple;
	bh=8draj2+XKXYqJuJ0+OMFjNtUAyIyqg64fJ8mffjZ8v0=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bC2xTHLbSfRnfwhpL0bOFyT44Tu4pW4wb72ODR6M8TsOxhJTuDFmWunZnV12l6bMPRCe/CyBKKgiFqVTf2c0Y+TDON6GhW2OTygVwrAKSMzUWig8THsINsGlQBK8rqxScP1xdMChOkPEO4JvLc4LnYCdu2Td0iZugZxiBV3XGnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=aJjQhrvl; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="aJjQhrvl"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=8draj2+XKXYqJuJ0+OMFjNtUAyIyqg64fJ8mffjZ8v0=;
	t=1770206749; x=1771416349; b=aJjQhrvldHDNiDowrjx2TbKb6C2pz16py8Be+qzk0Ed8P9C
	QhtNv6yOzChbaLSdKcyx6WQAjDWi/Omcf+m2a5KFHBsKO3GO8pHWa1y2nSm7iF9uPfLubE0OKGr1b
	m99I/CzSGRorVGQhwG2DZSleE7pwZn8sscpsrT6aegsuuirc19u9nbfC5UtHkeqxeRxSy0VfAwsKs
	nZP9rixZFpDC/OVOM41GVHN3w+ewYhlDzGG+CnFSpCo32/NPcR7QCpZ3wNnBvdBTLaASwp4cAc7zP
	4BpJq7eFfwz2WWfO07vg6wTILl7Tad7F7sHvQd3hKmU8jRI8lHmUYgMDkWeIQaEg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vnbdj-0000000ELTj-19Ks;
	Wed, 04 Feb 2026 13:05:47 +0100
Message-ID: <6c4341040006e667e0bda79aa8a46111c6ca9ae3.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next 0/4] DFS/CAC changes
From: Johannes Berg <johannes@sipsolutions.net>
To: Janusz Dziedzic <janusz.dziedzic@gmail.com>, 
	linux-wireless@vger.kernel.org
Date: Wed, 04 Feb 2026 13:05:46 +0100
In-Reply-To: <20260203185717.103810-1-janusz.dziedzic@gmail.com> (sfid-20260203_195733_222042_8F0E51FD)
References: <20260203185717.103810-1-janusz.dziedzic@gmail.com>
	 (sfid-20260203_195733_222042_8F0E51FD)
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

Hmm.

This patchset causes dfs_cac_restart_on_enable and
dfs_us_chan_switch_precac tests from upstream hostap to fail for me, so
I'm dropping it for now.

johannes
