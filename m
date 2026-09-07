Received: from smtp.forwardemail.net (smtp.forwardemail.net [121.127.44.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CAD4E8E16
	for <linux-wireless@vger.kernel.org>; Mon,  7 Sep 2026 13:01:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=121.127.44.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788786081; cv=none; b=YUgHee0jYuV2bQsrFnHxHfzLtlqA2MaZAPmlvM58+pepOoMUcYbBWS9plhHgLO2MIwh3N00hLbpCZBDrbwv5rabdHad5gWBIaNO+yIJosIrtOCIB5ZDzmaYVviTRD4XmGcr7r3CcJ01CIL0J1+RmpWJnU9c8CWfuXCrT8o9nqJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788786081; c=relaxed/simple;
	bh=XJC28kyFBFHh55MFL9xqSsgO3JBx/Prlq6Tro9Wq2vU=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=X4NnZTLceCjWF+dabSec3ZcRKjv5vWVCTmmMokr89IaWsCMBypr9F5MNCNdt0p4YF3myASA5RnIaiAte0YA0bvpCTzbIiCjqVb5qPZ6M4csNLZBh8G6reKVke9A9chMjZztcUqdIoHKwD1DIM5AwkpiMtywWgcvqsvtEPWREeqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ubuntu.com; spf=pass smtp.mailfrom=fe-bounces.ubuntu.com; dkim=pass (2048-bit key) header.d=ubuntu.com header.i=@ubuntu.com header.b=Q+trQsMt; arc=none smtp.client-ip=121.127.44.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ubuntu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fe-bounces.ubuntu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ubuntu.com header.i=@ubuntu.com header.b="Q+trQsMt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ubuntu.com;
 h=In-Reply-To: References: To: From: Subject: Cc: Message-Id: Date:
 Content-Type: Content-Transfer-Encoding: Mime-Version; q=dns/txt;
 s=fe-953a8a3ca9; t=1788786053;
 bh=0Mb9UwR4nTQJB2bRA3Lqm6lyxR/KAuxHEv2Zzy1Jh38=;
 b=Q+trQsMtYxM0Z0CkpgQ7hbDd85GsNR+Mvx98/ZobR+EFZTY6+S6ZNXowzulIGcAcU71yGI3tw
 Cb7FBelUXI8Q8NZlSLwVmo8QGnCso+AX+P0Ji7THk5a3KQ6iPoduVjOKRrOrnP7ZcjRXrS6UGIK
 TINBwZz7vzQ7xAih1FbmkLWFhSaHAG9DNNE5RjU7mdPSJMyDbLo2sgyHM+FZC2n8/hDBrgtDD8h
 SUOY8t2F7Ud8NfT1E7CJ+tBaTLf0P8Jp+g9R3uuuSo5xDHEKqFf5ongjZ7iL6WubBjpzp/xmV+4
 yvzJYv6mWVzE4bHwcfwI5YPzPpkCKZPaq35upDQJ9Y7g==
X-Forward-Email-ID: 6a9eb58316171017b32b9267
X-Forward-Email-Sender: rfc822; jpeisach@ubuntu.com, smtp.forwardemail.net,
 121.127.44.73
X-Forward-Email-Version: 2.14.2
X-Forward-Email-Website: https://forwardemail.net
X-Complaints-To: abuse@forwardemail.net
X-Report-Abuse: abuse@forwardemail.net
X-Report-Abuse-To: abuse@forwardemail.net
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8; format=Flowed
Date: Mon, 07 Sep 2026 09:00:49 -0400
Message-Id: <DL93QEI0KQC8.30Z9WDM35DAK2@ubuntu.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-wireless@vger.kernel.org>,
 <b43-dev@lists.infradead.org>, <brcm80211@lists.linux.dev>,
 <brcm80211-dev-list.pdl@broadcom.com>, <libertas-dev@lists.infradead.org>
Subject: Re: [PATCH] wifi: fix typos in comments
From: "Joshua Peisach" <jpeisach@ubuntu.com>
To: "Christian Lamparter" <chunkeey@gmail.com>, "Hemanth Selam"
 <hemanth.selam@gmail.com>, "Jeff Johnson" <jjohnson@kernel.org>, "Jiri
 Slaby" <jirislaby@kernel.org>, "Nick Kossifidis" <mickflemm@gmail.com>,
 "Luis Chamberlain" <mcgrof@kernel.org>, "Arend van Spriel"
 <arend.vanspriel@broadcom.com>, "Stanislav Yakovlev"
 <stas.yakovlev@gmail.com>, "Stanislaw Gruszka" <stf_xl@wp.pl>, "Michael
 Buesch" <m@bues.ch>
X-Mailer: aerc 0.21.0
References: <20260904124353.6183-1-hemanth.selam@gmail.com>
 <d739eb56-b37d-4056-abf2-c3a4c9ba8662@gmail.com>
In-Reply-To: <d739eb56-b37d-4056-abf2-c3a4c9ba8662@gmail.com>

On Sun Sep 6, 2026 at 6:44 AM EDT, Christian Lamparter wrote:
> On 9/4/26 2:43 PM, Hemanth Selam wrote:
>> Fix typos in comments, reported by scripts/checkpatch.pl using the
>> misspelling list in scripts/spelling.txt.  Only touches comments, no cod=
e
>> changes.
>>=20
>> Assisted-by: Cursor:claude-opus-5
>> Signed-off-by: Hemanth Selam <hemanth.selam@gmail.com>
> Sure, for the p54 and carl9170 parts:
>
> Acked-by: Christian Lamparter <chunkeey@gmail.com>
>
> Does anyone know what ever happened to the trivial-patches?
> https://www.kernel.org/pub/linux/kernel/people//rusty/trivial/template-in=
dex.html
> Is this still going?

As a kernel newbie, I've never heard of this. I've heard of kernel-
janitors but even that seems not as active..

-Josh
