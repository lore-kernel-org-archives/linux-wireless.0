Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA0046D2A5;
	Tue, 21 Jul 2026 16:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784651294; cv=none; b=bHQNvrEKA+1YS08wDe0z+CkC9v4hftZA5nTkcNT/qhimAIxMrqPjvUht2DNe06XUngPUQg1D28tWhuaPThUn0h57N5XQmrUcpuTEqUIyBcB47myvJm2q7g8wEUeV1AbgI11Ny/1BFVF7JV9urPAvJ2h8y/9DVIC/WaVwSEx58gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784651294; c=relaxed/simple;
	bh=7tlR1po1/xVwEF9ccM4amgm/6+uQNpXi81ckxmNBE8U=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=upr+pSqmqO3BU2sSGGOGXLiL9UKC/pNuime6Uha30Y9B9FpAp8brdxkC9Qj6yiXIbRS/53jhA7UpBpVIuwgQ6KjRTH7kldDde3SMRjMG8P931HtZQhHGVGnrXWY0kpYhUGYbekqS23JuN2nbrXE2CbXFba+G3b8JnMTMpyIp1OY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=NcVDZhsO; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="NcVDZhsO"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=yBHQuwqRSrRRpd3ZRMLaZ//+19pguEtC6eLH644rrmw=;
	t=1784651292; x=1785860892; b=NcVDZhsONHORNf0lr/Otox+3Zgt7v1lVToumDGJ7mdYCE53
	EtmAMKKbhEF12pPbnvPSOL0fdRMQL/Yi+3pDJHyuOdO1L5hvuc1UMYKATqQa4l9Bjeano2Wwzwrhu
	d/+OQlYOPdJl3DjmxuUKQ6X/q5NE0gslrhY067Bg54a74lkvpGCcEK7EJCoL3rTsyV/UvGmPI1Q7f
	bsWYFK8J5Bai4CG0DfZr3nklJEwm5oOZowZ+gMTZAvPVBOXnAESK7pFRM8dQfMSIX8xBu8zLWLAhD
	FUnpgWS5jzjXfizyK+MGiTD4JW+ddECo5QVdxOHGxXpeo6SrKS6vcdyY1GX3y/Vg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wmDKC-00000002AEV-0MRj;
	Tue, 21 Jul 2026 18:28:08 +0200
Message-ID: <c913114343692dd201da3af8f05fe1bc356702a8.camel@sipsolutions.net>
Subject: Re: [PATCH v3 1/3] wifi: mac80211: add ieee80211_tx_peek API
From: Johannes Berg <johannes@sipsolutions.net>
To: Jose Ignacio Tornos Martinez <jtornosm@redhat.com>, jjohnson@kernel.org
Cc: ath11k@lists.infradead.org, ath12k@lists.infradead.org, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 21 Jul 2026 18:28:07 +0200
In-Reply-To: <20260720070852.206495-2-jtornosm@redhat.com>
References: <20260720070852.206495-1-jtornosm@redhat.com>
	 <20260720070852.206495-2-jtornosm@redhat.com>
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

On Mon, 2026-07-20 at 09:08 +0200, Jose Ignacio Tornos Martinez wrote:
>=20
> +const struct sk_buff *ieee80211_tx_peek(struct ieee80211_hw *hw,
> +					struct ieee80211_txq *txq)

While it makes some sense, I don't think I like the way you've
implemented this.

First, it basically does a lot of the work twice, say if it has to walk
a lot of flows to find the SKB.

Second, the work that it does is almost entirely disjoint from
ieee80211_tx_dequeue(). The latter doesn't even fill the hash (and not
all drivers might care), although I'm not even sure it's _needed_ to do
skb_get_hash() there, seems like this fairly obviously happens *after*
ieee80211_select_queue() or ieee80211_select_queue_80211(). So maybe
this isn't strictly more work than what dequeue() would do, because it's
a nop anyway.
Also though it does a LOT less work, although it pretends that the SKB
is fully formed, at least it makes no representations otherwise, and
that's obviously not true. Most things in the ieee80211_tx_info are not
filled in, kind of randomly by where and when mac80211 decided to do
that (which isn't really random, of course, but might as well be random
to the driver). As such, it seems only useful in a very limited subset
of cases.

Third, it documents that the skb will be returned by a subsequent
ieee80211_tx_dequeue() call, but that's obviously not true - the next
such call might not return anything at all, even for quite a while if
queues are stopped etc. which isn't considered in peek(), and I'm not
even convinced that it must ever be returned, if something else happened
in the meantime while such a situation occurred (queues stopped). Even
ieee80211_tx_dequeue() itself can drop SKBs entirely.

As such I'm not even convinced that there's a guarantee that after the
skb peek you even have done the work you claim to have done, if a
different skb is returned from dequeue() instead of this one.


I think I sort of understand the motivation, but it feels like you need
to go back to the drawing board. Maybe even further back, and perhaps
ath11k/ath12k just shouldn't use the hash of the SKB itself, but
something else that can be derived without the SKB hash?

If that's not feasible then this probably needs to be turned upside
down; perhaps there's some way to dequeue it anyway and hold it
somewhere for later (though that has issues with all the pointers in the
skb->cb), I don't have a good idea though.

johannes
