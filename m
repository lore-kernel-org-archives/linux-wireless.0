Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43100 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753604Ab3BRPUJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 10:20:09 -0500
Message-ID: <1361200801.8555.29.camel@jlt4.sipsolutions.net> (sfid-20130218_162014_601375_F4347BE7)
Subject: Re: [PATCH 1/3] mac80211: move mesh sync beacon handler into
 neighbour_update
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco@cozybit.com>
Cc: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org
Date: Mon, 18 Feb 2013 16:20:01 +0100
In-Reply-To: <512243AB.6000801@cozybit.com> (sfid-20130218_160727_852714_70BEB0A2)
References: <1360928446-543-1-git-send-email-marco@cozybit.com>
	   	 (sfid-20130215_124056_325990_55BC105E) <1360930499.15040.7.camel@jlt4.sipsolutions.net>
	    <3fance.mi9hwg.2rw1te-qmf@mx.google.com>
	    (sfid-20130215_134116_713607_1FD8E99F) <1360932381.15040.11.camel@jlt4.sipsolutions.net>
	   <511E38B2.40900@cozybit.com>
	  (sfid-20130215_143133_867871_FDF7438A) <1360935431.15040.14.camel@jlt4.sipsolutions.net>
	  <511E3CB7.4040207@cozybit.com>
	 (sfid-20130215_144844_328347_5B0B2D91) <1360936708.15040.18.camel@jlt4.sipsolutions.net>
	 <512243AB.6000801@cozybit.com> (sfid-20130218_160727_852714_70BEB0A2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-02-18 at 16:07 +0100, Marco Porsch wrote:

> > I guess you can tell I'm not in a good mood today. I think any use of
> > get_tsf() for operation is a complete waste of time, there's no way you
> > can get the timings correct. You could be preempted, and suddenly sleep
> > for a few tens or hundreds milliseconds, so none of this makes any
> > sense... To properly do it you have to do calculations in relative times
> > and let the device apply them.
> 
> I don't get your last sentence here. Maybe you can elaborate?

I'm saying what could happens is this:

 tsf = drv_get_tsf()
 [be preempted, 100ms later]
 do_something_with(tsf)

so I think using drv_get_tsf() is pretty much always wrong.


> Concerning timestamp vs. TSF usage; wow - I tested it when using the 
> timestamp value for TBTT scheduling. Works fine. Works even better than 
> TSF as it slightly reduces the measured wakeup overhead.
> 
> Hm, I was sure the TSF as in *now* would be more appropriate than the 
> TSF at receipt time... But either way, if it works better and is less 
> ugly, it is a win-win =)
> 
> I'll send an updated patch with the more intuitive API.

:)

johannes

