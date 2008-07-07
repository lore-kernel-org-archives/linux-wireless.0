Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:44758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753863AbYGGRM1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 13:12:27 -0400
Subject: Re: Question on rfkill double block
From: Dan Williams <dcbw@redhat.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Zhu Yi <yi.zhu@intel.com>, linux-wireless@vger.kernel.org
In-Reply-To: <20080704195543.GB27898@khazad-dum.debian.net>
References: <1214982208.14590.473.camel@debian.sh.intel.com>
	 <1215018189.29117.32.camel@localhost.localdomain>
	 <20080704195543.GB27898@khazad-dum.debian.net>
Content-Type: text/plain
Date: Mon, 07 Jul 2008 13:11:04 -0400
Message-Id: <1215450664.17128.64.camel@localhost.localdomain> (sfid-20080707_191250_636027_FEACEE2D)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-07-04 at 16:55 -0300, Henrique de Moraes Holschuh wrote:
> On Wed, 02 Jul 2008, Dan Williams wrote:
> > That would be more useful than the current enum, yes.
> 
> Dan, you do have a strong user case for "just software rfkilled", "just
> hardware rfkilled" and "soft+hard rfkilled" as opposed to simply "software
> rfkilled" and "hardware rfkilled, maybe software rfkilled as well" ?

No, I don't have a _NetworkManager_ usecase for being able to
distinguish between HW and HW+SW.  Just an observation that stuff other
than NM might want to figure that out for UI or something.

But if the HW block is on, NM doesn't care about softblock because you
can't use the radio anyway.  If the HW switch is unblocked, NM will
un-SW-block the radio anyway, since HW-unblock is definitely a
user-initiated option and signals user intent to unblock the radio
irregardless of SW block state from something else.

Dan

