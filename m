Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:41592 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605AbaDXUsR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Apr 2014 16:48:17 -0400
Date: Fri, 25 Apr 2014 06:48:01 +1000
From: James Cameron <quozl@laptop.org>
To: John Tobias <john.tobias.ph@gmail.com>
Cc: Bing Zhao <bzhao@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>,
	Xinming Hu <huxm@marvell.com>, Chris Ball <cjb@laptop.org>
Subject: Re: [PATCH 2/2] mwifiex: don't clear cmd_sent flag in timeout handler
Message-ID: <20140424204801.GA12124@us.netrek.org> (sfid-20140424_224824_559154_FCEF23DA)
References: <1397710914-10061-1-git-send-email-bzhao@marvell.com>
 <1397710914-10061-2-git-send-email-bzhao@marvell.com>
 <CACUGKYMWqr2-YAXhPzo8GfPPYBd2xoD_zf56FzqpkzN=X80X8A@mail.gmail.com>
 <477F20668A386D41ADCC57781B1F70430F70686650@SC-VEXCH1.marvell.com>
 <20140418044619.GF24166@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F706868D4@SC-VEXCH1.marvell.com>
 <20140419003410.GB14606@us.netrek.org>
 <20140424061137.GN1947@us.netrek.org>
 <477F20668A386D41ADCC57781B1F70430F70A2AB63@SC-VEXCH1.marvell.com>
 <CACUGKYMGVZyRHv7m90+3VJ3dAb6n0jvi=XHUYLUQh+1UAJgNQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACUGKYMGVZyRHv7m90+3VJ3dAb6n0jvi=XHUYLUQh+1UAJgNQA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 24, 2014 at 09:45:37AM -0700, John Tobias wrote:
> How did you know that by downgrading the firmware the problem has
> been solved?. Did you see a scenario or flow in the driver that both
> occurred when using the two different firmware but able to work on
> the p80?.

I knew it had been solved because the problem stopped happening,
whereas before it would always happen.

No, there was nothing in the driver changed, and nothing I could see
in the driver had any effect on the problem.

> The reason why I am asking is because sometimes the bug/s did not
> occur often.

We are probably facing different problems.  For the problem I am
working, it always happens, all I have to do is boot 14 or more
laptops.  The sequence is:

- the automatic starting or joining of an ad-hoc network, by the Sugar
  learning software,

- a stream of 13 adhoc station connect events from the card, one for
  each station in the network,

- at about the point that the 14th beacon is seen on RF, the card
  firmware hangs,

- a command is sent by the host (e.g. to get RSSI to update the
  display),

- no interrupt occurs, and so the mwifiex driver reports a command
  timeout.

http://dev.laptop.org/ticket/12763 has some of the details.

I have an instrumented kernel that reports the adhoc station connect
and disconnect events, and counts the number of stations that the card
knows about.

There's some sort of timer used by the card to issue the adhoc station
disconnect event; when no beacons from the station have been heard for
a few seconds.  So increasing the beacon interval to 10000 TU also
avoided the problem.

I doubt your problem is caused by firmware, but you could test for it.

-- 
James Cameron
http://quozl.linux.org.au/
