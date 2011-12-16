Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:20648 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760447Ab1LPU1I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 15:27:08 -0500
Date: Fri, 16 Dec 2011 23:26:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: sameo@linux.intel.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: re: NFC: Initial LLCP support
Message-ID: <20111216202659.GD18570@elgon.mountain> (sfid-20111216_212714_018224_15F4F1A2)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Samuel Ortiz,

This is a semi-automatic email about new static checker warnings.

The patch d646960f7986: "NFC: Initial LLCP support" from Dec 14, 
2011, leads to the following Smatch complaint:

net/nfc/llcp/sock.c +47 llcp_sock_bind()
	 warn: variable dereferenced before check 'addr' (see line 45)

net/nfc/llcp/sock.c
    44	
    45		pr_debug("sk %p addr %p family %d\n", sk, addr, addr->sa_family);
                                                                ^^^^^^^^^^^^^^^
New dereference.

    46	
    47		if (!addr || addr->sa_family != AF_NFC)
                     ^^^^
New check.

    48			return -EINVAL;
    49	

regards,
dan carpenter

