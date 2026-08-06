Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C529381EBA;
	Thu,  6 Aug 2026 07:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786003047; cv=none; b=mm75PyYqluQr+ux4z+3rYwvPZ7FiKo6/LV8StROGvpediQ6nUABvQA1tdyQFNZ9B+qIX5/l0Bgryxm4O2+e8e63sN1KOP8/WgvfrCovPVKtgDeOeySkF80Ji8QDeVlfA5b9fV1x5fcW24SfRqWYlx333x1QhGoj2/cD0lScHk9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786003047; c=relaxed/simple;
	bh=O5sbEBCRRFAg6x4wU9GXPuB33BhdLkx1hxZNd5hg7vk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=A/5Ju+2hwngMI0tzKwBSDEWHbNrTmx0I+QG/SIvfOmInWBEyBGBs9k3ucIgNc9FW8Wa54fYxEoA0X+ctZydGdchFPxUCyeMGUS42+Ww8YC09c+rGOssEnJGUUZinM5TsT1XMB41SYHjlCd+gRUFiTmwZxmkQjox2l9WvPb9s+oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=ivm2O0n+; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="ivm2O0n+"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=O5sbEBCRRFAg6x4wU9GXPuB33BhdLkx1hxZNd5hg7vk=;
	t=1786003045; x=1787212645; b=ivm2O0n+j9z71QogcjHVZTYKkIEeKCeBvBCskds8XljDG9M
	l2+h8Q8nFw+344Z4UJnxwVxMSRATrdl8KeUv3QlM83K7e7rh4IPFtYyMZAFkpujTSd0M/SUubiEYP
	bMFfZDaEcoXmxt+cQfb7k0JgI1X3FMU7face4sMxhJCuqem2a/4ACnfqb9vBrhCSz2Xl97LjteWjH
	jYkWnRN6U/RZEftoczsTcXYnuh26Avq/SYotGugIX670c/OXpiNrOyUhcITT3cgcowcTRXO2pzNSX
	p6NMGvUze9r/KXgXs1EspoMJj2QuQKEiXgrCwRhcjmKTnKDywvDvWDuKWNujIWFw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wrsyY-0000000CdAR-1SH7;
	Thu, 06 Aug 2026 09:57:14 +0200
Message-ID: <3b6c46b6d79f3a0e0ded2967db3cfd469314b05c.camel@sipsolutions.net>
Subject: sysbot AI patches and wireless
From: Johannes Berg <johannes@sipsolutions.net>
To: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com, 
	linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev, Slawomir Stepien
	 <sst@poczta.fm>, Krystian Kaniewski <krystianmkaniewski@gmail.com>
Date: Thu, 06 Aug 2026 09:57:13 +0200
In-Reply-To: <068e46b5-0c88-4432-959a-b9400d9691ee@mail.kernel.org>
References: <068e46b5-0c88-4432-959a-b9400d9691ee@mail.kernel.org>
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

Hi,

> See https://goo.gle/syzbot-ai-patches for information about AI-generated =
patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.

I'm going to state, for the record, that I'm going to make judicious use
of ability to ignore patches, and apply it to pretty much all syzbot-AI-
generated patches unless a 3-second review says "obviously right".

In particular, I will absolutely *not* "comment on the patches as usual"
and argue with an LLM that can bullshit out code faster than another
computer can even deliver it to me by email.

Whoever is currently pretending to be the human in the loop *absolutely*
needs to think about the patches, and if that's happening it's probably
no longer an AI-generated-sent-by-syzbot but you're going to rewrite it
and send it properly.

(IOW: get lost, syzbot)

johannes
