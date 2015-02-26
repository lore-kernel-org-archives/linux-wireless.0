Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:41961 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307AbbBZSHu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Feb 2015 13:07:50 -0500
Received: from [192.168.100.236] (unknown [50.251.239.81])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by mail2.candelatech.com (Postfix) with ESMTPSA id E51EC40AB7C
	for <linux-wireless@vger.kernel.org>; Thu, 26 Feb 2015 10:07:49 -0800 (PST)
Message-ID: <54EF60F5.1030506@candelatech.com> (sfid-20150226_190753_768816_FA71C63F)
Date: Thu, 26 Feb 2015 10:07:49 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Flaky AP has bad AIFSN, so no HT/VHT....
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

One of our customers reported that our ath10k stations were only able
to connect at 54Mbps speeds.  This is using somewhat hacked 3.17.8 kernel,
but it looks like 3.19 has the same code checks for AIFSN.

It looks like their beacon has bogus AIFSN info, and sniff of the beacon does
show AIFSN set to 0.

Kernel dmesg logs:

wlan0: authenticated at: 1424969385.456415
wlan0: AP has invalid WMM params (AIFSN=0 for ACI 0), disabling WMM
wlan0: associate with 00:18:25:06:4a:b4 (try 1/3), at: 1424969385.457148
wlan0: RX AssocResp from 00:18:25:06:4a:b4 (capab=0x401 status=0 aid=2) at: 1424969385.476681
wlan0: associated at: 1424969385.477265


But a commercial phone connects just fine to this AP, and reports ~780Mbps link speed,
so it at least thinks it is doing VHT.

My question is, should we just warn and ignore this bad AIFSN, or is this really
a fatal issue as far as enabling WMM?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

