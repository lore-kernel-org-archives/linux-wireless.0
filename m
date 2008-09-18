Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:37589 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929AbYIRRka (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 13:40:30 -0400
Received: by nf-out-0910.google.com with SMTP id d3so6560nfc.21
        for <linux-wireless@vger.kernel.org>; Thu, 18 Sep 2008 10:40:28 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] rfkill: clarify usage of rfkill_force_state() and rfkill->get_state()
Date: Thu, 18 Sep 2008 19:40:24 +0200
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>
References: <20080918145236.GJ1583@khazad-dum.debian.net> <200809181724.03723.IvDoorn@gmail.com> <20080918164339.GM1583@khazad-dum.debian.net>
In-Reply-To: <20080918164339.GM1583@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200809181940.24727.IvDoorn@gmail.com> (sfid-20080918_194034_623794_99D71BBC)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 18 September 2008, Henrique de Moraes Holschuh wrote:
> On Thu, 18 Sep 2008, Ivo van Doorn wrote:
> > On Thursday 18 September 2008, Henrique de Moraes Holschuh wrote:
> > > rfkill_force_state() is used to update the rfkill core's idea of what is
> > > really happening RIGHT NOW to the transmitter hardware in a PUSH model.
> > > 
> > > rfkill->get_state() does the same, in a PULL model.
> > > 
> > > Neither of them change the real hardware radio state through a call to
> > > rfkill->toggle_radio() or anything of the sort, so they must deal with the
> > > real, current state of the hardware.
> > > 
> > > Change some documentation to make that more clear (I hope).
> > > 
> > > Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> > > Cc: Ivo van Doorn <IvDoorn@gmail.com>
> > 
> > See my other mail I just send out.
> 
> I did, and just replied to it.
> 
> But only now do I think I realised what you meant:  That even if the driver
> tries to keep set txpower off separate from rfkill, if it uses the hardware
> soft-rfkill bit to implement both, it cannot use that to feed information to
> rfkill_force_state() directly.
> 
> Argh.

Indeed, you need to differentiate between RFKILL and RADIO states.

> > But I don't quite agree on this change of rfkill event interpretation.
> 
> Well, there is no intended change in interpretation, but I don't know how to
> word it in a way that means "the real current hardware state as far as
> rfkill is concerned".

Well my interpretation is that rfkill events and thus rfkill_force_state() calls
should be done for RFKILL state changes only. And RADIO state should be
ignored since they don't matter for rfkill.

> Because suppose it is a driver doing txpower off AND software rfkill using
> the *same* hardware bit (a sigle software rfkill bit).
>
> Now it must do something like this in pseudo-code:
> 
> 	1. if (the bit is disabled (i.e. SW rfkill is NOT ACTIVE)) {
> 		rfkill-SW-status = disabled;
> 	   }  else if (the bit is enabled (i.e. SW rfkill is ACTIVE)) {
> 		if (tx power off is NOT ACTIVE)
> 			rfkill-SW-status = enabled;
> 		else
> 			rfkill-SW-status = whatever the user asked
> 	   }
> 
> THEN, it should use rfkill-sw-status, along with the hw rfkill line status,
> to synthesize the state it must pass to rfkill_force_status().
> 
> ICK.  Of course, if the driver has another way to implement txpower off that
> does not clash with sw rfkill, the above is unneeded.
> 
> How would you put that into words for the rfkill documentation?

The driver is required to keep track of the userspace configuration settings,
when rfkill sends BLOCK to driver it should disable the radio, when rfkill
send UNBLOCK to the driver it should restore to the userspace configuration
settings (which can either be an enabled or disabled radio).

Ivo
