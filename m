Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc12.worldnet.att.net ([204.127.131.116]:42759 "EHLO
	mtiwmhc12.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752866AbYHBDGi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Aug 2008 23:06:38 -0400
Message-ID: <4893CF3D.1070504@lwfinger.net> (sfid-20080802_050642_208535_9B73129E)
Date: Fri, 01 Aug 2008 22:06:37 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: "David S. Miller" <davem@davemloft.net>
CC: wireless <linux-wireless@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
Subject: p54usb broken by commit b19fa1f
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In testing 2.6.27-rc1, I found that p54usb caused my machine to freeze. A few
times, I was able to use the KDE system status applet to see that the system was
using essentially 100% of the CPU's. One other time, the system responded a 
little - enough for me to see tha wpa_supplicant was consuming 100% of the my 
AMD Turion 64 X2 running an x86_64 kernel. From bisection, the problem is due to

commit b19fa1fa91845234961c64dbd564671aa7c0fd27
Author: David S. Miller <davem@davemloft.net>
Date:   Tue Jul 8 23:14:24 2008 -0700

     net: Delete NETDEVICES_MULTIQUEUE kconfig option.

     Multiple TX queue support is a core networking feature.

     Signed-off-by: David S. Miller <davem@davemloft.net>

Obviously, something in the driver cannot handle multiqueues, but I
have not found anything, and I have not been able to get any logged events that
show what is going wrong.

Thanks,

Larry

