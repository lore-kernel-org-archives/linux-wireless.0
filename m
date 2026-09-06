Received: from mta1.migadu.com (out-1.mta1.migadu.com [95.215.58.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442112C15B0
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 14:58:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788706708; cv=none; b=RTtpu6sRgs+FzhTJfL6zqTjSaZxwUJ/FpxZf+8RM/jw4PQDeQ2pCYBW/hqp17YtUX+FP1J/EHxp81bfuaunYpYqRBvBPHOw9anLcyYSvR6dDctlY20/zDeqNw9AXPf2YMkkSjCTpWnqGAy716ZaOHSlknPU1wER5TuulhCX14lY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788706708; c=relaxed/simple;
	bh=X1X1XJOiaGMcgLUV9Phz5J441oQ5Q9jynA6K9H0r+Es=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=Lvauf5BWfxRvhEf/SOx0AuHyn/dW3op4/zasToECTkJe86nzoq1TqPKACOu4oWg1Yz7a6wLYD8YGfNYgz7OpiuM3gOjeUaFeOU/jh30fJRxSleyT6Pntc4+qnvCHsW8xalJhkc+iY79RnQQksDCzdbLCnjavE90GuSxO614gRjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Au2Caw1K; arc=none smtp.client-ip=95.215.58.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Au2Caw1K"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=X1X1XJOiaGMcgLUV9Phz5J441oQ5Q9jynA6K9H0r+Es=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788706704; v=1; x=1789311504;
 b=Au2Caw1K896veQEYRPH+LK7+2NA+HuStpmhlyOUn+Q6SjMU9Nsxja3EzAeQNwNzgJBAeB7M3
 xurRqQMJmK76pjdzzX3VM8A8hGu2DT8eV1ApPCC0/muaxSjWKGCcoHx/erX4A0akGuCa91D6IPI
 /B0qaY5SmUW99BF+Us3b5BeM=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7c99fd45abf91139;
	Sun, 06 Sep 2026 14:58:14 +0000
X-Mizu-Trace-ID: 7c99fd45abf91139
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Sun, 06 Sep 2026 16:58:08 +0200
Message-Id: <DL8BLOM85V8C.2LYATK4FQ9CNG@linux.dev>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, "Bitterblue Smith"
 <rtl8821cerfe2@gmail.com>, "Peter Robinson" <pbrobinson@gmail.com>, "Hans
 de Goede" <johannes.goede@oss.qualcomm.com>
Subject: Re: [PATCH v8 0/6] wifi: rtw88: preparations for RTL8723B/RTL8723BS
From: "Luka Gejak" <luka.gejak@linux.dev>
To: "Ping-Ke Shih" <pkshih@realtek.com>, "Luka Gejak"
 <luka.gejak@linux.dev>, "linux-wireless@vger.kernel.org"
 <linux-wireless@vger.kernel.org>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260825163314.1590-1-luka.gejak@linux.dev>
 <4866D935-FCC8-4F24-9C05-8678DCB22533@linux.dev>
 <f1454e9c2add47b2b01a0adb8233455f@realtek.com>
 <B2A0C047-C517-4AB4-BD6E-3EC6E9DA23EB@linux.dev>
 <f3e7701d6eb045faa31c1b914eae6228@realtek.com>
In-Reply-To: <f3e7701d6eb045faa31c1b914eae6228@realtek.com>

Ping-Ke Shih <pkshih@realtek.com> wrote:
> Without proper quota message, I need coming back to previous mail and fin=
ding
> out the stuff you want to discuss...

Sorry, my last reply dropped your text. Quoting properly from here.

> I don't know how bad the poor signal environment was. But 2000ms looks ve=
ry
> strange to me, it is too large. Have you captured air sniffer to see what
> happened?
>
> I think we can check three points
> 1) If the probe uses low rate (e.g. 6M)
> 2) signal strength
> 3) signal quality

Agreed that 2000 ms is not a sane number, and I am not proposing it as
one. I raised it only because it separates a late report from a missing
one, and it did.

No air capture: that is the tester's board and environment, not mine, so
I cannot sniff it. I will ask him for the three points above.

The one measurement I do have that speaks to all three is a comparison
within the same link and the same window. Nullfunc reports come back in
400 to 1000 ms, worst case 1460 ms (appeared only once), while management
frames on that same link come back in 0 to 20 ms. A 6M probe rate or a weak
signal would slow both, so whatever is happening is specific to the nullfun=
c
path rather than to the air, and it looks like firmware retry time.

So I am not asking for anything here and there is no patch attached to
it. If his three answers say otherwise I will come back with them.

> The ieee80211_purge_tx_queue() I mentioned is to reference to the point:
>
>>>   rtw_tx_report_purge_timer() -> skb_queue_purge()
>> I think it should use ieee80211_purge_tx_queue() instead of skb_queue_pu=
rge().

Understood, and that is what I have. I answered a question you had not
asked last time.

  wifi: rtw88: tx: hand timed out TX report frames back to mac80211

No chip condition. It is the same pattern rtw_txq_push_skb() already
uses in rtw-next, which hands the skb back with ieee80211_free_txskb()
when the HCI write fails, applied to the report timeout instead.

I will send it together with the SDIO padding fix once the preparation
series is applied, to keep them out of the way while that is in review.

Best regards,
Luka Gejak
