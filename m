Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0C843D5C15;
	Sat, 18 Jul 2026 14:56:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.63.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784386590; cv=none; b=tRT+G8lwb9eztU1CBbCJbHv2Ia9TK2uuusVw3ke2g++/Tk8wfSlplvAh3WzYkz5wTVfoMgSUyHwnCIBGXupdQ2VjtTfx8GKfz3uXuvqLngUBqV0/gu2TC3+1x8Y10yZip8CuizvAkfTd/OqLG/KqwN1dHq78VIz/Cqq07nFT0rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784386590; c=relaxed/simple;
	bh=V+4RDvvdkn7QOPnyIGw4jxWXBqEFQehJEVg4UQJY85w=;
	h=Content-Type:From:Mime-Version:Subject:Date:Message-Id:References:
	 Cc:In-Reply-To:To; b=eevdLIqdVkq+SMOVRy0ccCaDXjzXOds5Z2YVAC0twQVEEM/BtDofxEZcwvW+MKywgbdUvuvp91uouIU7634g8u/1CHki+6UbXO2SYqyB5+psz19Ls4ZHKk4VHoEey0okD6ni00Du4mC4+VYVuA6m5RzG2vNTjeSuitilg/DNM8k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=breiteneder.me; spf=pass smtp.mailfrom=breiteneder.me; dkim=pass (2048-bit key) header.d=breiteneder.me header.i=@breiteneder.me header.b=istPOT+p; arc=none smtp.client-ip=188.68.63.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=breiteneder.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=breiteneder.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=breiteneder.me header.i=@breiteneder.me header.b="istPOT+p"
Received: from mors-relay-2501.netcup.net (localhost [127.0.0.1])
	by mors-relay-2501.netcup.net (Postfix) with ESMTPS id 4h2VGb21zlz69kl;
	Sat, 18 Jul 2026 16:56:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=breiteneder.me;
	s=key2; t=1784386583;
	bh=V+4RDvvdkn7QOPnyIGw4jxWXBqEFQehJEVg4UQJY85w=;
	h=From:Subject:Date:References:Cc:In-Reply-To:To:From;
	b=istPOT+pqzcKSAoSLj0AYMpMEzNMvAKubo4cW6QBfw5XmqCArRTddF+HTX6JsFc6J
	 QEDjsyrI3rySN7n2essV7k0f9+Mmgys41Zsc6+4YbNv90Pgszc18+ABtCad71FQ8/N
	 L9sjYwgju1jT0v7Cby4yB9pTLFPaxaSF+Cmi7wQybsEdEJ/iaHWihmUUAFBeiDuhEr
	 guoFHKDT4Bmy0XIo3MTzh4snyUPacAK0LceQpRyrigqpBt3XeYOvTS/20r4OfL74PJ
	 JO4+6NqPexLgnDH43ak4WwZNAB7XKvzGHG/SDRpqo3v1CxeHghPJOZHfFn6gaqbJn6
	 NiRIM0kZMVgKQ==
Received: from policy01-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-2501.netcup.net (Postfix) with ESMTPS id 4h2VGb1JR8z4y3B;
	Sat, 18 Jul 2026 16:56:23 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at policy01-mors.netcup.net
X-Spam-Flag: NO
X-Spam-Score: -2.901
X-Spam-Level: 
Received: from mxe81b.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy01-mors.netcup.net (Postfix) with ESMTPS id 4h2VGZ3Dmvz8tdC;
	Sat, 18 Jul 2026 16:56:22 +0200 (CEST)
Received: from smtpclient.apple (unknown [185.151.22.188])
	by mxe81b.netcup.net (Postfix) with ESMTPSA id BDE29C00A0;
	Sat, 18 Jul 2026 16:56:21 +0200 (CEST)
Authentication-Results: mxe81b;
        spf=pass (sender IP is 185.151.22.188) smtp.mailfrom=armin@breiteneder.me smtp.helo=smtpclient.apple
Received-SPF: pass (mxe81b: connection is authenticated)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From: Armin Breiteneder <armin@breiteneder.me>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (1.0)
Subject: Re: [regression] rtw89_8852be: silent RX stalls since v7.1;
 reverting bda294ed0ed0 appears to fix it
