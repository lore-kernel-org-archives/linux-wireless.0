Return-Path: <SRS0=sb9s=RE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50570C43381
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 10:31:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26BE520851
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Mar 2019 10:31:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727710AbfCAKbf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Mar 2019 05:31:35 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:35836 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725978AbfCAKbf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Mar 2019 05:31:35 -0500
Received: by mail-wm1-f68.google.com with SMTP id y15so11755660wma.0
        for <linux-wireless@vger.kernel.org>; Fri, 01 Mar 2019 02:31:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=iMqsBRnkVC0oBlT4MkQbifwxLpT+qODX/8yUaDIpMbA=;
        b=iayjYwgBv2oU13jCcOH6hJmEg+kE9D6DmKL40DWo4rRKbFfzZ+hpJKbqkrHt90PJht
         8HXZhRKpiLpRVQP3UB5N+rSUXN8Q6/BJQvxMAYKFZQ+YwNVWJ6ifo9c2uOvD3K2jRHU2
         MCLJdgHphM2yaR7zuwFxc6U/kHaWYaOx+l7J01Ka4otTqJamd8XtugS/PpXcGPikQcwV
         JeKodxTCL0wv+An1ngd19jQqzc+agbNywS+Rc6qNMFaSzx9h+xXhXl7mAkwj6gSzATyr
         hYygiA0R4gB49boXDHJ5HHhwWWE1fEKs0minVAo041HWRJZJMG28hFk8cVktF8pjvAri
         rjXw==
X-Gm-Message-State: APjAAAUAt2WIg5dJpy8Q+g4ykMKGjaEp2MoWKfjG8ZKXKwjd6yV4+k4h
        WDZvCv8B8iBVADJlLbuHxMHoEA==
X-Google-Smtp-Source: AHgI3Ia2ZqQWj68Tx/DmE3Kmoj0ECUYM082iGOYjBsJezhQBPKESgJkXtRK/iew/M9cDCMxxh/vkSw==
X-Received: by 2002:a1c:6555:: with SMTP id z82mr2563294wmb.125.1551436292921;
        Fri, 01 Mar 2019 02:31:32 -0800 (PST)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id d206sm13343125wmc.11.2019.03.01.02.31.31
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 01 Mar 2019 02:31:32 -0800 (PST)
Date:   Fri, 1 Mar 2019 11:31:28 +0100
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, nbd@nbd.name,
        linux-wireless@vger.kernel.org, ryder.lee@mediatek.com,
        roychl666@gmail.com
Subject: Re: [RFC 2/2] mt76: introduce mt76_hw_queue data structure
Message-ID: <20190301103126.GA16993@localhost.localdomain>
References: <cover.1551431791.git.lorenzo@kernel.org>
 <e42f2de79766a2bd507d66ea2dabb0e79a684450.1551431791.git.lorenzo@kernel.org>
 <20190301095852.GA31324@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="cNdxnHkX5QqsyA0e"
Content-Disposition: inline
In-Reply-To: <20190301095852.GA31324@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


--cNdxnHkX5QqsyA0e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On Fri, Mar 01, 2019 at 10:22:04AM +0100, Lorenzo Bianconi wrote:
> > -struct mt76_queue {
> > +struct mt76_hw_queue {
> > =20
> >  	u16 first;
> >  	u16 head;
> >  	u16 tail;
> > -	int ndesc;
> > -	int queued;
> > -	int buf_size;
> > =20
> > +	dma_addr_t desc_dma;
> > +
> > +	int buf_size;
> >  	u8 buf_offset;
> > +
> >  	u8 hw_idx;
> > =20
> > -	dma_addr_t desc_dma;
> > -	struct sk_buff *rx_head;
> >  	struct page_frag_cache rx_page;
> >  	spinlock_t rx_page_lock;
> > +	struct sk_buff *rx_head;
> > +};
> > +
> > +struct mt76_queue {
> > +	struct mt76_hw_queue *hwq;
> > +
> > +	struct list_head swq;
> > +	int swq_queued;
> >  };
>=20
> I don't think massive renaming is necessary. It makes patch more complex
> and eventual future backporting of fixes harder. Simpler approach would
> be doing:
>=20
> struct mt76_sw_queue {
> 	struct mt76_queue *q;
>=20
> 	struct list_head swq;
> 	int swq_queued;
> }

ack, it sounds good to me. Anyway mt76_queue is pretty spread as well :(
I will post a v2 squashing this change.

Regards,
Lorenzo

>=20
> what should achieve the same goal without massive changes in the code.
>=20
> Stanislaw

--cNdxnHkX5QqsyA0e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXHkJ+wAKCRA6cBh0uS2t
rPrxAP9hESTwLgw3UrTGBlABcvkWqG8I7d7TyiGP0uyKO/LyFQD+NdzJPhbTbWaf
GrvRm88F+bmpKYzXoNmbDcNTkO6YSQo=
=hyCi
-----END PGP SIGNATURE-----

--cNdxnHkX5QqsyA0e--
