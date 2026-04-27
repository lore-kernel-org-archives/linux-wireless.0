Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFDB37702E;
	Mon, 27 Apr 2026 10:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777286204; cv=none; b=qyWsTH4BPI+kIBxLPg9ZLIN0/Um4+qOwELLo78eKZjqnOCq8Mn2Bpjds13BzPSYdDeA9dW/oPoVYyfo/ddVjeW+lcEfMnp+DQfCulTFiCwgvFGwqjGaPQ/cqpg+OyqcUAWTX4h8yw/eYzkBsoUAMBbTsVcoxFnZXxQrXBRWu77U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777286204; c=relaxed/simple;
	bh=hPb1Hp68ntuFENnEQeGnp9cz6z0WQsXRDlpBvjQVfUI=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XvECJNUFwATU6lj6+Orr506fap1wXoWMutMGOP8CAY6YrGFA5Ow2KGAF6MZhpAldg1IqVF1AyyMra/PM+KLqLYIp/OF9sT/Fmtba6y79aLcMjFDHFy+v0RAv9yKfoArQN2KrIQ3k+nIqlEEoF7NrUhayLetv9w5Ufbki5W20LkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=W6T4r+RS; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="W6T4r+RS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=hPb1Hp68ntuFENnEQeGnp9cz6z0WQsXRDlpBvjQVfUI=;
	t=1777286203; x=1778495803; b=W6T4r+RSNRcQuMigwFduJeG4AV2pQTuNi72sHM9h2pMEkEP
	rWyVUUjz/1xtT9KtVmeE77nO8VMSYJQvptJuXNKb1eK59RNvdS5wf2zE/jGsiKodFQU//JnJA1+rK
	BNwMDo3tima+G9hr+a5COXuPHEEdaU6FXk/FVap880nw9RAAUJpmJKErRK/AAJE72hzN9NW/cQsL7
	uNGyiLQPyxIpVcFMhdUN3A5CNNp1tiaWFrFosAo44YoFlRZoglEBoWnyfzU+oN3FGTvUwZKF4AY15
	MLRgfDL9F0/hO1XRyUWt/IMFgKab7DndJ6I6fyoHCMaiN8qC0UrUhXla+oIf0p7A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wHJKS-0000000EqXi-2mQV;
	Mon, 27 Apr 2026 12:36:40 +0200
Message-ID: <7d6e5942b1da502ae011da8e1afc898fed1b44d8.camel@sipsolutions.net>
Subject: Re: [PATCH] zd1211rw/mac: Fix out-of-bounds upon RX when
 unassociated
From: Johannes Berg <johannes@sipsolutions.net>
To: Lubomir Rintel <lkundrak@v3.sk>, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Mon, 27 Apr 2026 12:36:39 +0200
In-Reply-To: <20260415170810.1809398-1-lkundrak@v3.sk>
References: <20260415170810.1809398-1-lkundrak@v3.sk>
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

On Wed, 2026-04-15 at 19:08 +0200, Lubomir Rintel wrote:
> Upon plugging the adapter, UBSAN complains about an out of bounds read:

> It is correct: if zd_mac_rx() is called when unassociated, the channel
> is 0, becomes -1 under assumption there's a proper channel number
> starting from 1.

The 'unassociated' part here seems rather misleading - it's basically
when it's called before mac80211 configures the channel?

Maybe zd_rf_init() should set the channel to 1 or whatever the default
channel of the device is? I'm surprised it even receives anything before
being properly configured. But I also see no way to ever go to an
invalid channel number again after the initial configuration of a
channel.

Never mind that the reporting is also racy, but I guess it doesn't
really matter too much ... I had a couple of these devices but they all
broke.

I don't mind applying this patch either, but please edit the commit
message to not mislead about association. If I'm reading it correctly
then all that matters is that it receives before a channel config, and
that only happens as a race during init.

johannes
