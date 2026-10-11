Received: from smtpcmd10102.aruba.it (smtpcmd10102.aruba.it [62.149.156.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48FBF2BE03B
	for <linux-wireless@vger.kernel.org>; Sun, 11 Oct 2026 16:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.156.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791737167; cv=none; b=Vm3QRcxSe0X09fJbMkg+0x5ZQ1zX/4ktqlaS89HAftM0tPAQTddIfls3v/pZOZKC5JlVGTtOY1H+Rp87zPNds9sLwadkZLSwOkdLasBx/VpzKx2MMqf+NRdTLAhcDRJ4gOKT00yBparVw+FwaTmIZQJgbTpo8TX/XahV/nsl71M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791737167; c=relaxed/simple;
	bh=noKYH/ILE+edtD22uFEoznBAxGNgkcArENQ4uTe/p7E=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=t6I6aIelkDgCOXHZFv5LblMTGCmjgYi9AS2xUac7kslqg7ys1TNkJvoR7QnzFQd6laAhAuFT3EaqfTssKnfMQST8g7tJU3Qpqi3gw+O+SpUDUHu0WZIN2GiKR1G4Lh2MSMOVJRzWUMhBxEWjPU+0/Bz0RTOtFiKgz0GnmAMv0E4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=RMmYU11h; arc=none smtp.client-ip=62.149.156.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="RMmYU11h"
Received: from fedora ([94.34.125.0])
	by Aruba SMTP with ESMTPSA
	id FwdRxUeYAN2P6FwdRxKlOC; Sun, 11 Oct 2026 18:42:53 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1791736973; bh=noKYH/ILE+edtD22uFEoznBAxGNgkcArENQ4uTe/p7E=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=RMmYU11h4//LH6HSQ03VpNjw7DKASVJx1kz4+0LogjK8xKYMya2mZkrNChhBb0jBR
	 TPAwazsD0BTB6MCFXCiC9tpMQo8agl+3Q9bME0dIkBeeeGt9sBfMphHIVlL6iShjft
	 iBRUPEJA3eiYaye+G8DLaRoON9Gvs1df832+MPSmxg/NjCMsfWr04Zmii2bPE7PpJg
	 NWemySCu1+ro8+c5PigVnU7okDJ/nuGjg5e98f8bERP07AUYyUsZYcDUqyk9hCzw/Y
	 kEFRknY72TNZggl1ob6dOIkT0bUpo1ogvW8mFzXM+TNU4dl0MOy/Co4kYSfCmcQMzY
	 c4KzR6A/2n9Nw==
Date: Sun, 11 Oct 2026 18:42:53 +0200
From: Alessio Ferri <alessio.ferri@mythread.it>
To: "andreas.wendleder" <andreas.wendleder@proton.me>
Cc: "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
 "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: b43: ac rev1 captured packets with ampdu
Message-ID: <20261011184253.5997a984@fedora>
In-Reply-To: <waSj3jvDuNtKDHP_lrLDt-1KAgv7xgyvTwKtdnXv18FPaVH12yRZk0f-bVfrApfaHnsALsEpipfhkgv0UvRQdMPiyj_tmKRVMwg1G5jDZmg=@proton.me>
References: <20261009173133.0e534ec2@fedora>
	<j7yDoG5_QzsvHn2hPYg-t1IRCKILne4bSf-E0ix15-48INcyh3HHnBydtcLdyWJCXh61NfsV1HawpRIBKpsGYzVzAfMCJIo3Z4Q-c20M15E=@proton.me>
	<1NF3n26c1UQ1YcYwXT-JD8OKl7dIr_22x7bgdLLwLHkWHnKlZAtcYw7504hufNHGIBEo3qr8atDAoKtK6qxtLUfVWhVSazjaIH5QPYGAgs0=@proton.me>
	<20261010161043.5dd21203@fedora>
	<waSj3jvDuNtKDHP_lrLDt-1KAgv7xgyvTwKtdnXv18FPaVH12yRZk0f-bVfrApfaHnsALsEpipfhkgv0UvRQdMPiyj_tmKRVMwg1G5jDZmg=@proton.me>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-CMAE-Envelope: MS4xfEqKvMN4MJZCb8vTEQ4TJGNqMZLmGw/jtNJlJ0R8RzflCjpWObsm9h5kAwj/0BvzqnZA7SvFWM3OrCG/Ytb/oivZMCbEebF+p/l6rkIDuGEmRHIEP7mH
 9Z6vh9tpMk6+fjXa3EYtkgQXdyIa641J/UCYi1aNmMJwY1MPr+uViuCDLqpkEgANvzqTNmkzG78CiQgDdk729QvkQhxnEy0FCaK30y5/FYERi4Ok23JjC/+t
 z0N2fl+lww3lwBZZkWqRF0P1dT13JXvIdY0OF+vUg38=

Il giorno Sat, 10 Oct 2026 14:15:51 +0000
"andreas.wendleder" <andreas.wendleder@proton.me> ha scritto:

> Hi Alessio,
>=20
> On the TX gain: that fits. In the basement (-70 dBm) index 64 carries
> no HT frame at all, index 20 works, index 0 is worse again. The reset
> value was just far too quiet. I now use index 20, inside the range
> the stock power loop ran at here (0x14=E2=80=930x26), until I have power
> control.
>=20
> RX aggregation works too. It only needed accepting the session in
> ampdu_action; the microcode deaggregates and sends the block acks.
> Both directions aggregated: about 30 Mbit/s up and 20 down at -70
> dBm, against 13 and 10 at legacy rates.
>=20
> On the RCAL timeout: that run was your unmodified head without my
> logging, so no added delays. I can rerun it and send the full dmesg.
>=20
> On the PHY words: yes, these are writes of the hybrid 6.30.223 wl on
> the MacBookAir6,1, from my MMIO trace at 2.4 GHz: 0x1739 =3D 0, 0x016b
> =3D 0, 0x0175 =3D 0, 0x03c4 =3D 0x0668, and in channel setup 0x0197 =3D
> 0x0014, 0x0198 =3D 0x0010. Bluetooth is plausible, the board has
> BTCOEXIST set.
>=20
> Thanks, Andreas

Hi Andreas,

I managed to get HT20/HT40 working, i also fixed two bugs that may have
been the cause for the failure of my driver in your hardware:=20
- first i had wrongly gated an operation over "only once per boot"
  while in fact it was necessary on any restart, even in hot restarts.
  I never catched it on unit testing.=20
- second i was using 9xx ucode layout for initvals, so both my 7xx and
  your 8xx ucode were using invalid values. My just happen to work with
  no-ht mode, but it was pure luck. Once i fixed it and stopped
  polluting a beacon bit it the transmission work fine with 10 mbits up
  and down.

I also added some bits to test BT coexistence.

Next i'll tackle VHT20/VHT40/VHT80 and then ampdu.

I am really excited that the work is finally coming together and i
really want to hope that broadcom ac rev1 generation will be the best
supported by b43.

Alessio
