Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C941634D3B5
	for <linux-wireless@vger.kernel.org>; Wed, 15 Apr 2026 12:12:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776255176; cv=none; b=n/vqlPVbU+SQMCPusrI3j9y6n/HkaB30FOHjNRAuzBDjkrp6nraUuG0oWesmVAngRYUNU/4/F+l4tQeC8N/G5d6DRT7+tAxKdaSJ2GG8v+qiV+IvbqmDWo1GVj3V0NBTJPIXlOubY4uq9CsXrGkGTwqyVzLLfxXjCnYZlpX16OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776255176; c=relaxed/simple;
	bh=V47QstzcxjQgrEIc4raXpZ7cg3JthIkx0h0koXK4RDw=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=fDv9mtYqyF2E1Rfr2P9qP56PZyBWu1GLtBD+m0yFZqVgWtC2ynYnuot1pFz1fenX3KGs2Krk20gIlrr8OKAM6nc3vjoC5aI6pEKN6ugrqsOHhqDNBN0rTiO5RwzAaufa5rgzHpQ1hXKL3V9BpGSIvwqyDiESoZ5y76QPAtdwfBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=fBNEV1Me; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="fBNEV1Me"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:To:From:Subject:Message-ID:Sender:
	Reply-To:Cc:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=V47QstzcxjQgrEIc4raXpZ7cg3JthIkx0h0koXK4RDw=;
	t=1776255174; x=1777464774; b=fBNEV1Me18m5jaUujVnAnNYAmdkcPalur+RE6Rm1OqFgFiA
	O8BCuDxum+KkOTc6CBW4Rx1rRt0duHH3Qg45D7qUmaGQIEh+eEWJ8VHWxhxQhJ1AYq6GlVUpE4sTw
	yMXmo8ctz0yh47aHwDRmZLhLqSFzqEkww+icBpRMmyLSn67cjoYy/xuyeR4o1JfY+vJr0IjimQvnv
	WF5mwWY3ok7FNbTTqaOv5/+oCauG77ASl3dJFMpPlMNHjonr6Q+XTpTBfrjLwXT545YF2aIy7uFhK
	mn+hP8h3bRP1GwJlmE96xIWT/0AdOMg0i9HqdfOIeXXbsZIncYRSBI1sAq8a+MPA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wCz6x-00000006NnU-1zRJ;
	Wed, 15 Apr 2026 14:12:51 +0200
Message-ID: <fdcc6bd175d5f241ad9d4547075149ce3a6853e8.camel@sipsolutions.net>
Subject: Re: [PATCH wireless-next] wifi: radiotap: add definitions for the
 new UHR TLVs
From: Johannes Berg <johannes@sipsolutions.net>
To: Miri Korenblit <miriam.rachel.korenblit@intel.com>, 
	linux-wireless@vger.kernel.org
Date: Wed, 15 Apr 2026 14:12:50 +0200
In-Reply-To: <20260412152605.73e682d0c8c3.I5a0c858467c852b7a2a00f580bd073af29c37705@changeid>
References: 
	<20260412152605.73e682d0c8c3.I5a0c858467c852b7a2a00f580bd073af29c37705@changeid>
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

On Sun, 2026-04-12 at 15:26 +0300, Miri Korenblit wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>=20
> Add the necessary definitions to create radiotap UHR TLVs
> for UHR sniffers.

Any particular reason you resent this? v2+changelog would be nice then,
but I guess I'll drop the older version now.

johannes
