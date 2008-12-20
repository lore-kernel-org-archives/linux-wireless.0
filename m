Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:60109 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752580AbYLTUPs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Dec 2008 15:15:48 -0500
Date: Sat, 20 Dec 2008 18:15:41 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Werner Almesberger <werner@openmoko.org>
Cc: linux-wireless@vger.kernel.org
Subject: Re: AR6k: to rfkill or not to rfkill ?
Message-ID: <20081220201541.GD25001@khazad-dum.debian.net> (sfid-20081220_211553_689184_4F0B2BDA)
References: <20081218212234.GI5019@almesberger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20081218212234.GI5019@almesberger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 18 Dec 2008, Werner Almesberger wrote:
> In Openmoko, we're wondering whether we should make the Atheros AR6k
> driver register as an rfkill controller or not, and if we do it,
> what semantics this should have. I'm looking for advice here.

There is one screening rule that does help:

Is that a way you can program the device that *ENSURES* without any doubt,
that it will never emit energy off the transmitter?

If the answer is no, you are not to add an rfkill controller. It is that
simple (at least with the current rfkill core).

If the answer is yes, then you can consider adding an rfkill controller.

> If the answer is "yes", would the following semantics be right for
> the disabled state ?
> 
> - we de-associate
> - we stop scanning
> - all ioctls still work as usual, but they have no effect on
>   association and scanning until rfkill re-enables the device

If your rfkill controller has been set to "block the radio", you must NOT
allow any energy to be emmited by the transmitter.  This is all that
matters.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
