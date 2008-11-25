Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:13475 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752690AbYKYUCn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 15:02:43 -0500
Subject: Re: ath5k: can't browse at all.
From: Pavel Roskin <proski@gnu.org>
To: Irwan Siajadi <dev.bahamot@yahoo.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <790145.29340.qm@web59606.mail.ac4.yahoo.com>
References: <790145.29340.qm@web59606.mail.ac4.yahoo.com>
Content-Type: text/plain
Date: Tue, 25 Nov 2008 15:02:38 -0500
Message-Id: <1227643358.4162.4.camel@dv> (sfid-20081125_210248_117560_671B11C0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2008-11-25 at 09:24 -0800, Irwan Siajadi wrote:

> Further testing shows that if I change from WPA2/AES to WPA/TIKIP, I
> can finally browse. But it's still hit and missed, I need to reload
> the pages once or twice before the pages can load properly. 

Try disabling hardware crypto in the driver:

rmmod ath5k
modprobe ath5k nohwcrypt=1

In any case, check messages from wpa_supplicant.  Maybe it's
reauthenticating very often.  If you flood ping the router ("ping -f"),
you would probably see growing dots that represent lost packets.

-- 
Regards,
Pavel Roskin
