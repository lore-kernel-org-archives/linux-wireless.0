Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.sigma-star.at ([95.130.255.111]:14386 "EHLO
	mail.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbbCMLhO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2015 07:37:14 -0400
From: Richard Weinberger <richard@nod.at>
To: netdev@vger.kernel.org
Cc: linux-wireless@vger.kernel.org, coreteam@netfilter.org,
	netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	sameo@linux.intel.com, aloisio.almeida@openbossa.org,
	lauro.venancio@openbossa.org, davem@davemloft.net,
	kadlec@blackhole.kfki.hu, kaber@trash.net, pablo@netfilter.org
Subject: net: portid signedness and format string fixes
Date: Fri, 13 Mar 2015 12:31:12 +0100
Message-Id: <1426246276-15839-1-git-send-email-richard@nod.at> (sfid-20150313_123856_241366_DE7A0E44)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

My application blow up as values in nfnetlink_queue suddenly turned
negative.

i.e.
$ cat /proc/net/netfilter/nfnetlink_queue
    0  29508   278 2 65531     0 2004213241 -2129885586  1
    1 -27747     0 2 65531     0     0        0  1
    2 -27748     0 2 65531     0     0        0  1

This series fixes that. Patches 1 to 3 change users of signed
portid to unsigned integers. Just for the sake of consistency.
Patch 4 fixes the printf format string such that applications
don't have to deal with negative numbers.

[PATCH 1/4] netlink: Fix portid type in netlink_notify
[PATCH 2/4] nfc: Fix portid type in urelease_work
[PATCH 3/4] netfilter: Fix portid types
[PATCH 4/4] netfilter: Fix format string of nfnetlink_queue proc file

Thanks,
//richard
