Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:59756 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754317AbZBROCL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 09:02:11 -0500
Date: Wed, 18 Feb 2009 16:01:38 +0200
From: Jouni Malinen <j@w1.fi>
To: Dan Williams <dcbw@redhat.com>
Cc: Marcel Holtmann <marcel@holtmann.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: Missing link quality with wireless-testing
Message-ID: <20090218140138.GB10871@jm.kir.nu> (sfid-20090218_150216_509942_59C5263A)
References: <1234904111.29785.44.camel@johannes.local> <1234904978.4678.31.camel@californication> <1234913132.11832.10.camel@70-5-246-164.pools.spcsdns.net> <1234933059.21412.28.camel@californication> <20090218073104.GA23366@jm.kir.nu> <1234944391.21412.47.camel@californication> <20090218082520.GA26280@jm.kir.nu> <1234959523.13950.47.camel@localhost> <20090218123301.GA6152@jm.kir.nu> <1234961297.13950.55.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1234961297.13950.55.camel@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 18, 2009 at 07:48:17AM -0500, Dan Williams wrote:

> Then mac80211 is not conforming to WEXT...  unless it's setting
> IW_QUAL_DBM in the updated field, which it probably is.

It should have IW_QUAL_DBM set.

> Here's the relevant bit of wireless.h:
> 
>         /* Quality range (link, level, noise)
>          * If the quality is absolute, it will be in the range [0 ; max_qual],
>          * if the quality is dBm, it will be in the range [max_qual ; 0].
> 
> That doc never got updated for IW_QUAL_DBM either.

Yeah, the max_qual=-110 does not seem to fit into that description.

> > The unknown values are not included anymore in wpa_supplicant 0.7.x.
> 
> Just pulled; it doesn't show up in master.  Do you have a separate git
> repo for 0.7.x?

0.7.x is in hostap.git and this change should be there:
http://w1.fi/gitweb/gitweb.cgi?p=hostap.git;a=commitdiff;h=7c2849d2a09c1ba3cbc2247f08baad2e929464c1

I don't remember when I pushed that out, but anyway, it is there now.

-- 
Jouni Malinen                                            PGP id EFC895FA
