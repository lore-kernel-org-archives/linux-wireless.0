Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh03.mail.saunalahti.fi ([62.142.5.109]:42071 "EHLO
	emh03.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751591AbYCaPFc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Mar 2008 11:05:32 -0400
Date: Mon, 31 Mar 2008 18:04:23 +0300
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	Javier Cardona <javier@cozybit.com>, Jiri Benc <jbenc@suse.cz>,
	Michael Wu <flamingice@sourmilk.net>,
	Bill Moss <bmoss@CLEMSON.EDU>, Daniel Drake <dsd@gentoo.org>,
	Dan Williams <dcbw@redhat.com>, Vladimir Koutny <vlado@ksp.sk>,
	Tomas Winkler <tomasw@gmail.com>,
	John Linville <linville@tuxdriver.com>
Subject: Re: mac80211 MLME scanning - BSS list trouble
Message-ID: <20080331150423.GQ14333@jm.kir.nu> (sfid-20080331_160535_338447_D69209C0)
References: <1206865999.22530.187.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1206865999.22530.187.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Mar 30, 2008 at 10:33:19AM +0200, Johannes Berg wrote:

> After having two bug reports about the BSS list/probe_resp variable i=
n
> mac80211 and a very detailed analysis of the problem from Bill Moss, =
I
> think I've understood the problem now but I'm not sure how to proceed
> because I do not understand the reason for "Do not allow beacons to
> override data from probe responses".

The main (and only) reason for this is support for multi-SSID
configurations (hidden SSID and/or multiple SSIDs with the same BSSID,
but with different security parameters). Only the Probe Response frames
are guaranteed to include correct information for <BSSID,SSID> pair in
these cases and because of that, Beacon frames are not allowed to updat=
e
things like SSID or WPA/RSN IE.

> The question, however, is: why are beacons not allowed to override pr=
obe
> response information? That is, why does this piece of code exist:
>=20
>         if (sdata->vif.type !=3D IEEE80211_IF_TYPE_IBSS &&
>             bss->probe_resp && beacon) {
>                 /* STA mode:
>                  * Do not allow beacon to override data from Probe Re=
sponse. */
>                 ieee80211_rx_bss_put(dev, bss);
>                 return;
>         } =20

This controls which BSS info fields are updated based on both Beacon an=
d
Probe Response frames and which are updated only based on Probe Respons=
e
frames.

One example of information that should not be overridden by Beacon
frames is WPA and RSN IE since these could differ based on the SSID in
multi-SSID configurations. An example of information that must be
updated from every Beacon frame would be ERP IE. Finally, there are als=
o
more complex cases, like the Capability Information, which should
probably be handled separately for each subfield (e.g., Privacy could b=
e
per-SSID and Short Slot Time for every SSID of the BSSID).

> Bill Moss reports that removing this piece of code (and then the
> probe_resp variable =EF=BB=BFcompletely since it'll be write-only) fi=
xes the
> problem, and it's obvious why.

I don't think that this would be the correct fix for this issue.

> The only thing I'm not sure about is whether that will introduce
> regressions because probe responses can contain better information th=
an
> beacons. The only reason I can find for this would be an AP that has
> multiple SSIDs with different security settings on each and announces
> those only in the probe responses (and otherwise uses a hidden SSID),
> but we only handle that now, much later than the code there that was
> already present.

I'm not sure whether the current code is correct for all information
from Beacon/ProbeResp (i.e., some parts might need to be moved to be
before/after this check), but changes to WPA/RSN IE are after this
return-on-Beacon for a reason and removing that check would break some
multi-SSID networks.

> However, that actually seems to have another bug, if you have such an=
 AP
> will you find two BSSes, one with a hidden and one with a visible SSI=
D?

That is by design.

> Any hints about this code or the desired behaviour would be greatly
> appreciated.

I think that we will need to evaluate whether the current implementatio=
n
is updating all pieces of information in correct place and still
maintain possibility of not using Beacon frames to update some fields.
There might be cases where the old information from ProbeResp should
expire (though, if we are still associated with that BSSID,SSID pair, w=
e
should use Probe Request to update this information instead of just
blindly throughing it away).

Any information that has to be same for all SSIDs in multi-SSID (single
BSSID) configuration can be updated based on Beacon frames since the
SSIDs for a specific SSID would not contain any different information
for these parts. However, fields that can be configured per-SSID, must
be handled separately in order to be able to support multi-SSID
configuration with different security policies per SSID. This would
mainly included Privacy flag in the capability field and security
related IEs (WPA IE, RSN IE), but there may be something else that woul=
d
benefit of similar handling.

--=20
Jouni Malinen                                            PGP id EFC895F=
A
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
