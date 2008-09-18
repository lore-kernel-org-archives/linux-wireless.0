Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:50309 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755842AbYIRUNk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Sep 2008 16:13:40 -0400
Date: Thu, 18 Sep 2008 17:13:36 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Michael Buesch <mb@bu3sch.de>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John W Linville <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
Subject: Re: [RFC] b43: A patch for control of the radio LED using rfkill
Message-ID: <20080918201336.GS1583@khazad-dum.debian.net> (sfid-20080918_221343_373456_13FD3971)
References: <48d1e227.AmBwRnEuhx6kxlHv%Larry.Finger@lwfinger.net> <200809181931.49636.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200809181931.49636.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 18 Sep 2008, Michael Buesch wrote:
> Can rfkill_force_state recurse into b43_rfkill_soft_toggle()?

rfkill_force_state() will never call any of the rfkill struct hooks, ever.

So, unless you driver is hooked into the rfkill notifier chain (which is the
only possible way to recurse through the rfkill core when using
rfkill_force_state()), it will not recurse.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
