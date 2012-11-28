Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44422 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754577Ab2K1Qmj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Nov 2012 11:42:39 -0500
Message-ID: <1354120982.9345.35.camel@jlt4.sipsolutions.net> (sfid-20121128_174246_886056_FD8C7512)
Subject: Re: iwlwifi hibernate / suspend issue
From: Johannes Berg <johannes@sipsolutions.net>
To: Jens Kapitza <j.kapitza@schwarze-allianz.de>
Cc: linux-wireless@vger.kernel.org, emmanuel.grumbach@intel.com
Date: Wed, 28 Nov 2012 17:43:02 +0100
In-Reply-To: <50B62BEB.6020109@schwarze-allianz.de>
References: <50B61C71.6060007@schwarze-allianz.de>
	 (sfid-20121128_152227_935873_AFE02FFF) <1354113010.9345.27.camel@jlt4.sipsolutions.net>
	 <50B62254.9070700@schwarze-allianz.de>
	 <1354113722.9345.28.camel@jlt4.sipsolutions.net>
	 <50B62BEB.6020109@schwarze-allianz.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2012-11-28 at 16:21 +0100, Jens Kapitza wrote:
> > just enter "dmesg" and pastebin the result somewhere

> this line seems to be wrong
> 
>   [ 4650.687346] iwlwifi 0000:02:00.0: RF_KILL bit toggled to disable radio.

Well, it's not necessarily wrong, it indicates that the device read that
the rfkill line was pulled low ("rf should be off").

You said reloading the module fixes this, which is interesting since the
device should be sending interrupts whenever the state changes, so even
if it was reading the wrong state at resume time (as it does now) it
should catch up later...

johannes

