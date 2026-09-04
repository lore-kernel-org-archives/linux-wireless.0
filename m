Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D92BD18DB2A;
	Fri,  4 Sep 2026 07:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788507722; cv=none; b=jDDUDLk/7HIirq/6njKKJETPwYwDrYxjy0hX4W8/7ELgyaFQeoQrgANkJp3+IzaD/OuBRuk+1CjTOE6pnspWzrRJjiC7PyRDcEqCpS0ngw6U61goGeag4umWZqykva6GrEgLSfys7g7xJUEOuocrT6OokmoClbKAzoW4C1rdsGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788507722; c=relaxed/simple;
	bh=yFURoIvUehAIIMb4Yg50lERt4SU4xnCGpFV6ko4GSWw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=NG3jr5NxZaXzOWgBzgr9DxITxqkLP+77YELKZIC98CaZsls89UfzjcGGG4ymm7bAKR2BdXPvsseBelGtJJs/LYwj+EPbGRgbS/NuPJfCNhpApOXMLSnuk3KWxxFJdHFjFVaWB4R4toiZlsIlkcLM/uUiugyBq7MR3684kQRwGaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Gd0M++KF; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Gd0M++KF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=yFURoIvUehAIIMb4Yg50lERt4SU4xnCGpFV6ko4GSWw=;
	t=1788507720; x=1789717320; b=Gd0M++KFwhOng80dnuKmnbo7cbgrbvHUTgDDcGf3ADgLOii
	IVhrBWmD6kDQ9AoaSw+9ZBLKztOH6KVif89ZPTlp6FpTb2w1dJ54uYYCljoEsSprwW1u0DX6V2vB5
	Vq+ENvWQQHC+pvC2UuH/Log0Oz6TErpR2HisASDIqwTaKgL28XoT4IzZQI6Qp6qG8x/yB+JPYtrRS
	N/hXR1HZgxASZggXjw8jdkIOS6odH0VkgS03ccKwEWND0NlEBf3RcFFIBkp5Y3NVG5HKfXzryaqfo
	LO+rGT41QBEYrBxCjlEe8T9/sm73w7Br3B4Oo5p7fv09cWm/jnEP27ryVbwsn6qA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x2OYg-00000001F7R-0IPU;
	Fri, 04 Sep 2026 09:41:58 +0200
Message-ID: <12f4b21bb334a49c88bf28428b92589adecfa53a.camel@sipsolutions.net>
Subject: Re: [PATCHv2 wireless] mac80211: stop tpt LED trigger timer before
 freeing trigger
From: Johannes Berg <johannes@sipsolutions.net>
To: Rosen Penev <rosenp@gmail.com>, linux-wireless@vger.kernel.org
Cc: "John W. Linville" <linville@tuxdriver.com>, open list
	 <linux-kernel@vger.kernel.org>
Date: Fri, 04 Sep 2026 09:41:57 +0200
In-Reply-To: <20260815190724.16943-1-rosenp@gmail.com> (sfid-20260815_210730_234011_D868352F)
References: <20260815190724.16943-1-rosenp@gmail.com>
	 (sfid-20260815_210730_234011_D868352F)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Sat, 2026-08-15 at 12:07 -0700, Rosen Penev wrote:
> On a hot unplug, the device is torn down
> through ieee80211_unregister_hw() without ever going through
> ieee80211_do_stop(), so the timer is never stopped.

I don't buy this.

Also, missed wifi: prefix.

Please don't just feed me LLM garbage. Do you have a crash reported on
this?

johannes
