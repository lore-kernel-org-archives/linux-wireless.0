Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2590 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752099AbYF3RrL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jun 2008 13:47:11 -0400
Date: Mon, 30 Jun 2008 13:29:08 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Johan Adolfsson <Johan.Adolfsson@axis.com>,
	linux-wireless@vger.kernel.org, "'Dan Williams'" <dcbw@redhat.com>
Subject: Re: [PATCH] Add module parameter to override regioncode on libertas
Message-ID: <20080630172908.GA8391@tuxdriver.com> (sfid-20080630_194715_148742_6521F6D3)
References: <1214580776.10355.16.camel@localhost.localdomain> <054201c8da7b$b12677e0$0137550a@se.axis.com> <20080630140330.GB6864@tuxdriver.com> <20080630154425.GB22984@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080630154425.GB22984@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 30, 2008 at 12:44:26PM -0300, Henrique de Moraes Holschuh wrote:

> Now I get my trusty laptop with the EEPROM-based regdomain driver, and
> travel to somewhere where the channel overlap with the Americas regdomain
> the vendor used is such that the card can actually operate outside of the
> requirements for the local government.   If I am lucky, it just won't allow
> me to talk to everyone like what happens in Brazil.  If I am not, I could be
> breaking the law.
> 
> Where, in the entire scenario above, was the regulatory information in the
> EEPROM useful to me?  NEVER.  It was a hindrance in every step.

Hardware vendor representatives insist that regulaions should be
enforced as the product of both where you are (or claim to be) _and_
where the device was certified to operate when it was produced.  I have
no specific examples to cite of what might happen if e.g. a USA device
is operated on channel 13, but the hardware vendors insist that this
should not be allowed to happen.  "It works for me" anecdotes aside,
it seems like a bad idea to encourage (or fail to discourage) users
to override certified hardware regulatory settings.

If this is the only way to influence the regulatory enforcement
then your 2nd example is a valid.  But in that case moving to a
cfg80211-based regulatory enforcement seems like a better way to go.

John
-- 
John W. Linville
linville@tuxdriver.com
