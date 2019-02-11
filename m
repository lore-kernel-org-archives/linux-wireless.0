Return-Path: <SRS0=RvtO=QS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01D8BC169C4
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 16:37:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CD709218D8
	for <linux-wireless@archiver.kernel.org>; Mon, 11 Feb 2019 16:37:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729025AbfBKQhw (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 11 Feb 2019 11:37:52 -0500
Received: from paleale.coelho.fi ([176.9.41.70]:58492 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727247AbfBKQhw (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Feb 2019 11:37:52 -0500
Received: from 91-156-4-241.elisa-laajakaista.fi ([91.156.4.241] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1gtEab-0005BT-Kg; Mon, 11 Feb 2019 18:37:49 +0200
Message-ID: <13b1fe1bd243a3c47b322a6359562910b24eb5c3.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, Adiel Aloni <adiel.aloni@intel.com>
Date:   Mon, 11 Feb 2019 18:37:48 +0200
In-Reply-To: <8409e5d470926c650e37062f4063976989096280.camel@sipsolutions.net>
References: <20190206111721.29283-1-luca@coelho.fi>
         <20190206111721.29283-13-luca@coelho.fi>
         <8409e5d470926c650e37062f4063976989096280.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 12/15] mac80211: shorten debug print to avoid warning
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2019-02-11 at 15:52 +0100, Johannes Berg wrote:
> On Wed, 2019-02-06 at 13:17 +0200, Luca Coelho wrote:
> > From: Adiel Aloni <adiel.aloni@intel.com>
> > 
> > Signed-off-by: Adiel Aloni <adiel.aloni@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> > ---
> >  net/mac80211/mlme.c | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
> > index 6d1e7e6f1c21..0b27e52daf43 100644
> > --- a/net/mac80211/mlme.c
> > +++ b/net/mac80211/mlme.c
> > @@ -184,7 +184,7 @@ ieee80211_determine_chantype(struct
> > ieee80211_sub_if_data *sdata,
> >  		 * it should be OK.
> >  		 */
> >  		sdata_info(sdata,
> > -			   "Wrong control channel: center-freq: %d ht-
> > cfreq: %d ht->primary_chan: %d band: %d - Disabling HT\n",
> > +			   "mismatch: center-freq: %d ht-cfreq: %d ht-
> > >primary_chan: %d band: %d - Disable HT\n",
> > 
> 
> I know you also have a patch in the pipeline that just extends the
> buffer, so I'm dropping this :)

Oooohhh, that's insider information! :P

But yeah, I merged the other patch internally one day before I sent
this one out, so my bad... sorry.

--
Cheers,
Luca.

