Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30t.wh2.ocn.ne.jp ([125.206.180.136]:32797 "HELO
	mail30t.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752477Ab0JLCsM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 22:48:12 -0400
Received: from vs3008.wh2.ocn.ne.jp (125.206.180.171)
	by mail30t.wh2.ocn.ne.jp (RS ver 1.0.95vs) with SMTP id 3-0163061689
	for <linux-wireless@vger.kernel.org>; Tue, 12 Oct 2010 11:48:11 +0900 (JST)
From: Bruno Randolf <br1@einfach.org>
To: Ben Greear <greearb@candelatech.com>
Subject: Re: [PATCH v2] ath5k:  Adjust opmode when interfaces are removed.
Date: Tue, 12 Oct 2010 11:48:19 +0900
Cc: linux-wireless@vger.kernel.org
References: <1286564475-10105-1-git-send-email-greearb@candelatech.com> <201010121044.39093.br1@einfach.org> <4CB3C3A3.5040309@candelatech.com>
In-Reply-To: <4CB3C3A3.5040309@candelatech.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Message-Id: <201010121148.19073.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue October 12 2010 11:10:43 Ben Greear wrote:
> On 10/11/2010 06:44 PM, Bruno Randolf wrote:
> > On Sat October 9 2010 04:01:15 greearb@candelatech.com wrote:
> >> +
> >> +	/* Calculate combined mode - when APs are active, operate in AP mode.
> >> +	 * Otherwise use the mode of the new interface. This can currently
> >> +	 * only deal with combinations of APs and STAs. Only one ad-hoc
> >> +	 * interfaces is allowed above.
> > 
> > the comment reference to "above" does not make sense here any more.
> 
> This patch is already in..but I can send a followup cleanup patch.

just for the comment it's probably not worth it, but...

> >> ieee80211_vif *vif) +static void ath_do_set_opmode(struct ath5k_softc
> >> *sc)
> >> +{
> >> +	struct ath5k_hw *ah = sc->ah;
> >> +	ath5k_hw_set_opmode(ah, sc->opmode);
> >> +	ATH5K_DBG(sc, ATH5K_DEBUG_MODE, "mode setup opmode %d (%s)\n",
> >> +		  sc->opmode,
> >> +		  ath_opmode_to_string(sc->opmode) ?
> >> +		  ath_opmode_to_string(sc->opmode) : "UKNOWN");
> >> +}
> > 
> > what's the point of this function? just to add the debug print?
> 
> Yes.  At one point, I had it being called from several places..but now it's
> called from only one place currently, I think.  I could make it explicitly
> inline code if someone cared.

i think i do care. could you please just open-code it at the one place where 
you call this function?

> > i think it makes sense to set the opmode here. and also do the same in
> > ath5k_remove_interface. that way we figure out the opmode when interfaces
> > are added/removed.
> 
> It calls ath5k_mode_setup(sc, vif), which sets rx filter, updates bssid
> mask, and sets the opmode.
> 
> >> @@ -2905,7 +2919,7 @@ ath5k_remove_interface(struct ieee80211_hw *hw,
> >> 
> >>   	else if (avf->opmode == NL80211_IFTYPE_ADHOC)
> >>   	
> >>   		sc->num_adhoc_vifs--;
> >> 
> >> -	ath5k_update_bssid_mask(sc, NULL);
> >> +	ath5k_update_bssid_mask_and_opmode(sc, NULL);
> >> 
> >>   	mutex_unlock(&sc->lock);
> 
> And that recalculates opmode and bssid mask on removal.
> 
> Or maybe I'm mis-understanding your suggestion?

i guess my suggestion was to solve it directly in add/remove_interface, as i 
think that would me a more obvious place to do it, but as your patch already 
got already merged: nevermind. your solution has advantages too.

thanks,
bruno
