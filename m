Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:56227 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753489AbYHGA4K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Aug 2008 20:56:10 -0400
Message-ID: <489A4829.5080704@lwfinger.net> (sfid-20080807_025616_650826_331DC324)
Date: Wed, 06 Aug 2008 19:56:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: John W Linville <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] p54: Fix potential concurrent access to private data
References: <4896381c.abQmtcnBFB3TpLyf%Larry.Finger@lwfinger.net> <200808062321.53120.chunkeey@web.de>
In-Reply-To: <200808062321.53120.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chr wrote:
> 
> Well the reason why there isn't any bug report about it is maybe
> because unlike most other devices we don't program one single
> setting per time, but always a "group of similar ones" at once so
> the device should always be in a sane state in theory.
> 
> So as long as mac80211 provides at least some kind of protection
> against it's own concurrency, we are in save waters even without
> any fancy kind of locking.
> 
> Regards,
> 	Chr

For the config callback, mac80211 does not protect against concurrency. We 
learned that with rtl8187, where this routine ran somewhat longer. After the 
power setting routine was added to the wext interface in mac80211, the driver 
broke due to concurrent calls to the config routine and was fixed by just this 
kind of mutex, which is why I added this protection for p54.

Larry
