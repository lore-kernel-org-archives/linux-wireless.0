Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:42713 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024Ab2BARcC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 12:32:02 -0500
Message-ID: <4F297706.3060404@candelatech.com> (sfid-20120201_183207_636846_70EEB4D6)
Date: Wed, 01 Feb 2012 09:31:50 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Paul Stewart <pstew@google.com>
Subject: Re: [PATCH 1/2] ath9k: recover the chip from tx/rx stuck
References: <1328112335-19265-1-git-send-email-rmanohar@qca.qualcomm.com>
In-Reply-To: <1328112335-19265-1-git-send-email-rmanohar@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/01/2012 08:05 AM, Rajkumar Manoharan wrote:
> In the following scenario, where the distance b/w STA and AP is ~10m
> or in a shield environment by placing an attenuator with reduced AP
> txpower, the station started reporting with beacon loss and got
> disconnected whenever the chariot endpoint was initiated with BiDi
> traffic. In such state, two different stuck cases were observed.
>
>    * rx clear is stuck at low for more than 100ms
>    * dcu chain and complete state is stuck.
>
> This patch detects the stuck state if the beacons are not received for
> more than 300ms. In the above matching conditions, trigger a chip
> reset to recover. This issue was originally reported in 3.0 kernel with
> AR9382 chip by having two stations associated with two different APs in
> the same channel and was attenuated/controlled by Azimuth ADEPT-n box.

Can't the AP be configured for larger beacon intervals?  Maybe have it
be some multiple of that instead of a fixed 300ms?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

