Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:46047 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751059AbZGBJvo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Jul 2009 05:51:44 -0400
Date: Thu, 2 Jul 2009 12:51:34 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Jouni Malinen <jmalinen@atheros.com>
Subject: Re: [PATCH 8/8 v3.1] mac80211: re-add HT disabling
Message-ID: <20090702095134.GA11235@jm.kir.nu>
References: <20090630115245.675553951@sipsolutions.net> <20090630115303.111250594@sipsolutions.net> <20090630132547.GB24667@vasanth-laptop> <1246369077.16643.10.camel@johannes.local> <20090630135207.GC24667@vasanth-laptop> <1246370452.16643.11.camel@johannes.local> <1246433956.16643.35.camel@johannes.local> <20090701101336.GD24667@vasanth-laptop> <1246444959.4131.15.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1246444959.4131.15.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 01, 2009 at 12:42:39PM +0200, Johannes Berg wrote:
> On Wed, 2009-07-01 at 15:43 +0530, Vasanthakumar Thiagarajan wrote:
> > On Wed, Jul 01, 2009 at 01:09:16PM +0530, Johannes Berg wrote:
> > > @@ -1236,6 +1236,14 @@ static int ieee80211_assoc(struct wiphy
> > > +       for (i = 0; i < req->crypto.n_ciphers_pairwise; i++)
> > > +               if (req->crypto.ciphers_pairwise[i] == WLAN_CIPHER_SUITE_WEP40 ||

> > for..loop does not seem to be necessary here as it is very unlikely that
> > an assoc req will have more than one cipher suite.

> True, but so far we've defined the API that way. Should we redefine the
> API? I keep forgetting what is valid where. Jouni?

The (re)association request is only allowed to list one pairwise cipher
suite (see IEEE 802.11, 8.4.3). Various other use cases for RSN IE
support multiple cipher suites, but this one does not.

-- 
Jouni Malinen                                            PGP id EFC895FA
