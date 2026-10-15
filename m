Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F61751C35A;
	Thu, 15 Oct 2026 12:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792067252; cv=none; b=Sq67INynhk2epyiUOx090cU591u7je9QPTw0yZt7UJx9VxYitseGZ9wCnc65cl/l3ZmVimO7hzA/Ars3Zl0RS6IdrSNE6wCReWaDMxkAVKbQN2QgwTE9fcQnOSRUjn3vDuBw95WTJOTKdnmu5CuFSGxA0IPnMgi6lIBCTBSeQS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792067252; c=relaxed/simple;
	bh=e411y3RhKnN6FFcumfBf8rZ9KChWjZILyrv8U/P4rgk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BBMTznyvfB3mc+rxTqoF5+suKzLVwGsYII6WpIZhXZGN9kudBlU8s7+6Qt5+2FLYewEm77vZ+OQaPKnrozXPtxb710d31syg7TNWc7vzhQVcbtxzr/jxrvQYU/qEhsmyt90pbs3i4PtQZ5HMpAiyOGH1xDFmAy1+dy3cYviw3nw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ELCPJSLa; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ELCPJSLa"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=e411y3RhKnN6FFcumfBf8rZ9KChWjZILyrv8U/P4rgk=;
	t=1792067251; x=1793276851; b=ELCPJSLa0PQb8bKkrE6SsnSxFLOjTeMWcc6nRn0dOcqL+hg
	n/TbXuWNhBzflpx5cV4wKhbaFoxbxgIExqZbMhbrgtbDp4pikmtsgDc1fhIljL77nEtEKjGr7ytig
	o/Wm15OR9GRlQB6x96nKQ/h/t51uvk0DLsLyQt2EbRXWxJE8F0Xgl9zJk6BDl6tsWG/nOLiHdIUTA
	S1WYIYHmgWHQKqQJbB5CXzIJTjvOuqGKYnfKGP6Y8NozQ7SAyUrfSrVvIFgPuARs+R6UMRxxGUQM8
	PhaXwYLtuyFF6yBBBaMpLEy/bGFJftwcNxKVgeuCSCOVTP7UDTtpnAmKuXYhCs9w==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xHKYR-00000003ZRA-2Uaf;
	Thu, 15 Oct 2026 14:27:27 +0200
Message-ID: <44cb773984f61ae85b8c42904ef1ce7a62e85e4e.camel@sipsolutions.net>
Subject: Re: [GIT PULL] wireless-next-2026-10-07
From: Johannes Berg <johannes@sipsolutions.net>
To: Kuniyuki Iwashima <kuniyu@google.com>, Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Date: Thu, 15 Oct 2026 14:27:26 +0200
In-Reply-To: <CAAVpQUATko2Oig53r1+VHe+4Y3fFeX1xOw5RAnXtUAGwvQoB5A@mail.gmail.com> (sfid-20261008_040528_485050_028310B5)
References: <20261007205827.467974-3-johannes@sipsolutions.net>
	 <20261007163616.1088d364@kernel.org>
	 <CAAVpQUATko2Oig53r1+VHe+4Y3fFeX1xOw5RAnXtUAGwvQoB5A@mail.gmail.com>
	 (sfid-20261008_040528_485050_028310B5)
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

On Wed, 2026-10-07 at 19:05 -0700, Kuniyuki Iwashima wrote:
>=20
> Also,
> I hope we could remove the long comment in __rtnl_unlock().

So I sent my next PR, and we could therefore do that now. I also checked
across the other places in the tree, and isotp_release() was the only
one that seems to do something similar, keeping a socket pinned around
rtnl_unlock(), but I don't think that could cause a similar problem.

I was going to send a patch, but then I didn't (and am sending this mail
instead) because I'm not really sure what we should do with the WARN_ON.

On the one hand, it's no longer strictly _necessary_, code that queues a
work item (unregistered a netdev) and then calls __rtnl_unlock()
explicitly wouldn't have any expectation of completing that soon.

On the other hand, the next random code that acquired the rtnl and then
unlocked it would suddenly have to do the unregistration work for some
other code and it'd be accounted to that thread and cause latency there
(not that it can have much expectation on latency while using the rtnl
...), so in some way the WARN_ON() still seems justified?

Anyway, the cfg80211 bits are gone once the PR lands, so you can remove
the comment (and possibly WARN_ON) whichever way you prefer :)

johannes
