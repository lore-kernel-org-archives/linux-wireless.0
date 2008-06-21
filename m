Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.250]:44406 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750985AbYFUMU4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jun 2008 08:20:56 -0400
Received: by an-out-0708.google.com with SMTP id d40so383406and.103
        for <linux-wireless@vger.kernel.org>; Sat, 21 Jun 2008 05:20:55 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Let drivers have access to TKIP key offets for TX and RX MIC
Date: Sat, 21 Jun 2008 14:38:48 +0200
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
References: <20080621115133.GI17936@ruslug.rutgers.edu> <200806211423.59465.IvDoorn@gmail.com> <1214050052.8967.245.camel@johannes.berg>
In-Reply-To: <1214050052.8967.245.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200806211438.49029.IvDoorn@gmail.com> (sfid-20080621_142114_958437_10F33E04)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 21 June 2008, Johannes Berg wrote:
> On Sat, 2008-06-21 at 14:23 +0200, Ivo van Doorn wrote:
> > On Saturday 21 June 2008, Johannes Berg wrote:
> > > On Sat, 2008-06-21 at 07:51 -0400, Luis R. Rodriguez wrote:
> > > > Some drivers may want to to use the TKIP key offsets for TX and RX
> > > > MIC so lets move this out.
> > > > 
> > > > Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> > > > ---
> > > >  include/net/cfg80211.h |    5 +++++
> > > >  net/mac80211/key.h     |   37 ++++++++++++-------------------------
> > > >  2 files changed, 17 insertions(+), 25 deletions(-)
> > > > 
> > > > diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> > > > index e007508..6cb8b02 100644
> > > > --- a/include/net/cfg80211.h
> > > > +++ b/include/net/cfg80211.h
> > > > @@ -12,6 +12,11 @@
> > > >   * Copyright 2006, 2007	Johannes Berg <johannes@sipsolutions.net>
> > > >   */
> > > >  
> > > > +/* Starting offsets for each key for TKIP */
> > > > +#define ALG_TKIP_TEMP_ENCR_KEY		0
> > > > +#define ALG_TKIP_TEMP_AUTH_TX_MIC_KEY	16
> > > > +#define ALG_TKIP_TEMP_AUTH_RX_MIC_KEY	24
> > > 
> > > put it into nl80211 and give it proper namespace prefixes, please.
> > 
> > Don't we need something similar for AES keys as well?
> 
> I don't think there is a separate MIC key for AES, is there?

Hmm, I'm off reading some specs about TKIP and AES encryption. ;)

PS, above defines are very useful for rt2x00 since apparently I swapped the
2 fields in the rt2x00crypto implementation.

This was caused the legacy driver code which did:

WPANONE:
txmic = 16
rxmic = 16

authenticator:
txmic = 16
rxmic = 24

normal:
txmic = 24
rxmic = 16

Ivo

