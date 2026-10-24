Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=45.145.95.4
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792831153;
	b=ORF4etJFbWZQNYceHFylXL5VmILwzZxEOYVRs4MhTNR0+nT8e1q+2eqxjYSwIlB3OdCA
	 Un2K8+gg/hgjmwg/Jdjy4VfkyMQ43kq3R1/B0xlCjEgkyAtB7DJc0SLbeCZre/lhU9vsL
	 9SC22HIs7ILveyya7siiFUfIB2V1H/2sSIdN+p/FcBO/dhis81MlNKya8sgY7WrQoFLgB
	 Zb4cRrj1mYE+YbjVya9+NwkU9s4/mutXIR2PkFNEfKKHrHQZgQ+QWuBp4wZ0u/xyoBJ2s
	 dnIWgB6LK61oiawMePAnhGjNCSXYhton5oNcDOZhyN6muv/qNwg0MCmg+3Tnn8oX40Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792831153;
	h=DMARC-Filter:From:To:Cc:Subject:In-Reply-To:References:Date:
	 X-Clacks-Overhead:Message-ID:MIME-Version:Content-Type;
	bh=CkxCGOO0CuB773M/YWAckLO9nmRNkk1oA8N4cQeEO1o=;
	b=UU+sR0pz/PiSkjrnHfUPB7FuFQbX5wF+jx09GpIkDvNlcvr8LM0kVSxCNQ2QrWeoQuug
	 NZo9yWDY0QnZ3dZXuQ3GdF34hOXivNDNWEhiRm/8NyT0n11pIepIzEt6NY1wYhAuzmq4m
	 9qwkmKINJqRBol9a5rPRZoLSmijJfC/C1mGhyxxXr9s8Xcji/imNLC4EacWCwDQx+kiwU
	 WOZfBePpxPrvprQIIh8pLy6VX+drP8ubNU6YCzkWoUkfs/rdmOWRDNWAITOsjxAaqrOVb
	 YpXWAIHmAFUNioauDp1fFrp3RGUX7bPhCaTwEhDjNpHzPvEplkPlx6U2Gk28KZfAnWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=toke.dk;
	spf=pass smtp.mailfrom=toke.dk;
	arc=none smtp.remote-ip=45.145.95.4
Received: from mail.toke.dk (mail.toke.dk [45.145.95.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8AA0606A31A;
	Sat, 24 Oct 2026 08:39:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8AA0606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=toke.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=toke.dk
Authentication-Results: mail.toke.dk; dkim=none
From: Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
To: Tomas Tonhauser <t.tonhauser@pobox.sk>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
 linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] wifi: ath9k: clear destination mask for
 non-aggregate frames
In-Reply-To: <atufwCYLtoF3UaMk@blackbox>
References: <20261003192957.761090-1-t.tonhauser@pobox.sk>
 <87mrs9v3aa.fsf@toke.dk> <atufwCYLtoF3UaMk@blackbox>
Date: Sat, 24 Oct 2026 10:39:08 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87jyn7pk5v.fsf@toke.dk>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Tomas Tonhauser <t.tonhauser@pobox.sk> writes:

>> Anyway, I don't think it's unreasonable to add the same retry logic to
>> non-aggregated frames that we have for aggregated ones, and the retry_q
>> seems like the simplest way to do that.
>
> I'll work on re-queueing failed/filtered non-aggregate frames on
> tid->retry_q for awake stations and send a v2.

Alright, sounds good!

-Toke
