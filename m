Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7133 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753793AbZJZT5N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Oct 2009 15:57:13 -0400
Subject: Re: Questions about cfg80211's cfg80211_connect_params->crypto
 settings
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200910260947.48365.hs4233@mail.mn-solutions.de>
References: <200910260947.48365.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Mon, 26 Oct 2009 12:57:15 -0700
Message-Id: <1256587035.2110.14.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-10-26 at 09:47 +0100, Holger Schurig wrote:
> Hi,
> 
> I'm a but confused about what fields in "struct 
> cfg80211_connect_params" (now abbreviated as sme->)
> are relevant for me.
> 
> 
> sme->private
> ------------
> Right now, my lbs_cfg_connect() code just tests 
> sme->crypto.cipher_group. It doesn't check or use sme->privacy.
> 
>  and sme-> crypto.wpa_versions like they are redundant. Is this 
> correct?
> 
> Empirical it migth be correct, because I can successfully connect 
> to APs, but if "privacy" is redundant, should I prepare a patch 
> to get rid of it?
> 
> What is this?  And how should my driver react to it's settings?
> 
> 
> 
> sme->crypto.wpa_versions
> ------------------------
> Again I seems to be ok to ignore this variable and just check 
> sme->crypto.cipher_group. In practice this seems to work, but is 
> it correct?
> 
> What is this, what is the intented use of it?  May I prepare a 
> patch to get rid of it?

Wouldn't this be used to force WPA2/RSN?  THere are APs out there where
you can select WPA+CCMP and WPA2+TKIP, which wouldn't be apparent from
just cipher_group, right?  If userspace really does want you to only
connect to a WPA2-capable AP and ignore WPA1+TKIP and WPA1+CCMP, then
this field is the only way to indicate that.

In libertas, this would all happen during the scan-before-connect when
we try to find the BSSID of the AP we want to associate with.  The WEXT
stuff had a bunch of ugly checks to match up an AP in the scan list with
the parameters of the connect request, and that's where I'd expect this
to be used?

Dan

> 
> 
> sme->crypto.n_ciphers_pairwise, sme->crypto.ciphers_pairwise
> ------------------------------------------------------------
> The same for sme->crypto.n_ciphers_pairwise. It is always 0 zero 
> for the WEP case and always 1 for the WPA/WPA2 case, so isn't it 
> redundant either?  lbs_cfg_connect() ignores this, maybe it's 
> not needed at .connect() time anyway?
> 
> But what is it really, what is the intended use?
> 
> 
> 
> sme->crypto.n_akm_suites, sme->crypto.akm_suites
> ------------------------------------------------
> In cfg80211.h, the kdoc help text for sme->crypo.akm_suites is 
> just "AKM suites" or "number of AKM suites", which keeps me as 
> confused as before.
> 
> What is this?  And how should my driver react to it's settings?
> 
> 

