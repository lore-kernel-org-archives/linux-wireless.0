Return-Path: <SRS0=/cM4=X3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A480C35280
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Oct 2019 09:09:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 06AB7218DE
	for <linux-wireless@archiver.kernel.org>; Wed,  2 Oct 2019 09:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbfJBJJm (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 2 Oct 2019 05:09:42 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:60214 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726443AbfJBJJm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Oct 2019 05:09:42 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92.2)
        (envelope-from <johannes@sipsolutions.net>)
        id 1iFadf-0002Ht-RB; Wed, 02 Oct 2019 11:09:39 +0200
Message-ID: <b3198e85e5ea4a1794cc901843d3262e39f10a31.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: simplify TX aggregation start
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 02 Oct 2019 11:09:38 +0200
In-Reply-To: <20191002090849.GA2943@redhat.com>
References: <1569960387-I152912660131cbab2e5d80b4218238c20f8a06e5@changeid>
         <20191002090849.GA2943@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-10-02 at 11:08 +0200, Stanislaw Gruszka wrote:
> On Tue, Oct 01, 2019 at 10:06:29PM +0200, Johannes Berg wrote:
> > index f1cdcd61c54a..b74e758cce09 100644
> > --- a/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > +++ b/drivers/net/wireless/ralink/rt2x00/rt2800lib.c
> > @@ -10489,7 +10489,7 @@ int rt2800_ampdu_action(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> >  		 */
> >  		break;
> >  	case IEEE80211_AMPDU_TX_START:
> > -		ieee80211_start_tx_ba_cb_irqsafe(vif, sta->addr, tid);
> > +		ret = IEEE80211_AMPDU_TX_START_IMMEDIATE;
> >  		break;
> >  	case IEEE80211_AMPDU_TX_STOP_CONT:
> >  	case IEEE80211_AMPDU_TX_STOP_FLUSH:
> <snip>
> > +#define IEEE80211_AMPDU_TX_START_IMMEDIATE 1
> > +
> >  /**
> 
> On rt2x00 we already return 1 for case we do not have free HW WCID
> number for a remote station.
> 
>         if (sta_priv->wcid > WCID_END)
>                 return 1;
> 
> So we should change that to some other error code i.e. -ENOSPC.

Hah, umm... that's kinda weird, but ok :)

johannes

