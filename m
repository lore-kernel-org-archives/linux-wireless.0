Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:59115 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750714Ab2LLGlA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 01:41:00 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Wed, 12 Dec 2012 12:10:59 +0530
From: vivekanandah@posedge.com
To: <linux-wireless@vger.kernel.org>
Cc: <johannes@sipsolutions.net>
Subject: adding =?UTF-8?Q?ba=5Fpolicy=20member=20in=20drv=5Fampdu=5Faction?=
 =?UTF-8?Q?=20op=20-=20request=20information?=
Message-ID: <95cd69900bf76c0024d3a0838ed38d30@posedge.com> (sfid-20121212_074103_386762_33ADCA57)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

presently in code, the block ack policy is not sent by mac80211 to the 
lower level driver via the ampdu_action callback.

The mac80211 while transmitting a block ack (ADDBA)request, hardcodes 
the block ack methodology to immediate block ack.

on the receive side, the delayed block ack bit is checked along-with 
the capability of the receiver station to support delayed block ack. 
even if the station supports delayed block ack, mac80211 does not send 
the ba_policy down to the driver.

should ba_policy be sent to the driver so that lower level drivers can 
take a call as to send block ack response in a delayed manner at its 
convenience?

looking forward to some information
thanks in advance
Vivek

