Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:54135 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752741AbbFKVHM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 17:07:12 -0400
Message-ID: <5579F87F.4070601@candelatech.com> (sfid-20150611_230716_265107_DE1B3DE7)
Date: Thu, 11 Jun 2015 14:07:11 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Question on beacon-miss offloading.
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In my ath10k CT firmware, I am disabling the beacon-miss offloading
to save space and because it will not work with lots of virtual
stations.

But, it must be that I need some way to tell the stack that this
feature is not enabled, because when suddenly kill my AP, then
the ath10k station connected to it shows endless 'beacon loss' events
in 'iw events' output, but it never actually loses connection.

Stock firmware works fine, so probably I just need to disable
some feature flag when registering the ath10k hardware
when using CT firmware.

With stock firmware, I see a quick dissassociation due to inactivity.

I am having poor luck finding how a driver tells the stack
it has beacon miss offload or not, so, does anyone know how
this is controlled?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

