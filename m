Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95CF0396572
	for <linux-wireless@vger.kernel.org>; Mon,  3 Aug 2026 08:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785746428; cv=none; b=YP0ng75tvA5yxVUiYY0ULkecerV77+3aNtHfn2M0YY80jwBrMTD1UmMZ0ehyRD6l77kGb+HKql2IiX6KI7qCELPOyFKV3UTE6pC1GqeKCZsktVMYzggoe0+S8LEsJYVeLRjkkiyL39d9wPUEdU0A5I7n8XL/gXtBah9H3g29DpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785746428; c=relaxed/simple;
	bh=XecuAQOeYhiDAxs7Uok4jrs1j4cRg33NLWqrdiihqiM=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=cs+amTd9136G8aQF23BlBDqkeI+HynzituB/zCHwQwThvaQezg7rExj3XPGprgte6Z973JjFWrzp2nPMIJCHclICh/4jE/ZBTI3fT+p4OmQ4/bv1BYPGKthq5qvbyArpevbk00FZVxYQ1aFQyzBhH6K/Kudh4OanxkGtSMhyUek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=Na+vvVHH; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="Na+vvVHH"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=XecuAQOeYhiDAxs7Uok4jrs1j4cRg33NLWqrdiihqiM=;
	t=1785746426; x=1786956026; b=Na+vvVHHi2WlQbuYc+BSKnzkucgBaAIu+cD7Z0HpGiRptRh
	+PTl1gLkbfdixyCEPSq1xNjDz6BYWTEsYigsAgfJLOYFfvy7eOsp43KngPIi202xqcq4T+DT6umjB
	j3/3lcHp68POP6+/mRASnbqaeFdDq1HRTNuqrYiPpeJFAgMw5sQW5X6JrUSJUKNfr8k3q/xv2Dre7
	nvi+VnQuMFf7npJP0FLT0BxO8xSSOl1ks8EiBSjLpwYk7pfWFHrhAy74yMlRL/rcotGLTpHXWekTo
	cibQ5um1NfAXtPlvnoM9kiOw17lBQn9ihNgXgXHbgrJxDM9qwH41xvEVR+7vy/Tw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wqoDf-000000062Az-37wW;
	Mon, 03 Aug 2026 10:40:24 +0200
Message-ID: <4cd5a1c8e807d064714a2f6fed46ea49d1033ace.camel@sipsolutions.net>
Subject: Re: [PATCH wireless 0/1] wifi: mac80211: keep paired old chanctx
 alive
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhiling Zou <zhilinz@nebusec.ai>, linux-wireless@vger.kernel.org
Cc: michal.kazior@tieto.com, vega@nebusec.ai
Date: Mon, 03 Aug 2026 10:40:22 +0200
In-Reply-To: <cover.1785730815.git.zhilinz@nebusec.ai> (sfid-20260803_063526_248734_4BF193C7)
References: <cover.1785730815.git.zhilinz@nebusec.ai>
	 (sfid-20260803_063526_248734_4BF193C7)
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

FWIW, none of your mails seem to be reaching the mailing list - I have
emails sent after yours on it, so I don't think it's just a delay.

> We found and validated a issue in net/mac80211/chan.c. The bug is reachab=
le by a
> non-root user via user and net namespace.

With all these hwsim bugs I wonder - how do you get it loaded in the
first place? I don't think it's very interesting if (real, non-ns) root
has to load it first, basically nobody _really_ has much interest in it
other than while testing/developing, and even then it'll mostly get used
in VMs. I guess you could technically trigger this on real HW in a
namespace, but ... again that needs real root to put it there.

Not saying that makes it completely irrelevant, but all the whole "bug
is reachable by non-root ..." seems to significantly overstate it?

johannes
