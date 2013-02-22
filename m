Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4755 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757110Ab3BVPAZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 10:00:25 -0500
From: "Piotr Haber" <phaber@broadcom.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH 1/2] [RFC] cfg80211: configuration of Bluetooth
 coexistence mode
Date: Fri, 22 Feb 2013 14:59:56 +0000
Message-ID: <53E0CDA8188165468B8B837459C34CA901053F56@SJEXCHMB15.corp.ad.broadcom.com> (sfid-20130222_160042_912774_2D27D3B5)
References: <1361524092-4814-1-git-send-email-phaber@broadcom.com>
 <1361524092-4814-2-git-send-email-phaber@broadcom.com> (
 sfid-20130222_100804_524805_03F665CB),<1361533924.8146.5.camel@jlt4.sipsolutions.net>
 <53E0CDA8188165468B8B837459C34CA901053EEA@SJEXCHMB15.corp.ad.broadcom.com>,<1361542053.3420.2.camel@jlt4.sipsolutions.net>
In-Reply-To: <1361542053.3420.2.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> > This is supposed to be temporary and time limited, so if say DHCP finishes in the window
> > we give it - great, if not the coexistence goes back to default behavior and Wifi traffic is
> > treated as usual.

> That's not even documented/implemented, the way I read the patch you'd
> have to set it back manually.

You are right, we implement it this way in brcmfmac but it is not documented
in nl80211 change. I thought of DISABLED as a trigger (for timed boost)
and ENABLED as a way to notify that whoever requested it is done.
The interface could be made to reflect this "design"

> > > What application would actually call this? I don't really see how it
> > > could be integrated like that.

> > For EAPOL wpa_supplicant might use it. For DHCP it could be used from enter/exit hooks
> > via iw or some other utility able to send nl messages.

> See that's the thing, I don't really see the point for EAPOL: you could
> just as well start protecting when the association is done, and end it
> when the station is marked authorized. That will have protected any
> EAPOL (or other protocols for that matter) traffic.

That is true, this could be totally automatic.

> Similarly, you could give it a certain timeout to protect DHCP traffic.
> I guess the only thing that would seem necessary would be a notification
> of "DHCP done" that would allow you to drop the protection right away.

I guess that is the only reason we need this interface.
Still if we set the "protection" timeout to be reasonable it can do without
it...

> > This feature is styled after Android one.

> I know, I'm (vaguely) familiar with that.

> > There a Wifi state machine tries to "protect" DHCP traffic.

> Is there any *reason* for it though? Would it ever call it after the
> connection is fully established?

As for reason I can't tell, someone found one to implement it in Android :)
It is not used after connection is established.

Piotr 

