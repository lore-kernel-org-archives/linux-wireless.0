Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:3797 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752576AbYIZSSr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Sep 2008 14:18:47 -0400
Received: by nf-out-0910.google.com with SMTP id d3so409484nfc.21
        for <linux-wireless@vger.kernel.org>; Fri, 26 Sep 2008 11:18:45 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH RFC] mac80211: notify mac80211 about rfkill events
Date: Fri, 26 Sep 2008 20:18:40 +0200
Cc: Tomas Winkler <tomasw@gmail.com>, linville@tuxdriver.com,
	yi.zhu@intel.com, hmh@hmh.eng.br, linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
References: <1222357719-26294-1-git-send-email-tomas.winkler@intel.com> <1ba2fa240809251505p342d8a6do51cf870624e0c8dd@mail.gmail.com> <1222426905.10563.100.camel@johannes.berg>
In-Reply-To: <1222426905.10563.100.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200809262018.40777.IvDoorn@gmail.com> (sfid-20080926_201902_204707_09792CC0)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 26 September 2008, Johannes Berg wrote:
> On Fri, 2008-09-26 at 01:05 +0300, Tomas Winkler wrote:
> 
> > > I am not sure if registring a notifier would be the best solution,
> > > persionally I was thinking of implementing the rfkill structure into ieee80211_local
> > > and make it listen to events directly.
> 
> I think I like this better.
> 
> > That's definitely other option we wanted to suggest that mac80211
> > would register itself to rfkill subsystem and will provide to driver
> > appropriate callbacks.  The question is how  drivers vary in the rfkil
> > implementation and whether it wouldn't be more complex, in that case
> > the notification is quite clean solution.
> 
> How complex does it have to be?

Not really, probably it only needs to be a wrapper around rfkill_force_state
where we can use the RFKILL_ defines to indicate the BLOCKED status.

> > > That means that the only change needed in ieee80211_ioctl_siwtxpower() is
> > > only allowing the enabling of the radio when RFKILL is not set to BLOCKED.
> > 
> > That's just complicates everything and moving the policy  decisions to
> > the driver after all even
> > form txpower off you implement it as soft rfkill.

Why does it complicate things? It means that mac80211 doesn't use
rfkill_force_state() when the user triggers a radio state change using
iw/iwconfig/ifconfig or whatever userspace tool.

mac80211 doesn't generate rfkill events because it isn't tied to any device
keys/buttons/sliders. That is what the drivers do. And they should only listen
to that key/button/slider.

> > I would suggest just remove the support for txpower off in mac80211
> > now when appropriate or sync it with soft block after all it coming
> > from user space as a software event.
> 
> I think what we should do is in mac80211 simply synthesize the
> "radio_enabled" state that the config callback has from both rfkill and
> txpower off. Anything wrong with that?

Come to think of it, there is a bug in the previous patch since it doesn't handle
the case when the interface is brought up during a BLOCKED state.

So all that has to be done is:
	* rfkill BLOCK event received in mac80211
	* set flag to indicate the BLOCKED state
	* disable radio
	* prevent radio being enabled through ifup
	* prevent radio being enabled through iwconfig txpower on

	* rfkill UNBLOCK event received from mac80211
	* clear flag to indicate UNBLOCKED state
	* restore radio to the by iwconfig/ifup configured state

Ivo
