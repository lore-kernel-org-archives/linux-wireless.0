Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 848A73B531A
	for <linux-wireless@vger.kernel.org>; Tue,  3 Mar 2026 14:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772548480; cv=none; b=g9SmO4ZFJUaOEffurhUy2tNRwD/v/wYeKyuvK/+HENuO+ejbPOalpx0pcOJh4Q3XxYwu2dFruGe8120MWW8jnE55YcfNMyBpYIT5rWWaRDT3LxL7e9EVdmJWZa0FlRBhGalUxuq/cag1L1ZZvpR78BcUNPFxRQd2ySNnni/vGGs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772548480; c=relaxed/simple;
	bh=yywQOKR5ijW1J+hvDj80HlpeeiFgT9GIifqyfAlNNbw=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Nbd/lGxyaxMZlWL1dszr7RTjFm+naLkuBcAaR1ppejc+xixReKOIQ4z97ua24clChblANDqIkIsP9oSkA4qY4v0MLvhlZh/MgdfR0hRuW51IO06pPZURj5/Jl7ffoPufCXvgPEIPIEavrG38IX4xXJkKGBm8hRUuhhVNacQ5VSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=fN03D6bs; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="fN03D6bs"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:To:From:Content-Type:Sender:Reply-To:Cc:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-To:Resent-Cc:
	Resent-Message-ID:In-Reply-To:References;
	bh=rXrtp3L62P+2sA9yzKzhf0AGP9TTkTpbaBsh2vCX1zM=; t=1772548479; x=1773758079; 
	b=fN03D6bsQeuc+YvrEmBAYQ31GxDZZucTMd9GDpTbf4zlthwHY56Map+NXIEAEXdPX5HGjJ8yIHv
	g2FkiS2jmZQGAoSWCa4dmkM2NpLvTmc3uHJ+8KOyw9b5o+n73NoKCuQMRerlenEK63VekaZ5oqL71
	AhXOwXt2JkygrwM79+DyWfNpaIVEhKRRzhsmDOOCigB85Xt8yD5Qi05jcX3oFotbhETytllgfh9Db
	JbQ8edDcLLPPzshWZo+cXqpjabYWKJql3bJM/Lc8YscvrYcr1paC4VJ7hnoErGOHoBFxR8L7kIPCX
	y3w9FdUt4wKjQKBW5lRpckPW7Jsf0IkweJjA==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1vxQpZ-00000007A1T-16T2
	for linux-wireless@vger.kernel.org;
	Tue, 03 Mar 2026 15:34:37 +0100
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Subject: [RFC wireless-next 0/8] initial UHR NPCA support
Date: Tue,  3 Mar 2026 15:26:55 +0100
Message-ID: <20260303143434.273141-10-johannes@sipsolutions.net>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Here's the UHR Non-Primary Channel ACcess (NPCA) support I've been
working on.

The idea is to represent the NPCA channel/puncturing in the chandef
and have the other parameters per link. That's maybe not compeletely
right, but having them all in the chandef seemed too complex, and
these have to be there to be able to set up things.

There is, however, a problem with the way I've done this: I'm now
checking that NPCA is legal, i.e. the NPCA primary channel [sic]
is actually in the second half of the chandef. This cause problems
when adding DBE, because DBE extends the chandef as well, and you
could have, for 320 MHz:

| p |   |   |   | n |   |   |   |   |   |   |   |   |   |   |   |
| BSS Channel                   |
                | NPCA channel  |
| DBE Channel                                                   |

p = primary channel
n = NPCA primary channel

so that the NPCA isn't actually in the second half. I think now
the right way is to actually represent it as in the picture, but
it seems the spec is also still evolving wrt. the intersection of
NPCA and DBE. Some folks want NPCA to be in DBE but that doesn't
seem to work well (to me) with puncturing patterns etc.

So I think I'm probably going to change the chandef validation on
top of these changes when adding DBE, and then we need a separate
NPCA validation function for mac80211 instead, but that seems OK.


This is based on the patches I sent a few minutes ago:
https://lore.kernel.org/linux-wireless/20260303152558.00e7bc8e9f4b.Iafdf37fb0f4304bdcdb824977d61e17b38c47685@changeid/T/#u
https://lore.kernel.org/linux-wireless/20260303142641.273071-5-johannes@sipsolutions.net/T/#t

johannes

