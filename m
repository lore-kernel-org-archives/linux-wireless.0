Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from blaine.gmane.org ([80.91.229.8]:55434 "EHLO hugh.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756283AbYFWSKp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 14:10:45 -0400
Received: from public by hugh.gmane.org with local (Exim 4.63)
	(envelope-from <public@hugh.gmane.org>)
	id 1KAqUv-0002V0-QC
	for linux-wireless@vger.kernel.org; Mon, 23 Jun 2008 20:10:37 +0200
Date: Mon, 23 Jun 2008 15:10:09 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Fabien Crespel <fabien@crespel.net>,
	John Linville
	<public-linville-2XuSBdqkA4R54TAoqtyWWQ@hugh.gmane.org>,
	public-linux-wireless-u79uwXL29TY76Z2rM5mHXA@hugh.gmane.org,
	Ivo van Doorn
	<public-ivdoorn-Re5JQEeQqe8AvxtiuMwx3w@hugh.gmane.org>,
	Matthew Garrett
	<public-mjg-H+wXaHxf7aLQT0dZR+AlfA@hugh.gmane.org>,
	Dan Williams <public-dcbw-H+wXaHxf7aLQT0dZR+AlfA@hugh.gmane.org>,
	Thomas Renninger <public-trenn-l3A5Bk7waGM@hugh.gmane.org>,
	Dmitry Torokhov <public-dtor-JGs/UdohzUI@hugh.gmane.org>
Subject: Re: [PATCH 11/12] rfkill: do not allow userspace to override ALL
	RADIOS OFF
Message-ID: <20080623181009.GC22039@khazad-dum.debian.net> (sfid-20080623_201059_880744_1D6BB91E)
References: <1214149128-5913-1-git-send-email-hmh@hmh.eng.br> <1214149128-5913-12-git-send-email-hmh@hmh.eng.br> <485EAA82.30808@crespel.net> <20080623052206.GE9926@khazad-dum.debian.net> <20080623095053.ZZRA012@mailhub.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080623095053.ZZRA012@mailhub.coreip.homeip.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On Mon, 23 Jun 2008, Dmitry Torokhov wrote:
> On Mon, Jun 23, 2008 at 02:22:07AM -0300, Henrique de Moraes Holschuh wrote:
> > On Sun, 22 Jun 2008, Fabien Crespel wrote:
> > > rfkill_epo() doesn't change the current_state of the tasks, and the 
> > > various calls to rfkill_schedule_set(..., RFKILL_STATE_ON) don't work if 
> > > the last current_state stored was already RFKILL_STATE_ON.
> > >
> > > Anyway, the whole current_state thing seems completely useless and a 
> > > source of problems in rfkill-input, since state comparison is already 
> > > done in rfkill, and rfkill-input is more than likely to become out of 
> > > sync with the real state.
> 
> Real state of what? The state of rfkill-input represents desired
> (target) state of a group of RF switches of certain type (all WIFI or
> all Bluetooth, etc) and may indeed be different from the state of
> individual transmitter.

Indeed.  rfkill-input takes care of what I call "global state (per rfkill
type)".  We don't export that to userspace yet, the only way to interact
with them is through input events right now.  This will change, eventually.

That said, there is no need to try to avoid extra calls to
rfkill_switch_all, which AFAIK is all current_state is good for.

I tested Fabien's patch here, and it does seem to work well.  I added some
guards to EPO so that it just ignores any attempts to queue
rfkill_switch_all calls while a rfkill_epo call is queued, as well.

> > > Therefore I propose this additional patch to remove current_state 
> > > completely from rfkill-input.
> > 
> > I would like to get rid of it, but I need some sleep before I can think
> > clearly about this issue.
> 
> I think the best solution for now would be to add 'force' argument to
> rfkill_switch_all that would override rfkill->user_claim.

No, rfkill-input is not to override rfkill->user_claim except for EPO.  Even
if we added a force parameter to rfkill_switch_all, rfkill-input wouldn't be
able to use it (except in the EPO path, that has a better helper to use
anyway: rfkill_epo()).

I fixed the whole EPO issue already, btw.  I tried with Fabien's patch, and
on top of it I applied a modified version of the EPO patch that calls
rfkill_epo through the generic work queue and ignores other attempts to
queue rfkill_switch_all while rfkill_epo hasn't run yet (on the grounds that
rfkill_epo would override them anyway, and that when in doubt of what should
be happening because we got a bunch of confusing events all piled up, we
want EPO to win).

I am just waiting for Fabien's signed-off-by line, so that I can push v3 of
the patchset with the bug fixes.

I am also looking at a way to make rfkill-input restore the previous global
states when it receives an SW_RFKILL_ALL ON sometime after an EPO.  That's
how I'd prefer it to act (so I will make it selectable, and you guys tell me
what the default should be).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

