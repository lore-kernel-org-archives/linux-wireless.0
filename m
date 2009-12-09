Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cpsmtpm-eml103.kpnxchange.com ([195.121.3.7]:58453 "EHLO
	CPSMTPM-EML103.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753815AbZLIV5y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Dec 2009 16:57:54 -0500
Message-ID: <4B201D67.8000607@gmail.com>
Date: Wed, 09 Dec 2009 22:57:59 +0100
From: Gertjan van Wingerde <gwingerde@gmail.com>
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Ivo van Doorn <IvDoorn@gmail.com>, linux-wireless@vger.kernel.org,
	Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: REGRESSION for RT2561/RT61 in 2.6.32
References: <Pine.LNX.4.44L0.0912090940030.4120-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0912090940030.4120-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/09/09 15:41, Alan Stern wrote:
> On Tue, 8 Dec 2009, Gertjan van Wingerde wrote:
> 
>> Hmm, the stack overrun seems to be generated as part of the
>> Alt-SysRq-* handling, not of any rt61pci handling.
>>
>> I noticed in the Alt-SysRq-T output that powersaving is enabled. We've
>> seen some strange behaviour on this, so could you disable that with:
>>
>> iwconfig wlan0 power off
>>
>> or run a kernel in which CONFIG_CFG80211_DEFAULT_PS is disabled.
>>
>> Maybe that will fix the problem we are seeing?
> 
> It did indeed!  Thank you very much.  If you need a testbed to figure 
> out what's wrong with the power-saving code, just ask.
> 

Great!

Thanks for testing and confirming.

I'll disable powersaving for rt2x00 for now.

And then to find the bugs in there before enabling it again :-(

---
Gertjan.
