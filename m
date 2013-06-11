Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:37297 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755014Ab3FKLdB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Jun 2013 07:33:01 -0400
Message-ID: <1370950378.8356.13.camel@jlt4.sipsolutions.net> (sfid-20130611_133319_481355_B34C88E3)
Subject: Re: [PATCH v2 2/2] cfg80211/nl80211: Add packet coalesce support
From: Johannes Berg <johannes@sipsolutions.net>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Luciano Coelho <coelho@ti.com>
Date: Tue, 11 Jun 2013 13:32:58 +0200
In-Reply-To: <5FF020A1CFFEEC49BD1E09530C4FF5950F313C2CB5@SC-VEXCH1.marvell.com>
References: <5FF020A1CFFEEC49BD1E09530C4FF5950F313C2CB5@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2013-06-03 at 09:47 -0700, Amitkumar Karwar wrote:

> "iw coalesce add" was used, because command for adding multiple rules
> at the same time will be a bit lengthy(user will need to enter
> multiple lists of packet patterns) and syntax check in iw will also
> need some efforts. 

I think that this is so much unlike all other nl80211 settings where
they're either refused or replace previous ones entirely that I would
rather not have it. Take connecting for instance, wext allowed you to
set all parameters one by one, etc. This is a bit similar. Also, this
disallows doing checks on the entire configuration easily.

Personally, I see iw as a bit of a test tool so I'm not too concerned
about its sometimes odd command line, but I know giving it lots of
things can be awkward. For TCP wakeup, I've made it parse a small file,
maybe that's an option here as well?

> > Otherwise you're going to have very awkward races and need
> > to always clear etc. The code would also be easier, though obviously
> > you'd need to be able to specify multiple rules at the same time.
> 
> For "iw coalesce set" also user needs to always clear the settings
> using "iw coalesce disable". Also similar to "coalesce set", for
> "coalesce add" we clear the settings and free allocations while
> unloading the driver.
> 
> Please let us know if you prefer "coalesce set" over "coalesce add".

I would much prefer just having set/clear over piecewise configuration.

johannes

