Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 615D94E01E8
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 10:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790849413; cv=none; b=RMWe2Txc/TqjnFFSvcBm9PWaqvI8K/UZYcjcklflA7xO7FynQfKoMsCPnsavBrbICuUn6hvy/vDocAQBUOrRsNeJVKcZ4/B8ctGPcs1wgmS3KdejqgK0uZwKpl548CYnW1wcUor+PKx56e371uyCaq22DbluFi6ZjWeqkbxPrFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790849413; c=relaxed/simple;
	bh=7RZ1xxcsc7CqaGbUt1qaId0J2yRMRHYz96e2VuvNxCg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=t+UwgdqAWrvB2TMT12h/KRI181tCRtFwYGTO250L25t6RZHfxyzT21/7QFCibv68+vuIZXA/bdKWx6zgOb18cVTTQUI6LRt+nmnzsqcqgjherlg8Ki1bjDoih0rNmYYKYGzi/0VHDW0bFJt5fbMfOv7ttJBi6YAoKWUPHeLqG34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=T0iE7Gmz; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="T0iE7Gmz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=7RZ1xxcsc7CqaGbUt1qaId0J2yRMRHYz96e2VuvNxCg=;
	t=1790849406; x=1792059006; b=T0iE7GmzUIxMTp1pcw1IekNVd6SJOkL2+TKpKMPt4d3Zmfp
	z+jJT0tISvE1ZvAyJHBMAut6eMzZ0ObkDn23hOYXUeP5JXe1kfEcmmYEmhqCWZUDvWhxqwBwPzsf7
	jXaGJnGrh0J87MCF71LHZlbl/Yf+rnaSjMeg0GhiaNoeI/Eqi2YXVLKnbudYdc+Mk+8RMLoCbicjT
	oThaZRrJbZ2b6D0/h6kRfJe9/9SB3Wo8dFPjyKHNCErHmB2CJNrylTm+Hj4HvphEytnaKugoN/B+l
	MQJeegJ3rpdrFw5dtU8poSmo4+0pDicyeuYeWp5CbHQM3HhIwADEWGBrYuq5Ylpw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xCDjl-000000001zr-3ecx;
	Thu, 01 Oct 2026 12:10:02 +0200
Message-ID: <c6483fff1146ce90e056f806363fba7e7fbb7377.camel@sipsolutions.net>
Subject: Re: [PATCH 2/2] wifi: nxpwifi: add netlink vendor command for TX
 power limits
From: Johannes Berg <johannes@sipsolutions.net>
To: jeff.chen_1@oss.nxp.com, linux-wireless@vger.kernel.org
Cc: francesco@dolcini.it, Jeff Chen <jeff.chen_1@nxp.com>
Date: Thu, 01 Oct 2026 12:10:01 +0200
In-Reply-To: <20261001100640.2829946-3-jeff.chen_1@oss.nxp.com>
References: <20261001100640.2829946-1-jeff.chen_1@oss.nxp.com>
	 <20261001100640.2829946-3-jeff.chen_1@oss.nxp.com>
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

On Thu, 2026-10-01 at 18:06 +0800, jeff.chen_1@oss.nxp.com wrote:
> Add a cfg80211 vendor command that allows user space to retrieve and
> update firmware TX power limit data through a stable netlink interface.

No ...

https://wireless.docs.kernel.org/en/latest/en/developers/documentation/nl80=
211.html#vendor-specific-api

johannes
