Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from jenny.ondioline.org ([66.220.1.122]:54941 "EHLO
	jenny.ondioline.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751612AbZF3Fg7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Jun 2009 01:36:59 -0400
Received: from jenny.ondioline.org (localhost [127.0.0.1])
	by jenny.ondioline.org (Postfix) with ESMTP id 1FE142BFB6
	for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2009 17:30:25 +1200 (NZST)
Received: from bulky.wgtn.ondioline.org (121-98-84-12.bitstream.orcon.net.nz [121.98.84.12])
	by jenny.ondioline.org (Postfix) with ESMTPSA id 604802BFB5
	for <linux-wireless@vger.kernel.org>; Tue, 30 Jun 2009 17:30:24 +1200 (NZST)
From: Paul Collins <paul@burly.ondioline.org>
To: linux-wireless@vger.kernel.org
Subject: iwlagn: possible regressions from 2.6.29 in 2.6.30
Date: Tue, 30 Jun 2009 17:30:20 +1200
Message-ID: <874oty9tlf.fsf@bulky.wgtn.ondioline.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Two things I liked about iwlagn in 2.6.29 no longer happen with 2.6.30:

1. reassociation following resume from suspend-to-ram
2. transmission of packets > 250 bytes following resume from suspend-to-ram

I can script around the first problem just by doing "iwconfig wlan0 ap
auto" on resume, but the second problem requires me to ifdown/ifup wlan0
before I can usefully use my network again, so fixing the first problem
doesn't get me very far.

When I say "packets > 250 bytes" I mean 250-byte packets as claimed by
"ping -s 222 mygateway":

        PING cornelius.lan (10.2.4.1) 222(250) bytes of data.

The above will work, but "ping -s 223 cornelius" yields no replies.

I am using a Wireless WiFi Link 5300 [8086:4236] in a ThinkPad X200.

In both cases I was using Debian kernels, although they don't seem to
have included any changes to iwlagn.

-- 
Paul Collins
Wellington, New Zealand

Dag vijandelijk luchtschip de huismeester is dood
