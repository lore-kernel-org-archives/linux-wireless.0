Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:53769 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752822AbXHNAYY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Aug 2007 20:24:24 -0400
Message-ID: <46C0F635.9040300@lwfinger.net>
Date: Mon, 13 Aug 2007 19:24:21 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Wu <flamingice@sourmilk.net>
CC: Ivo van Doorn <ivdoorn@gmail.com>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH V3] mac80211: Turn off meaningless TKIP message when software  WEP encryption is used
References: <46c0d788.GYQYqGfCBKyAWrg7%Larry.Finger@lwfinger.net> <200708140054.22845.IvDoorn@gmail.com> <46C0E5AD.2080407@lwfinger.net> <200708131658.27758.flamingice@sourmilk.net>
In-Reply-To: <200708131658.27758.flamingice@sourmilk.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michael Wu wrote:
> On Monday 13 August 2007 16:13, Larry Finger wrote:
>> Yes, this empirical behavior does not seem to match one's intuition on what
>> the flag should do.
>>
> The flag means the hardware does the rc4 but doesn't bother to deal with the 
> IV/ICV. If you're going do software encryption, there's no reason to bother 
> with that flag, as that says your hardware supports and does rc4 in hardware.

That is fair enough, but why does that flag ever make any difference when the user has not provided 
a set_key callback. My interpretation of the code was that this was one means of indicating that we 
were never going to do any hardware encryption

It would be very helpful to driver writers if the comments in include/net/mac80211.h we improved. 
This flag has none, but I don't think it is that obvious.

Larry
