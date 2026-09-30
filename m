Received: from fout-b4-smtp.messagingengine.com (fout-b4-smtp.messagingengine.com [202.12.124.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83EA9453A33;
	Wed, 30 Sep 2026 07:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790754765; cv=none; b=eekkenuwar4Yt9OFIoBpW+xVhUPLEzrsd/I63FKIJp5xLL0uo5VEDzAHGYqb1ZtpVy1kk9STQZ6lZCDN9LxE4On+sFDriUvI9DMBCDizu8mEQLL7cdcrvaSpfioXp1qnR5Ep4L+vz/qAbe1qbNyOElWl6ymsjhXMYr94DXzNA0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790754765; c=relaxed/simple;
	bh=+ZUjpI1bbEQ+Y3jyaObrNhgx4hKta9AFmHyIBk+ib0Y=;
	h=MIME-Version:Date:From:To:Cc:Message-Id:In-Reply-To:References:
	 Subject:Content-Type; b=LW2zkb0sonGgnQ/Mq9gHD+O/rp53Wgk6ff5YNVnweaIzATsBF7U4o0ap8WI6ca6g8b/ItEkwytMO/W9SkVZD11NmIxzAFLjEhnw8OX/HY1lyzvXLO9Owiw2fpjoF9dSkMhcjE3BG8ZHfHf0FbPU28f7b4TeK1Kp3DF3HcYQcJDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de; spf=pass smtp.mailfrom=arndb.de; dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b=mkDauZe8; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=d9hRquuf; arc=none smtp.client-ip=202.12.124.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arndb.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arndb.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=arndb.de header.i=@arndb.de header.b="mkDauZe8";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="d9hRquuf"
Received: from ams-compute-02.internal (ams-compute-02.internal [10.64.2.62])
	by mailfout.stl.internal (Postfix) with ESMTP id 91C671D00715;
	Wed, 30 Sep 2026 03:52:41 -0400 (EDT)
Received: from ams-imap-03 ([10.64.2.23])
  by ams-compute-02.internal (MEProxy); Wed, 30 Sep 2026 03:52:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=arndb.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1790754760;
	 x=1790841160; bh=LogGlCJ0mVEO3OVB8MrJLtlRZkt6j829s0jF8jKE/FQ=; b=
	mkDauZe836rveNeLxwAwB/9HKis53swdNDZJoCsZV55bT8nffQmtfNuWGETEyGyU
	kaqQc5XA5O7Nrd/0GOpSg5aRAlbBrPfL204IP3QHIprmwD55uEkztLW8nOjNlMbm
	V4nYnj2J8JV9+ZVrRDiU67KNnryGuYoYzpRgvjKeVaRhWP29PXdRKdAJGMlnIpBK
	Yifh2/7HFRkVVw6UKfkc5pPYhq/bID2xrK41qyAVosQJM6yYXSzxViG+TFYTVS0e
	6knSeN899yrjjDqBCmI4Josv5GAsU68KO615A8qJm9FWBTIrAFvhyLcaCbObAmHx
	cEfbmeligx2jQKLQFsuKmQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1790754760; x=
	1790841160; bh=LogGlCJ0mVEO3OVB8MrJLtlRZkt6j829s0jF8jKE/FQ=; b=d
	9hRquufQpG6Nwd8APPlsH69OKkCBmFqLm7cKmrNATEQkTJ6oOpeEZB2kYA19OcDv
	BNukcb25lNrVl2vYD1EXIp9I8ejTCkDNsioepVnchZ1ycLmF5aZgsKNnjvz5vygE
	37E1m7xhxQc+v5Y1vTvyIrb5vH/feGDWqt7YYScQbc7ccG8josKoRjMYN94OUG18
	mSqjvLFEFerG5/6iFTX9IzWyMJbvGL6HHPONgnsX3+wIqX7p/h2TfELlGoYZ2KB1
	xqMZ/FpzbN7+eOaslXVGgvil3Ee+wKfEbS6TApF7jTjwaZz0Vl23OPFtlEPtYsgc
	jBLcP9PsTETEhtIFnbXqQ==
X-ME-Sender: <xms:xr-8anR4neW_irO6Xt81-Gcpmk0rHtZWNumHCBt8GnOt1b7vXnqx6w>
    <xme:xr-8ajlVw7zUl8yv_OjLbAZopfEpWSHa5pjOnsxPZOksftdKbQu8QwJTNJjbfuFde
    WJjx0mjqaznK2G8xh-SLKvIAR98wMsO11xXUSkosjtAuiYVD34-eUmJ>
X-ME-Proxy-Cause: dmFkZTGmX3wTdRV6d8JIY92p9Kp+huUcE/MQojo/VtO81/18ppr1ZR60bB7cP9Z5dOW8Jd
    g3BQq01QNYnzP9beah9vomnv9RxIu1Rl6lyeABnLkHMRBqEsGmICIGaOv+tCpiUu1uslIJ
    CXnHvzQMeeZCebbce0vPSS1sGXrNgMxcL6/ZjboqZMvDigBgDkttHG74h26DS46VMp28IM
    3sCyUDKXwn0ec/fP46Hd3pQEf8vu5C4mBsaTf8d04IaXcxoflzNR93a2lvnbcB1a+iw/VS
    0WylwrtgcOsx3jVqFe/vJHZ1QogFQAq19Ck5m2wcRQ6GfVNuKzIbOjikCVatiw6P3vQ7mT
    eYkSUIXZM7TJ0tAz6/lV9YqymRwuXcBoBb4IYSumSTDodqHeZUlHb8SjBnnM84ZVdtRhG3
    W0a+tF8U7f9TYiGA6LK1QIWTZSPUzefH73PJt9kkfct0ZGMY6QYQb0iXmObkIlbP6DVsYC
    Qxvz/y4YDAKDyrY1hu3IdPT+m7ZOgRtMgaZNG3CX2F6m5UPzM+f3LzMdLNhhb1y/wShw0+
    mmHt8OUVXn8vubm9zyQGc1jYLml4pkwxqnmyZ85KuMWMd0edcWy3RWWdUStLVNMtE15wUO
    qJr9bnIC6GSHqhUV4464OWZbhKORjFjSBJkLr0l6JXfCEIRGCln8g+Ob6aEw
X-ME-Proxy: <xmx:x7-8anR38iDq9w28QBGq6FOEm4s6t4Voky-Ja_H_Q_9EG1qvNFoWSA>
    <xmx:x7-8ajszryQnLXWfTqn3rkGQcPJpVtMsQdxcBo4NJP3eGOsZiJfI0g>
    <xmx:x7-8ar1IDHl389fgq4qVW6khd6ORnavnL0ygZeM_GnrKYnDDqaH2Bw>
    <xmx:x7-8asXKnoYj37sZdNYEzGzmSq5H44stY4KKuQxv4SeFCKpHncHXcg>
    <xmx:yL-8agio6XC88-D1E-_QnLbBXgS9aehcUAzCg6obnywC6PlGk8Uzsb7t>
Feedback-ID: i56a14606:Fastmail
Received: by mailuser.ams.internal (Postfix, from userid 501)
	id 9B1B932A008A; Wed, 30 Sep 2026 03:52:38 -0400 (EDT)
X-Mailer: MessagingEngine.com Webmail Interface
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-ThreadId: AeRYNq7l0AL7
Date: Wed, 30 Sep 2026 09:52:18 +0200
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Ping-Ke Shih" <pkshih@realtek.com>, "Arnd Bergmann" <arnd@kernel.org>,
 "Johnson Tsai" <wenjie.tsai@realtek.com>
Cc: "rtl8821cerfe2@gmail.com" <rtl8821cerfe2@gmail.com>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Message-Id: <0162247f-ca33-4152-bd32-255343c7216b@app.fastmail.com>
In-Reply-To: <1bde7ea5999c4915b184bf2fcb904901@realtek.com>
References: <20260929104159.3236854-1-arnd@kernel.org>
 <1bde7ea5999c4915b184bf2fcb904901@realtek.com>
Subject: Re: [PATCH] wifi: rtw89: fix LED dependencies
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, Sep 30, 2026, at 02:28, Ping-Ke Shih wrote:
> Arnd Bergmann <arnd@kernel.org> wrote:
>> The problem is a misunderstanding of how Kconfig dependencies
>> work, as the 'imply' keyword is not sufficient to enable a
>> a user-visible dependency, and the boolean 'RTW89_LEDS_MC'
>> symbol cannot determine whether linking against the MC code is
>> valid.
>
> People intend to weakly select the dependency. I think keeping
> 'imply' is harmless.

Whoever those 'people' are, please tell them to stop using 'imply'.

It's obviously harmless in the sense that it doesn't do enforce
anything, it just make it more error-prone:

 - the first 'imply' only works because MAC80211_LEDS has
   the same dependency as RTW89_LEDS, so it works as a 'select'
   as long as the dependencies don't change. If the dependency
   were to change, the only difference is that imply makes it
   harder to debug because it skips the helpful message from
   kconfig.

- the second 'imply' turns on a random symbol from another
  subsystem, which is discouraged.

- we already have a mix of 'depends on' and 'select'
  for the LED support, which can lead to circular dependencies
  and other problems. Adding a third way can only make it
  worse.

>> Address this by using the correct construct to determing whether
>> linking agains the MAC80211_LEDS and LEDS_CLASS_MULTICOLOR
>> code is possible, respectively.
>> 
>> Fixes: d910631ff352 ("wifi: rtw89: add LED support to reflect the wireless association status")
>> Fixes: 721d90c8509a ("wifi: rtw89: add multicolor LED support for RTL8852CU valve board")
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>> ---
>>  drivers/net/wireless/realtek/rtw89/Kconfig | 6 ++----
>>  1 file changed, 2 insertions(+), 4 deletions(-)
>> 
>> diff --git a/drivers/net/wireless/realtek/rtw89/Kconfig
>> b/drivers/net/wireless/realtek/rtw89/Kconfig
>> index 7c678dd1f6b3..4000ae344544 100644
>> --- a/drivers/net/wireless/realtek/rtw89/Kconfig
>> +++ b/drivers/net/wireless/realtek/rtw89/Kconfig
>> @@ -208,15 +208,13 @@ config RTW89_DEBUGFS
>>  config RTW89_LEDS
>>         bool
>>         depends on RTW89_CORE
>> -       depends on LEDS_CLASS=y || LEDS_CLASS=MAC80211
>
> I remember we fixed to this style years ago by imitating ath10k and iwlwifi,
> which they look like that still. 

ath10k doesn't use ieee80211_led but seems to just duplicate that code.

I do see that my version also got it wrong, as the 

+	depends on MAC80211_LEDS=y || MAC80211_LEDS=RTW89_CORE

line is nonsense with MAC80211_LEDS being a 'bool' symbol.

The way this was meant to be used is to have

config RTW89_LEDS
      def_bool RTW89_CORE && MAC80211_LEDS

or you can skip the symbol entirely and replace all the
CONFIG_RTW89_LEDS checks in source code and Makefile with
'#ifdef CONFIG_MAC80211_LEDS', see ath5k and ath9k for instance.

     Arnd
