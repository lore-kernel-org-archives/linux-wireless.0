Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:40528 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779AbZCKTlg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Mar 2009 15:41:36 -0400
Message-ID: <49B813E9.8050108@lwfinger.net> (sfid-20090311_204143_512517_BE5C44E9)
Date: Wed, 11 Mar 2009 14:41:29 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "P.G. Richardson" <p.g.richardson@phantomjinx.co.uk>
CC: linux-wireless@vger.kernel.org
Subject: Re: rtl8187 - nice work!
References: <50533.82.152.175.172.1236798263.squirrel@www.phantomjinx.co.uk>
In-Reply-To: <50533.82.152.175.172.1236798263.squirrel@www.phantomjinx.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

P.G. Richardson wrote:
> Hi,
> 
> Installed the compat-wireless-2009-03-10 and the speed has greatly
> improved. Thanks very much.
> 
> I do have some observations that might be a bug or just configuration.
> 
> When powering up, the wireless decided on 54M as its bit rate.
> Consequently, tcp was patchy at best - losing packets whilst pinging, ssh
> failing to connect. Setting the rate back to a fixed 11M solves this and
> gives good speed. Interestingly, performance declines as I up the bit rate
> from 11 to 18 etc...

It is probably a bug. My Netgear WG111V2 with an RTL8187L chip is perfectly
happy running at 48 or 54 Mb/s with a transmit throughput of 21-23 Mb/s - close
to the maximum for an 802.11g network. There are, however, other reports like
yours where the OFDM rates (6, 9, 18, 24, 36, 48, and 54 Mb/s) don't work very
well. It seems that not all 8187's are the same.

What rate-setting algorithm are you using? Use 'dmesg | grep rate' to see that.
I would have expected it to have settled into 11 Mb/s. Perhaps the auto retry
hasn't really been turned off.

Larry
