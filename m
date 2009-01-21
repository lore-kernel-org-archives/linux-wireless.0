Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.170]:32390 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbZAUNYM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 08:24:12 -0500
Received: by wf-out-1314.google.com with SMTP id 27so4351419wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jan 2009 05:24:11 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18807.8570.438280.892581@localhost.localdomain> (sfid-20090121_142417_592572_38771C90)
Date: Wed, 21 Jan 2009 18:52:02 +0530
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Add documentation bits for mac80211_rate_control_flags
In-Reply-To: <1232541853.4106.0.camel@johannes.local>
References: <18806.42720.858590.913279@gargle.gargle.HOWL>
	<1232541853.4106.0.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2009-01-21 at 10:08 +0530, Sujith wrote:
> > Signed-off-by: Sujith <Sujith.Manoharan@atheros.com>
> > ---
> >  include/net/mac80211.h |   20 ++++++++++++++++++++
> >  1 files changed, 20 insertions(+), 0 deletions(-)
> > 
> > diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> > index 9a5869e..742937f 100644
> > --- a/include/net/mac80211.h
> > +++ b/include/net/mac80211.h
> > @@ -262,6 +262,26 @@ enum mac80211_tx_control_flags {
> >  	IEEE80211_TX_CTL_RATE_CTRL_PROBE	= BIT(12),
> >  };
> >  
> > +/**
> > + * enum mac80211_rate_control_flags - per-rate flags set by the
> > + *	Rate Control algorithm.
> > + *
> > + * These flags are set by the Rate control algorithm for each rate during tx,
> > + * in the @flags member of struct ieee80211_tx_rate.
> > + *
> > + * @IEEE80211_TX_RC_USE_RTS_CTS: Use RTS/CTS exchange for this rate.
> > + * @IEEE80211_TX_RC_USE_CTS_PROTECT: CTS-to-self protection is required.
> > + *	This is set if the current BSS requires ERP protection.
> > + * @IEEE80211_TX_RC_USE_SHORT_PREAMBLE: Use short preamble.
> > + * @IEEE80211_TX_RC_MCS: HT rate.
> > + * @IEEE80211_TX_RC_GREEN_FIELD: Indicates whether this rate can be used in
> > + *	Greenfield mode.
> > + * @IEEE80211_TX_RC_40_MHZ_WIDTH: Indicates if the Channel Width can be 40 MHz.
> > + * @IEEE80211_TX_RC_DUP_DATA: the frame should be transmitted on both of the
> > + *	adjacent 20 MHz channels, if the current channel type is
> > + *	NL80211_CHAN_HT40MINUS or NL80211_CHAN_HT40PLUS.
> > + * @IEEE80211_TX_RC_SHORT_GI: Short Guard interval can be used for this rate.
> > + */
> 
> Are you sure all this should say "can" rather than "should"? I'm
> thinking that the driver should just follow whatever the rc algorithm
> said here?

Right, I'll change the wording.

Sujith
