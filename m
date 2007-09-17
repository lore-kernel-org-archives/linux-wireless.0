Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc13.worldnet.att.net ([204.127.131.117]:42992 "EHLO
	mtiwmhc13.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752210AbXIQR1e (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Sep 2007 13:27:34 -0400
Message-ID: <46EEB8F1.5080702@lwfinger.net>
Date: Mon, 17 Sep 2007 12:27:13 -0500
From: Larry Finger <larry.finger@lwfinger.net>
MIME-Version: 1.0
To: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
CC: jt@hpl.hp.com, Michael Buesch <mb@bu3sch.de>,
	linux-wireless@vger.kernel.org,
	bcm43xx devel <Bcm43xx-dev@lists.berlios.de>
Subject: Re: 2.6.23-rc regression: bcm43xx does not work after commit 4cf92a3c
References: <20070917.042418.19962472.yoshfuji@linux-ipv6.org> <20070917165435.GA26926@bougret.hpl.hp.com>
In-Reply-To: <20070917165435.GA26926@bougret.hpl.hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jean Tourrilhes wrote:
> On Mon, Sep 17, 2007 at 04:24:18AM +0900, YOSHIFUJI Hideaki / ?$B5HF#1QL@ wrote:
>> Hello.
>>
>> With latest git tree, bcm43xx driver does not work.
>> By bisect, I've found the commit 4cf92a3c is the first "bad" commit.
>>
>>     [PATCH] softmac: Fix ESSID problem
>>
>>     Victor Porton reported that the SoftMAC layer had random problem when setting the ESSID :
>>     http://bugzilla.kernel.org/show_bug.cgi?id=8686 After investigation, it turned out to be
>>     worse, the SoftMAC layer is left in an inconsistent state. The fix is pretty trivial.
>>     
>>     Signed-off-by: Jean Tourrilhes <jt@hpl.hp.com>
>>     Acked-by: Michael Buesch <mb@bu3sch.df>
>>     Acked-by: Larry Finger <Larry.Finger@lwfinger.net>
>>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
>>
>> After reverting this commit, the driver starts working again.

Thank you for this thorough, if surprising, bug report.

I would like a few more details about your configuration so that I might be able to reproduce the
problem.

When you say "the latest git tree", do you mean Linus's mainstream tree?

Is your wireless device being controlled by NetworkManager, or by ifconfig up/down?

Which distro do you use?

Which BCM43xx device do you have?

Thanks,

Larry
