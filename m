Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57811 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752638AbYFERxs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Jun 2008 13:53:48 -0400
Message-Id: <1212688428.15820.1256966109@webmail.messagingengine.com> (sfid-20080605_195352_115350_DA4CBBFF)
From: "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>
To: "Ivo van Doorn" <ivdoorn@gmail.com>
Cc: "Tomas Winkler" <tomasw@gmail.com>,
	"Dan Williams" <dcbw@redhat.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, "Dmitry Torokhov" <dtor@mail.ru>
Content-Type: text/plain; charset="ISO-8859-1"
MIME-Version: 1.0
References: <1212549017-30144-1-git-send-email-hmh@hmh.eng.br>
   <1ba2fa240806041607j10841ac0qb11fe0d0b27953d8@mail.gmail.com>
   <20080605003808.GA16599@khazad-dum.debian.net>
   <200806051803.43193.IvDoorn@gmail.com>
Subject: Re: [PATCH 01/12] rfkill: clarify meaning of rfkill states
In-Reply-To: <200806051803.43193.IvDoorn@gmail.com>
Date: Thu, 05 Jun 2008 14:53:48 -0300
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 5 Jun 2008 18:03:42 +0200, "Ivo van Doorn" <ivdoorn@gmail.com> said:
> On Thursday 05 June 2008, Henrique de Moraes Holschuh wrote:
> > The correct reading of rfkill class states are:
> > 
> > RFKILL_STATE_ON:  transmitter is UNBLOCKED and *may* operate
> > RFKILL_STATE_OFF: transmitter is BLOCKED and will *NOT* operate.
> > 
> > Nothing else is correct.
> > 
> > We could certainly rename these states to
> > 
> > enum rfkill_state {
> > 	RFKILL_STATE_BLOCKED = 0,
> > 	RFKILL_STATE_UNBLOCKED = 1,
> > };
> > 
> > #define RFKILL_STATE_ON RFKILL_STATE_UNBLOCKED
> > #define RFKILL_STATE_OFF RFKILL_STATE_BLOCKED
> > 
> > Ivo, do you want a patch that does the above (plus the documentation
> > changes, of course)?
> 
> Patch would be good. I would however drop the #define RFKILL_STATE_ON
> and force the RFKILL_STATE_BLOCKED/RFKILL_STATE_UNBLOCKED usage
> to make sure everybody gets the right idea about the meaning.

The advantage of the former way is that we break nothing, and all drivers
can be moved to the new names at their maintainer's leisure.  It could also
work as a marker for "this driver has been reviewed and now uses rfkill
correctly" or somesuch.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh

