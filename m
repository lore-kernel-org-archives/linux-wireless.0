Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.236]:13340 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbZHBPcv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Aug 2009 11:32:51 -0400
Received: by rv-out-0506.google.com with SMTP id f6so894566rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2009 08:32:50 -0700 (PDT)
Message-ID: <4A75B1BD.7000207@lwfinger.net>
Date: Sun, 02 Aug 2009 10:33:17 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: Re: Regression since 2.6.31-rc3-wl
References: <4A74F1E3.8050502@lwfinger.net> <1249199214.2007.3.camel@johannes.local>
In-Reply-To: <1249199214.2007.3.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> Hi Larry,
> 
> On Sat, 2009-08-01 at 20:54 -0500, Larry Finger wrote:
>> When I tested 2.6.31-rc4-wl on my old i386 laptop that uses ifup to
>> control the network, wireless did not work. The problem was bisected
>> to the following:
> 
> Thanks for taking the time to bisect the problem, can you be more
> specific as to how the problem manifests itself? Are you using ifup to
> configure an ad-hoc network?

No, the network is in managed made using WPA2 encryption. I'm using
ifup because that laptop is only used for testing, is quite slow, and
does not run X.

When I tried to test the latest version on my main laptop using ifup
instead of the usual NM setup, I found that I had to modify my
configuration file /etc/sysconfig/network/ifcfg-eth1. My udev rules
explicitly rename my Broadcom devices to eth1. When I transferred the
revised file to the other laptop, it also started working. With
testing, it turns out the critical addition was "WIRELESS='yes'"

I do not understand why a change in configuration was necessary at
that point; however, the "regression" is only that a more complete
configuration file is required. Please disregard this thread.

Larry
