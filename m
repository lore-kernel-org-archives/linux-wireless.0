Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:57498 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab1LPU0p (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Dec 2011 15:26:45 -0500
Date: Fri, 16 Dec 2011 23:26:38 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: NFC: smatch stuff: min_t() casting
Message-ID: <20111216202638.GC18570@elgon.mountain> (sfid-20111216_212648_519693_54B0150B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sam,

Smatch complains about the min_t() casting here.

net/nfc/llcp/sock.c +80 llcp_sock_bind(44)
	warn: min_t truncates here '(llcp_addr.service_name_len)' (4294967295 vs 9223372036854775807)

    78          llcp_sock->local = local;
    79          llcp_sock->nfc_protocol = llcp_addr.nfc_protocol;
    80          llcp_sock->service_name_len = min_t(unsigned int,
    81                          llcp_addr.service_name_len, NFC_LLCP_MAX_SERVICE_NAME);
                                ^^^^^^^^^^^^^^^^^^^^^^^^^^
Smatch complains that .service_name_len is a size_t (64 bits on 64 bit
architectures).  The cast to unsigned int takes the minimum of the
truncated value.

    82          llcp_sock->service_name = kmemdup(llcp_addr.service_name,
    83                                  llcp_sock->service_name_len, GFP_KERNEL);


These two functions are the same way.

net/nfc/llcp/sock.c +461 llcp_sock_connect(71)
	warn: min_t truncates here '(addr->service_name_len)' (4294967295 vs 9223372036854775807)
net/nfc/llcp/sock.c +521 llcp_sock_recvmsg(36) warn:
	min_t truncates here '(len)' (4294967295 vs 9223372036854775807)

It's not really an issue, but it's slightly untidy.

regards,
dan carpenter
