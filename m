Received: from mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0EF23DB305
	for <linux-wireless@vger.kernel.org>; Tue, 25 Aug 2026 08:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787645295; cv=none; b=Bawb3cEHAsQxOiW8mqlGvcLA/fl8HNnjhqVK8B1mY4VswurDujyoT98aX3VZsFg8BfVL0zKrxpyH4A5D5QNdQpZVB3drB71WlqnylGQzr81w5nuhtvpVLiFpb+I8qZ1CN/ClOr7CwgOwP8gshlH+8Q6vYBYX1J5zYmwNlniMCXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787645295; c=relaxed/simple;
	bh=xwSCTUisnEan090oTItdJ4c5cg/rEdInRMJkKPoeQ5I=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=j+HuCBOzJekydr4avDOu4BpfWtpcLYuESsayZ4W2U8J7T4nZSv4LIeL8ZK8Cj/PQ/j1Z22lDQDNh5yXS2+nf9OTuOdALqo3pvo5iwGrYxcEJUladquiB/XpxNy6WMmJArq0i7BKYCEtlr3AUR7LAYZfzBRhDEmoCH1jwZ5QaC9A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=uGJ/5VEu; arc=none smtp.client-ip=95.215.58.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="uGJ/5VEu"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=xwSCTUisnEan090oTItdJ4c5cg/rEdInRMJkKPoeQ5I=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787645286; v=1; x=1788250086;
 b=uGJ/5VEuEM4AJegmm7zUrWaEqnoQ7IpMTYlNxHHw70kKDYfAFlPJzG5mLLzJRQFT82WV1M6M
 t484Wq3vBFGrDw2nXrwo9DYZdmdXBeRjETn7veMo4VKHUql1hChz+RDsRePDCtswd7Gji0K5vK2
 d+NhodXQMrRyspSLrBuTra0A=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: from ehlo.thunderbird.net (31.223.131.35)
	by smtp.migadu.com with ESMTPS id 93f490c8784e81a4;
	Tue, 25 Aug 2026 08:08:05 +0000
X-Mizu-Trace-ID: 93f490c8784e81a4
X-Migadu-Flow: FLOW_OUT
Date: Tue, 25 Aug 2026 10:07:59 +0200
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
In-Reply-To: <68a844f5ea2b4eea827da95080a9dbcb@realtek.com>
References: <20260820090412.19574-1-luka.gejak@linux.dev> <20260820090412.19574-5-luka.gejak@linux.dev> <17c3c1f641fe41c4bfacb989af4b75a6@realtek.com> <AD323744-AE68-4C77-92A9-CD215B8A7E43@linux.dev> <f3f44d1bf5c248ef8ccdc092c2354ac0@realtek.com> <E2ACBF1F-1C98-4091-A851-E2D8AF006911@linux.dev> <68a844f5ea2b4eea827da95080a9dbcb@realtek.com>
Message-ID: <E037DFDC-7C17-4537-810A-2D5DBFF4EECC@linux.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

On August 25, 2026 9:50:05 AM GMT+02:00, Ping-Ke Shih <pkshih@realtek=2Ecom=
> wrote:
>Luka Gejak <luka=2Egejak@linux=2Edev> wrote:
>> On August 25, 2026 9:25:13 AM GMT+02:00, Ping-Ke Shih <pkshih@realtek=
=2Ecom> wrote:
>> >Luka Gejak <luka=2Egejak@linux=2Edev> wrote:
>> >> Hi Ping-Ke,
>> >>
>> >> On August 25, 2026 8:12:58 AM GMT+02:00, Ping-Ke Shih <pkshih@realte=
k=2Ecom> wrote:
>> >> > guard(mutex)(&rtwsdio->tx_credit_lock);
>> >>
>> >> The lock is only taken for this chip, and guard() is unconditional, =
so I
>> >> split the locked region into its own function instead of branching a=
round
>> >> the lock:
>> >>
>> >>         if (!rtw_is_8723bs(rtwdev)) {
>> >>                 txsize =3D sdio_align_size(rtwsdio->sdio_func, skb->=
len);
>> >>
>> >>                 ret =3D rtw_sdio_check_free_txpg(rtwdev, queue, txsi=
ze);
>> >>                 if (ret)
>> >>                         return ret;
>> >>
>> >>                 return rtw_sdio_write_to_port(rtwdev, skb, queue, tx=
addr,
>> >>                                               txsize);
>> >>         }
>> >>         =2E=2E=2E
>> >>         guard(mutex)(&rtwsdio->tx_credit_lock);
>> >>
>> >>         return rtw_sdio_8723bs_write_port(rtwdev, skb, queue, txaddr=
, txsize,
>> >>                                           write_size);
>> >
>> >I meant
>> >
>> >    if (rtw_is_8723bs(rtwdev))
>> >        guard(mutex)(&rtwsdio->tx_credit_lock);
>> >
>> >Doesn't it work?
>> >
>> >
>>=20
>> I tried it, and no=2E guard() expands to a declaration, and a declarati=
on
>> cannot be the body of an if, so it does not build:
>>=20
>>   sdio=2Ec: In function 'rtw_sdio_write_port':
>>   include/linux/cleanup=2Eh:302:9: error: expected expression before
>>   'class_mutex_t'
>>     302 |         class_##_name##_t var __cleanup(=2E=2E=2E) =3D
>>=20
>> Adding braces builds cleanly, which is the more dangerous version, beca=
use
>> the cleanup then runs at the closing brace and the mutex is released ag=
ain
>> before any of the code it is meant to protect runs=2E
>>=20
>> That is why I moved the locked part into its own function: the guard ne=
eds
>> a scope that is exactly the critical section, and an if body is either =
too
>> small or not allowed=2E
>
>Okay=2E Got it=2E
>
>
Do you mind answering this question, it seems like you missed it:

The unaligned SKB warning now sits in both callers rather than once inside
rtw_sdio_write_to_port(), because __func__ would otherwise report
rtw_sdio_write_to_port for every other SDIO chip where it reports
rtw_sdio_write_port today=2E Keeping that message identical costs three
duplicated lines=2E Putting it once in rtw_sdio_write_to_port() is the
tidier code and arguably the more accurate message, at the price of
changing a log line on chips this series is not about=2E I went with the
duplicate to leave the other parts alone, but I have no strong feeling
either way, so say which you prefer=2E

