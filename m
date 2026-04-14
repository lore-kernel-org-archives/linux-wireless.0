Received: from smtp.forwardemail.net (smtp.forwardemail.net [121.127.44.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BE034DCFF
	for <linux-wireless@vger.kernel.org>; Tue, 14 Apr 2026 11:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=121.127.44.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776166249; cv=none; b=tiKaCoJ6GhcsNagTT6ecFitk6POObYElB0IihU0f0hSHzktgk72jbh1jKVl6ID3LYFdEdHkH7K2A3l6K35Od3xsEAVZgXo4bQ5AETJn9Fs+ZAOmo7ChSEQuTtiTY6r3dv0KvFk1uB/ba8OgKoVxVshCOT28f8ui5ouAEuimsOuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776166249; c=relaxed/simple;
	bh=Xitvg6EmoRMrDndV4vUkzGscWrGz8aNvlTxgksPRITo=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:
	 References:In-Reply-To; b=ppOSFmd0T30vdvv9X1KPu9YyX4ahxLnkkhTUIQ1S7bwuDnvoH4p2a+TsE0Kzee21/cPUy0Ads3jAjCS07paSqnVqSamiAMqSfeUHwxYXmIhOYmPsd0ccQ5VshOYuI9ldGi9Vn0lxp3qwgWzbYqEEE5lxbOqPuvuITHsIj5DMeoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ubuntu.com; spf=pass smtp.mailfrom=fe-bounces.ubuntu.com; dkim=pass (2048-bit key) header.d=ubuntu.com header.i=@ubuntu.com header.b=Sw/x50hn; arc=none smtp.client-ip=121.127.44.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ubuntu.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fe-bounces.ubuntu.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ubuntu.com header.i=@ubuntu.com header.b="Sw/x50hn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ubuntu.com;
 h=In-Reply-To: References: To: From: Subject: Message-Id: Date:
 Content-Type: Content-Transfer-Encoding: Mime-Version; q=dns/txt;
 s=fe-953a8a3ca9; t=1776166247;
 bh=Xitvg6EmoRMrDndV4vUkzGscWrGz8aNvlTxgksPRITo=;
 b=Sw/x50hnJhWmDl9Uikpf5/xQkojwAPgHjOtkDQI5sxbOmV2J/rQgMQkD26fQgpeFgm4fj6nuu
 rldgxCkP13iACNiavPcSfl9blyI1u8Ogb66MvKn4MIhZwsfTeHfBhSKQFa5prFqAN23TkB4zf/A
 e0mgUSYsRiAO65Mz7eNiVlxrU15TdFren5UPkmiWvY4fWy6o1ezgpacyo7xMS/UpXKwPmweyy1S
 QFMO439jksJRTh2dv7k2WN7bIxMkp1WY0UHxomy8jiOgWjcg54VghJQ0HSpHhmOcD0FqOCmzUmz
 6sjMpyhz28qZJVJuheH9+ovLB//0k893EKAdSTwcwUGg==
X-Forward-Email-ID: 69de25640963e560b6266193
X-Forward-Email-Sender: rfc822; jpeisach@ubuntu.com, smtp.forwardemail.net,
 121.127.44.73
X-Forward-Email-Version: 2.7.3
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
Date: Tue, 14 Apr 2026 07:30:43 -0400
Message-Id: <DHSUDVMGW0PS.2LYWKGG1C1135@ubuntu.com>
Subject: Re: Firmware for reverse engineering b43?
From: "Joshua Peisach" <jpeisach@ubuntu.com>
To: "Johannes Berg" <johannes@sipsolutions.net>, "Joshua Peisach"
 <jpeisach@ubuntu.com>, <b43-dev@lists.infradead.org>,
 <linux-wireless@vger.kernel.org>
X-Mailer: aerc 0.21.0
References: <DHS1BJ5XFYRC.GCF9PXS0OSRI@ubuntu.com>
 <c62a448843f189d78187de18d3fcb955f2779d13.camel@sipsolutions.net>
In-Reply-To: <c62a448843f189d78187de18d3fcb955f2779d13.camel@sipsolutions.net>

On Tue Apr 14, 2026 at 5:14 AM EDT, Johannes Berg wrote:
> I think there's no easy answer - what are you even trying to achieve?
> Does b43 not work sufficiently well? Do you even know if some specific
> calibration have a tendency to go out of whack? Is there later firmware
> that has some advantage (given how little actually happens in firmware
> in these devices, I'd be surprised by that) but isn't compatible with
> the driver now, and you want to change that?
>
> I'd be tempted to say that if there's no problem there don't try to fix
> anything, the hardware is ancient anyway, likely has few users, and
> those users would probably be fine with just leaving it?
>
> johannes

The BCM4321 (nphy) doesn't connect to my 5G network, so I figured that
by filling in TODOs and FIXME's, I could eventually get something
working.

Other than that, I was thinking of making improvements for the sake of
improving the driver.

-Josh
