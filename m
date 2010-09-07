Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:50085 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758180Ab0IGXa1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Sep 2010 19:30:27 -0400
Received: from [192.168.0.22] (static-72-92-88-10.phlapa.fios.verizon.net [72.92.88.10])
	by smtprelay2.cesmail.net (Postfix) with ESMTPSA id 826D434C6A
	for <linux-wireless@vger.kernel.org>; Tue,  7 Sep 2010 19:32:42 -0400 (EDT)
Subject: rt61pci: oops in rt2x00lib_txdone(), entry->skb is NULL
From: Pavel Roskin <proski@gnu.org>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Sep 2010 19:30:12 -0400
Message-ID: <1283902212.5071.11.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

wireless-testing.git as of yesterday has a problem with rt61pci.  After
a minute of web browsing, the kernel reports an oops in
rt2x00lib_txdone() and no more traffic goes through.  That system used
to run a month old wireless-testing.git identified as 2.6.35-rc6-wl, and
it didn't have that problem.

The oops happens on this line:
enum data_queue_qid qid = skb_get_queue_mapping(entry->skb);

When it happens, entry->skb is NULL.  I cannot reproduce the problem by
ping, even by flood ping, but using a web browser on a moderately
complex site (e.g. cnn.com) triggers the oops reliably within a minute
or so.

The architecture is x86_64, it's a multicore system, SMP is enabled in
the kernel.

If there are no good ideas what it might be, I'll try to find time to
bisect the bug.

-- 
Regards,
Pavel Roskin
