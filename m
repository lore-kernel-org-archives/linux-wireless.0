Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:3303 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751575AbZI1OyS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 10:54:18 -0400
From: Holger Schurig <h.schurig@mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] libertas: first stab at cfg80211 support
Date: Mon, 28 Sep 2009 16:54:08 +0200
Cc: libertas-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>
References: <200909281321.21600.h.schurig@mn-solutions.de> <1254144714.3151.1.camel@johannes.local>
In-Reply-To: <1254144714.3151.1.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200909281654.08859.h.schurig@mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> This seems wrong -- doesn't libertas have multiple netdevs?
> You're treating wdev == wiphy it seems here, rather than wdev
> == netdev. 

Yes, it has three netdevs, but they aren't all setup at 
card-initialization time.


Some details: "struct private" contains:

        struct net_device *dev;
        struct net_device *mesh_dev; /* Virtual device */
        struct net_device *rtap_net_dev;

The old code did have an

        dev = alloc_etherdev(sizeof(struct lbs_private));"

and the other two netdevs got initialized at some other location:

* priv->lbs_add_mesh() in lbs_add_mesh()
  via "alloc_netdev(0, "msh%d", ether_setup)". And lbs_add_mesh()
  is called only when the hardware supports this.
* rtap_net_dev is created in lbs_add_rtap() and again I haven't
  change the creation of this thingy.

Please note that when I'm using the card in station mode, both 
mesh_dev and rtap_net_dev are NULL. My firmware doesn't have 
mesh code, and only when I set the card into monitor mode will 
the rtap_net_dev created.


I kept this behavior for now: at initialzation I call:

        wdev = lbs_wdev_alloc(sizeof(struct lbs_private), dmdev);
	wdev->xyz = initialization;
        ...
        dev = alloc_netdev()


For me it's not clear if I should create wdev's for mesh_dev and 
rtap_net_dev as well. However, I'm not able to check the mesh 
code anyway: my firmware doesn't support this. And for 
rtap_net_dev I'm not sure if this shouldn't be handled 
differently in a cfg80211 scenario, e.g. via 
lbs_cfg80211_change_iface().

A hint of what I should then would be most welcome :-)


-- 
M&N Solutions GmbH          Ein Unternehmen der Datagroup AG
Holger Schurig
Raiffeisenstr. 10
61191 Rosbach
Tel: 06003/9141-15          Fax 06003/9141-49
http://www.mn-solutions.de/

Handelsregister Friedberg, HRB 5903
Geschäftsführer: P.Schrittenlocher
