Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp156.iad.emailsrvr.com ([207.97.245.156]:57178 "EHLO
	smtp156.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756221AbXFEC1c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2007 22:27:32 -0400
Received: from [192.168.1.103] (c-24-34-179-5.hsd1.ma.comcast.net [24.34.179.5])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: ddrake@brontes3d.com)
	by relay5.relay.iad.emailsrvr.com (SMTP Server) with ESMTP id 4A84860A47C
	for <linux-wireless@vger.kernel.org>; Mon,  4 Jun 2007 22:27:32 -0400 (EDT)
Message-ID: <4664C9EB.8050106@gentoo.org>
Date: Mon, 04 Jun 2007 22:26:51 -0400
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: mac80211 TX hangs up
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've been seeing occasional problems on mac80211 where the connection is 
lost. The same device has been used for many hours with the softmac 
driver with no problems.

I just saw it again and confirmed that the device stops TXing when this 
happens.

After observing this, I tried to scan, and this came up in the logs:

WARNING: at net/mac80211/ieee80211.c:1280 ieee80211_tx()
  [<f02ad79f>] ieee80211_master_start_xmit+0x19b/0x4b2 [mac80211]
  [<b011b334>] __wake_up_common+0x32/0x55
  [<b011b891>] __wake_up+0x32/0x43
  [<b02e6f54>] dev_hard_start_xmit+0x18a/0x1e9
  [<b02f121c>] __qdisc_run+0xc5/0x190
  [<b02e7cbd>] net_tx_action+0xa8/0xd0
  [<b032ad2d>] wireless_nlevent_process+0x2a/0x31

The line of code in question is 	
	WARN_ON(__ieee80211_queue_pending(local, control->queue));

This was with mac80211 from 2.6.22-rc3, but the problem has also been 
seen with a recent wireless-dev.git.

Any ideas or other reports of this?

Thanks,
Daniel
