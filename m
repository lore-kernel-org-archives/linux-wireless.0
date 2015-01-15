Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from packetmixer.de ([79.140.42.25]:46461 "EHLO
	mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753323AbbAOP6b (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Jan 2015 10:58:31 -0500
From: Simon Wunderlich <sw@simonwunderlich.de>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	mathias.kretschmer@fokus.fraunhofer.de, stable@vger.kernel.org
Subject: Re: Re: [PATCH] ath9k: ignore radar PHY errors when DFS is not enabled
Date: Thu, 15 Jan 2015 16:58:23 +0100
Message-ID: <3234042.vtm90oWCeY@prime> (sfid-20150115_165835_881800_1F500F93)
In-Reply-To: <87ppagnmjo.fsf@kamboji.qca.qualcomm.com>
References: <1420822458-531-1-git-send-email-sw@simonwunderlich.de> <3155015.RnApTRDnnO@prime> <87ppagnmjo.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2445890.MTfX3xZkqq"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--nextPart2445890.MTfX3xZkqq
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Hey Kalle,

On Thursday 15 January 2015 16:30:51 Kalle Valo wrote:
> Simon Wunderlich <sw@simonwunderlich.de> writes:
> >> I did not dig how the hw->conf.radar_enabled flag is set in monitor mode,
> >> but if it is same as for master (i.e. set for DFS channels), then it
> >> would
> >> be a better approach to prevent calling ath9k_dfs_process_phyerr()
> >> altogether from ath9k_rx_skb_preprocess() if not set.
> > 
> > Hm, you mean like - if radar_enabled then dfs_process, otherwise
> > fft_process? That would might be more elegant indeed ...
> > 
> > The monitor mode does not have the radar flag enabled,
> > cfg80211_chandef_dfs_required() returns 0 in this case.
> 
> So are you going to send v2 or what's the plan? I didn't quite get the
> conclusion from the discussion.

sorry for the silence - yes, please drop this version, I'll send v2.

Thanks
    Simon
--nextPart2445890.MTfX3xZkqq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iEYEABECAAYFAlS346IACgkQrzg/fFk7axZW3ACg2r6dj/EUqdeYY5L8Xp0ieHGD
oMQAoJ3BZq69xbXaCnKNeDvzDA67RgX7
=otcX
-----END PGP SIGNATURE-----

--nextPart2445890.MTfX3xZkqq--

