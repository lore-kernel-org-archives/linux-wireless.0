Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:9422 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752909AbYGWTLT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 15:11:19 -0400
Received: by nf-out-0910.google.com with SMTP id d3so944236nfc.21
        for <linux-wireless@vger.kernel.org>; Wed, 23 Jul 2008 12:11:17 -0700 (PDT)
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] rfkill: add EPO lock to rfkill-input
Date: Wed, 23 Jul 2008 21:28:31 +0200
Cc: linux-wireless@vger.kernel.org
References: <1216775046-9506-1-git-send-email-hmh@hmh.eng.br> <200807232044.24531.IvDoorn@gmail.com> <20080723190114.GE11009@khazad-dum.debian.net>
In-Reply-To: <20080723190114.GE11009@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200807232128.32033.IvDoorn@gmail.com> (sfid-20080723_211122_784372_1C4D61A5)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 23 July 2008, Henrique de Moraes Holschuh wrote:
> On Wed, 23 Jul 2008, Ivo van Doorn wrote:
> > > --- a/net/rfkill/rfkill-input.c
> > > +++ b/net/rfkill/rfkill-input.c
> > > @@ -47,6 +47,8 @@ struct rfkill_task {
> > >  enum rfkill_global_sched_op {
> > >  	RFKILL_GLOBAL_OP_EPO = 0,
> > >  	RFKILL_GLOBAL_OP_RESTORE,
> > > +	RFKILL_GLOBAL_OP_UNLOCK,
> > > +	RFKILL_GLOBAL_OP_UNBLOCK,
> > >  };
> > 
> > As mentioned in the previous patch "rfkill: add master_switch_mode functionality"
> > the above 2 new enums aren't allowed because they are blocked in the module
> > init function.
> 
> Hmm? The GLOBAL_OP are internal stuff for the driver, and
> master_switch_mode=2 does work, I did test :)  I will reread the code and
> reply to you on the previous patch.

*sigh* forget my statement, I am mixing up
RFKILL_INPUT_MASTER_* and RFKILL_GLOBAL_OP_*

I'll grab some coffee to wake up. :)

> > >  static void rfkill_schedule_toggle(struct rfkill_task *task)
> > >  {
> > >  	unsigned long flags;
> > > @@ -169,30 +161,19 @@ static DEFINE_RFKILL_TASK(rfkill_wlan, RFKILL_TYPE_WLAN);
> > >  static DEFINE_RFKILL_TASK(rfkill_bt, RFKILL_TYPE_BLUETOOTH);
> > >  static DEFINE_RFKILL_TASK(rfkill_uwb, RFKILL_TYPE_UWB);
> > >  static DEFINE_RFKILL_TASK(rfkill_wimax, RFKILL_TYPE_WIMAX);
> > > -static DEFINE_RFKILL_TASK(rfkill_wwan, RFKILL_TYPE_WWAN);
> > 
> > Are all RFKILL_TYPE_WWAN users gone?
> > In that case the define should disappear completely.
> 
> No, we do have users of WWAN.  Thinkpad-acpi for one.  What we don't have is
> any specific KEY_WWAN or SW_WWAN event, so rfkill-input doesn't need to
> special case it like it does for the others.  And the new RFKILL_ALL/EPO
> code handles every switch type in a single for() loop, so I didn't need to
> special-case it anymore.
> 
> I didn't add a KEY_WWAN because I don't know exactly of anyone who needs it
> (thinkpads actually want a KEY_WIRELESS that is used to cycle through
> various states for WLAN, WWAN, BLUETOOTH and UWB, or to bring up a GUI or
> somesuch).
> 
> However, if you guys think it is best, we can certainly ask Dmitry for
> KEY_WWAN and add it to rfkill-input.  Anyone with a laptop with a
> UMTS/EDGE/GPRS radio might want to map one of his keys to that keycode and
> have rfkill-input handle it.

I don't think Dmitry will be very happy with new KEY_* defines, if I recall correctly
there aren't that many availble slots left.

> Unfortunately, we can't share KEY_WIMAX.  We could DROP KEY_WIMAX in favor
> of KEY_WWAN and have rfkill-input handle KEY_WWAN as both a WiMAX and WWAN
> event (WiMAX is actually an element of the WWAN set)...  but the proper fix
> for that is a bit more complicated (add superclasses/groups, make WWAN a
> superclass and add WIMAX inside it, make WLAN a superclass, create a WPAN
> superclass with bluetooth and UWB inside it) and I really don't feel like
> coding that one right now :(   rfkill-input really would benefit from that,
> user-interface wise, as we usually want to rfkill an entire set of devices
> regardless of their "technology".

Those superclasses and groups sound like a complete mess, (or perhaps not, but
just very complicated to get right). If nobody needs the KEY_WWAN lets keep it
out for now, and see later what to do about it.

We should promote userspace tools to control rfkill rather then rfkill-input anyway. ;)

Ivo
