Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59232 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753232Ab3BVOHh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 Feb 2013 09:07:37 -0500
Message-ID: <1361542053.3420.2.camel@jlt4.sipsolutions.net> (sfid-20130222_150741_486966_F6B54D7F)
Subject: Re: [PATCH 1/2] [RFC] cfg80211: configuration of Bluetooth
 coexistence mode
From: Johannes Berg <johannes@sipsolutions.net>
To: Piotr Haber <phaber@broadcom.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 22 Feb 2013 15:07:33 +0100
In-Reply-To: <53E0CDA8188165468B8B837459C34CA901053EEA@SJEXCHMB15.corp.ad.broadcom.com>
References: <1361524092-4814-1-git-send-email-phaber@broadcom.com>
	 <1361524092-4814-2-git-send-email-phaber@broadcom.com>
	 ( sfid-20130222_100804_524805_03F665CB),<1361533924.8146.5.camel@jlt4.sipsolutions.net>
	 <53E0CDA8188165468B8B837459C34CA901053EEA@SJEXCHMB15.corp.ad.broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-22 at 13:32 +0000, Piotr Haber wrote:

> > Apart from a few minor technical comments that I'll omit for now, I'm
> > not sure what value this really has? EAPOL can already be "protected" by
> > way of knowing when the station is marked authorized, and DHCP is pretty
> > tricky because it could take "forever", might not be there at all, etc.

> By "protect" I meant give Wifi a priority over BT so these time sensitive things 
> can finish quicker/on first try, limiting the possibility of dropping packets because of BT 
> using the medium.

I know :)

> This is supposed to be temporary and time limited, so if say DHCP finishes in the window 
> we give it - great, if not the coexistence goes back to default behavior and Wifi traffic is
> treated as usual. 

That's not even documented/implemented, the way I read the patch you'd
have to set it back manually.

> > What application would actually call this? I don't really see how it
> > could be integrated like that.

> For EAPOL wpa_supplicant might use it. For DHCP it could be used from enter/exit hooks
> via iw or some other utility able to send nl messages.

See that's the thing, I don't really see the point for EAPOL: you could
just as well start protecting when the association is done, and end it
when the station is marked authorized. That will have protected any
EAPOL (or other protocols for that matter) traffic.

Similarly, you could give it a certain timeout to protect DHCP traffic.
I guess the only thing that would seem necessary would be a notification
of "DHCP done" that would allow you to drop the protection right away.

> This feature is styled after Android one.

I know, I'm (vaguely) familiar with that.

> There a Wifi state machine tries to "protect" DHCP traffic.

Is there any *reason* for it though? Would it ever call it after the
connection is fully established?

To me this seems not very well thought out.

johannes

