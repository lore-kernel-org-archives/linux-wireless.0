Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mog.warmcat.com ([62.193.232.24]:49149 "EHLO
	mailserver.mog.warmcat.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752837AbXCST5o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2007 15:57:44 -0400
Received: from armbox7.home.warmcat.com (cpc1-nthc5-0-0-cust289.nrth.cable.ntl.com [82.29.29.34])
	by mailserver.mog.warmcat.com (Postfix) with ESMTP id 5041D8CAD2
	for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2007 20:57:42 +0100 (CET)
Received: from meerkat.home.warmcat.com (flatcat [192.168.0.77])
	by armbox7.home.warmcat.com (Postfix) with ESMTP id F1E10FFBE
	for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2007 19:57:42 +0000 (UTC)
Received: from [127.0.0.1] (meerkat.home.warmcat.com [127.0.0.1])
	by meerkat.home.warmcat.com (Postfix) with ESMTP id 147CE18D1D67
	for <linux-wireless@vger.kernel.org>; Mon, 19 Mar 2007 19:57:41 +0000 (GMT)
Message-ID: <45FEEB34.1000403@warmcat.com>
Date: Mon, 19 Mar 2007 19:57:40 +0000
From: Andy Green <andy@warmcat.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Faking powersave for fun and realtime channel muxing
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi folks -

If you could generate and manage powersave protocol frames to an AP from 
the mac80211 stack, without actually putting the radio to sleep, you 
could do some interesting things.

For example you could allow any logical network interface to have a 
different channel.  In this case, during the time that the channel you 
are associated on has been told you have gone into powersave mode, you 
can actually spend time on that other channel, before switching the 
channel back to check in with the AP.  So you could for example run 
monitor mode on channel 11 while being associated on channel 2, given 
the limitation that sometimes you aren't listening because you are 
taking care of business on channel 2.  This can surely lead to ripping 
out all the "scanning" stuff and ioctl(s) from kernel mode and doing it 
from a regular interface using the existing Monitor semantics.

Depending on the limitations of the time you can arrange to "sleep" with 
the AP, using this technique you could even associate multiple logical 
interfaces to APs on different channels despite they are sharing one 
physical radio.  That could be cool for dealing with realtime selection 
of the best channel/AP when the guy is mobile, for example.

Is there something like firmware constraints or the detail of the 
powersaving protocol that kill this dead or is it possible to consider?

-Andy
