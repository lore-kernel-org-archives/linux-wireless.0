Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:38695 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab3FQSt4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Jun 2013 14:49:56 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r5HIntVu030061
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Mon, 17 Jun 2013 11:49:56 -0700
Message-ID: <51BF5A53.8050100@candelatech.com> (sfid-20130617_205007_448068_E9E81DD2)
Date: Mon, 17 Jun 2013 11:49:55 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Lots of confusion on bss refcounting.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

More on looking for bss and ies leaks...

I am trying to understand the bss refcounting, but everywhere I
look it seems like the code is weird at best.

For instance:

We create an assoc_data, assign a bss pointer in ieee80211_mgd_assoc,
but do not claim a reference.

Later, when deleting the assoc_data, the ref is not freed either,
except in one error path where it is explicitly freed:

		if (!ieee80211_assoc_success(sdata, *bss, mgmt, len)) {
			/* oops -- internal error -- send timeout for now */
			ieee80211_destroy_assoc_data(sdata, false);
			cfg80211_put_bss(sdata->local->hw.wiphy, *bss);
			return RX_MGMT_CFG80211_ASSOC_TIMEOUT;
		}

This seems ripe for bugs, if not already buggy.

Maybe we should be more explicit about always grabbing a ref when
we take a reference to the pointer, and always put it when we
destroy the pointer?

I'll be happy to cook up some patches if this seems like the right
path to take.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

