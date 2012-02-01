Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44400 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755551Ab2BATD2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Feb 2012 14:03:28 -0500
Message-ID: <4F298C76.1030106@candelatech.com> (sfid-20120201_200332_411137_22983CDA)
Date: Wed, 01 Feb 2012 11:03:18 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	Paul Stewart <pstew@google.com>
Subject: Re: [PATCH 1/2] ath9k: recover the chip from tx/rx stuck
References: <1328112335-19265-1-git-send-email-rmanohar@qca.qualcomm.com> <4F297706.3060404@candelatech.com> <20120201184959.GA24166@vmraj-lnx.users.atheros.com>
In-Reply-To: <20120201184959.GA24166@vmraj-lnx.users.atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/01/2012 10:50 AM, Rajkumar Manoharan wrote:
> On Wed, Feb 01, 2012 at 09:31:50AM -0800, Ben Greear wrote:
>> On 02/01/2012 08:05 AM, Rajkumar Manoharan wrote:
>>> In the following scenario, where the distance b/w STA and AP is ~10m
>>> or in a shield environment by placing an attenuator with reduced AP
>>> txpower, the station started reporting with beacon loss and got
>>> disconnected whenever the chariot endpoint was initiated with BiDi
>>> traffic. In such state, two different stuck cases were observed.
>>>
>>>    * rx clear is stuck at low for more than 100ms
>>>    * dcu chain and complete state is stuck.
>>>
>>> This patch detects the stuck state if the beacons are not received for
>>> more than 300ms. In the above matching conditions, trigger a chip
>>> reset to recover. This issue was originally reported in 3.0 kernel with
>>> AR9382 chip by having two stations associated with two different APs in
>>> the same channel and was attenuated/controlled by Azimuth ADEPT-n box.
>>
>> Can't the AP be configured for larger beacon intervals?  Maybe have it
>> be some multiple of that instead of a fixed 300ms?
>>
> Yes. It can. But the detection log will look for specific signature and
> meanwhile if the beacons are received, the inprogress logic will be aborted.
> I believe that 300ms is not too short or too long to trigger the detection.
> Isn't it?

If the beacon interval is 500ms, then you could easily not get a beacon
during your 300ms interval.  If the beacon logic is just a backup, and it doesn't
matter if you don't see the beacon, then probably there is no problem.
I just wanted to make sure you had thought about that issue and that there
would not be spurious fixup logic called if the beacon timer is large.

Thanks,
Ben

>
> -Rajkumar


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

