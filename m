Return-Path: <SRS0=jb13=W2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80109C3A5A6
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Aug 2019 12:07:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D4BC21721
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Aug 2019 12:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1567166821;
	bh=mfzJylxmbYnOeISRWfpHmnDMaGj6dcvEKPdLqlFsuSc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=wVLrauS4mizm4v8ZHxN1vIteIaMQHF44ZW1dp2eVjVU6OsuTpfNrMUcjWdnR7+L79
	 AWAhfA24ylV4wHGgxQdDKn0Q8TirriDsEeRvo2VoN6/SjRyXeiFkKo8kKgD8J6gWA5
	 /ma4a59CiuJVyBsPThExxHgdVAGVi1UL4Z08QuXQ=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728053AbfH3MHA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 30 Aug 2019 08:07:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:60208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727928AbfH3MG7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Aug 2019 08:06:59 -0400
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FFB621721;
        Fri, 30 Aug 2019 12:06:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567166812;
        bh=mfzJylxmbYnOeISRWfpHmnDMaGj6dcvEKPdLqlFsuSc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rdSSSXe6DCACnougqKmpWNVc4At2SN3VLfhApvfvsxwXXgX+2BljK9Ys6pCHhG6Dm
         7w/NJ4Cvh3c9YCNi6DsHICbLbMoRQL015BKhezTKweh+ToDHEkLb3/k4sTR+QoHTd7
         6868Dz8V8yzgIV3kbM2pHR13K4Sj2lPINCH8x2F8=
Date:   Fri, 30 Aug 2019 14:06:47 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Ryder Lee <ryder.lee@mediatek.com>
Cc:     nbd@nbd.name, lorenzo.bianconi@redhat.com,
        linux-wireless@vger.kernel.org, royluo@google.com
Subject: Re: [PATCH] mt76: mt7615: move mt7615 sta utilities in pci.c
Message-ID: <20190830120647.GD5910@localhost.localdomain>
References: <e095a331854ab9c9619f86ae8860502abf808fbe.1567068930.git.lorenzo@kernel.org>
 <1567165961.8079.3.camel@mtkswgap22>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="6WlEvdN9Dv0WHSBl"
Content-Disposition: inline
In-Reply-To: <1567165961.8079.3.camel@mtkswgap22>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--6WlEvdN9Dv0WHSBl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Thu, 2019-08-29 at 10:57 +0200, Lorenzo Bianconi wrote:
> > Move mt7615_sta_add, mt7615_sta_assoc, mt7615_sta_ps and mt7615_sta_rem=
ove
> > utility routines in pci.c and make them static since they are only used=
 to
> > initialize mt76_driver_ops callbacks
> >=20
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > ---
> >  .../net/wireless/mediatek/mt76/mt7615/mac.c   |  4 --
> >  .../net/wireless/mediatek/mt76/mt7615/main.c  | 40 ---------------
> >  .../wireless/mediatek/mt76/mt7615/mt7615.h    |  7 ---
> >  .../net/wireless/mediatek/mt76/mt7615/pci.c   | 49 +++++++++++++++++++
> >  4 files changed, 49 insertions(+), 51 deletions(-)
>=20
> Just to note that we might have other interface shares with the same
> utility routines in upcoming days.
>=20
> Ryder
>=20

Hi Ryder,

I guess what really matter is if they are non-PCI based devices and if they=
=20
rely on the same mcu commands

Regards,
Lorenzo

--6WlEvdN9Dv0WHSBl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXWkRVQAKCRA6cBh0uS2t
rIU/AQCnqFPJZ+twx5/H2mjtW8UH/XIL7bgJpW32XoxQa1+wpgD7BeIDSQBns7GU
Og0zmYUMRQPPS07SKkvVh1Hm+xmxlAA=
=WInN
-----END PGP SIGNATURE-----

--6WlEvdN9Dv0WHSBl--
