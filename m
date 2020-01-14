Return-Path: <SRS0=6QfK=3D=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D7AEC33CB1
	for <linux-wireless@archiver.kernel.org>; Tue, 14 Jan 2020 14:31:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 219DE24681
	for <linux-wireless@archiver.kernel.org>; Tue, 14 Jan 2020 14:31:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1579012298;
	bh=54HPWXnPhTrMsq2ttUIKblR/qMaezsM/da5/FBE1KxQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=sp1uz/iGwJjHne710orV8m9Aa273BFigtGMR5h5n4EoB1NJEBC9d5O30KwjY90FAO
	 BUecKszadtt4mSymEfJrbnqj8yJYFH363+8Mt0+KuP9Y4QN1fwMX1B0SdQ8j8K42+0
	 zvpB76Zgz5UNpo5fZk6gYQWbQKVWjOM0zmoS0EUU=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728932AbgANObh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 14 Jan 2020 09:31:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:43874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726106AbgANObh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Jan 2020 09:31:37 -0500
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 021FB2467D;
        Tue, 14 Jan 2020 14:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579012296;
        bh=54HPWXnPhTrMsq2ttUIKblR/qMaezsM/da5/FBE1KxQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jH4dBSFCiURmffiOwSrTaP1GWv0H92DVAOYq3vzN+tK5THduZcEL+sOT52I5hlBND
         AxPG+e/32UQuY3JpscrR/OD6E55ZtQMxCxlRo0vL5Nn9G7HVGGZWDfDGTP/nqKJk4x
         7Q710IX3u+h6bkbhoeRwwJ2Kxpcyg0L16MX6RGTE=
Date:   Tue, 14 Jan 2020 15:31:31 +0100
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     nbd@nbd.name, lorenzo.bianconi@redhat.com,
        linux-wireless@vger.kernel.org, Sean.Wang@mediatek.com
Subject: Re: [PATCH v2 01/18] mt76: mt76u: check tx_status_data pointer in
 mt76u_tx_tasklet
Message-ID: <20200114143131.GA29696@localhost.localdomain>
References: <cover.1578226544.git.lorenzo@kernel.org>
 <abcddd40dcf003980e1d095d6cbd40b22ac98a43.1578226544.git.lorenzo@kernel.org>
 <87muaq15x8.fsf@tynnyri.adurom.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="BXVAT5kNtrzKuDFl"
Content-Disposition: inline
In-Reply-To: <87muaq15x8.fsf@tynnyri.adurom.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--BXVAT5kNtrzKuDFl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Jan 14, Kalle Valo wrote:
> Lorenzo Bianconi <lorenzo@kernel.org> writes:
>=20
> > New devices (e.g. mt7663u) do not rely on stats workqueue to load tx
> > statistics but will be reported by the firmware. Check tx_status_data
> > pointer in mt76u_tx_tasklet in order to reuse tx tasklet for new devices
> >
> > Signed-off-by: Sean Wang <sean.wang@mediatek.com>
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> Why is Sean's s-o-b first? Lorenzo is marked as the author so his s-o-b
> should be first.

Hi Kalle,

my bad, I did not pay attention on it, I should put my SoB first.

>=20
> Also I recommend taking a look at the new Co-Developed-by tag.

I think Co-Developed-by fits better.
@Felix and Kalle: do you prefer to resubmit?

Regards,
Lorenzo

>=20
> --=20
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpa=
tches

--BXVAT5kNtrzKuDFl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXh3QwAAKCRA6cBh0uS2t
rCKqAP0e5k/DsJKxA+jXp20vvMsGeMynB37igPPJQdAeMeIcsAEA4Hj3pvZixGTK
YbA5KolHUpeHbU6C6ueE1zZY5bhSpAY=
=ux+C
-----END PGP SIGNATURE-----

--BXVAT5kNtrzKuDFl--
