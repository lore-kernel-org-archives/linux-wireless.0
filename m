Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:40141 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756150AbYGGUrO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 16:47:14 -0400
Date: Mon, 7 Jul 2008 17:47:08 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Dan Williams <dcbw@redhat.com>
Cc: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org
Subject: Re: Question on rfkill double block
Message-ID: <20080707204708.GA3166@khazad-dum.debian.net> (sfid-20080707_224717_625113_822810F3)
References: <1214982208.14590.473.camel@debian.sh.intel.com> <1215018189.29117.32.camel@localhost.localdomain> <20080704195543.GB27898@khazad-dum.debian.net> <1215450664.17128.64.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1215450664.17128.64.camel@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 07 Jul 2008, Dan Williams wrote:
> On Fri, 2008-07-04 at 16:55 -0300, Henrique de Moraes Holschuh wrote:
> > On Wed, 02 Jul 2008, Dan Williams wrote:
> > > That would be more useful than the current enum, yes.
> > 
> > Dan, you do have a strong user case for "just software rfkilled", "just
> > hardware rfkilled" and "soft+hard rfkilled" as opposed to simply "software
> > rfkilled" and "hardware rfkilled, maybe software rfkilled as well" ?
> 
> No, I don't have a _NetworkManager_ usecase for being able to
> distinguish between HW and HW+SW.  Just an observation that stuff other
> than NM might want to figure that out for UI or something.

Ok.  I will still *try* to implement the fourth state, but I will post the
patch as a RFC.  If it is too messy or complex, I will recommend that we
drop it.

> But if the HW block is on, NM doesn't care about softblock because you
> can't use the radio anyway.  If the HW switch is unblocked, NM will
> un-SW-block the radio anyway, since HW-unblock is definitely a
> user-initiated option and signals user intent to unblock the radio
> irregardless of SW block state from something else.

I intend to offer the *possibility* of using the HW switch like this on
rfkill-input: on block, block all (EPO).  On unblock, restore previous state
(so, e.g. if WLAN was enabled and bluetooth was disabled, after a HW switch
on/off/on cycle, you will not get bluetooth and WLAN enabled).  But that's
not ready yet, and I am not sure I will be able to do it cleanly.  If I
can't, I will drop it.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
