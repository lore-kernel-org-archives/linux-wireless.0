Received: from mailer3.cs.nctu.edu.tw (mailer3.cs.nctu.edu.tw [140.113.235.122])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6E8135A53
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 03:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=140.113.235.122
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791776659; cv=pass; b=eKuOrwRrrN51KnQfRlt5fNCC8/+iltP2XG1P0n173l3lIhbG1u0pGvQGvknKWdwkC14B1gyhHpycxAHr5K/Sh1T35QdpIMCzawC9RUWwGna9XS24kuaE7gRTnX2Kk6POKhbAWZrayO7vdS/qdhUtCXvh0JEtXfEio1WL9Q7M/rE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791776659; c=relaxed/simple;
	bh=V+MWa+npayTuwu7uRGptl+HjI9B4yKEtoJiTvcE52d0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=tJGB+7UWIY1WtDYyUz0CyDySl25OqwtkDaSK4ze+bELn+cwSYxxmowCMpMx80T/H5rCK0oTt5yU5HdqAl+eMKEHQRsqoxRSKBxDtAVktYWN+xGqTn311Yq8ANfRi38CWOcKMWwytscwYBm0LkgeFxqEV1lPWmawLUs7yJQaI8io=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (4096-bit key) header.d=cs.nctu.edu.tw header.i=@cs.nctu.edu.tw header.b=RsVuMvYJ; arc=pass smtp.client-ip=140.113.235.122
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=cs.nctu.edu.tw header.i=@cs.nctu.edu.tw header.b="RsVuMvYJ"
Received: from csmail8.cs.nctu.edu.tw (csmail8.cc.cs.nctu.edu.tw [10.1.9.25])
	by mailer3.cs.nctu.edu.tw (Postfix) with ESMTP id A7BCE1824CB
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 03:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cs.nctu.edu.tw;
	s=20191018.mailer1; t=1791776218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=V+MWa+npayTuwu7uRGptl+HjI9B4yKEtoJiTvcE52d0=;
	b=RsVuMvYJ2L2heUpDAQ2iIPuwPqkwbU0h1xWI0zULq3ke4jNiIIvhAxZtWKkI7Ko0KXizP3
	UfB90/bGoab4m6iKcvw9cUczv4c4pQnbtUFPyHydzfmr0irNG9XjnGK3XMZp+pEYbYH3J6
	5LrDwqZAZpU570ywq7tEFf4IkEjEnIMTO+ZaWC9OhDrXDzB8ItdU2QGbTzsDhpAR8fQu22
	uMfjAKc1Q26t6gTfQGA/V5JGdErRUGf7Luk6jBlvZDdg8A44p779gUtcC+ao4TZL4RO2xi
	+DKj+T7qqvOAzhf7sUoi6Pt6CgELC0RxPIaH1w7y+cvMcFXDaTjTz8w8WXGOEd/WUO8uDF
	1ogodqQnQjtcbDmPOqg/4+pklZb5avFFV4l2uXhf5Cr9Y+ZMIIEJQBs9qMhVQ9DWtSb1Wk
	09LM0Dk674DkGaTF+totWUNwKymEf1Z83nv2IVG6wcGWJjs2GB9DLsFpbzZDSudNxVyI6g
	lFb42U9tB6nm7QBlAD/B0LWr9zMeUtbwsZahlQopFCWaIYws9KysB0w/ZPK5H1yMx3KZXp
	w245ZA0CQj04LQ4c+7La394EO3DbPzvbZwG4BA2FXE1r+7lLNxvllXHnYkPnjFZb6kveU/
	PcssxwqshZom3hO2u0/1ikovmN1IRRqgZdbEhKV1rycNOydWu9RLk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=cs.nctu.edu.tw;
	s=20191018.mailer1; t=1791776218;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=V+MWa+npayTuwu7uRGptl+HjI9B4yKEtoJiTvcE52d0=;
	b=pfbHUvt52BIo/FpcsQhu46Ho24SGv+k+W3krrt8PqyGymI4bUvLHbqJ5K94vF7u+iiPfiO
	GogdmEub5PKVsP+sG3v3PZw49clSUQlgeDwVzVWNAzJaLNxkDWwCz7hj5+nj7p8c2KnRmt
	CNSKExGYm2AgLLthKBHJ7k/9mIdFfrB9Vb4vTizlNfpMSl5QtkA2E5pH31fRZ+xseOrrQx
	jLLcf9rJq34MdUX0Pbp0bIlonr1iO+6nMYw/7WyhOz9WKshtdePe/Py33/XwxtODng33tf
	yKfcCYijvD0fA4NGQAYRLIkZqkEtNiycJW0KM4zATzBu7htjz0x6OFs2bpdGysd3iJfiVu
	0iur0KOv6RL8Y/ke24Tq8O1kwralgLdc9EROZ5i5BnIHm9N3OX+k25Pl9lKC8lA4fQpMcr
	4B3kb9Rzee7GPvM5WrYlvdHE3veywneZ+hfpX/q8ZIb7DDAesspgfHMG4xSL8JXFokrhK/
	gSa2htQcohGn1pxY7zIMuEhGbD8pUVWT0ZyE+7INAxVFIHx82fe/csGQoFKUMkm8KO3U8O
	jwa4ajJnEdet69yQps1BcHvMWpMpsH6p59rUpxkPGfVm/7JtNGL+VGlSiud668wC9UQ+BV
	tb7jRmJzCMk6K44QZg7Hh5AiwfH8k/O9+En81mwufDpC4DCnfegUw=
ARC-Authentication-Results: i=1;
	ORIGINATING;
	none
