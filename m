Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:5987 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab2FML4d (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jun 2012 07:56:33 -0400
Message-ID: <4FD87FEA.3070208@qca.qualcomm.com> (sfid-20120613_135637_198525_78EA68E4)
Date: Wed, 13 Jun 2012 14:56:26 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Luciano Coelho <coelho@ti.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	Thomas Pedersen <c_tpeder@qca.qualcomm.com>,
	<ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>,
	<victorg@ti.com>
Subject: Re: [PATCH] nl80211: specify RSSI threshold when scanning
References: <1339533801-32016-1-git-send-email-c_tpeder@qca.qualcomm.com>  <1339566003.4519.1.camel@jlt3.sipsolutions.net> <1339587447.3840.272.camel@cumari.coelho.fi>
In-Reply-To: <1339587447.3840.272.camel@cumari.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/13/2012 02:37 PM, Luciano Coelho wrote:
> On Wed, 2012-06-13 at 07:40 +0200, Johannes Berg wrote:
>> On Tue, 2012-06-12 at 13:43 -0700, Thomas Pedersen wrote:
>>> Support configuring an RSSI threshold in dBm (s32) when requesting
>>> scheduled scan, below which a BSS won't be reported by the cfg80211
>>> driver.
>>
>> I'm confused -- were you going to do scheduled scan only? Makes sense,
>> but if you could maybe change the subject a bit to "specify ... in
>> scheduled scan"?
> 
> It makes more sense with scheduled scans, but maybe it is also desirable
> with normal scans to reduce the amount of scan results traffic?
> 
> At least if we consider the intermediate scan results that Victor has
> been working on... We may want to report all scan results at the end,
> but only send intermediate events if all the matches are satisfied, for
> example.
> 
> Just thinking out loud a bit.

Good point.

Funnily enough I don't have any idea how ath6kl has implemented this
feature, but in theory this feature is useful also for the current
normal scan (when the firmware/hardware supports it) as we can avoid
host wakeups. If there are 10 APs, but all are below the RSSI threshold,
we will have only 1 host wakeup (scan ready event) opposed to 11 wakeups
(10 AP found events plus 1 scan ready event).

Kalle
