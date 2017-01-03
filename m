Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.133]:57135 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934163AbdACJjl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Jan 2017 04:39:41 -0500
Received: from [192.168.190.77] ([77.180.51.43]) by mrelayeu.kundenserver.de
 (mreue001 [212.227.15.167]) with ESMTPSA (Nemesis) id
 0LfKWX-1cqlQx3IdN-00p3fC for <linux-wireless@vger.kernel.org>; Tue, 03 Jan
 2017 10:39:38 +0100
From: Thomas Graf <post@thomas-graf.de>
Subject: mac80211 / ath9k / Monitor Mode
To: linux-wireless@vger.kernel.org
Message-ID: <0c7b53f5-8756-54d7-c1be-0acb524108d7@thomas-graf.de> (sfid-20170103_103947_048279_04908191)
Date: Tue, 3 Jan 2017 10:39:39 +0100
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Everyone,

Since I updated my Kernel to the current version 4.9 I don't get my tx 
packets dumped in monitor mode. That worked at least with the old 4.1 
Kernel.
That problem seems to have to do with IEEE80211_TX_CTL_REQ_TX_STATUS. In 
the xmit.c of the ath9k driver only packets with that flag are passed on 
to ieee80211_tx_status and otherwise to ieee80211_tx_status_noskb.
So if that flag is not set that packet won't get to the monitor 
interface in mac80211.

My solution was to add that flag in ieee80211_xmit:

	if (local->monitors)
	{
	  info->flags |= IEEE80211_TX_CTL_REQ_TX_STATUS;
	}

I'm not sure if that is the right position or if I'm missing something else.

Thanks,
Thomas
