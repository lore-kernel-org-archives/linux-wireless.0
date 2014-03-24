Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59329 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750816AbaCXWVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Mar 2014 18:21:25 -0400
Message-ID: <5330AFC6.60205@candelatech.com> (sfid-20140324_232157_370196_51ADD76B)
Date: Mon, 24 Mar 2014 15:20:54 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ath10k: fix rssi and rate reporting
References: <1395692698-4745-1-git-send-email-janusz.dziedzic@tieto.com> <1395692698-4745-2-git-send-email-janusz.dziedzic@tieto.com>
In-Reply-To: <1395692698-4745-2-git-send-email-janusz.dziedzic@tieto.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/24/2014 01:24 PM, Janusz Dziedzic wrote:
> RSSI and RATES fields are valid only when START_VALID
> bit is set. So, in current implementation we have to
> remember/caclulate them when START_VALID and report the same
> when only END_VALID is set.
> Currently during heavy traffic we could have:
> - 10 packets with START_VALID - correct RSSI and RATES
> - 10 packets with END_VALID
> - 10 packets with START_VALID - correct RSSI and RATES
> - 10 packets with END_VALID

I applied all 8 of these patches to my tree, and it does fix the problems I saw with
rx-rate and signal being broken (perhaps because I am using raw rx mode for
my stations).

I'll leave these in my tree and will let you know if I see any
problems that might be related to them.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

