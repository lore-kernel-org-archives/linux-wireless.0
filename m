Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3407 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030678AbXDSAsv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Apr 2007 20:48:51 -0400
Date: Wed, 18 Apr 2007 20:24:15 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Hanno =?iso-8859-1?Q?B=F6ck?= <ml@hboeck.de>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Meaning of two trees wireless-dev and wireless-2.6
Message-ID: <20070419002415.GA5733@tuxdriver.com>
References: <200704190153.39400.ml@hboeck.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <200704190153.39400.ml@hboeck.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 19, 2007 at 01:53:39AM +0200, Hanno B=F6ck wrote:
> Hi,
>=20
> On git.kernel.org, there seem to be two active main wireless-trees:=20
> wireless-dev and wireless-2.6.
>=20
> Can anyone explain me the meaning of both trees? Is it planned to mer=
ge the=20
> work?

The wireless-2.6 tree is the current "feeder" tree for pushing wireless
patches on their way towards Linus.  It only has components that are
currently in Linus' tree or (in the case of a new driver) soon will be.

The wireless-dev tree is for (ahem) development of wireless components
with more freedom than is possible in a tree that feeds upstream.
It includes new components like cfg80211 and nl80211 (for wireless
hardware configuration) as well as mac80211 (a replacement for the
ieee80211softmac component) and the drivers that use mac80211.o

The components in the wireless-dev tree have been available in Andrew
Morton's -mm tree for most of the 2.6.22 development cycle.  FWIW,
David Miller has been prodding me to start sending him patches to
add some of those components (notably cfg80211 and mac80211) to the
upstream kernels.  Once that happens and the patches are accepted
upstream, then those components will be handled by the wireless-2.6
tree.

Once all those components and the mac80211 drivers have made their way
upstream, then wireless-2.6 will handle everything and wireless-dev
may cease to exist.  The exception would be if some new piece of
"disruptive" development pops-up that warrants further maintanence
of wireless-dev.

Hth!

John
--=20
John W. Linville
linville@tuxdriver.com
-
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