Date: Sat, 18 Jul 2026 16:56:10 +0200
Message-Id: <281EAB3B-48CA-4C03-B371-34F701C08C1B@breiteneder.me>
References: <4d8ac018-ce77-4e30-9596-bbc28d18c18f@gmail.com>
Cc: Ping-Ke Shih <pkshih@realtek.com>, o-Hao Huang <phhuang@realtek.com>,
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <4d8ac018-ce77-4e30-9596-bbc28d18c18f@gmail.com>
To: Bitterblue Smith <rtl8821cerfe2@gmail.com>
X-Mailer: iPhone Mail (23F84)
X-PPP-Message-ID: <178438658191.987164.16492626022687478706@mxe81b.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: BDE29C00A0
X-NC-CID: y7v3fM7yAyi31/D35iLNgDA8/CmPBB9oodkG5LsJ6Z70xibG

Perfect!
Thank you for the fast response!


Am 18.07.2026 um 13:55 schrieb Bitterblue Smith <rtl8821cerfe2@gmail.com>:

=EF=BB=BFOn 18/07/2026 01:48, Armin Breiteneder wrote:
> Hi,
>=20
> I am hitting a reproducible WiFi regression with rtw89_8852be (RTL8852BE, 1=
0ec:b852, CV:1 RFE:1, firmware 0.29.29.18) on Fedora 44.
>=20
> Good: 7.0.14-201.fc44
> Bad:  7.1.3-200.fc44, and v7.1 vanilla
>=20
> Reverting bda294ed0ed0 ("wifi: rtw89: Drop malformed AMPDU frames with abn=
ormal PN") on top of v7.1 appears to fix it -- the stalls are gone.
>=20
> Symptom: every few minutes the RX data path stalls silently for 1-7 minute=
s at a time. The radio link stays perfectly healthy -- still associated, sig=
nal unchanged (~-62 dBm), "tx failed" and "tx retries" both 0 (the AP ACKs e=
very frame we send), "beacon loss" 0 -- and the station's rx_packets counter=
 keeps climbing at ~23 frames/s. Yet almost nothing is delivered to the netw=
ork stack. The kernel logs nothing at all. Then it recovers on its own, with=
out re-association, and the whole backlog is delivered in one burst.
>=20
> Quantified over one 54-second stall (mac80211 station counter vs. the napi=
_gro_receive tracepoint):
>   frames received and counted from the AP : ~1230
>   frames delivered to the network stack   :  ~211
>   frames withheld                         : ~1000
>   delivered in one interval on recovery   : +5070
>=20
> Everything that does get through during the stall is broadcast/multicast o=
nly (ARP, IPv6 multicast, vendor ethertypes) -- exactly the traffic that byp=
asses Block-Ack reordering.
>=20
> That fits the suspected commit: dropping a frame inside an A-MPDU leaves a=
 hole in the sequence numbers, so the RX reorder buffer waits for something t=
hat never arrives, everything behind it piles up, and it is only released on=
ce a timeout fires. I have not verified this in the code beyond reading the c=
ommit, so please treat the mechanism as a hypothesis -- the revert result is=
 the solid part.
>=20
> The AP is a FRITZ!Box 4040 on channel 36 (5180 MHz, VHT80), non-DFS.
>=20
> Already ruled out:
> - Powersave: disabled (NetworkManager wifi.powersave=3D2, confirmed via iw=
).
> - ASPM: disable_clkreq=3Dy disable_aspm_l1=3Dy disable_aspm_l1ss=3Dy disab=
le_ps_mode=3Dy
>   all set and confirmed active. The stall still occurs -- note this is the=

>   workaround that reportedly fixes the CachyOS case below; it does not hel=
p here.
> - Signal / range / DFS: signal constant across the stall, channel is non-D=
FS.
> - TX path: txf=3D0 and txr=3D0 throughout.
> - Stable patches: "git log v7.1..v7.1.3 -- net/mac80211/ drivers/net/wirel=
ess/
>   realtek/rtw89/" is empty, so this came in with the v7.1 merge window.
>=20
> I could not find a way to trigger the stall on demand, so I could not bise=
ct; the suspect was found by reading the v7.0..v7.1 commits touching the RX/=
AMPDU path and running a targeted revert test.
>=20
> A regression with the same version boundary was reported against the Cachy=
OS kernel: https://github.com/CachyOS/linux-cachyos/issues/921
>=20
> Fedora bug: https://bugzilla.redhat.com/show_bug.cgi?id=3D2501974
>=20
> Happy to run a debug build or test patches -- I have the affected hardware=
 and the failure shows up within minutes of normal use, so turnaround is fas=
t.
>=20
> #regzbot introduced: bda294ed0ed0
>=20
> Thanks,
> Armin
>=20
>=20

Hi!

This commit from 7.2 should fix it: https://github.com/torvalds/linux/commit=
/63ccdfac8677387dfdbd9d4336089e9823280704

It's queued for 7.1.x as well.
