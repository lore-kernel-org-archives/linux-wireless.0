Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33654 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab3CRTyO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Mar 2013 15:54:14 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi8so3054112wib.7
        for <linux-wireless@vger.kernel.org>; Mon, 18 Mar 2013 12:54:12 -0700 (PDT)
Date: Mon, 18 Mar 2013 20:54:06 +0100
From: Karl Beldan <karl.beldan@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Sam Leffler <sleffler@chromium.org>
Subject: Re: Radiotap injected rates
Message-ID: <20130318195406.GB17878@gobelin> (sfid-20130318_205430_922324_2D995A22)
References: <20130317215544.GA7031@gobelin>
 <1363634768.8260.16.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1363634768.8260.16.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 18, 2013 at 08:26:08PM +0100, Johannes Berg wrote:
> On Sun, 2013-03-17 at 22:55 +0100, Karl Beldan wrote:
> > Hi,
> > 
> > Some time ago the rate selection for radiotap injected frames did not
> > make it essentially for mac80211 getting short in IEEE80211_TX_CTL_*s.
> > 
> > Would it be acceptable to replace the originally proposed:
> > 
> > 
> > -	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL))
> > +	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) &&
> > +	    !(info->flags & IEEE80211_TX_CTL_NO_RC))
> >  		CALL_TXH(ieee80211_tx_h_rate_ctrl);
> > 
> > with something like :
> > 
> > -	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL))
> > +	if (!(tx->local->hw.flags & IEEE80211_HW_HAS_RATE_CONTROL) &&
> > +	    !(info->flags & IEEE80211_TX_CTL_INJECTED && info->control.rates[i]))
> > 		CALL_TXH(ieee80211_tx_h_rate_ctrl);
> 
> No, older wpa_supplicant/hostapd still use monitor interfaces for
> management frame transmissions, and require rate control.
> 

Since they require rate control, I guess they don't pass any radiotap
IEEE80211_RADIOTAP_{RATE,MCS} ? In that case that wouldn't disturb them.


And, oops typo, I meant :

+	    !(info->flags & IEEE80211_TX_CTL_INJECTED && info->control.rates[0] != -1))

with info->control.rates[0] properly set in the radiotap header parsing,
instead of :

> > +	    !(info->flags & IEEE80211_TX_CTL_INJECTED && info->control.rates[i]))

If that changes anything to what you guessed.

 
Karl
