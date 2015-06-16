Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:53194 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123AbbFPCyU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jun 2015 22:54:20 -0400
Date: Tue, 16 Jun 2015 12:53:56 +1000
From: James Cameron <quozl@laptop.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Arnaud LE CAM <arnaud.lecam@yahoo.fr>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Bug ?] 10ec:b723 Realtek RTL8723BE wireless card drops
 connection
Message-ID: <20150616025356.GC4862@us.netrek.org> (sfid-20150616_045424_856197_CF5E2DDE)
References: <1434268591.3014.YahooMailBasic@web172003.mail.ir2.yahoo.com>
 <557D9966.5050209@lwfinger.net>
 <20150614230456.GE12739@us.netrek.org>
 <557E0AB4.2030001@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <557E0AB4.2030001@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 14, 2015 at 06:13:56PM -0500, Larry Finger wrote:
> On 06/14/2015 06:04 PM, James Cameron wrote:
> >On Sun, Jun 14, 2015 at 10:10:30AM -0500, Larry Finger wrote:
> >>To address your problem, power saving does not work correctly on
> >>this device. That is why there are numerous posts on the web telling
> >>people to use ips=0. It seems that Ubuntu people never look at
> >>anything but the Ubuntu literature; however, I'm sure that I posted
> >>this "suggestion" there as well. The Realtek group is currently
> >>rewriting the entire dynamic management code for all their drivers.
> >>When complete, this should improve performance and should help the
> >>power-save condition. No, I do not know when the new code will be
> >>ready, or how much improvement it will make.
> >
> >Thanks for summary.
> >
> >OLPC is also seeing the issue.  Power saving mode impacts battery run
> >time; one of our design goals.  ips=0 seems to solve with 3.19, but
> >not fully with 4.1-rc7; still some periods of packet loss.
> >
> >I offer to test any rtl8723be changes.
> 
> Please do a bisection between 4.1-rc7 and 3.19.

Thanks.  But I was too hasty in reporting a good result.

Now no difference across those kernel versions; still some
periods of packet loss with ips=0.

Workaround is to use both ips=0 and fwlps=0.  We'll ship with that
unless we hear of a fix.

-- 
James Cameron
http://quozl.linux.org.au/
