Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out04.msg.oleane.net ([62.161.7.2]:50353 "EHLO
	smtp-out04.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225AbbCZLjQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2015 07:39:16 -0400
Received: from smtp29.msg.oleane.net (smtp29.mail.priv [172.17.20.151])
	by smtp-out04.msg.oleane.net with ESMTP id t2QBIrYS028167
	for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2015 12:18:53 +0100
Received: from acksys.fr ([195.6.104.67]) (authenticated)
	by smtp29.msg.oleane.net (MTA) with ESMTP id t2QAweu8022094
	for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2015 11:58:41 +0100
Subject: DFS ETSI conformance for weather channels (again)
Date: Thu, 26 Mar 2015 11:58:40 +0100
Message-ID: <773DB8A82AB6A046AE0195C68612A319019FF0E8@sbs2003.acksys.local> (sfid-20150326_123922_431774_BB0B5CC7)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
From: "Jean-Pierre TOSONI" <jp.tosoni@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi list,

I just stumbled on this patch that IMHO was rejected for a bad reason:

  [PATCH v3 4/4] cfg80211: DFS use 10 minutes CAC when weather channels
  At http://www.spinics.net/lists/linux-wireless/msg115296.html

The reason given is the "unachievable" requirement in the ETSI norm of
99.99% detection success. It was even considered disabling the weather
channels.

*But the norm (ETSI EN 301 893 V1.7.1) does not say this.* It states
that 99.99% is the target performance:

 - during conformance tests only, (5.3.8.1.1 paragraph 5)
 - specifically *not* a requirement with specific real life radars,
(5.3.8.1.1 paragraph 5)
 - on a limited series of 20 tests, (5.3.8.2.1.2 item g)
 - with a pulse power at +10dB above other pulse detection tests,
(5.3.8.2.1.2 item f)
 - with some patterns excluded from the test. (5.3.8.2.1.2 item g)

Hence it is very possible that existing products can achieve the
conformance test target.

That being said, would it be possible to reexamine that dropped patch
and apply it?

Best regards,

Jean-Pierre Tosoni

