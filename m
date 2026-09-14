Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D7EB480357
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 12:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789390731; cv=none; b=tUIoXNUMFIZGJKCfEg93ELtOaaDj/oVuKm9Aii6DDoH4FfQXv5pTVwvm+bUjWoswSgjATU9suy3DAH0DlST1pbbroclexfdWp2qquCiyZitva/ZqsjSVM/LfpErBWp02LoO50mENoDRusZmJTEikFdpGZhT5aFITDhFZ1lD9fvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789390731; c=relaxed/simple;
	bh=445p2A0D2g3Vppp+qHEzCE7f3/L7kFo57xUqlBZ5wVk=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=s6Uj9Ud83RBFmAf9JUzHTNINWn9SYRzWDz+Zh23dzqwTM1x45ZMWxWQ7SPZM0IlS0P3seDhniyQ2Q6xu5ioN4KV7Gu2mycJcYc0uNGp/sC7n2VaguhhjOXHADmrpiUyJ8KxKpaGmaYE8M1GGQ4b3+GIEc7boXJpVbCQSIQ8gXlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=pass smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=NNwzYSxC; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="NNwzYSxC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=Q6PpcdRGuERSPwSa7AMpx3pOzfqSziGYLUMOgaRiNG8=;
	t=1789390729; x=1790600329; b=NNwzYSxC7I3C+zr33UDkz89nJXlpAWaLAvcS8gZBIrL7vlq
	bPP5c53w+QQLs1Y7LVWO7uCaYMWbUrEwE1qGKOcEpCmaaE52jujILu7sw/RY5HIxNAf0SDFCv4cVZ
	ItXMkxLKpf+iFaxAqDXemzs2JJD0hnJ6a4yyUyEbJ2P98k/LEo9Z+Lu1UCd7sdeJPiQuSRPjD9i1R
	XtQuXaT2oQXsH4MZxD8f6njLXpVwX6U0KfBik0tP7/7JvwA1FfBFkRdBIjN6QIOLdl+fVeHeHVjP2
	ttE2EqVZabOBbfjY5/vmlxckQNnhFZh7Ts49hpHsut3IAub4Y2vvOpu7Lqd0FJ5A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1x66Gj-0000000FSuq-2Js0;
	Mon, 14 Sep 2026 14:58:45 +0200
Message-ID: <f8abbc475027650afc3293c4317433ccde2e9173.camel@sipsolutions.net>
Subject: Re: [PATCH wireless 1/1] wifi: mac80211: fix fragment length
 overflow
From: Johannes Berg <johannes@sipsolutions.net>
To: Zhiling Zou <zhilinz@nebusec.ai>, linux-wireless@vger.kernel.org
Cc: vega@nebusec.ai
Date: Mon, 14 Sep 2026 14:58:44 +0200
In-Reply-To: <ff9b52fe8e4afb8af643ab5e6c638f8fe6596714.1787980055.git.zhilinz@nebusec.ai> (sfid-20260829_073623_742822_6E8076F2)
References: <cover.1787980055.git.zhilinz@nebusec.ai>
	 <ff9b52fe8e4afb8af643ab5e6c638f8fe6596714.1787980055.git.zhilinz@nebusec.ai>
	 (sfid-20260829_073623_742822_6E8076F2)
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

On Sat, 2026-08-29 at 13:36 +0800, Zhiling Zou wrote:
> The fragment reassembly cache tracks the amount of data in continuation
> fragments in a u16. An oversized fragmented frame can therefore wrap the
> value before it is passed to pskb_expand_head(), leaving the destination
> skb too small for the queued fragments and triggering skb_over_panic().
>=20
> Use an unsigned int, matching skb->len, so the accumulator is not
> truncated at 16 bits.
>=20
> Fixes: 3a11ce08c45b ("mac80211: add fragment cache to sta_info")
> Cc: stable@vger.kernel.org

I'm not sure this is reachable in real hardware - there are PHY limits
on frame sizes too... it might be though with VHT or so?

> +++ b/net/mac80211/sta_info.h
> @@ -458,7 +458,7 @@ struct ieee80211_fragment_entry {
>  	struct sk_buff_head skb_list;
>  	unsigned long first_frag_time;
>  	u16 seq;
> -	u16 extra_len;
> +	unsigned int extra_len;
>  	u16 last_frag;

You could reorder the fields to not add holes, especially if you're
fixing a patch that as trying to make this smaller ...

johannes
