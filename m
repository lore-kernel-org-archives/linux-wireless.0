Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793152482;
	b=oHAzw/jj2R24L3r82AJWN6lDsknuru6Q5trfVbo8/zsKj5ejZrmQ0pWCIXUPirDJEhtf
	 7ftcmjTqHsuMkuolNXkJ1KuBufaZR1nuXtZRsbnnWwIN5uVfm5vFdzwd/rfkBvJuwcrgy
	 hbC9eGjF+0FAQHgecCP1KLliAYhmtpMmkZbYgsYadNcOwWA5yqRWl+6CCaEdsG7qgzVYu
	 OveE9HW7+yGtDJpvaXLGtDdBrnbNyAU813bX2RfBzR31yo0f0O3uACZzV46zMag8bbnCO
	 0wAWVbymfSs9Mz3k4c/0SiEVdv09IhPo8+kmaAiYXQoaN6sqxAVxLhp4nFYFvVw69VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793152482;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=Jv0viWHQHTUEV1mDCkGnX75tF9pmsdnlVC2brICS/pY=;
	b=o3E1+2WeI7CmKaRF3F8mz42hRfG3VNg+09LIhBnUOvbr1dX3qKvG7YogRyO01caljFck
	 HF1SZJLcaabbcXGjDyrzJ/XhbUV9Xlj1zB4LAbgghDwjuJSVaiAGYN9gfGF6vEWCPj4iY
	 R5qt9XyMDn8qiW27PFi0vprjfv4IUQCVFA0rK1vhj4XRaUI82dZKg4qsHDF1NSryTr4Pl
	 akz45fXFHWAxLCsKzBX8h/G0oGS9m/v9GeoJB5spU15FbibW1aJ6egp6Z9NrYXZv4S4c/
	 L0HIToK54biaZeWDYeo7Q5uv6PnWrwMWY7AwKLEZBwwO2YSKmTkygrZ35mDqMTA9Rqw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=dPXKpcGv;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72749606A31D;
	Wed, 28 Oct 2026 01:54:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72749606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=dPXKpcGv
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69S1sPnrD1438641, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793152465; bh=Jv0viWHQHTUEV1mDCkGnX75tF9pmsdnlVC2brICS/pY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=dPXKpcGviR5nwI9MZ4YlJHUM021OBcWcbTVpVQwqsbpNcshU4SxBJb0bn2QcKlgHG
	 Yt1DWFnBWfDC7dGdoDfTfzfdeuNwMN/1Tbs3ojfPS9a7PMCv0d84LbNjAVO2wQZ3RI
	 i9xpwQuL/7Av/nMDq/Z5Az8Mm9rZsr7anwLwPkwKywIkNwa0XHrng+szBWrFwB8xKx
	 KiOd3YEkHgtvC1u0MNkG+8oseMqb7/Te1yfwgtoHzuq9I7N0QgPYxkfSSGFlOzFNvy
	 oBzm8Vx1xXQbpKcNNQ13MDQdVI4z88VTXM518giHl7lhBxkUAgnYxDwhWBKmmJ1nSh
	 d+xWrmN/9J7UA==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69S1sPnrD1438641
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 28 Oct 2026 09:54:25 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 28 Oct 2026 09:54:24 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Wed, 28 Oct 2026 09:54:24 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Luka Gejak <luka.gejak@linux.dev>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mehmet.fide@screeningeagle.com"
	<mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v8 2/3] wifi: rtw88: support channel switch in AP
 mode
Thread-Topic: [PATCH rtw-next v8 2/3] wifi: rtw88: support channel switch in
 AP mode
Thread-Index: AQHdYVG43GUzyp7a8U+d1TEXFu+Me7cNv5wAgABaToCAApC2sP//82gAgAGdZ9A=
Date: Wed, 28 Oct 2026 01:54:24 +0000
Message-ID: <a0a741641b9f40248c8754c8e1e8d5fd@realtek.com>
References: <64d3a24e0afd460db4a182bfa2214aa0@realtek.com>
 <20261027091312.1421798-1-mehmet.fide@gmail.com>
In-Reply-To: <20261027091312.1421798-1-mehmet.fide@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Mehmet Fide <mehmet.fide@gmail.com> wrote:
> Hi Ping-Ke,
>=20
> > During the WoW suspend, I think AP stays on original channel and sends
> > beacon without countdown. How does associated STA do? Will it switch to
> > target channel and disconnect result from no beacon?
>=20
> Yes. I tried it with mac80211_hwsim on wireless/main: the station
> switches on its timer even when the AP goes on beaconing on the old
> channel without the CSA element, and disconnects after the beacon
> loss. From the code, only drivers with abort_channel_switch (iwlwifi,
> mt7921, mt7925) abort the switch on such a beacon and stay.
>=20
> The AP stays up during WoWLAN only with AP + station on the 8822C:
> WoWLAN takes a station vif only, so with an AP alone rtw_ops_suspend()
> returns 1 and cfg80211 stops the AP before suspending. I checked this
> on an RTL8822CU during a countdown.
>=20
> Refusing WoWLAN during a switch would not help the stations, cfg80211
> would stop the AP as well, so I would keep v9. The resume path does
> not run on USB, the device is unbound during suspend; an 8822CE is on
> order, it takes two to three weeks, and I can test it when it arrives.

Understood. Then, AP mode continues to switch to target channel after
the resume.

Ping-Ke



