Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59851 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754886Ab3CEN3N (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Mar 2013 08:29:13 -0500
Message-ID: <5135F327.4000408@openwrt.org> (sfid-20130305_142917_322753_2ABB85A7)
Date: Tue, 05 Mar 2013 14:29:11 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: john <karl.beldan@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH v2 1/2] mac80211: get the rates masks from the txrc in
 rate_control_get_rate
References: <1362421635-28008-1-git-send-email-karl.beldan@gmail.com> <1362427924.21028.42.camel@jlt4.sipsolutions.net> <20130304204541.GA8819@gobelin>
In-Reply-To: <20130304204541.GA8819@gobelin>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-03-04 9:45 PM, john wrote:
> On Mon, Mar 04, 2013 at 09:12:04PM +0100, Johannes Berg wrote:
>> On Mon, 2013-03-04 at 19:27 +0100, Karl Beldan wrote:
>> > From: Karl Beldan <karl.beldan@rivierawaves.com>
>> > 
>> > Currently it gets it from the sdata. This uses and updates the ad-hoc
>> > masks of the ieee80211_tx_rate_control instead of copying them.
>> 
>> Is there any need to update them?
>> 
>> The change for "mask" seems to make it less efficient since it could
>> otherwise be put into a register.
>> 
> Totally, this commit spares the 10bytes copy of mcs_mask but adds a less
> efficient indirection to mask.
> I thought of it but kept the symmetry with mcs_mask.
> Apparently you wouldn't mind the dissymmetry so I will re-send using mask
> by value, plus I wrote "updates .." where it is more like "lets the
> ad-hoc masks get overwritten".
It seems to me that all of this could be made more efficient by default
if a mcs mask pointer is only passed to rate control if the user
actually configured a MCS mask. Also, filtering out rates from the mask
that the sta does not support seems a bit unnecessary, since the rate
control usually looks at the HT capabilities and the sta's mcs rx mask
anyway.

- Felix
