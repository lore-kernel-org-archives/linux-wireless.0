Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:40204 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753301AbXDUWQv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Apr 2007 18:16:51 -0400
Subject: Re: [PATCH] ieee80211: Output frequency rather than channel in  scan results
From: Dan Williams <dcbw@redhat.com>
To: Pavel Roskin <proski@gnu.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	John Linville <linville@tuxdriver.com>,
	Bcm43xx-dev@lists.berlios.de, linux-wireless@vger.kernel.org
In-Reply-To: <20070421001253.q449myskosg0sg8k@webmail.spamcop.net>
References: <46298e00.m7oDqYNvDCFdCSj1%Larry.Finger@lwfinger.net>
	 <20070421001253.q449myskosg0sg8k@webmail.spamcop.net>
Content-Type: text/plain
Date: Sat, 21 Apr 2007 18:19:57 -0400
Message-Id: <1177193997.19554.1.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-04-21 at 00:12 -0400, Pavel Roskin wrote:
> Quoting Larry Finger <Larry.Finger@lwfinger.net>:
> 
> > In ieee80211, the output of scan results lists channels rather than
> > frequencies; however, NetworkManager needs frequency. This patch
> > changes the output from channel to frequency.
> 
> The driver can report both, and I think it should.  This would make the iwlist
> output a bit longer, but kernel drivers shouldn't be written to make userspace
> program generate pretty output.

I'm trying to remember why NM cares about frequency, and I think it's
for ad-hoc mode; but wpa_supplicant didn't historically support a
"channel" configuration parameter and so you can't create adhoc networks
with NM right now anyway...  What's the failure mode?

Dan

> --
> Regards,
> Pavel Roskin
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

