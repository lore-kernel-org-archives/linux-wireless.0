Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10864379C5E;
	Mon, 12 Oct 2026 13:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791812156; cv=none; b=RS3CeuomPl5s6ELs/AX30XefsYeWX4d72MW/yiU7vMteKcQDSEUejIzhZj+Z7lgbnJDY8ziNojrTt1sxcozpsaQNz8t1Ktrou9rSZ5rTKMvhT8pjxzvPJEzHAsn2SH26jfBczYTAuM8Yg5tkEQf5WWHVkIidn5hL/rvHjdmzAp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791812156; c=relaxed/simple;
	bh=Pj+zytdzrV/KVroohs8MURj9Nv6CGRAXvzVJT1zVv+4=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=tzL68afB7TEoxylCjYfz9HNQh5qqzi5q+O1codpPPvb54BC2V7mvPIbLAchMvqaBZUaLHU/iqrfTPAg73hdp0NNG5bBqScXOrObNuk8S4j4aoQbq5T4a2PHifsor8ZZIj80sk5F2wff6Xf0agbwmxOpPM3pruQ1DWcwhi9mexDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=OJvI5iJz; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="OJvI5iJz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Pj+zytdzrV/KVroohs8MURj9Nv6CGRAXvzVJT1zVv+4=;
	t=1791812153; x=1793021753; b=OJvI5iJzMf4wiYa5zObYZRJm/pVupZBmc8uQxoCVcQiu1Kp
	d7EvyuEyQSBLECQYO/VPdjYojTps95+sRvMxV7JfRK/2mXp3bXYnQgU1ttSTtvklj4MkIPCN9xuwz
	by6HdcpuN85QgAVmVjJxcZioE8aj7uUMAtoahNTA7b5MAbS2xkUh2+SpR83Itzye8zlIDZVBADHVP
	vsGgcUxi2RmFKJZTPnGbCaJR74RUZVVQLV25Sy7mxJ45eLtGQTUjFNFWHcClJzumNaklGCjfushkH
	8u4cVC5TGal0zSIkmF9jilDkDgxe2zbhMqkaCRc7eMzOG4OOXFWMYp3J3kbWMzYA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xGGBr-0000000FfzR-2qWo;
	Mon, 12 Oct 2026 15:35:43 +0200
Message-ID: <0361e4f89508eaf9fea291d949e4eb21f8d6e839.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: cfg80211: allow IR on a channel the wiphy already
 operates on
From: Johannes Berg <johannes@sipsolutions.net>
To: TangYi <1914018426@qq.com>, linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Date: Mon, 12 Oct 2026 15:35:42 +0200
In-Reply-To: <tencent_2B956CE56BB4DE6A4748896922E04666FD0A@qq.com>
References: <tencent_2B956CE56BB4DE6A4748896922E04666FD0A@qq.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Mon, 2026-10-12 at 20:59 +0800, TangYi wrote:
> Self-managed LAR devices (e.g. iwlwifi) that have not yet learned a
> regulatory domain flag their channels as NO-IR, typically without
> setting IEEE80211_CHAN_IR_CONCURRENT, even while the device is
> associated and communicating on that very channel.

This isn't how regulatory works, sorry.

johannes
