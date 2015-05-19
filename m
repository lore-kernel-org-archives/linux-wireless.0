Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:34955 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755823AbbESSjv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2015 14:39:51 -0400
Message-ID: <555B8376.3090600@candelatech.com> (sfid-20150519_203955_198366_CF7218C2)
Date: Tue, 19 May 2015 11:39:50 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath10k 10.1 firmware cannot do ANQP queries
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I took some time to debug this in my 10.1 CT firmware.

It appears that the problem is the ANQP queries may be destined
for APs that the station is not currently connected to.  So, the
firmware cannot find the peer, and then it just fails to put the
management frame on the air.

I have fixed my CT firmware to use the 'bss-peer' when the real peer
for a mgt-frame cannot be found.  That appears to work.

Unless upstream firmware does something similar, I think ANQP
(GAS) queries are going to remain broken on ath10k.  I am not
sure of any sane way to do a work-around in the driver, unless
you want to add fake peers and then make them go away sometime
later (when you assume the mgt frame has been properly put on the air).

A simple test case is to use recent wpa_cli:

> anqp_get 00:0e:8e:f8:73:96 1
OK
<3>GAS-QUERY-START addr=00:0e:8e:f8:73:96 dialog_token=0 freq=5180
<3>GAS-QUERY-DONE addr=00:0e:8e:f8:73:96 dialog_token=0 freq=5180 status_code=0 result=SUCCESS
<3>ANQP-QUERY-DONE addr=00:0e:8e:f8:73:96 result=SUCCESS
>

That MAC addr is an AP that the station is NOT connected to.  Even if you
have no ANQP support in the AP, this should still put a packet on
the air I believe...so you should be able to do simple testing with
a sniffer.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

