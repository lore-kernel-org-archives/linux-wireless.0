Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:59285 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752043AbYFXRIA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 13:08:00 -0400
Date: Tue, 24 Jun 2008 14:07:55 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dmitry Baryshkov <dbaryshkov@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 04/13] rfkill: add parameter to disable radios by
	default
Message-ID: <20080624170755.GA17576@khazad-dum.debian.net> (sfid-20080624_190805_765018_C9F78049)
References: <1214252588-30723-1-git-send-email-hmh@hmh.eng.br> <1214252588-30723-5-git-send-email-hmh@hmh.eng.br> <g3quvb$8sa$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <g3quvb$8sa$1@ger.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 24 Jun 2008, Dmitry Baryshkov wrote:
> Henrique de Moraes Holschuh wrote:
> > Currently, radios are always enabled when their rfkill interface is
> > registered.  This is not optimal, the safest state for a radio is to be
> > offline unless the user turns it on.
> > 
> > Add a module parameter that causes all radios to be disabled when their
> > rfkill interface is registered.  The module default is not changed so
> > unless the parameter is used, radios will still be forced to their
> > enabled state when they are registered.
> > 
> > The new rfkill module parameter is called "default_state".
> 
> Why not add the possibility for each rfkill-enabled radio to supply it's 
> default state?

The radios already can, and should, inform rfkill of their power-up state
(set rfkill->state before calling rfkill_register), but if it is different
from the global state, rfkill will try to adjust it to match the rest of the
system.

When you implement rfkill support on your wireless driver, you transfer all
policy decisions about rfkill state to the rfkill system.

That's how it is supposed to work.  If you have all radios blocked,
hotplugging a new one will cause it to be blocked by rfkill soon after it
registers itsef.  If you have bluetooth unblocked, when you hotplug a new
bluetooth radio, rfkill will unblock it when it registers itself.

If you mean you'd like to be able to use kernel parameters to set the
default state for each radio type separately, the first version of the patch
did just that, but it was vetoed and I was asked to use a single parameter.

This doesn't mean the system doesn't control the radios on a per-type basis,
it does.  It is just that you can only tell it to start with every radio
BLOCKED by default, or to start with every radio UNBLOCKED by default,
regardless of type.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
