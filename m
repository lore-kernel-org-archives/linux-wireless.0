Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41333 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753077AbYFXXR7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2008 19:17:59 -0400
Date: Tue, 24 Jun 2008 20:17:51 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Fabien Crespel <fabien@crespel.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 04/13] rfkill: add parameter to disable radios by
	default
Message-ID: <20080624231751.GA28975@khazad-dum.debian.net> (sfid-20080625_011803_669332_529827BF)
References: <1214252588-30723-1-git-send-email-hmh@hmh.eng.br> <1214252588-30723-5-git-send-email-hmh@hmh.eng.br> <g3quvb$8sa$1@ger.gmane.org> <g3r9hn$av5$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <g3r9hn$av5$1@ger.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 24 Jun 2008, Fabien Crespel wrote:
> Dmitry Baryshkov wrote:
>> Why not add the possibility for each rfkill-enabled radio to supply 
>> it's default state?
>
> Indeed, I think it would be better to let the driver choose the default 
> state (initialization) instead of forcing it when registering. This would 

For drivers dealing with input devices, it makes some sense.  Mind you,
there IS no API you can use for it right now that will work fine, and anyone
dreaming of doing it through rfkill-input will get an earful :-)

We need to add an API to export the global states in rfkill and rfkill
input, first.  platform drivers that are completely sure they know what
they're doing could then use that API to basically call rfkill_toggle_all.

HOWEVER:

1. It requires rfkill's default to be BLOCK.  Otherwise, you can have
   periods while the devices are blocked at system startup (firmware),
   then unblocked during boot (rfkill just loaded), then blocked again
   (platform driver loaded after rfkill).

   I don't see this as much of an issue, since we'd add this functionality
   along with the global state APIs (that need to also address userspace),
   so anyone who likes his radios to start UNBLOCKED would just need to do
   it in his userspace init scripts.

2. It has severe ordering problems if there is more than one driver wanting
   to do it.  It is not that it wouldn't work, but not only the radio might
   be on undesired states until the last driver loads, the end result would
   also depend on WHICH driver loaded last.  Yuck.

   So the functions would be made to lock down after one use.  You'd get one
   "set the initial state" per radio type, plus one for RFKILL_ALL.

3. It is only acceptable for drivers of input devices that issue rfkill
   events.

> allow drivers to restore the device state after a reboot or shutdown 
> (provided the firmware stores it, which is the case at least on my ASUS 
> F3JC laptop).

Sounds interesting.  But is this functionality worth the hassle of
implementing it?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
