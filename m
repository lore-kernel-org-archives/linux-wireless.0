Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:12224 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251AbYFTHHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jun 2008 03:07:12 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] libertas: make mesh code configurable
Date: Fri, 20 Jun 2008 09:06:59 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	libertas-dev@lists.infradead.org
References: <200806191704.10297.hs4233@mail.mn-solutions.de> <1213889556.8967.29.camel@johannes.berg>
In-Reply-To: <1213889556.8967.29.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200806200906.59479.hs4233@mail.mn-solutions.de> (sfid-20080620_090741_696383_888483F5)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Especially for the mesh_dev thing, you should probably have a
> static inline that returns priv->mesh_dev (mesh case) and NULL
> (non-mesh case) and rely on the compiler to elide as much code
> as possible.
>
> E.g. this:
> > +#ifdef CONFIG_LIBERTAS_MESH
> >  	if (priv->mesh_dev && (priv->mesh_connect_status ==
> > LBS_CONNECTED)) netif_wake_queue(priv->mesh_dev);
> > +#endif
>
> wouldn't then need an ifdef.

Ah, I thought that the compiler would barf about the
priv->mesh_connect_status, because this is no longer in
struct lbs_private.

So I tried your suggestion and, yes, the compiler barfs:

static inline struct net_device *lbs_mesh_dev(struct lbs_private *priv)
{
#ifdef CONFIG_LIBERTAS_MESH
        return priv->mesh_dev;
#else
        return NULL;
#endif
}

        if (lbs_mesh_dev(priv) && dev == lbs_mesh_dev(priv)) {
                priv->mesh_open = 1;
                priv->mesh_connect_status = LBS_CONNECTED;
                netif_carrier_on(dev);
        } else {
                priv->infra_open = 1;

                if (priv->connect_status == LBS_CONNECTED)
                        netif_carrier_on(dev);
                else
                        netif_carrier_off(dev);
        }

drivers/net/wireless/libertas/main.c: In function 'lbs_dev_open':
drivers/net/wireless/libertas/main.c:414: error: 'struct lbs_private' has no member named 'mesh_open'
drivers/net/wireless/libertas/main.c:415: error: 'struct lbs_private' has no member named 'mesh_connect_status'
