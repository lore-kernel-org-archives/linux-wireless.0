Received: from meesny.iki.fi (meesny.iki.fi [195.140.195.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3117B38DC43;
	Sat, 12 Sep 2026 07:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=195.140.195.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199963; cv=pass; b=ICNbzCSL40bQnL06XWrtN4h3ijBZeQYm120Z4BTVJcnQKyMT7qawTDB7YvYXFmvnDq4/WLrLNaVZ+3duxIvsRI45zdJTJ8OHCqRGAHDqCxaIJlFm+vIWOjF9BXpPnUeDRwKv9lkrKYeF37Cl1nb99Byi3yCCz0kW9ye9V/9HcK0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199963; c=relaxed/simple;
	bh=NmXmFYFRtLU22HLrYBSd1oFf2pfvgHBMxjXsjw+Yi3Q=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=EZkuNzch6xYFbQmUj7UEVpMVjs2ZLRCX4rziFgjAPds/oYkDO6xa9VqDppkmfVhdkqt8UJt0xzBdPls7O5fRKvRw8WsTrnd5ZvrJ1WRzd4QfkDaHjt9x8xk89r+EsVK/a+KOoD6XtuXJzpfcRNAJeVcJw2+2nQOBbnC5jBbDHeQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b=c1nizgtp; arc=pass smtp.client-ip=195.140.195.201
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=iki.fi header.i=@iki.fi header.b="c1nizgtp"
Received: from fauth-c1-smtp.messagingengine.com (fauth-c1-smtp.messagingengine.com [204.75.18.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by meesny.iki.fi (Postfix) with ESMTPSA id 4hhkMH4PThzySb;
	Sat, 12 Sep 2026 10:59:07 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=meesny;
	t=1789199948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kWtoX2q/jGZ//1+vTBGDG8T4O15rbIPB/EVBKLVQA20=;
	b=c1nizgtp/UZNwiHIDtiTCKEEfIaCe0KdOhFPIJTCb47HHJUK5LsxbiUhPhvDePNeNsnn8+
	J7nd5Ar9y49SERDsS6Hkxa6YUP5HOPQ4Jnp0DYKlJWCOs8umYf2YjnUAT/nFF5A8lUGsEg
	Ao61NcvI0IRG9KkoCLAhGdVYMdBUl9Y=
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=meesny; cv=none; t=1789199948;
	b=VJ4U+jtAJFzR306aVpQL7xZpYGbpV8t2XgbbbxHtD23dRNrH0Vvrt1J+2xMdDxIIPQiism
	MaZrkIiN15ygXZ/9kRybeR+lDqalOpf3+SNjZXbFZPd7kPP6/SEzBT0CpQHzoeE7nbgqAm
	QxkH0PhCg/NyLJFJv12qM84cnINRR94=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=meesny; t=1789199948;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kWtoX2q/jGZ//1+vTBGDG8T4O15rbIPB/EVBKLVQA20=;
	b=Y3jj+/jl1D9ZL3reijnjzxtM1ndhiL681A2rux/8xF+hhqz2GQevjUZkCfDQML5TPR+/LE
	yYHfVYFG2dWLLnhGMIcvlnozPqIrfswLFBhTMJRBwSJ9IepE8Cr4Pj1dBFavCpPd4Wg2At
	Mc0qck58ThGJGsc2sjk9vXm33lnm6Bc=
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=jmtilli smtp.mailfrom=juha-matti.tilli@iki.fi
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 88644198004A;
	Sat, 12 Sep 2026 03:59:06 -0400 (EDT)
Received: from ams-imap-13 ([10.64.2.33])
  by ams-compute-02.internal (MEProxy); Sat, 12 Sep 2026 03:59:06 -0400
X-ME-Sender: <xms:Rwalamwxsu26ZEAS5voScVlywrSY1nhVUTKXq3cCPVO3bORaiKI0WQ>
    <xme:RwalatHmZGDCrKjVl44ZugsMgSP-83xtoEiRnWXbEa594O-wzVVXEOaS37DOktAxZ
    4sdKJ1HSC1VSuv0EC7SHScw5yENnTPd1ZiKGEFNV7szZcRnIbl0xl0>
X-ME-Proxy-Cause: dmFkZTFEXGNHCKhuAHtyaQNCz9mF0LZj+0EMZrDTZmy3QBtpWwkxw8Zh/OO90gMbHDDFgT
    rbvZjVfyzbe7pkuXoVe4F/B+gfkty3EASgQrgf67g1gdMjrMwpOFHdiISUkhGVC3bvpJ9v
    A91YgggnXoVf0wSMRnkH/4DlMkIjf+ckzw7bbjyYzmMwVAMq2ftHOT3fnqksac5SBbsmIa
    MaWjmODyRy0ISaJM+6j9CoXe9+qacm+h1bg9tNmq/kjTbQPDkj/cxQkqm5oWG/imqJqNJs
    Ev2UEr8Eg77CV9+/3aghkj2fBy7lSvVvXi3yrGhTiR19pRxc5DHSStlNeaVEV1VLGnx+TT
    ZYeGFc/3MyJHxUijdmDRETWFGoaVjYJAdy1uZQ/BfFqdZAqgxHenipTtFZ+IsAkjZV82et
    gYjy9Mrr0CxGBXCBY1gjGvAMwjbuPDk7V5PvJKRykqP8MnmE6N5FOiABM14uiaEeRu+Le3
    uHBEaMbVg7qJTalVLlsh9Imxuv55Qyvo3/xt1DGbpovUZCUaT2W2s8VIJI2wXY1hnINTO7
    ZGpqOFUev7REkutW6tUhurd8LQBWLSTGVe0PRDkwpzJCTQPdGQxKqrkfewZC4O+6lWMbRA
    Wu1nZnQ4La7Mwtb9p3zmrEEuuwQHxIEdOcO30Im3b01LDr8JJ1MMMtqcoukQ
X-ME-Proxy: <xmx:SgalanJwwwbuJsLQgae23CqvUJjCBfbiUimryUZ_BVZMVHowVP0KSA>
    <xmx:SgalagAkJ3r3T_wIeqZo1ZRDMk6UNekCYm1Igx-rQlq1g3bzFzQh_A>
    <xmx:SgalaoScTpCd1L-V1EcbcZqBRrWadwyH-hQgdE5LxFjo5cFTHYGotA>
    <xmx:SgalahqLyq8KMc4R3N09DShooKOVboWooC2HMbjuNW16yJBdUFescg>
    <xmx:SgalahV9QqOmNXwtcBK-HLYKgjWLCsxT90vaUs6jp6PopLystOxxEea7>
Feedback-ID: i02414972:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 5DC57F80087; Sat, 12 Sep 2026 03:59:03 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: Av35K2MZ7qUg
Date: Sat, 12 Sep 2026 10:58:42 +0300
From: "Juha-Matti Tilli" <juha-matti.tilli@iki.fi>
To: "Jeff Johnson" <jeff.johnson@oss.qualcomm.com>,
 ath11k@lists.infradead.org, ath12k@lists.infradead.org,
 "Kalle Valo" <kvalo@kernel.org>, "Jeff Johnson" <jjohnson@kernel.org>,
 "Manivannan Sadhasivam" <manivannan.sadhasivam@oss.qualcomm.com>
Cc: "Bjorn Andersson" <andersson@kernel.org>,
 "Konrad Dybcio" <konradybcio@kernel.org>,
 "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>, "Simon Horman" <horms@kernel.org>,
 "Mihai Moldovan" <ionic@ionic.de>, linux-wireless@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-Id: <65bea1ee-edf5-4884-98e7-f9d6237f8999@app.fastmail.com>
In-Reply-To: <d91ce2be-6489-4399-b035-23f6aec0371f@oss.qualcomm.com>
References: <20260908093145.2492666-1-juha-matti.tilli@iki.fi>
 <d91ce2be-6489-4399-b035-23f6aec0371f@oss.qualcomm.com>
Subject: Re: [PATCH v3 00/12] ath1{1,2}k: support multiple PCI devices in one system
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, Sep 11, 2026, at 22:15, Jeff Johnson wrote:
> On 9/8/2026 2:31 AM, Juha-Matti Tilli wrote:
> > Hello,
> > 
> > As you may well know, multiple identical ath11k and ath12k devices are
> > not supported in a single Linux host because they use conflicting QRTR
> > node IDs. Fortunately, Denis Kenzior created a patchset to support
> > multiple QRTR endpoints with identical node IDs, and Mihai Moldovan
> > refined it, after which I took over the patchset and refined it more.
> > 
> > [snip]
> 
> How are you populating the list of recipients for your e-mail?
> 
> You are including folks no longer involved in kernel development, but more
> importantly, you are using an obsolete e-mail address for the MHI maintainer
> (Mani). I've replaced his address in my reply.
> 
> Please make sure to use scripts/get_maintainer.pl to get an accurate list of
> recipients.

Hello,

I will post a new patchset without messed-up threading later. The e-mail
list was populated from Mihai's patchset from 2024, and I indeed noticed 
that Mani's e-mail address was old, which would have been fixed in the
next version anyway. I will also do an estimate of how recently the
recipients have been doing kernel development, based on the Linux kernel
commit history, and what kind of development they have done (in what
subsystems), and remove addresses that haven't been part of relevant
kernel subsystem development recently (except maybe Denis and Mihai
could be listed as the patches were originally theirs). Of course,
get_maintainer.pl result will be included.

I will also join the modified recipient lists of Denis's patchset and
Mihai's patchset, as they are related to each other, and Mihai's patches
require Denis's patches.

I hope that with these modifications, the patchsets could be taken into
consideration and review.

At least my git send-email settings and changed SMTP server settings
should prevent the previous mistake in the next series, and if not, now
I know --in-reply-to and --no-thread. Also shorter CC list will make SMTP
server limits less likely.

BR, Juha-Matti
