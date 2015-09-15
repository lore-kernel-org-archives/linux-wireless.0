Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:47784 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729AbbIOSUJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 14:20:09 -0400
To: ath10k <ath10k@lists.infradead.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From: Ben Greear <greearb@candelatech.com>
Subject: Default rates for broadcast, multicast, and management frames?
Message-ID: <55F86158.2090907@candelatech.com> (sfid-20150915_202014_409040_1EED3B12)
Date: Tue, 15 Sep 2015 11:20:08 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

ath10k firmware allows one to set fixed rates for broadcast, multicast, and management/beacon
frames.  I think upstream firmware may not have full support, but the API is there in 10.1,
at least, and CT firmware has full support.

I think the defaults are 6Mbps, but not certain of that.

CT kernels have a patch that gives debugfs access to set this, and I am also
working on automatically decreasing the rate down to 1Mbps if user has specified
only /b legacy rates, etc.

Instead of using whatever the firmware chooses for defaults, I think it is
better if the driver explicitly set the rates as desired.

So, what are the suggested defaults for these rate types?  Stick with 6Mbps for
/b/g and /a modes?  Set to 1Mbps of /b mode?  Different defaults for different
types?

Also, at least some ucast/bcast frames may be turned into directed frames and
then it may use normal peer rate-ctrl logic, as far as I remember.

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

