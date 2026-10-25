Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792948841;
	b=EleMjAPt7xUjh32NoavP5bHbe9uAyvDZHu2hay8PXFqKEAl5+2i+gGJr+1BwYHjPl0jL
	 O8823w0IiqjxaA8FyVtUOAuDxL1fjQbB1zJFpFuY2TqgTU9Z7qOIx6mcd6ez6BYpqr4IG
	 cNgL7mtPi5GvggwbkC9qDzEVxqAqgIV9c9T1wZvK2DXeWVRQZhQFegnkYLMafJZ9jSXvg
	 YTY1x6MEcVZiPGlgs3rj+jwEjth0GecxZA45/2RWKq63SpFCJkq9OeSwnAnUdkX1feP4N
	 fVKRAXbPNMGjYVa9tIuzR5H2Gb++rfJAwhea0Qqq88PWK646/NKsh16E6prIg4k2tgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792948841;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=5dxpgPcKzfFZ2lcAer16Y/Y8wJrvG4oTB3fEBLaSNVo=;
	b=ThsjId9GLeaHESqC1Rmdo2Nvkc0FukRvr7dZJdvcattkgKyPbir9h3eaufTs+5pRPuBM
	 6t4LLfTdWb/a5Cjld46IO/zcdk849lwUmLGsA4NnU8hPyGD5NOH23Z+9W27JB5ov+axpw
	 gkdSQbl+4suay2jSmWFUobU3v2bjJ3kFvQHy6yxuL6tNk7awC0HkrhhNSQS9omgXEefDw
	 QC6TZGltvQNvHrMhjtEMFihy3LUBNKzXbbVdovMXemOqI/4ecdG5hH37ED76DV7ILPB1n
	 M5NnddQ3VIvWdyFbTD25adqziS9JPTkygjcVNJa7zYM3eENkbqMwvYISYrpGp9tPJrw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ea7Zwjo8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6102D606A320
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 17:20:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ea7Zwjo8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8211D1F01825;
	Sun, 25 Oct 2026 17:20:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792948841;
	bh=5dxpgPcKzfFZ2lcAer16Y/Y8wJrvG4oTB3fEBLaSNVo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Ea7Zwjo8ckDYTndwi5yQ2Z19UDaOTrPu+BHBmURfn0vPZK3WFTApMnWlvb9xNsyWx
	 2PhjBcRfpQAI3y+11YG3ftbWba5SLTMqeBpHsWMaavpKgcAymnVl8Rj1rT78UwclkO
	 TcES/Nv5B3SSj0nLQg5BVLLsd+Czdtc2SdSR+QFY=
Date: Sun, 25 Oct 2026 18:20:40 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: CryoSlayer <npetr9395@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: rsi: fix missing offset bounds check in
 rsi_read_pkt()
Message-ID: <2026102532-cheddar-steep-1394@gregkh>
References: <CAEabPvLTeZ4kmgRsxdGLdfX1F7QaPWAKi=UU04ivjH4vfg3KjQ@mail.gmail.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEabPvLTeZ4kmgRsxdGLdfX1F7QaPWAKi=UU04ivjH4vfg3KjQ@mail.gmail.com>

On Sun, Oct 25, 2026 at 04:35:14PM +0500, CryoSlayer wrote:
> From: CryoSlayer <npetr9395@gmail.com>

Real name please.

thanks,

greg k-h
