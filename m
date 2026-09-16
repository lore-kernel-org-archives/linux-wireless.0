Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B7354A387A;
	Wed, 16 Sep 2026 09:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789550248; cv=pass; b=lHHuB2u46bp0YcEBoAJuynWTDDHQQgWCc8gtER6AXpRQeD+OGxg4NtTejHZPQiTbso2XLAbu5LdJq0cqTkVzJBNDga/fqcjya3f6a5okxHWnrLityy1q/jO6ILZCsxYY1N59RvL24aNcI+KX+9jclJ2lePkIQDusLcTBfQFNxIE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789550248; c=relaxed/simple;
	bh=9apGcAGF+qN+WdJNOYa47ONmDgzcaDL77nJ6s3G6f94=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=KaXSUeuH2XXuRMeKOEF5hrmLW+mxdcmyipF2MttjZaEKl3ofZpfc+ubrjRmEUL1LIhtdNhozloH3xUNuG2QownNbBRNSqusDHRLyRrrskvIlLZ2v2dRfyFKRhFQElBeC54tsmmLlG7FsSoEBgYlN3ZPr5wqe4RnJPSlu+WovV/k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=LOgzLAs4; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="LOgzLAs4"
Received: from fauth-c2-smtp.messagingengine.com (fauth-c2-smtp.messagingengine.com [204.75.18.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hlCvL4YHpz49Q5T;
	Wed, 16 Sep 2026 12:17:02 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1789550224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9ZXpwDz6DoWWBmQ6vDNVRxdpcZSSALaEWv74i0upVdU=;
	b=LOgzLAs4BikP/sgnQAfLugwVmoLTCaaR6pBGXA1afPjrpCv8xZ/XnHqdolLosB9Z928jgz
	gUC1WbzWA3saYj/NlMXzY9Fx2IsiRZ+G1d/NRMZsLjMl6mixZRfJxp4/HOFQvH0OX9fr5M
	fIExVqAoITO+kWu0iRMKXxdqsywyX0yt4e4HeIfupMcULbcornYNcOAeF53fr4xae0tZOi
	cogbMyXpR/kYZ+yd1EWN0o65wR6CWx3xqmJnwO1aTVTv7yozoIYp+Omz6mQxHSKPmqL/CW
	Hf2JQUn0Revkw1uCxFo+keDNbJ8/sbDMdgSv+FcoEwNk+Q/+ZjNME7Pae+ENEA==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1789550224;
	b=NGsvDT5a/D5ir8PsCu1YTvoejFwVxfILAw8mbusf8jcy0Befo7S6EgbCGn2XYE5e3NUEdq
	kvgfjp4IsId7XRwGXOfaW0XGlS+RVtTO/xfLLlaTvN3yWoizUDYa7FKexRFFDuVwQYlBSb
	kE3qEYw9DUxj8JcdEqiJghgJ3YpQGsjpo4dIuUnc4k+/i0jGkxyBLl5BpOdbkdO3CvXAQl
	loqkxHgAtHbnqwGU4ZOjlO8+VTx2lrjcgCe8DKlx/OLWzFsLBzMse2BncHy9xV7iitf99+
	56uvEQlqXRy6s8kAOcLVijWW2z5Mai/pMMYpJ9Z/ma/fuP5spzz+kVgHJ/qmYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1789550224;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9ZXpwDz6DoWWBmQ6vDNVRxdpcZSSALaEWv74i0upVdU=;
	b=QaZDi5PRFHJw2YLEriC+I9FJuecvdYIKGxF2MwFomYnNj/WiyC04XmYLvrQR9TT1YrMnBW
	XvM5KBxSJftPOuuDw48YeC0bvLzaRjRThXIUIg1RC2ihUI6eqVVp0zLe0C4rQyKqvXn2EQ
	tG/jrxZT5asy1ZPaZ3OQxbdDWuUS0jotYa/kv7LLO5xfkhTJ4vMp7J1iz6zEJR6GmWtdSz
	pmQOvF+SQ1AWYwyXTY0kb0H6JT7v2FXyDNsXL5s/ybHq9rHdH6BAnvKTcqJfwJD5ICGkp6
	O/uNL1xpjDFaQzOUPayvoSjgNagiqCR1WE+Pyr5oLwyA5jWTwfW8koJ7rKsL5Q==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=jmtilli smtp.mailfrom=juha-matti.tilli@iki.fi
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 8E28B198003A;
	Wed, 16 Sep 2026 05:17:01 -0400 (EDT)
Received: from ams-imap-13 ([10.64.2.33])
  by ams-compute-02.internal (MEProxy); Wed, 16 Sep 2026 05:17:01 -0400
X-ME-Sender: <xms:iV6qag3fwJZVElS11KOnACeO3JGDmX_uwUJvl8TgfoB81E3A3vBJTg>
    <xme:iV6qal56Dzqp_NRsS9Es8Vuey_S8mDBuDqKiHnugv7udTKHByS_h2x7KhaWC9KEU3
    ZFj6u_mUwXrGGZgRvLUvPqFAckzru_7RfuhLscUhqlA1JtFSH91NSE>
X-ME-Proxy-Cause: dmFkZTGNFtvyF6MZNYMeLjLWJ41+we1JJ2Ix4Ro8hXfbflboz9ZBw6ovM/eey9Gijq0/Iq
    aPwhDw8Qs0gEeTKSlITUHQSLt0dbFE5HrptM2obUWfKKcjNRHWOJjELo9P5f3QEsYpsE6d
    hrW5Y+e/1UX012oUQk2r8ajWj1yE2k4hnhEzGiUXQ2NZpcbroifSXrsO8hYkY4GZvOPXW5
    babRbJSvfgsF0DJ+bk/amnon7PS+3s261lu//dm2pq9kX+yE0j/XwQTCgkJ5QWBcdzXRyp
    IvmjBKmjAjCc36wGn77wxm/mB3uS0XnN641PdGPuNW6NRJnwXoV5AaGiTKSGXWUb2sv2kW
    srTKTE258K+d/Dwk2y/m0SKBTkVT7iUPkU1kdUtkFDK9au+RML61NpjAQSvMuS2QklOCAT
    UAE0Hclbs+lQFAMq3R/mv2I+geAjMoF/L4gApGDO6Ok4deMGQcUNbcrZ2rTidFmHrHZzx/
    gQMgSOeBNDvD9iy9e0dl1J5ZBX04VAXhXHLTuesqaH0VHp1GqpyU+6RzZ9I6Vnu/y6GVaA
    BUHGfOrmUhAdNu0TKM/MpcKO7bndP+Kp/1Gmkn31I3yzIkbIc5y04Ohkm3zMV2cLZp4SOD
    mE6ShLsWg4EeG8xoB2+/E/2wMsc/KbkcfJAiIpiyOo86TfLmsaLXCTMeEgZg
X-ME-Proxy: <xmx:jV6qag_xAfBF4b7JfLUzVt_CTM_U8mWr7A_Fmw2jJJINzbR-C7OltQ>
    <xmx:jV6qakIvhColpei7gd9PzH58eLkXDhYxtHsZOf4mSPorf1AdaldRnA>
    <xmx:jV6qakuRhvl58_-z8GXRpFgARl3MkEUjJMCJkpvj-5fzdjVRb-5nDw>
    <xmx:jV6qatltm3i7OvXc1xh20Y-yn0KjYy3bt86NYaMQOUa0ni1awM2SLg>
    <xmx:jV6qarkHNZlZSzvbVHQJBCQkSeFEKTwE3m9W_toSFDjvBi2RYo-4MH1r>
Feedback-ID: i02414972:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id C76DFF80089; Wed, 16 Sep 2026 05:16:57 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AaJBIn-uFwMB
Date: Wed, 16 Sep 2026 12:16:37 +0300
From: "Juha-Matti Tilli" <juha-matti.tilli@iki.fi>
To: "Manivannan Sadhasivam" <mani@kernel.org>
Cc: linux-arm-msm@vger.kernel.org, "Jeff Hugo" <jeff.hugo@oss.qualcomm.com>,
 "Jeff Johnson" <jjohnson@kernel.org>,
 "Bjorn Andersson" <andersson@kernel.org>,
 "Konrad Dybcio" <konradybcio@kernel.org>,
 "Eric Dumazet" <edumazet@google.com>,
 "Kuniyuki Iwashima" <kuniyu@google.com>, "Paolo Abeni" <pabeni@redhat.com>,
 "Willem de Bruijn" <willemb@google.com>,
 "David S . Miller" <davem@davemloft.net>, "Jakub Kicinski" <kuba@kernel.org>,
 "Simon Horman" <horms@kernel.org>, "Mihai Moldovan" <ionic@ionic.de>,
 "Denis Kenzior" <denkenz@gmail.com>, "Marcel Holtmann" <marcel@holtmann.org>,
 "Andy Gross" <agross@kernel.org>, linux-kernel@vger.kernel.org,
 mhi@lists.linux.dev, linux-wireless@vger.kernel.org,
 ath11k@lists.infradead.org, ath12k@lists.infradead.org,
 netdev@vger.kernel.org
Message-Id: <9ffaeae1-3768-408b-8434-9f1704412fbe@app.fastmail.com>
In-Reply-To: 
 <bjfwy4usrfbrabmcp4xsr65nqwdpuryvmrb6tzp6k2ckmdx27h@kvf7idvsugsm>
References: <20260915054207.2513877-1-juha-matti.tilli@iki.fi>
 <20260915054207.2513877-4-juha-matti.tilli@iki.fi>
 <bjfwy4usrfbrabmcp4xsr65nqwdpuryvmrb6tzp6k2ckmdx27h@kvf7idvsugsm>
Subject: Re: [PATCH v7 03/15] net: qrtr: fit node ID + port number combination into
 unsigned long
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, Sep 16, 2026, at 10:01, Manivannan Sadhasivam wrote:
> On Tue, Sep 15, 2026 at 08:41:55AM +0300, Juha-Matti Tilli wrote:
> > From: Mihai Moldovan <ionic@ionic.de>
> > 
> > The flow control implementation uses a radix tree to store node ID and
> > port number combinations and the key length is hardcoded to unsigned
> > long.
> > 
> > The original implementation shifted the node ID up by 32 bits and added
> > the port number to the lower 32 bits of the unsigned long value to
> > create a key.
> > 
> > Unfortunately, since both node IDs and port numbers are defined as u32,
> > this will overflow on platforms where sizeof(unsigned long) < 8 (which
> > are most 32 bit platforms) and essentially just drop the node ID part.
> > 
> > To fix this, build the key in a generic way, using half of the unsigned
> > long space for the node ID and the other half for the port number.
> > 
> > This will be transparent to platforms where sizeof(unsigned long) >= 8
> > and fix overflow issues otherwise.
> > 
> > The caveat, of course, is that, for platforms where
> > sizeof(unsigned long) < 8, the supported amount of node IDs and port
> > numbers will be severely limited - to half of sizeof(unsigned long),
> > which typically will be 16 bits. Needless to say, we have to check if
> > both values fit into this limit.
> > 
> > This limitation is probably not going to be an issue in real-world
> > scenarios, but if it turns out to be one after all, we could switch from
> > a radix tree implementation to an XArray implementation.
> > 
> 
> Documentation/core-api/xarray.rst says:
> 
> "If your index can be larger than ``ULONG_MAX`` then the XArray is not the data
> type for you."
> 
> So the fix is to not make XArray work, but switch over to some other storage
> mechanism instead of XArray, like hashtable.

I think I will drop this along with patch 04/15 from the next series,
as it fixes one bug but introduces another, and those bugs should
probably be irrelevant for this patch series.

Indeed, that commit message by Mihai wasn't entirely correct: XArray
will not work here.

BR, Juha-Matti
