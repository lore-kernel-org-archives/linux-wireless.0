Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:3649 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753459AbXKFQmV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Nov 2007 11:42:21 -0500
Date: Tue, 6 Nov 2007 11:41:48 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Claudio Matsuoka <claudio@mandriva.com>
Cc: linux-wireless@vger.kernel.org, flamingice@souremilk.net,
	dsd@gentoo.org, kune@deine-taler.de
Subject: Re: RTL8187 rate control problems
Message-ID: <20071106164148.GB4440@tuxdriver.com> (sfid-20071106_164225_595214_E51E595E)
References: <200711061323.16302.claudio@mandriva.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <200711061323.16302.claudio@mandriva.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 06, 2007 at 01:23:16PM -0200, Claudio Matsuoka wrote:

> I've been reported a problem with RTL8187 working only at very close ranges 
> (4-5m) in Linux while the same hardware works at much higher distances in 
> Windows. Investigating the problem, I found that it's caused by the mac80211 
> rate control incrementing the bit rate to 54M and never going down because 
> the fail counter stays at zero. What would be a good way to check 
> transmission retries or failures in the RTL8187 to prevent this problem? Is 
> it possible to have a retry count sent to the tx callback so 
> status->retry_count could be set accordingly?   

I think you are right -- it looks like rtl8187 never sets
excessive_retries for transmit status.  I don't see anything obvious
in the specs that would give us an actual indication of that either,
which probably explains why it is missing.

The zd1211rw(-mac80211) driver(s) have a mechanism for matching-up
received ACKs with transmitted frames so that they can synthesize the
required excessive_retries data.  Probably rtl8186 needs something
similar.  Maybe this would even be worth generalizing?

John
-- 
John W. Linville
linville@tuxdriver.com
