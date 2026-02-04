Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2F9F2D0292
	for <linux-wireless@vger.kernel.org>; Wed,  4 Feb 2026 15:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219161; cv=none; b=IGFwU2ElxFGH9HZPtDMj02GLd+ZCjfMmBuVx+mt9Rbn+dfXwjFmuft9fosJx8+5OIF2jqzIqtnikESWSefSUOpJL2J83i++/3wBOcJz4zLrmo6BWU8ndH5TW0NS289zBDbWNEZoOsB/+0oCE7pumCAFseXO+St/yZJu/cwWuio4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219161; c=relaxed/simple;
	bh=seR9ckCDQrrLZQ+bGiJT7Q9b2WFmI5hOTYlGBjWy6g0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=F8zO8691YJsAra7xffDZIuPBM1PhNw2DqgwaLcNz0DI6KVgBB2tUX9EONs5crYqErYwT40nmwJGecCCvSkvu+YgSLbam+53/BhJQBaIVeFBUjNbt6ZyRSVAJ/nU3Xcy65SHCaaBQx4sQ251EAjPyXQdl677c88S1y3yA59Mdtnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=xNoMrdXe; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="xNoMrdXe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=ajl+w0tQCQH9W8Rznf4XJm8ciXAafXXOIgiya5oQsSM=;
	t=1770219161; x=1771428761; b=xNoMrdXeT33eN7jFC9PkQRC3C6IqxTr8qB2M5W3hpaTpCL5
	QptxMoY7yyKwP1iKLn2405Mz3FlDU4pxaumNuYtZvKVJ+AxjBvuZtsl4cEccGL88QuZcZfXo1HDgX
	lMihQEfSrTC95XwfHheVY578ZuFvFZSzG/DIzfXKw8UJMpHoszzCZqQ9I9GFR4IIrNhUnt7dCeZqA
	WsUHOoIJQI3tnrgAfeAq82b5BBDW7o4qxZ01uVq/cHB8SjkcgkbjSzi3+eM3zU6uosLkCx/Lqq3fo
	qiKJJw4+SPzr4xSU5x8uvzOt3rjqesMpmYsLjoNPzHtCBqgOZlZ8DbDJ6nEXHKSg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vnert-0000000ETqQ-3Bou;
	Wed, 04 Feb 2026 16:32:38 +0100
Message-ID: <da71512c862e91e6394184f2b6c39dba009a87b2.camel@sipsolutions.net>
Subject: Re: iwlwifi: Null deref in iwl_mld_reorder
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>, "linux-wireless@vger.kernel.org"
	 <linux-wireless@vger.kernel.org>
Cc: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Date: Wed, 04 Feb 2026 16:32:36 +0100
In-Reply-To: <ed9ab029-a762-4666-85ed-7a67ec7c1b52@candelatech.com>
References: <ed9ab029-a762-4666-85ed-7a67ec7c1b52@candelatech.com>
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

On Wed, 2026-02-04 at 05:41 -0800, Ben Greear wrote:
>=20
> I guess the compiler optimized this somehow so that crashes are not actua=
lly
> seen in this particular code path.  Also possible that it is somehow exac=
erbated
> by some local patch in our tree.
>=20
> But, probably best to assign mld_sta after the NULL sta check.

Admittedly not great, but

>          struct iwl_mld_sta *mld_sta =3D iwl_mld_sta_from_mac80211(sta);

That's just a pointer calculation, ie. mld_sta =3D sta + offset, so
there's no actual dereference.

johannes
