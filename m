Return-Path: <SRS0=FsXk=RO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26396C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 10:11:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 015AE20657
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Mar 2019 10:11:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbfCKKLs (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Mar 2019 06:11:48 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33880 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726567AbfCKKLs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Mar 2019 06:11:48 -0400
Received: by mail-wr1-f66.google.com with SMTP id f14so4378873wrg.1
        for <linux-wireless@vger.kernel.org>; Mon, 11 Mar 2019 03:11:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ovyrkK5173os6saQVifuJJ1+3AqQ9SD2nWxyVDaxDDE=;
        b=g2vUb+wpOyATgyXTKPqqGGs/qSoEz+Ws6rWFdiSe90Cd2HR/77MG4j4D8HyFS1LCst
         kSL7zYJHTwJIU03jT/SqAKj0CcDWlIvMWt6trxklXmsGtC3EyO38Apfrr7Ou5OxhBjGo
         oIbaJoBX7hJ4bOAaI8OdVMOa14HI41KCR9e6FASxW3g1AJIeUbO6MK4RaMampiEmefTr
         bFBQwMJSiEyAAkb0ciawKGMbEV38bLbSG/eysVDzmAAQVFhJazyZ2MBqCo2ChGc9jAbR
         dZbarVBFDBsaL5K3+AJz8AS7W9/RfwUaP2Xv0v+dIHuZYuy+ahx6hufzzAo6OJz4BI4g
         UrYQ==
X-Gm-Message-State: APjAAAWxZtvqP2rKnskqi+evao1E6VH5SgRr8Cs01fY2yD/oWrWFonJo
        5E64UZSyAZBYefY3OEi10T4hspemQOU=
X-Google-Smtp-Source: APXvYqzRXZZ572Id4OkUBjntm4xBwLTRV/JtUWE+VF5DxCgmxt3wA2dmtNiGKOTMN+D1Gw/bTZLJxw==
X-Received: by 2002:adf:f30a:: with SMTP id i10mr2618715wro.300.1552299106135;
        Mon, 11 Mar 2019 03:11:46 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id t15sm131970wrr.16.2019.03.11.03.11.44
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 11 Mar 2019 03:11:45 -0700 (PDT)
Date:   Mon, 11 Mar 2019 11:11:39 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-wireless@vger.kernel.org, sgruszka@redhat.com
Subject: Re: [PATCH] mt76: fix schedule while atomic in mt76x02_reset_state
Message-ID: <20190311101138.GA15418@localhost.localdomain>
References: <cover.1552251427.git.lorenzo@kernel.org>
 <510d7b670f673a4662ed672b0ce3d9f75512b100.1552251427.git.lorenzo@kernel.org>
 <09c3c2ec-071f-4fd9-927d-2981b65fe29f@nbd.name>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <09c3c2ec-071f-4fd9-927d-2981b65fe29f@nbd.name>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 2019-03-10 23:47, Lorenzo Bianconi wrote:
> > Fix following schedule while atomic mt76x02_reset_state
> > since synchronize_rcu is run inside a RCU section
> >=20
> > [44036.944222] mt76x2e 0000:06:00.0: MCU message 31 (seq 3) timed out
> > [44036.944281] BUG: sleeping function called from invalid context at ke=
rnel/rcu/tree_exp.h:818
> > [44036.944284] in_atomic(): 1, irqs_disabled(): 0, pid: 28066, name: kw=
orker/u4:1
> > [44036.944287] INFO: lockdep is turned off.
> > [44036.944292] CPU: 1 PID: 28066 Comm: kworker/u4:1 Tainted: G        W=
         5.0.0-rc7-wdn-t1+ #7
> > [44036.944294] Hardware name: Dell Inc. Studio XPS 1340/0K183D, BIOS A1=
1 09/08/2009
> > [44036.944305] Workqueue: phy1 mt76x02_wdt_work [mt76x02_lib]
> > [44036.944308] Call Trace:
> > [44036.944317]  dump_stack+0x67/0x90
> > [44036.944322]  ___might_sleep.cold.88+0x9f/0xaf
> > [44036.944327]  rcu_blocking_is_gp+0x13/0x50
> > [44036.944330]  synchronize_rcu+0x17/0x80
> > [44036.944337]  mt76_sta_state+0x138/0x1d0 [mt76]
> > [44036.944349]  mt76x02_wdt_work+0x1c9/0x610 [mt76x02_lib]
> > [44036.944355]  process_one_work+0x2a5/0x620
> > [44036.944361]  worker_thread+0x35/0x3e0
> > [44036.944368]  kthread+0x11c/0x140
> > [44036.944376]  ret_from_fork+0x3a/0x50
> > [44036.944384] BUG: scheduling while atomic: kworker/u4:1/28066/0x00000=
002
> > [44036.944387] INFO: lockdep is turned off.
> > [44036.944389] Modules linked in: cmac ctr ccm af_packet snd_hda_codec_=
hdmi
> >=20
> > Introduce __mt76_sta_remove in order to run sta_remove without holding =
dev->mutex.
> > Move __mt76_sta_remove outside RCU section in mt76x02_reset_state
> >=20
> > Fixes: e4ebb8b403d1 ("mt76: mt76x2: implement full device restart on wa=
tchdog reset")
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> > diff --git a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c b/driver=
s/net/wireless/mediatek/mt76/mt76x02_mmio.c
> > index 6a34a6afcfe4..898afcbcdf52 100644
> > --- a/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
> > +++ b/drivers/net/wireless/mediatek/mt76/mt76x02_mmio.c
> > @@ -419,6 +419,7 @@ static void mt76x02_key_sync(struct ieee80211_hw *h=
w, struct ieee80211_vif *vif,
> >  	mt76x02_mac_wcid_sync_pn(dev, wcid->idx, key);
> >  }
> > =20
> > +/* need to run with mt76.mutex held */
> >  static void mt76x02_reset_state(struct mt76x02_dev *dev)
> You can replace that comment with a call to lockdep_assert_held in the
> function.
>=20
> > @@ -426,11 +427,11 @@ static void mt76x02_reset_state(struct mt76x02_de=
v *dev)
> >  	clear_bit(MT76_STATE_RUNNING, &dev->mt76.state);
> > =20
> >  	rcu_read_lock();
> > -
> >  	ieee80211_iter_keys_rcu(dev->mt76.hw, NULL, mt76x02_key_sync, NULL);
> > +	rcu_read_unlock();
> > =20
> >  	for (i =3D 0; i < ARRAY_SIZE(dev->mt76.wcid); i++) {
> > -		struct mt76_wcid *wcid =3D rcu_dereference(dev->mt76.wcid[i]);
> > +		struct mt76_wcid *wcid =3D dev->mt76.wcid[i];
> This should use rcu_dereference_protected() instead of accessing the
> pointer directly.
>=20

ack, I will fix them in v2.

Regards,
Lorenzo

> Thanks,
>=20
> - Felix

--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXIY0VwAKCRA6cBh0uS2t
rDy5AQCSCHhWYrGGAWkWfzIweeqJvELOwysju+Eb4FxxmRLqQAD9EdDJQ0gNnjDO
mI+S7DkQaAx8LcW2zollTTn4zIKH/g4=
=DTbn
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
