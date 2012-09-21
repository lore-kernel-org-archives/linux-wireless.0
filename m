Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31421 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754005Ab2IUNIB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Sep 2012 09:08:01 -0400
Date: Fri, 21 Sep 2012 15:07:11 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	Christian Lamparter <chunkeey@googlemail.com>,
	Luciano Coelho <coelho@ti.com>, Arik Nemtsov <arik@wizery.com>
Subject: Re: [RFC] mac80211: validate key before MIC verify
Message-ID: <20120921130711.GC3100@redhat.com> (sfid-20120921_150806_097138_D337ADD6)
References: <20120921124141.GA3100@redhat.com>
 <1348232380.4160.7.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1348232380.4160.7.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Sep 21, 2012 at 02:59:40PM +0200, Johannes Berg wrote:
> On Fri, 2012-09-21 at 14:41 +0200, Stanislaw Gruszka wrote:
> 
> > --- a/net/mac80211/wpa.c
> > +++ b/net/mac80211/wpa.c
> > @@ -97,6 +97,14 @@ ieee80211_rx_h_michael_mic_verify(struct ieee80211_rx_data *rx)
> >  		return RX_CONTINUE;
> >  
> >  	/*
> > +	 * Some hardware seems to generate Michael MIC failure reports; even
> > +	 * though, the frame was not encrypted with TKIP and therefore has no
> > +	 * MIC. Ignore the flag them to avoid triggering countermeasures.
> > +	 */
> > +	if (!rx->key || rx->key->conf.cipher != WLAN_CIPHER_SUITE_TKIP)
> > +		return RX_CONTINUE;
> > +
> > +	/*
> >  	 * No way to verify the MIC if the hardware stripped it or
> >  	 * the IV with the key index. In this case we have solely rely
> >  	 * on the driver to set RX_FLAG_MMIC_ERROR in the event of a
> 
> Hm, this doesn't seem _quite_ right, but I'm not sure: it seems that
> previously it was possible that we don't have a key pointer but the
> driver set all of RX_FLAG_MMIC_STRIPPED, RX_FLAG_IV_STRIPPED and
> RX_FLAG_MMIC_ERROR, in which case after your change the frame will be
> accepted rather than rejected.

I wanted to cleanup stuff, but yeah, that seem to be wrong. I guess
I can just add check before rx->key->u.tkip.rx usage to fix the
problem. Eventually fix flags setting in driver.

Stanislaw 
