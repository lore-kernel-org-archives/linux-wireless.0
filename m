Received: from mta0.migadu.com (out-24.mta0.migadu.com [91.218.175.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 714903C2790
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 10:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791973657; cv=none; b=OwN9EHnqV2WA9XBSLmweQqoEFRAKwh5kwlO1c5k+3SLxyzL1hMfOMi3Bf42eCe3qO86LC63pU7S9U90m8k8TYPzHZwQSQO0UXUA2HCiWKd7twPAQoRpr8Ih4VT8Sjxm1kXJpwRIlMjflq59cyWNFVpIpfJ2EGmtHtOkPc4zL9WI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791973657; c=relaxed/simple;
	bh=lo4KWbRiL3hhpKkmgmuaXLkp6Q25xPCOBKEqTzladfk=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:
	 References:In-Reply-To; b=ekweDaxCQ3jrqYrFnNG8dsY9+SHSdCpyOVzx5VQB06kd/d69yXNF+srpdmAEeOwrsvPHFtkhtrCSKMjInKCavOOzq7ixoeGxTcS5aJMDO6lpG8E2QBtNqH2/qn9TmHdA5371H2C6Tyo3rNGyCk+umVTvRCIL8IhhI8uhGMxtgjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Q2LlHfW9; arc=none smtp.client-ip=91.218.175.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Q2LlHfW9"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=lo4KWbRiL3hhpKkmgmuaXLkp6Q25xPCOBKEqTzladfk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791973652; v=1; x=1792578452;
 b=Q2LlHfW9tfzmj+Co8Sjy1cv8QbDT3uJqExC/BdROxd1B15UHyIoiOJtMgwjlTAAPHo18yvb3
 8TreGxl+NQ+mb8tLtaoIjsphwkj1f9p3jWavYBNJZI3SSNW6ikX5jaFYCZIwskaVOfx4meVqc5z
 WR8W+0ujUMRCDU3d2PjEbR2k=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 2173e25b94ec7b3c;
	Wed, 14 Oct 2026 10:27:32 +0000
X-Mizu-Trace-ID: 2173e25b94ec7b3c
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 14 Oct 2026 10:27:31 +0000
Message-Id: <DM4HN6UYFJPO.2KDDCT5UHA52W@linux.dev>
Subject: Re: [PATCH 10/11] wifi: mac80211: avoid tailroom accounting on new
 key installation
From: "Luka Gejak" <luka.gejak@linux.dev>
To: "Johannes Berg" <johannes@sipsolutions.net>,
 <linux-wireless@vger.kernel.org>
X-Mailer: aerc 0.22.0
References: <20261013130604.254393-13-johannes@sipsolutions.net>
 <20261013150605.65fbe249d82e.Ie6b44dfeb421691898e1e181f38a6adfc780290d@changeid> <feaf62f6762bac17bc6e1edce2fc1d4d50adc3b4.camel@sipsolutions.net>
In-Reply-To: <feaf62f6762bac17bc6e1edce2fc1d4d50adc3b4.camel@sipsolutions.net>

Hi Johannes,

On Tue Oct 13, 2026 at 6:22 PM UTC, Johannes Berg wrote:
> This is well and all, but I'm starting to think we should just not do
> this. Given that SW crypto really should be the slow-path, I think we
> can instead simply remove the RCU sync *completely*, and accept that in
> the race case, the (SW) crypto path may have to expand tailroom (and
> might drop a frame if allocation fails).
>
> That's far simpler, no need to add the RX_ONLY flag I did in patch 11
> etc., ultimately instead of adding code it ends up removing some, since
> we can also get rid of the dec_tailroom_needed_wk and all that.
>
> Thoughts?

Agreed, the counter only exists to avoid synchronize_net(). Two things I
would want in the same series though, because "expand, or maybe drop a
frame" is not quite what the code does today.

The data crypto paths warn and drop rather than expand. tkip, ccmp and
gcmp all WARN_ON(skb_tailroom(skb) < tail) and return -1, and
ieee80211_tx_h_michael_mic_add() returns TX_DROP. So either those grow a
pskb_expand_head fallback, or the WARN_ONs become plain checks.

And the counter is also the cloned skb unshare trigger in
ieee80211_skb_resize(). Without it a header released clone with slack at
the tail skips the unshare, and software crypto then writes the MIC into
memory it does not own alone, which skb_tailroom() would not catch. An
unshare in the encrypt path would.

With that the counter is only an optimisation, so no objection from me.

Best regards,
Luka Gejak
