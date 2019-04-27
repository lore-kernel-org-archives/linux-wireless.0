Return-Path: <SRS0=RVLw=S5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F51DC43218
	for <linux-wireless@archiver.kernel.org>; Sat, 27 Apr 2019 17:26:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 160AC206A3
	for <linux-wireless@archiver.kernel.org>; Sat, 27 Apr 2019 17:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556386018;
	bh=mPXNrjAqa3h4G2p0T35cAlP+V4XUwk7RmI8qTwTGgbI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=KYKNPSsRI1NjqvJgE5pAebBzw/0Kbjlhmt48nmzyJ7Ot3dIlG66I4K/uarqe9brWn
	 t2U4ZuGcOaDTlTO24DiBcs5/eGpjfr5UPXRMOq/ipOU/YYurgwtouJu7IU5VaJub7w
	 v8e1mD9ye/9YXMbiK6O69ZtNwGVb7gEGglVbD9pE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726272AbfD0R0x (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 27 Apr 2019 13:26:53 -0400
Received: from heliosphere.sirena.org.uk ([172.104.155.198]:55110 "EHLO
        heliosphere.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbfD0R0x (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Apr 2019 13:26:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sirena.org.uk; s=20170815-heliosphere; h=In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=a3tmI0KUyLppW1kwBwL7lvA+SJm0kVYzuouVBoWkDwk=; b=tJcvGeRygaFThXfFvSb4czEha
        Q5l0BBPMyQjbuhkvhGj+D9qIDc+mqjrUmNh/2f1KkzZeznjETqI6tRGFOuLYdbX4u0UmWO5/aM/bL
        QKfDzTQ4ngEZdrqg0jSElj1AgoBqipYR5vhUgvD49iINDsZgUcMSjJzurhnVuy25KuTl0=;
Received: from [211.55.52.15] (helo=finisterre.ee.mobilebroadband)
        by heliosphere.sirena.org.uk with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <broonie@sirena.org.uk>)
        id 1hKR5G-0004ci-TI; Sat, 27 Apr 2019 17:25:55 +0000
Received: by finisterre.ee.mobilebroadband (Postfix, from userid 1000)
        id 48FE5441D3B; Sat, 27 Apr 2019 18:25:51 +0100 (BST)
Date:   Sun, 28 Apr 2019 02:25:51 +0900
From:   Mark Brown <broonie@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Sebastian Reichel <sre@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Harry Wei <harryxiyou@gmail.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>, linux-pm@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2 25/79] docs: convert docs to ReST and rename to *.rst
Message-ID: <20190427172551.GI14916@sirena.org.uk>
Mail-Followup-To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Sebastian Reichel <sre@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>,
        Harry Wei <harryxiyou@gmail.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>, linux-pm@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
References: <cover.1555938375.git.mchehab+samsung@kernel.org>
 <7adf9035ae06ecc6c7e46b51cb677f0a8f61d19a.1555938376.git.mchehab+samsung@kernel.org>
 <20190425180758.GC23183@sirena.org.uk>
 <20190426064609.7f00e013@coco.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="WR+jf/RUebEcofwt"
Content-Disposition: inline
In-Reply-To: <20190426064609.7f00e013@coco.lan>
X-Cookie: -- I have seen the FUN --
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--WR+jf/RUebEcofwt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 26, 2019 at 06:46:09AM -0300, Mauro Carvalho Chehab wrote:
> Mark Brown <broonie@kernel.org> escreveu:

> > This is massively CCed covering a large range of subsystems and is patch
> > 25 of a 79 patch series so I've no context for what's going on here or
> > why... =20

> You can see more details at patch 00/79:
> 	https://lore.kernel.org/lkml/20190422115110.26443b44@coco.lan/

OK, it would've helped to CC people on that.  Anyway

Acked-by: Mark Brown <broonie@kernel.org>

--WR+jf/RUebEcofwt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAlzEkJ4ACgkQJNaLcl1U
h9CLPQf/egnMPfy5Djt33xwT726spS5SVTG7kuJqe4sKQ3OXBoMa44iGLw9gz/+M
FmO/XFmO150AIxC3d1OJKSoimebzY1IPIiJFOOQC7SJDtKoOMVm4MTP5w+B8jdvC
o51B7dkua7q/hKAbj78Q023V/jvpOU+353/om9x82lB7jvoxnN+pGEcEDqQEBtk6
dSbAla2qU+BoMPdyoOGiCu9mjLpTSGWbU+lz4IKiIQHK5zWx9xFrBCgB1zyjoDEm
H69kzCVDwYkkiaGriSEV5ksQThpov8Ka2zvrJPZ8HOTaX4GSW3W2Ailr6FJ8cLbo
mPFwHR0sNRuPgcZtXvdaivvevBYKMw==
=wBS3
-----END PGP SIGNATURE-----

--WR+jf/RUebEcofwt--
