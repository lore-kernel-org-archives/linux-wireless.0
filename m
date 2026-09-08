Received: from lahtoruutu.iki.fi (lahtoruutu.iki.fi [185.185.170.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21E214A49A7;
	Tue,  8 Sep 2026 09:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=185.185.170.37
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788860689; cv=pass; b=HXSVR9bfnRHpzy0K7gyRhz1z0ppM5kKEJMYm4sSALFrxdQCdzLM8lDz7M9G2tif0/t4A1FTmlTeyKhHalmX9rTD0pOu6TZOoG9sCsn/q/cbf2+MHRMsz3I/j0WkHcy+4BkXuD57PvNOVHBcgC/entFcFcBTD66qBBtA1XnRxrk8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788860689; c=relaxed/simple;
	bh=okk/6UKvvJuFy0HfkixIG69h3/2z4AmE9S0HHh3WLco=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=eUAVKJPbu6+D/6CoJeMpQthE5ThmR21SEqVi8Kgwp9aH8+3Rq9OnEWxaUksAuo9bfdW6RoNj6AGqKQurw2eDow88y0dMpd4Ibw+havHNDkPMRYR0Lh3ejZlz90nr/q+pTkGz069J2dlWQ3kSz8rgEoX5C0/LoUI/f7hdErEztfI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi; spf=pass smtp.mailfrom=iki.fi; dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b=AkkoA4g+; arc=pass smtp.client-ip=185.185.170.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=iki.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=iki.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=iki.fi header.i=@iki.fi header.b="AkkoA4g+"
Received: from fauth-c2-smtp.messagingengine.com (fauth-c2-smtp.messagingengine.com [204.75.18.201])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: jmtilli)
	by lahtoruutu.iki.fi (Postfix) with ESMTPSA id 4hfJtw5MtWz49Q5T;
	Tue, 08 Sep 2026 12:44:40 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi; s=lahtoruutu;
	t=1788860681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=okk/6UKvvJuFy0HfkixIG69h3/2z4AmE9S0HHh3WLco=;
	b=AkkoA4g+cdgtOntOBeCtgp7e5YEL5kCQnDqxmKvSZPwzZX4MLzi7IVLpez33Wjv8mA00Jb
	gLnRewcuvFht5TvhvCuHXijTWDGGOjUQLfUcoDxakJvUys+jnzGraBLCbiJKFXQNmBfeqV
	XaUYPpui2v4eiMYt0Ha7fdOoBM+BNFVjp8fJGs85jPh0LTxldvPufaAHfSGEc/z6CqNlo7
	gYfdSCBnBKgJdFbF28Dn9xqjdhuSqVPPcRnVez36oqeYH5pi+HqXnhY2PVmcIacEktPf77
	M9wEV6K6d/uYs541XGNjKBzl6ISUNlEkiqDAntfVdq+0V/DbJ6tc623pFGKxcQ==
ARC-Seal: i=1; a=rsa-sha256; d=iki.fi; s=lahtoruutu; cv=none; t=1788860681;
	b=cd7AyBRDueQ3jJ07ANj8QVqU/kQcA2cgPwWB+a1kMFB17+jff+jVogBR19z9cBvB3JLG5d
	IghYGue4kaEhJ0gHF5Le074jyFkZKUZbAzNdR/ZDW/2L5z4TGS7DJpjBNC2JCmJ8tghWJq
	/NzwsYKa1EJOCy0Fk++A04t3RxTk1FxpwVeErcjxnuVQRyAtRnKy7rctvOAmiqpn1tkA4h
	2+jtrhdXBmV8R+rYaAaKJbHuVSvEV5q++dKxKK8hq7iJgz9Y+MAqrcJcsGP5Ie+wFBrLny
	sdTRrtYdfuEKcwKg7CQhk/7v3bV0I6Rr46soi8kpDDj6NH31G57yBghjZZrVJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=iki.fi;
	s=lahtoruutu; t=1788860681;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=okk/6UKvvJuFy0HfkixIG69h3/2z4AmE9S0HHh3WLco=;
	b=nNypRlsdhiGVdeSHQ37mzYZAzZIc0jJKwjTR1/SRSPlUYWgarZeLvY1Ur0/lcfZ8q654ii
	keouWkEih2fcBl2ASgw/pU0lITT780nD1NinxsNAJ21yYS8+OngDOjKHQZcJRXzeOjNCLD
	fuYrEH18QUBbamuINv8V4nusbz7F5MOTZb3mQ5HJLmtzIMaNMOLujHC+QoOojwTChIV7kx
	jveuPjbs79ZmnM/QLOjsiI2kptslQplomSHzPGHnUuK12cStr2/BL/xzlju9GTwpE5gIPf
	MMJu/HD/tYBtWnV1E5N+G/jfKlpvD8nooc5lBYuJDBPS2U7BXWZLxaSC37ABfw==
ARC-Authentication-Results: i=1;
	ORIGINATING;
	auth=pass smtp.auth=jmtilli smtp.mailfrom=juha-matti.tilli@iki.fi
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfauth.ams.internal (Postfix) with ESMTP id 0D73E198003A;
	Tue,  8 Sep 2026 05:44:40 -0400 (EDT)
Received: from ams-imap-13 ([10.64.2.33])
  by ams-compute-02.internal (MEProxy); Tue, 08 Sep 2026 05:44:40 -0400
X-ME-Sender: <xms:Bdmfag0oJIPtIHdp15FNK_ZlFdN56u-GxgQtG_P6tcyg-IKQuxu50w>
    <xme:Bdmfal6P618KOufT0AatJ7zRE4WPse3oGZosgxLcXeX3xEYbamL5ACxj0a94aXzP6
    4rZ0G6g-gEzVQKHhwMpfThmMB0F4Q7zlK9rvH05npXZlKoMVGSFgeoE>
X-ME-Proxy-Cause: dmFkZTEQ6RAYbZbS6n2XZ91CCDVH1PswnGr8U2+3tuLiFTy4d1Bb10G7XCafM0ID5ejv1h
    UZXyfcVmyzTcL718ElzEntJLirWMZWQhFqPCw2ydLCRkreUBMw2X3HnoN+1F7JnndHR8zi
    Sp4ODtSghtSxRKi4Cg861W0s4zHP/rrBOdathqyDMBoI/8T7s8i7Sbxh3vHOGHKpO+cw7K
    kcvpmbSz0nr0H1WhIwf4idE53v9ZsBaHoldGedv2Gdl6cVY0ywUqLCFL7w588aYhy64fOv
    SArJG669zMjCkJOlbyfwleJPE+mp9+24JBGl4a/sLnqcR7NpKb6o2Jut9dnpzXgjBXBjN+
    ZbaBEggnrGmIsPujM9VgF9Oug0fw8KuqtdbLn7kzmkc3wPC30aIXgzv6OFPNklHY+Fypmc
    HqanJxDTY6vLsYHuUxlM0qgUcp8bR4T/88Lfcnfr0gPXfre+lJPGQ8bXt2GBrNuOOzKlZY
    hEgQQss4L2oBP+d9CNGZJXrTGm8/jCRjQ9nL6XpH1UqHyvNuhYZfC6kNuph0jCo944fk0r
    E7kl6dQ/ntbsfOL1i4biQAriVlCJgrKbCpMweYBxAaDPHEP+/r919UIhhC/IYmWg5unr14
    V1LF0wEfCTTYNlVAPB+LBTdH9H8+SQRHgOasCrb6mtNlINf1A5NIcjiy3zNQ
X-ME-Proxy: <xmx:CNmfakY1PnJ90UlsCm8XHJwYiV_5SHH34CS-GYqSCvPOjzxhjoKRzQ>
    <xmx:CNmfaoIuCvbPae8Iatr8AFQel9kzLtqBvQCF-9mZfNDKjANJ47Kwxw>
    <xmx:CNmfatq4lc6ZVy1cPfkC6DZ0N7p7rvggsllI4zSFJtQmgebEKIVsQw>
    <xmx:CNmfahAo5lASRNKEZmoX9AoEIxTZhw7W3mioKr96w7lbO0rA63w9fA>
    <xmx:CNmfajcudKS2cF_hGTgEqVcCI_OV8tv7zL1oiUTz9Nh6UtNVV37URmL0>
Feedback-ID: i02414972:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 71AD9F80083; Tue,  8 Sep 2026 05:44:37 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: Av35K2MZ7qUg
Date: Tue, 08 Sep 2026 12:44:17 +0300
From: "Juha-Matti Tilli" <juha-matti.tilli@iki.fi>
To: ath11k@lists.infradead.org, ath12k@lists.infradead.org,
 "Kalle Valo" <kvalo@kernel.org>, "Jeff Johnson" <jjohnson@kernel.org>,
 "Manivannan Sadhasivam" <manivannan.sadhasivam@linaro.org>
Cc: "Bjorn Andersson" <andersson@kernel.org>,
 "Konrad Dybcio" <konradybcio@kernel.org>,
 "David S . Miller" <davem@davemloft.net>,
 "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>,
 "Paolo Abeni" <pabeni@redhat.com>, "Simon Horman" <horms@kernel.org>,
 "Mihai Moldovan" <ionic@ionic.de>, linux-wireless@vger.kernel.org,
 linux-arm-msm@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-Id: <2cf63e00-95aa-41ba-ae8e-8abbfbc486e7@app.fastmail.com>
In-Reply-To: <20260908093145.2492666-1-juha-matti.tilli@iki.fi>
References: <20260908093145.2492666-1-juha-matti.tilli@iki.fi>
Subject: Re: [PATCH v3 00/12] ath1{1,2}k: support multiple PCI devices in one system
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Tue, Sep 8, 2026, at 12:31, Juha-Matti Tilli wrote:
> As you may well know, multiple identical ath11k and ath12k devices are
> not supported in a single Linux host because they use conflicting QRTR
> node IDs. Fortunately, Denis Kenzior created a patchset to support
> multiple QRTR endpoints with identical node IDs, and Mihai Moldovan
> refined it, after which I took over the patchset and refined it more.

Hello,

I am incredibly sorry by messing up the threading. git-send-email said:

4.7.1 Error: too many recipients from 83.150.90.33

...and failed at the patch id 8/12.

So I thought retrying from where it failed would be safe. But that
broke the threading.

The next time, I'll increase the waiting time between subsequent mails.

Links to mails missed from the thread:

https://lore.kernel.org/all/20260908093437.2493698-1-juha-matti.tilli@iki.fi/
https://lore.kernel.org/all/20260908093437.2493698-2-juha-matti.tilli@iki.fi/
https://lore.kernel.org/all/20260908093437.2493698-3-juha-matti.tilli@iki.fi/
https://lore.kernel.org/all/20260908093437.2493698-4-juha-matti.tilli@iki.fi/
https://lore.kernel.org/all/20260908093437.2493698-5-juha-matti.tilli@iki.fi/

BR, Juha-Matti
