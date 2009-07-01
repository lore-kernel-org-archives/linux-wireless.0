Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:46587 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750917AbZGAO3T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jul 2009 10:29:19 -0400
Subject: Re: 4965AGN loses connection on Custom wireless event
From: Dan Williams <dcbw@redhat.com>
To: Jan Willies <jan@willies.info>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <4A4B5EC8.8060804@willies.info>
References: <4A4B5EC8.8060804@willies.info>
Content-Type: text/plain
Date: Wed, 01 Jul 2009 10:29:45 -0400
Message-Id: <1246458585.12198.114.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2009-07-01 at 15:04 +0200, Jan Willies wrote:
> Hello list,
> 
> I have a strange problem with an EAP-Network here. I can associate just 
> fine, but approx 1 min after the _initial_ connection completed the 
> network hangs. Though all the tools say I'm still connected (nm-applet, 
> iwconfig) I can't ping anything. I have to re-new the connection with 
> nm-applet and after that it works again (and longer!).
> 
> 1. boot notebook and associate with wifi
> 2. wait 1 min -> hang
> 3. re-establish connection with nm-applet
> 4. after that it never hangs again (mostly)

1242720535.735207 - initial connection
1242720593.722277 - random assoc-info event
1242720593.744343 - WEXT assoc event for the AP you're already on
1242720593.745312 - supplicant decides to reauth with EAP
1242720603.745888 - supplicant-initiated reauth times out

So yeah, there's something going wrong here in the supplicant's handling
of a spurious association event sent from the driver.

Jouni, how should the supplicant handle a WEXT assoc event for the AP
that's already associated with?  That seems to be what's going on here;
the card is coming back from a scan and emitting an assoc event (not
sure why) and that's making the supplicant (wrongly IMHO) try to reauth
at the EAP level for some reason.

Dan

> You can find the log here: http://jan.willies.info/wpa_supplicant.log
> 
> Dan Williams says the interesting line is 1242720593.722277: "the driver 
> sends an association event *after* it's completed association, which the 
> supplicant interprets as a restart of the authentication process".
> 
> This is a Thinkpad X300 with Fedora 11 (iwlagn-1.3.27kds and 
> wpa_supplicant-0.6.8)
> 
> 
> regards,
> 
>    - jan
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

