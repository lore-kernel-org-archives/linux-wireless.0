Return-Path: <SRS0=GdFy=TN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3ACCC04AB1
	for <linux-wireless@archiver.kernel.org>; Mon, 13 May 2019 08:41:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A944C20879
	for <linux-wireless@archiver.kernel.org>; Mon, 13 May 2019 08:41:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1557736895;
	bh=FvdUtuG7Ih8Awe6R6tv49B4Wf/lue5RkYTeKYIst6Zk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=JFBkLG6tpoGVBQlCOt1ByhbMD/sPgRB+2V2tVe52y73OnlhWn0dJMRwmUlBYKYI1n
	 4dRoouxMGF1P9e/I6ytM4Om2J2MuvXsqQjyuak7F/hu/bmc16+1TcMoen6GbS8jDRf
	 IIXqUFCSEXGKkAaxWX6lKKeGaKv71ZXS+NCmNqsY=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727589AbfEMIle (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 13 May 2019 04:41:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:50266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727347AbfEMIle (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 May 2019 04:41:34 -0400
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com [149.6.153.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6744920879;
        Mon, 13 May 2019 08:41:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557736893;
        bh=FvdUtuG7Ih8Awe6R6tv49B4Wf/lue5RkYTeKYIst6Zk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lOI2uzSN4vw2xvAZ/dw24hqeV3C4mVSPtVsbyq++z/mAkg+TH2Qk3nD7KyrFynta6
         AxwUnUbbkEuowt4ueP0rHda6cHo68CcsMY0gbsC57hlLaF/o68kH/OeZ0baniQNW+F
         J6I40FGuC681Rzp1ZEHeyCzQ0S3xINqtEIvb5fsU=
Date:   Mon, 13 May 2019 10:41:28 +0200
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     nbd@nbd.name, lorenzo.bianconi@redhat.com,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mt76: mt7603: add debugfs knob to enable/disable edcca
Message-ID: <20190513084127.GA3127@localhost.localdomain>
References: <cover.1557591530.git.lorenzo@kernel.org>
 <0691acb931e963cb6028d4687cdd61032d0aaf52.1557591530.git.lorenzo@kernel.org>
 <87r293ugia.fsf@purkki.adurom.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <87r293ugia.fsf@purkki.adurom.net>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> Lorenzo Bianconi <lorenzo@kernel.org> writes:
>=20
> > Introduce a knob in mt7603 debugfs in order to enable/disable
> > edcca processing
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>=20
> It's good to explain what edcca does and how the file is used supposed
> to be used. In other words, have a small introduction for the user.

Hi Kalle,

edcca is used for adjusting energy detect based on CCA thresholds.
The code was already there so I just reported the acronym.

>=20
> > @@ -48,6 +77,7 @@ void mt7603_init_debugfs(struct mt7603_dev *dev)
> >  	if (!dir)
> >  		return;
> > =20
> > +	debugfs_create_file("edcca", 0400, dir, dev, &fops_edcca);
>=20
> Why 0400 and not 0600?

yes, right. There is the same issue in mt76x02 code, I will fix both of the=
m.
Thx.

Regards,
Lorenzo

>=20
> --=20
> Kalle Valo

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXNkttAAKCRA6cBh0uS2t
rKlUAP4gy4CzjEsmAF3cyz3NpPT/XK7YDTh2wKOqLVxwS6IYqwEAg6aRSKFvOfb2
SpNafihGOYy6+iXf3Ng3HMrv9LOiMwc=
=b5GZ
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
