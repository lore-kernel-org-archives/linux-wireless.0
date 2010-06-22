Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 80-190-117-144.ip-home.de ([80.190.117.144]:56403 "EHLO
	bu3sch.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754133Ab0FVQbf (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Jun 2010 12:31:35 -0400
Message-ID: <4C20E561.4090203@bu3sch.de>
Date: Tue, 22 Jun 2010 18:31:29 +0200
From: =?ISO-8859-1?Q?Michael_B=FCsch?= <mb@bu3sch.de>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: b43-dev <b43-dev@lists.infradead.org>,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: Re: Recent results with BCM4312 on Netbook
References: <4C20D884.3010501@lwfinger.net> (sfid-20100622_173557_635889_3487F3F3)
In-Reply-To: <4C20D884.3010501@lwfinger.net> (sfid-20100622_173557_635889_3487F3F3)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/22/2010 05:36 PM, Larry Finger wrote:
> My first discovery is that if PIO mode is to be used, it is not sufficient
> to load the module with the "pio=1" option, but that both "qos=0" and
> "nohwcrypt=1" options must also be used, at least for WPA/WPA2 networks.

That is known. I posted it once or twice. It is b43 making bad
assumptions about mac80211 behavior. And mac80211 behavior changed...
b43 does modify the number of queues in the data structure after it
registered things to mac80211. That used to work properly in the past.
But it breaks now. The init does have to be re-ordered and implementation
of async firmware loading is required to fix that.

> No other combination works. In addition, the automatic failover to PIO
> mode does not work unless those two options were used when the module was
> loaded. Thus both of the following work:

It only works by accident anyway. But I already said that several times.

-- 
Greetings Michael.
