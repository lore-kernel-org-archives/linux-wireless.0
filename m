Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=168.119.38.16
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793012841;
	b=hHID0cYJjbIjkECedBWJUzi0EEFtcZUjXYIs31QA79XilcNo00BP+sGk4sGgr+QgyFpb
	 IxIUraTNY2j3b51SyBoDZa7WS6kxFWmzVNFzi1oj0iEvoXD0OmPxCII/Unv+QesCANDvZ
	 hfg9JFv41DYov1kJJnO2nnqGPuyMVFPIbZCwtdT5CpduWp8ZNkHxZRwd+9rnX4RVRmstM
	 ci869S8pYNTVKiuEdkzbLcN6/tTaOMoeH+b9GdP3LvtHieP2Ah2WitVgBPzp5grDTApzA
	 8cLORrLhOLhIXUZdRCech8sQXsjnfetlxO/+cLqaT7OhbT/gr1rOTVSNsKXgmyzYh7w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793012841;
	h=DKIM-Signature:Received:Message-ID:Subject:From:To:Cc:Date:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:
	 User-Agent:MIME-Version:X-malware-bazaar;
	bh=iwhaYhg950skyzyNiHbnMoeJRabwevrYhb3dfzGOLNs=;
	b=Fzbel2zq6qosyN/asiesa2OddHwHqQqBjKYdVF3/adDViP9z26AAVzXysIOciR5lNi8q
	 r7CtPsRrSDpZ4326b+x899Nml8d5nq7M/Y39XfTRu6kWhCcWP4Ymqz5LQz6fpXfT3OXBP
	 NlvALG+lzwsPcn7QHaQmLzYk7rqZ+kurBVJZ8HeCzTUJI2wmmwskWBe8PPYGEBhKXem/N
	 313NI+3L1nVnE0OAddTR2qvThcNillod/3K0MDMe5H49cJY1jkcx2ACoIrd48us/8dpUe
	 UHcdV39Ge4kFfpmsayN9kwSTXWqrPClpcCl9QYxtmOqskRrvtjJa3BFKMr4Xt/S5qNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=permerror header.from=sipsolutions.net;
	spf=pass smtp.mailfrom=sipsolutions.net;
	dkim=pass header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=m8F1rhoI;
	arc=none smtp.remote-ip=168.119.38.16
Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ADF1606A31A;
	Mon, 26 Oct 2026 11:07:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=sipsolutions.net header.i=@sipsolutions.net header.a=rsa-sha256 header.s=mail header.b=m8F1rhoI
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=iwhaYhg950skyzyNiHbnMoeJRabwevrYhb3dfzGOLNs=;
	t=1793012839; x=1794222439; b=m8F1rhoIn/QwtAmntzoG1wAwi1JY7JwNZJ2y3ZynX6IdzLX
	594wF7YJpXefjSOZ3bv5a0SfjPBVYHsN2PT2Eszpx/MOA4ID/f2rT+Pv0oNNISxZpve/wBE933e3+
	e8tKUfGaRDva6D7fez4YgQtSxlDqSghiw7GH9MH/DX4l5uufVRCJXGCatCWOndTj0zX6gWa75+ZCf
	EfxVuf7tS4/HGwD4euOGcnLp0UgA6yPklAaZOggBmqHtgcDDrSuvVyvuaXz+U6UL2ABNSMYf4vOgo
	UYDd+tdXnHLLZP81GsMXZnITibwJewZEd2akSZYWrzqpuKMlvgfM/0BvSAzBWNfg==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1xLIXt-0000000BCCo-1qAt;
	Mon, 26 Oct 2026 12:07:17 +0100
Message-ID: <116e1f238e2d78817a2ac5b42b00e0faeabf16bc.camel@sipsolutions.net>
Subject: Re: [PATCH wireless] wifi: mac80211: use HT CCFS2 when computing
 the AP's HE and lower bandwidth
From: Johannes Berg <johannes@sipsolutions.net>
To: John Macias <dencity7@gmail.com>, linux-wireless@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Date: Mon, 26 Oct 2026 12:07:16 +0100
In-Reply-To: <20261026040148.2633920-1-dencity7@gmail.com> (sfid-20261026_050215_574698_93BE14B6)
References: <20261026040148.2633920-1-dencity7@gmail.com>
	 (sfid-20261026_050215_574698_93BE14B6)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-3.fc44) 
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Sun, 2026-10-25 at 21:01 -0700, John Macias wrote:
> If the driver advertises VHT extended NSS BW support, hostapd announces
> a 160 MHz BSS the way IEEE 802.11-2020 allows for that case: the VHT
> Operation element has channel width 1, CCFS0 is the 80 MHz segment and
> CCFS1 is 0, and the 160 MHz centre is in the CCFS2 field of the HT
> Operation element.
>=20
> ieee80211_calc_ap_he_and_lower() only looks at the VHT CCFS1, so it
> sets bss_bw.he_and_lower to 80 MHz and ieee80211_sta_usable_bw() then
> limits every HE and VHT station to 80 MHz. Stations parse CCFS2 and use
> 160 MHz towards the AP, but the AP never transmits wider than 80 MHz.
>=20
> Take CCFS2 from the HT Operation element when the VHT CCFS1 is 0, as
> the station side already does in ieee80211_chandef_vht_oper().

This, by itself, is wrong.

johannes
