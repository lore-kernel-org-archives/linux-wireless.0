Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B29DF25C80E
	for <linux-wireless@vger.kernel.org>; Tue,  7 Jul 2026 17:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783445506; cv=none; b=hLxBMJ5m0/bQ24phYJkFKh6eFPC+AbDDgsq1g+a31sEguFYDGpQ8Ep4tXIA8WvY9DzX7JBsCJ9XR4oY8HV6fJwj5MOn4NVhHjTBi5t/C2gasmeqG4iEIGBJlugkFhl1sErtZzjYuWupxYXO3dfIghb0E0pgKlF7l7sld4/Bamt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783445506; c=relaxed/simple;
	bh=CGU1azzwD9FKumK2mScuGx5ktzxfyLu5CCMHFGUn0yU=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=un91Ad9gtDiNZJbRHjv+6OGsdnK6vgutjdjLBgEFDIiSqxgH0H4SX7N2HJHVJIefvxg+ScoDZAHwFSm4LGXxl84abAf/dT+Y/33bSGXceH+j0tmsoEuMdi2r2JRuRzCEb9WtmqU1wL7wQNloa3t36lfwRinU6odDfHu3wiGuoTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=da2xWSfN; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="da2xWSfN"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=CGU1azzwD9FKumK2mScuGx5ktzxfyLu5CCMHFGUn0yU=;
	t=1783445504; x=1784655104; b=da2xWSfNCSqTmNoJNYbsaKJbENOzGiHqSBU0FQo7TO/aN4a
	QKxvCZby2rowzjV1Vf4eYVVK9JP6zQfQxwMaWMlWdLNEzYBjpVYijJnFd6Wg7tBVRD3BtO/lc07EO
	W0UGimXoZD+k88ZFbK+qCdX/s6wOQGakspM1kIlVLSFDbc3wf8JCUSoYUvFjYAL9g1/K/n5pvCYC5
	f2qrmYrDAzhnKel0ll6MlIhajR92joUh72XODR2MvBdMSp5IdM0ero/eTSUUQ7sJ5sw5KfDCuQFKq
	h/yQSBdMHyPrm5ohJLoF9g4sNHj0HUzutWH5dqDS2XNzAkecolJ+8IIypgjFGi3Q==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wh9e1-000000015SB-3TdG;
	Tue, 07 Jul 2026 19:31:42 +0200
Message-ID: <bf10372fba8d1ce8503d01106a7adf2313f48381.camel@sipsolutions.net>
Subject: Re: [PATCH] wifi: cfg80211: reinit wiphy work entries on runaway
 drain
From: Johannes Berg <johannes@sipsolutions.net>
To: Cen Zhang <zzzccc427@gmail.com>
Cc: linux-wireless@vger.kernel.org, baijiaju1990@gmail.com
Date: Tue, 07 Jul 2026 19:31:40 +0200
In-Reply-To: <20260707134925.106972-1-zzzccc427@gmail.com> (sfid-20260707_154937_036072_793D17CA)
References: <20260707134925.106972-1-zzzccc427@gmail.com>
	 (sfid-20260707_154937_036072_793D17CA)
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

On Tue, 2026-07-07 at 21:49 +0800, Cen Zhang wrote:
> cfg80211_process_wiphy_works() has a runaway guard for the process-all
> case. When the guard fires, it drops the remaining queued work by
> reinitializing rdev->wiphy_work_list.
>=20
> That only resets the list head. The queued struct wiphy_work entries are
> embedded in their owners, and their entry fields still point at the old
> list neighbors. Later queue or cancel checks can then see a work item as
> listed even though the rdev list has been cleared.

Yeah ... that's not ideal, but also maybe part of the point. IIRC we've
seen cases where works are accidentally re-initialised and we get into
infinite loops iterating the list, or so.

So if everything else goes according to plan, your fix is certainly
correct. If we get some kind of list corruption in the first place, then
it's potentially going to make it worse.

Maybe at this point it's just worth bumping it to a few tens of thousand
iterations and doing BUG()? I don't think loop detection is simple here.

johannes
