Received: from mta1.migadu.com (out-118.mta1.migadu.com [95.215.58.118])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13F5F3D301F
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 07:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.118
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787643201; cv=none; b=NqlsprSexHWPecOzK227tl7sK8IgG+Lg8bYv4er3U+Od5ViEHm7re82cszaBScXJ5zre3/l61V1VpXkDeIB2H+QZZp6DK532dr0BMtjKQ1jpo1ZTIRxBqX7BsHmp8tqHT6fusmdt2oirr7JnYO+UgMir2nj17y/g63EcLBoue6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787643201; c=relaxed/simple;
	bh=3uNQf3vAiyaKWPIVk7SKgJoqF3sI2cvIpXKhpy1pCV0=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=dlL2hJedNGrYypBAKdTifSprr06dfNPsBbPIn/ZWKH6EinXlrpbJDrtoDI265ox//V18pFQ5IKBVLBG6klMXAlAXkI56jN6gJX3k059/Y3EtGwPhRpdVsAIou6Vrtag0+LSm/zXNzKVJRqLpTqICpAUymgsqUCX+vjAWEhidV5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=IOI8U//Y; arc=none smtp.client-ip=95.215.58.118
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="IOI8U//Y"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=3uNQf3vAiyaKWPIVk7SKgJoqF3sI2cvIpXKhpy1pCV0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787643197; v=1; x=1788247997;
 b=IOI8U//YQt5iE92Y0z6Td8I7ApNhErXYhNpRCU/gCNp4jDQwcExfEQet9Z0vrQwPnQ4F1SQ7
 9ERCEjVw4hU6MpM4HooCrPccy/hPrUwpW0bMezDA0wLocN0So9ibWq1U33unokEJgSTkhB5UMJq
 gmOVvPOv6A/jX+WbTDzZqEJw=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from ehlo.thunderbird.net (31.223.131.35)
	by smtp.migadu.com with ESMTPS id 8611aa49baacc79d;
	Tue, 25 Aug 2026 07:33:17 +0000
X-Mizu-Trace-ID: 8611aa49baacc79d
X-Migadu-Flow: FLOW_OUT
Date: Tue, 25 Aug 2026 09:33:15 +0200
From: Luka Gejak <luka.gejak@linux.dev>
To: Ping-Ke Shih <pkshih@realtek.com>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Michael Straube <straube.linux@gmail.com>,
 Bitterblue Smith <rtl8821cerfe2@gmail.com>,
 Peter Robinson <pbrobinson@gmail.com>,
 Hans de Goede <johannes.goede@oss.qualcomm.com>, luka.gejak@linux.dev
Subject: =?US-ASCII?Q?RE=3A_=5BPATCH_v7_4/6=5D_wifi=3A_rtw88=3A_sdio=3A_track?=
 =?US-ASCII?Q?_free_TX_pages_and_OQT_credits_for_RTL8723BS?=
User-Agent: Thunderbird for Android
In-Reply-To: <f3f44d1bf5c248ef8ccdc092c2354ac0@realtek.com>
References: <20260820090412.19574-1-luka.gejak@linux.dev> <20260820090412.19574-5-luka.gejak@linux.dev> <17c3c1f641fe41c4bfacb989af4b75a6@realtek.com> <AD323744-AE68-4C77-92A9-CD215B8A7E43@linux.dev> <f3f44d1bf5c248ef8ccdc092c2354ac0@realtek.com>
Message-ID: <E2ACBF1F-1C98-4091-A851-E2D8AF006911@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On August 25, 2026 9:25:13 AM GMT+02:00, Ping-Ke Shih <pkshih@realtek=2Ecom=
> wrote:
>Luka Gejak <luka=2Egejak@linux=2Edev> wrote:
>> Hi Ping-Ke,
>>=20
>> On August 25, 2026 8:12:58 AM GMT+02:00, Ping-Ke Shih <pkshih@realtek=
=2Ecom> wrote:
>> > guard(mutex)(&rtwsdio->tx_credit_lock);
>>=20
>> The lock is only taken for this chip, and guard() is unconditional, so =
I
>> split the locked region into its own function instead of branching arou=
nd
>> the lock:
>>=20
>>         if (!rtw_is_8723bs(rtwdev)) {
>>                 txsize =3D sdio_align_size(rtwsdio->sdio_func, skb->len=
);
>>=20
>>                 ret =3D rtw_sdio_check_free_txpg(rtwdev, queue, txsize)=
;
>>                 if (ret)
>>                         return ret;
>>=20
>>                 return rtw_sdio_write_to_port(rtwdev, skb, queue, txadd=
r,
>>                                               txsize);
>>         }
>>         =2E=2E=2E
>>         guard(mutex)(&rtwsdio->tx_credit_lock);
>>=20
>>         return rtw_sdio_8723bs_write_port(rtwdev, skb, queue, txaddr, t=
xsize,
>>                                           write_size);
>
>I meant
>
>    if (rtw_is_8723bs(rtwdev))
>        guard(mutex)(&rtwsdio->tx_credit_lock);
>
>Doesn't it work?
>
>

I tried it, and no=2E guard() expands to a declaration, and a declaration
cannot be the body of an if, so it does not build:

  sdio=2Ec: In function 'rtw_sdio_write_port':
  include/linux/cleanup=2Eh:302:9: error: expected expression before
  'class_mutex_t'
    302 |         class_##_name##_t var __cleanup(=2E=2E=2E) =3D

Adding braces builds cleanly, which is the more dangerous version, because
the cleanup then runs at the closing brace and the mutex is released again
before any of the code it is meant to protect runs=2E

That is why I moved the locked part into its own function: the guard needs
a scope that is exactly the critical section, and an if body is either too
small or not allowed=2E

Best regards,
Luka Gejak
