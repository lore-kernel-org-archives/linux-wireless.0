Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44487 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756132AbbIUM1y (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 08:27:54 -0400
Message-ID: <1442838469.1876.1.camel@sipsolutions.net> (sfid-20150921_142757_616898_6F8AA169)
Subject: Re: [PATCH] nl80211:  Print reasons for errors in setting bitrates.
From: Johannes Berg <johannes@sipsolutions.net>
To: greearb@candelatech.com, linux-wireless@vger.kernel.org
Date: Mon, 21 Sep 2015 14:27:49 +0200
In-Reply-To: <1442610135-8696-1-git-send-email-greearb@candelatech.com>
References: <1442610135-8696-1-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2015-09-18 at 14:02 -0700, greearb@candelatech.com wrote:
> From: Ben Greear <greearb@candelatech.com>
> 
> Makes it easier to figure out why user-space calls are
> failing.

I'm aware of this problem, but I'm not going to gratuitously start
printing to dmesg for this.

There's a scheme being discussed for extended error numbers/messages,
particularly for perf but it might be implemented for any syscall. We
might be able to extend that to netlink in a different way, including
the description in the (extended) netlink ack message.

johannes
