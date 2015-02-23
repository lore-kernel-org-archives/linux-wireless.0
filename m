Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60014 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974AbbBWLtT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Feb 2015 06:49:19 -0500
Message-ID: <1424692155.2782.6.camel@sipsolutions.net> (sfid-20150223_124924_625488_AF90D244)
Subject: Re: [RFC] mac80211_hwsim: notify user-space about channel change.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com
Cc: linux-wireless@vger.kernel.org
Date: Mon, 23 Feb 2015 12:49:15 +0100
In-Reply-To: <1424217588-29558-1-git-send-email-greearb@candelatech.com> (sfid-20150218_005956_617537_D2A9B91F)
References: <1424217588-29558-1-git-send-email-greearb@candelatech.com>
	 (sfid-20150218_005956_617537_D2A9B91F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-02-17 at 15:59 -0800, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> The goal is to allow the user-space application to properly
> filter packets before sending them down to the kernel.  This
> should more closely mimic what a real piece of hardware would
> do.

> + * @HWSIM_CMD_NOTIFY: notify user-space about driver changes.  This is
> + * designed to help the user-space app better emulate radio hardware.
> + * This command uses:
> + *      %HWSIM_ATTR_FREQ # Notify current operating center frequency.
> + *      %HWSIM_ATTR_ADDR_TRANSMITTER # ID which radio we are notifying about.
>   * @__HWSIM_CMD_MAX: enum limit

This seems a bit strange - don't we already tag packets with the
frequency? Why would you need the channel change separately? What does
that even mean? Depending on how you use this it could entirely break
off-channel operation, for example.

johannes

