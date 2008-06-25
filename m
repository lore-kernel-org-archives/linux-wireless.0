Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:53927 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756249AbYFYOCd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 10:02:33 -0400
Date: Wed, 25 Jun 2008 11:02:28 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Fabien Crespel <fabien@crespel.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 04/13] rfkill: add parameter to disable radios by
	default
Message-ID: <20080625140228.GA20618@khazad-dum.debian.net> (sfid-20080625_160237_419064_EBC62CF2)
References: <1214252588-30723-1-git-send-email-hmh@hmh.eng.br> <1214252588-30723-5-git-send-email-hmh@hmh.eng.br> <g3quvb$8sa$1@ger.gmane.org> <g3r9hn$av5$1@ger.gmane.org> <20080624231751.GA28975@khazad-dum.debian.net> <4861FDCA.1040505@crespel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4861FDCA.1040505@crespel.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Fabien!

On Wed, 25 Jun 2008, Fabien Crespel wrote:

> Henrique de Moraes Holschuh wrote:
>> Sounds interesting.  But is this functionality worth the hassle of
>> implementing it?
>
> For the end user, I think it's better to have the device state restored  
> at boot time if it's possible. Even though it can be tricky to  
> implement, as you outlined.

It is tricky alright.  Talking to an user that likes "everything on" at boot
(something I wouldn't be caught dead doing, but hey, to each his own and all
that...), I found another one...

* In order to not lose the possibility of giving rfkill a default of
UNBLOCK, we could accept the kernel parameter as an override of sorts.  if
it is there, we block the "first state" API calls and use the value of the
parameter.   It wouldn't be that much of an extra mile to go, IMHO, if one
is already doing the rest of the work.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
