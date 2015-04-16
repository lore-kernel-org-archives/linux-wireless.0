Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:44255 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757045AbbDPKTe (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Apr 2015 06:19:34 -0400
Date: Thu, 16 Apr 2015 20:19:13 +1000
From: James Cameron <quozl@laptop.org>
To: Florian Achleitner <flo@fopen.at>
Cc: linux-wireless@vger.kernel.org,
	Amitkumar Karwar <akarwar@marvell.com>,
	Avinash Patil <patila@marvell.com>,
	Maithili Hinge <maithili@marvell.com>
Subject: Re: [RFC/PATCH] mwifiex: Driver - Firmware Glitches
Message-ID: <20150416101913.GA26748@us.netrek.org> (sfid-20150416_121937_499565_5B447C24)
References: <3169170.GKjfvNuGRf@r90b40zn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <3169170.GKjfvNuGRf@r90b40zn>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Apr 16, 2015 at 11:10:02AM +0200, Florian Achleitner wrote:
> Is the necessity of frequent hardware resets a commonly known issue
> with this chip/firmware? Anybody else experiencing these?

Yes, but how frequent?

> Currently, we see three different scenarios. One of them is
> currently not answered by reset. Refer to the upcoming patch.
> 
> (1)  mwifiex_cmd_timeout_func: Timeout cmd .. Ok, after reset.

See this a lot during heavy testing.

> (2)  Firmware wakeup failed.. Ok, after reset.

Never see this.

> (3) DNLD_CMD: host to card failed. No reset triggered. See patch.

Very rarely see this.

However, our experience may not be comparable; we are using 8787 with
a 3.5 kernel, because we haven't the resources to use a later kernel
or get backports working.

Also, we use WOL (wake on lan) heavily; frequent automatic suspends,
with a GPIO wakeup in addition to the SDHCI.

-- 
James Cameron
http://quozl.linux.org.au/
