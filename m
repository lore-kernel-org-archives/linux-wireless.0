Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:58430 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113AbZHEUZR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Aug 2009 16:25:17 -0400
From: Christian Lamparter <chunkeey@web.de>
To: Joerg Albert <jal2@gmx.de>
Subject: Re: [PATCH 1/2] ar9170: cleanup of bss_info_changed and beacon config
Date: Wed, 5 Aug 2009 22:25:14 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <4A78CE98.70903@gmx.de> <200908050404.47371.chunkeey@web.de> <4A79D7E5.1080604@gmx.de>
In-Reply-To: <4A79D7E5.1080604@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <200908052225.16114.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 05 August 2009 21:05:09 Joerg Albert wrote:
> On 08/05/2009 04:04 AM, Christian Lamparter wrote:
> > the beacon timer isn't exclusively used to notify the driver when its 
> > time for a new beacon... The STA mode uses the same _timer_
> > in reverse to wait for the next beacon form the assoc. AP.
> >
> > so, to be on the safe side: why not preserve the old behavior for the
> > STA mode as well and simply tell the hardware about dtim & beacon interval?
> 
> ar9170_set_beacon_timers() uses the beacon interval only if for AP mode,
Although pretbtt is closely related to the beacon interval.
It has a slightly different purpose: It fires _before_ the beacon is sent.
So the host is able to do some _last msec_ changes to the beacon.

> dtim is left in STA mode.
both dtim_period and beacon_int are ORed

|
| if (ar->vif) {
|	v |= ar->vif->bss_conf.beacon_int;
|	switch() [...]
|	v |= ar->vif->bss_conf.dtim_period << 16;
| }
|

into AR9170_MAC_REG_BCN_PERIOD.

It would be a BUG if this setting is omitted in STA mode,
since dtim beacons are essential.
> > The only remaining question is where to disabled the timer for STA.
> > (which is in some way relevant to: [PATCH 2/2] because previously,
> >  these timers were always disabled by remove_interface.)
> > 
> > I think the best place is in ar9170_op_bss_info_changed:
> >        if (changed & BSS_CHANGED_ASSOC) {
> > 
> > just when bss_conf->assoc gets "0".
> 
> Yes. IMHO also enable on bss_conf->assoc == 1.
yes, but not necessary for bss_conf->assoc == 1,
ieee80211_set_associated sets BSS_CHANGED_BEACON_INT.

ar9170_set_beacon_timers is executed twice unless
you throw more code at it than just the assoc check & call.
But anyway, that's fine by me.

Thanks,
	Chr
