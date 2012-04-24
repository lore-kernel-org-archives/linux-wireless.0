Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:65445 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889Ab2DXFVN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 01:21:13 -0400
Received: by iadi9 with SMTP id i9so478534iad.19
        for <linux-wireless@vger.kernel.org>; Mon, 23 Apr 2012 22:21:13 -0700 (PDT)
Date: Tue, 24 Apr 2012 00:21:06 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Richard Kettlewell <rjk@greenend.org.uk>,
	Johannes Stezenbach <js@sig21.net>,
	linux-wireless@vger.kernel.org, debian-kernel@lists.debian.org,
	Ivo Van Doorn <ivdoorn@gmail.com>
Subject: Re: High network latency with ralink usb wireless device
Message-ID: <20120424052106.GA19023@burratino> (sfid-20120424_072117_207421_A8D132A9)
References: <4D84E433.70001@greenend.org.uk>
 <1300555815.26693.83.camel@localhost>
 <4D84EC90.4090803@greenend.org.uk>
 <20110319223159.GA19576@sig21.net>
 <4D85C506.1060003@greenend.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4D85C506.1060003@greenend.org.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ben,

About a year ago, Richard Kettlewell wrote[1]:
> On 19/03/2011 22:31, Johannes Stezenbach wrote:

>> I sent a patch to disable power save by default, but then work started
>> to fix it instead, but then stalled.  Seems like 2.6.38 shipped with
>> broken power save enabled by default.  Plese read the discussion
>> following my RFC patch:
>> http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-January/thread.html#3017
>>
>> You can test if power saving causes your issue by disabling
>> it with "iwconfig wlan0 power off".
>
> That does the trick - thanks!

Therefore ever since version 2.6.38-2, Debian kernels have had
powersaving disabled on rt2800usb devices.

I think we should revisit this in light of

  v3.0-rc2~7^2~16^2~190 rt2x00: Add autowake support for USB hardware
  (2011-04-30)

though I wouldn't be surprised if testing ends up revealing some
followup patches introduced after v3.2 to be needed for it to work
well.  What do you think?

Thanks,
Jonathan

[1] http://bugs.debian.org/618930
