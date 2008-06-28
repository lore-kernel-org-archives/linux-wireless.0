Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:51861 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755946AbYF1N5a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Jun 2008 09:57:30 -0400
Date: Sat, 28 Jun 2008 10:57:25 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: drago01 <drago01@gmail.com>
Cc: Linux Wireless <linux-wireless@vger.kernel.org>,
	"Zhu, Yi" <yi.zhu@intel.com>, Dan Williams <dcbw@redhat.com>,
	Tomas Winkler <tomas.winkler@intel.com>,
	Ivo van Doorn <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCHv2] iwlwifi: add support for RFKILL_STATE_HARD_BLOCKED
Message-ID: <20080628135725.GC871@khazad-dum.debian.net> (sfid-20080628_155820_391165_53662CFB)
References: <f6ca9fed0806280042o21101cb1v56f6ea5f7adbe331@mail.gmail.com> <20080628131439.GA871@khazad-dum.debian.net> <f6ca9fed0806280640y2a5faed3ne885382afd610a62@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <f6ca9fed0806280640y2a5faed3ne885382afd610a62@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 28 Jun 2008, drago01 wrote:
> On Sat, Jun 28, 2008 at 3:14 PM, Henrique de Moraes Holschuh
> <hmh@hmh.eng.br> wrote:
> > On Sat, 28 Jun 2008, drago01 wrote:
> >> This patch fixes the rfkill states to set RFKILL_STATE_HARD_BLOCKED when the
> >> radio is disabled by a hardware killswitch.
> >> It does not allow setting the sw state while the device is blocked by
> >> a hardware rfkill switch.
> >
> > It should.  In fact, you should do it in a way that it is possible to
> > double-block the radio (i.e. in SW while it is blocked in HW), so that if
> > the HW block goes away, the radio remains blocked.
> >
> > Read the docs and examples again, please.  There even is special code in the
> > rfkill_toggle_radio private function to allow for it, we want drivers to be
> > able to double-block.
> 
> OK, v2 attached it allows double-block.

Looks good at first glance (I just looked over the patch, I have never
looked at the iwlwifi code, though.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
