Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:52032 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830AbZC0PI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 11:08:28 -0400
Date: Fri, 27 Mar 2009 12:08:24 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Matthew Garrett <mjg@redhat.com>
Subject: Re: rfkill get_state
Message-ID: <20090327150824.GC24288@khazad-dum.debian.net> (sfid-20090327_160831_167617_FE0152CF)
References: <1238161210.4452.8.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1238161210.4452.8.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 27 Mar 2009, Johannes Berg wrote:
> When you implement get_state but don't do force_state, how does
> get_state ever get called?
> 
> It seems to me it'll only get called 
>  * when you read sysfs
>  * on resume
>  * on epo

Yes.  It is mostly something that the rfkill core uses to get an up-to-date
state when it knows it needs one, and it is not good for anything else.

> How do we ever react to a button press then to make a uevent?

rfkill-related uevents exist to signal change in state of the rfkill
switches, REGARDLESS of the reason.  So they are NOT related to button
presses, except in-so-far that a button press might have changed a rfkill
switch state.

So, the short answer is: rfkill_force_state().  Call it when the radio
rfkill state changed, and the core will generate uevents.

The core doesn't have any helpers for this, so if you need polling, for
example, you do it in your driver and call rfkill_force_state() as needed.


Where does the button press enters the picture in your driver?  Knowing
that, I can illustrate how it would plug to rfkill core, or to the input
device core (I am yet to see a case where it should be plugged to both).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
