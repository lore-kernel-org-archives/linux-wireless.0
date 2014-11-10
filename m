Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51618 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752359AbaKJKjY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Nov 2014 05:39:24 -0500
Message-ID: <1415615960.1847.11.camel@sipsolutions.net> (sfid-20141110_113927_656093_D64FF98C)
Subject: Re: Thinkpad X60s/200s: Intel 3945/5100 works with kernel
 2.6.32-67/3.0.0-32 but not 3.7 vanilla.
From: Johannes Berg <johannes@sipsolutions.net>
To: Uwe Brauer <oub@mat.ucm.es>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>
Date: Mon, 10 Nov 2014 11:39:20 +0100
In-Reply-To: <87egtbxs8t.fsf@mat.ucm.es> (sfid-20141110_113043_489571_43C3C8D9)
References: <87d28zdplq.fsf@mat.ucm.es>
	 <CANUX_P0f0WAHoq3CsC3V-jp4m3_Q7qLz7X+Mvn1hk9_JPrPTGg@mail.gmail.com>
	 <87egtbxs8t.fsf@mat.ucm.es> (sfid-20141110_113043_489571_43C3C8D9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2014-11-10 at 11:30 +0100, Uwe Brauer wrote:
>    > On Fri, Nov 7, 2014 at 4:58 PM, Uwe Brauer <oub@mat.ucm.es> wrote:
> 
>    > you problem is that you didn't compile the kernel with wireless
>    > extensions. This interface is deprecated, but I don't remember if it
>    > was the case for 3.7.
>    > In any case, this is a problem in your config, not a driver issue.
> 
> What make you say that?
> My config file concerning wireless options is:
> 
> CONFIG_WIRELESS=y
> CONFIG_WIRELESS_EXT=y
> CONFIG_IPWIRELESS=m

You'd need CONFIG_CFG80211_WEXT (or so) as well, but realistically you
should stop using wireless extensions and use nl80211 (via the "iw"
tool) instead.

johannes

