Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:59153 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751405AbYFWFON (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Jun 2008 01:14:13 -0400
Date: Mon, 23 Jun 2008 02:14:08 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>,
	Matthew Garrett <mjg@redhat.com>,
	Dan Williams <dcbw@redhat.com>,
	Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH 11/12] rfkill: do not allow userspace to override ALL
	RADIOS OFF
Message-ID: <20080623051408.GC9926@khazad-dum.debian.net> (sfid-20080623_071415_549395_C70354C9)
References: <1214149128-5913-1-git-send-email-hmh@hmh.eng.br> <1214149128-5913-12-git-send-email-hmh@hmh.eng.br> <20080623021714.GB24992@anvil.corenet.prv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080623021714.GB24992@anvil.corenet.prv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 22 Jun 2008, Dmitry Torokhov wrote:
> On Sun, Jun 22, 2008 at 12:38:47PM -0300, Henrique de Moraes Holschuh wrote:
> > SW_RFKILL_ALL is the "emergency power-off all radios" input event.  It must
> > be handled, and must always do the same thing as far as the rfkill system
> > is concerned: all transmitters are to go *immediately* offline.
> > 
> > For safety, do NOT allow userspace to override EV_SW SW_RFKILL_ALL OFF.  As
> > long as rfkill-input is loaded, that event will *always* be processed, and
> > it will *always* force all rfkill switches to disable all wireless
> > transmitters, regardless of user_claim attribute or anything else.
> > 
> > Signed-off-by: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
> > Acked-by: Ivo van Doorn <IvDoorn@gmail.com>
> > Cc: Dmitry Torokhov <dtor@mail.ru>
> 
> rfkill_event() is called with handle->dev.event_lock spinlock held and
> therefore can not sleep. rfkill_epo() takes rfkill mutex and may sleep
> so it can't be used in the interrupt context. That is the reason why
> we had tasks for switching rf switches in the first place.

Will fix to schedule an immediate call to _epo in task context, that
should fix the locking issue.  Thanks for noticing that one!

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
