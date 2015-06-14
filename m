Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from zimbra.real-time.com ([63.170.91.9]:48181 "EHLO
	zimbra.real-time.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752368AbbFNXFT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Jun 2015 19:05:19 -0400
Date: Mon, 15 Jun 2015 09:04:56 +1000
From: James Cameron <quozl@laptop.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Arnaud LE CAM <arnaud.lecam@yahoo.fr>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [Bug ?] 10ec:b723 Realtek RTL8723BE wireless card drops
 connection
Message-ID: <20150614230456.GE12739@us.netrek.org> (sfid-20150615_010530_133040_28AC9428)
References: <1434268591.3014.YahooMailBasic@web172003.mail.ir2.yahoo.com>
 <557D9966.5050209@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <557D9966.5050209@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 14, 2015 at 10:10:30AM -0500, Larry Finger wrote:
> To address your problem, power saving does not work correctly on
> this device. That is why there are numerous posts on the web telling
> people to use ips=0. It seems that Ubuntu people never look at
> anything but the Ubuntu literature; however, I'm sure that I posted
> this "suggestion" there as well. The Realtek group is currently
> rewriting the entire dynamic management code for all their drivers.
> When complete, this should improve performance and should help the
> power-save condition. No, I do not know when the new code will be
> ready, or how much improvement it will make.

Thanks for summary.

OLPC is also seeing the issue.  Power saving mode impacts battery run
time; one of our design goals.  ips=0 seems to solve with 3.19, but
not fully with 4.1-rc7; still some periods of packet loss.

I offer to test any rtl8723be changes.

(I'm also looking into IBSS, because Sugar desktop relies on
ad-hoc.  No beacons on creating an IBSS through NetworkManager, but
beacons are fine with "iw dev wlan0 ibss join x 2437".  But I'm not
yet ready to report problem; still some debugging to do.)

-- 
James Cameron
http://quozl.linux.org.au/
