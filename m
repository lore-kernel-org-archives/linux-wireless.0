Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out06.msg.oleane.net ([62.161.7.4]:52278 "EHLO
	smtp-out06.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751969Ab3DOOAd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Apr 2013 10:00:33 -0400
Received: from smtp06.msg.oleane.net (smtp06.mail.priv [172.17.20.115])
	by smtp-out06.msg.oleane.net with ESMTP id r3FE0VQl011315
	for <linux-wireless@vger.kernel.org>; Mon, 15 Apr 2013 16:00:31 +0200
Received: from RD9 ([195.6.104.67])
	by smtp06.msg.oleane.net (MTA) with ESMTP id r3FDdlH2028203
	for <linux-wireless@vger.kernel.org>; Mon, 15 Apr 2013 15:39:47 +0200
From: "Jean-Pierre Tosoni" <jp.tosoni@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Subject: mesh questions/suggestion about airtime metric and device constant in mesh_hwmp.c
Date: Mon, 15 Apr 2013 15:39:47 +0200
Message-ID: <000601ce39de$b26e2950$174a7bf0$@acksys.fr> (sfid-20130415_160038_072047_2BA4F555)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

The airtime_link_metric_get()  function follows closely section 13.9 of the
standard, except for the "channel access overhead" which is said to depend
on the PHY, headers, etc. 
Hence I understand that a complete implementation is not trivial.

The 'device_constant' variable is given the constant value '1<<ARITH_SHIFT',
which means 1 microsecond if I am correct. But the smallest possible
duration for the PPDU header is 20 microseconds in non-HT or 24 us in HT, as
shown in section 20.3.2

For the test frame of 8192 bits, say at 300Mbps (MCS15), Bt/r = the
currently computed airtime is 28 instead of 51, underevaluated by -45% !
Since the value accumulates on the mesh path, it may make a big difference
for the path selection.

Questions:
Even if device_constant is kept as a constant, shouldn't we set it to
something more realistic, like 20 or 24 ?
(I mean 20<<ARITH_SHIFT)
Does the standard really mean to include the PPDU header ?

(By the way, I understand that this value should also include the DIFS, and
maybe the ACK, so it should be much greater than 20)

Regards,

Jean-Pierre Tosoni



