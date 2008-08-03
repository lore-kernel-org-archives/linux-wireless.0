Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:55502 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754759AbYHCNoy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 09:44:54 -0400
Date: Sun, 3 Aug 2008 10:44:49 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 8/8] rfkill: add support for wake-on-wireless-packet
Message-ID: <20080803134449.GF12118@khazad-dum.debian.net> (sfid-20080803_154457_635785_A892275A)
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br> <1217703723.8621.50.camel@johannes.berg> <20080802192704.GB24253@khazad-dum.debian.net> <200808031012.06554.IvDoorn@gmail.com> <1ba2fa240808030107m64b1bc6dxc639665a2a7cc4af@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1ba2fa240808030107m64b1bc6dxc639665a2a7cc4af@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 03 Aug 2008, Tomas Winkler wrote:
> > I think that handler was added by Dmitry, but I see no real reason for
> > issuing the BLOCK event during suspend. However the handlers should
> > be used to prevent state changes to drivers after they have been suspended.
> 
> Sounds reasonable.

Added to TODO list to remove the toggle_radio() calls on the suspend path.

Note that rfkill will still call the toggle_radio() callback on the resume
path with whatever state the radio was before suspend, because we want the
state set by the user to be preserved across sleeps of any sort, and that's
not the wireless driver's business to ensure, but rather, rfkill's.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