ARC-Seal: i=1; s=20191018.mailer1; d=cs.nctu.edu.tw; t=1791776218;
	a=rsa-sha256; cv=none;
	b=AQyrZJmDyrYcuHajW0FvAEwuxG2FDaACc5Wgwh5nxR5w8oXH7mFfhrTGzcYQuUe2xfAGnB
	Yy9TQi5y7bLf58UJtqXYRQUxyecVwE8LMcVew6derwjiAhX8cXMr0QNbyFw7AznprI9mjq
	8ib3IkVJ7pkVmdibW1Rve4ky/QGCrfxF156iWApYlqKgneZe8Ll0oPeDAVvr85wlyHwrHK
	dtzogvq3GyrKNPemKGjcLu14ooqNeRkYMOllCrA9JLoIza2H17zcLhhtn0gXOvUiJsxyWq
	YfaCIakrWbwBBXEZJNA45DoDNUT0Kq/Oh/DrQ20ete5Ks4kKkWxCRnfEW7CbLBXNO2b4g0
	sir0oRWpy752poAbb4lz1rkjOajgzxJ0WEt+eOM+KJ7qcYzW+L3HwbmL7Pl4SvOIWfUE15
	/54pukFOHZu5dgwxFbOnGkZ/dGM4QZ9tHusosZvT3YrJZjIjrNr1mE8b5T20nQ68Z2HnBB
	3g03KDsWheAXTatE+RUq+8WlN07XMfPkRTQ3ha6QHGnFynzWfr5Jk1D/ZfWyIMi9E2Sxnd
	JjTWF5+61kpuEu0cBb29pM6SDoibxWraw10HzKuqo4Ex2eXeZx7VcMXzAWTW/bfOHD7D7G
	aHrucMcOdhu4h083yhYh3yGzKolDZGBNlgCTqUlPnqaqzYoxnMTng=
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: hctsai1006)
	by csmail8.cs.nctu.edu.tw (Postfix) with ESMTPSA id 8C4B87FC64
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 11:36:58 +0800 (CST)
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6af9a9451daso2128003a12.0
        for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 20:36:58 -0700 (PDT)
X-Gm-Message-State: AFq9FYKwgMjG3skKgo35efGbnfMs5I7ejuQ3F3Z0bN43m7/xPdXjnhwR
	Ue9GliesbM3Z3egws8vXfruYCbcIQ8KQwhtVtt4D+UHtvr7tc6IA04zws33LG9nMOwqyRxcQsM8
	LAYCc6MbWvgtj4mJd8VxkPY54dcvEi8kXBkI+0Xp94g==
X-Received: by 2002:a17:907:e10d:b0:c33:923b:ad51 with SMTP id
 a640c23a62f3a-c33923bd27amr242271866b.45.1791776216300; Sun, 11 Oct 2026
 20:36:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: =?UTF-8?B?6JSh56eA5ZCJ?= <hctsai1006@cs.nctu.edu.tw>
Date: Mon, 12 Oct 2026 11:36:29 +0800
X-Gmail-Original-Message-ID: <CAJF55xobc6hP-2gSUpiKYUibad0OV4Gg_h2wzxd4vd4Hz+Cgow@mail.gmail.com>
X-Gm-Features: AclHuK9hV_ziNNW28FNH45SW9EPEZzKOdj6NeCSoU2qHp28bbizqpceYEIDwAeE
Message-ID: <CAJF55xobc6hP-2gSUpiKYUibad0OV4Gg_h2wzxd4vd4Hz+Cgow@mail.gmail.com>
Subject: [RFC] mac80211: TXQ memory defaults on low-RAM VHT devices
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, nbd@nbd.name
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Mailpolicy: cs.nycu.edu.tw
X-Policy-Status: accepted

Hi Johannes,

Resending in plain text after the list rejected my earlier messages
for containing HTML. I've also updated the test results below.

I'd like your view on the default TXQ memory limit for low-RAM VHT
devices. On an Edimax BR-6478AC v2 running OpenWrt 25.12.5, with 64
MiB of RAM and MemTotal of 55964 KiB, the MT7612E radio has a default
limit of 16 MiB. Under load, MemAvailable reached zero with about 9=E2=80=
=9310
MiB queued, before that limit was reached.

The OpenWrt patch caps the default at one sixteenth of total RAM per
wiphy, without raising the existing limits or overriding a
driver-provided value. On this board, it sets 3581696 bytes per wiphy.
The fraction is a starting point, not a measured optimum.

I compared the release module and the patched module in four runs
each, in mixed order, rebooting before every run. The tests used
wired-to-Wi-Fi UDP traffic to one 5 GHz client, with a second stream
on another AC. The release module rebooted in three runs, and hostapd
and netifd were restarted in the fourth. With the patched module, the
host stayed up in all four runs, no OOM events were recorded, and both
services kept running. Single-client TCP was about 280 Mbit/s with
either module.

The Wi-Fi results were not entirely clean. In three patched runs,
mt76x2e reported MCU timeouts and restarted the radio. In one run, the
client's queue remained stalled for at least two minutes. The release
runs failed earlier, so I cannot make a comparable assessment of this
behavior or rule out an interaction with the lower limit. The
secondary stream also lost 9=E2=80=9331% of its packets at the receiver,
despite no drops recorded for it in the TXQs.

Simultaneous load on both radios remains untested. These are OpenWrt
results, not runtime validation on wireless-next.

Would you consider a RAM-based default in mac80211, or would you
prefer distributions to set these limits through the existing nl80211
interface? I'd appreciate your view on whether this approach belongs
upstream before preparing the upstream patch.

Original report: `https://github.com/openwrt/openwrt/issues/25722`

Patch and latest test results:
`https://github.com/openwrt/openwrt/pull/25733#issuecomment-6111638777`

I have use AI tool to assist me in writing this proposal letter bcuz
my English might not good.

Thanks,

Hsiu-Chi Tsai (thc1006)
