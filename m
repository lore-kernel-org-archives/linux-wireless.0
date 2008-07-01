Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:43158 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757651AbYGAOen (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Jul 2008 10:34:43 -0400
Date: Tue, 1 Jul 2008 11:34:39 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Michael Buesch <mb@bu3sch.de>
Cc: Adel Gadllah <adel.gadllah@gmail.com>,
	linux-wireless@vger.kernel.org, stefano.brivio@polimi.it,
	Larry Finger <larry.finger@lwfinger.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [PATCH/RFC] b43: remove input device usage for rfkill
Message-ID: <20080701143439.GA6962@khazad-dum.debian.net> (sfid-20080701_163519_434021_0B584900)
References: <6cf6b73e0807010255x1f2d8a21m8ed3e712012ea757@mail.gmail.com> <200807011227.15805.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200807011227.15805.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Ok, let's take it slow and one question/answer at a time, then.

First, I need to know some details about the B43 hardware, to help with
this.

1. It has an input pin that sometimes people connect buttons/switches
to.

Does that input pin act as an input for a FLIP-FLOP (and that flip-flop
output is the hardware rfkill line), or is it the hardware rfkill line
itself?

input for a flip-flop means it toggles the kill/unkill behaviour when
the input pin detects an edge (press/release of a button).

direct hardware rfkill line means you need a SWITCH in that pin, because
it directly sets the state.  If the pin is active, the hardware rfkill
line is active.  If the pin is inactive, the hardware rfkill line is
inactive.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
