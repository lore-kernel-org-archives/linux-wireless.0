Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:45630 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751377Ab3CJXde (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Mar 2013 19:33:34 -0400
Message-ID: <513D184B.2000805@openwrt.org> (sfid-20130311_003352_540321_A0A0DFD5)
Date: Mon, 11 Mar 2013 00:33:31 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Karl Beldan <karl.beldan@rivierawaves.com>
Subject: Re: [PATCH v2 1/2] mac80211: get the rates masks from the txrc in
 rate_control_get_rate
References: <1362421635-28008-1-git-send-email-karl.beldan@gmail.com> <1362427924.21028.42.camel@jlt4.sipsolutions.net> <20130304204541.GA8819@gobelin> <5135F327.4000408@openwrt.org> <20130310221627.GA3824@gobelin> <513D08B5.1030007@openwrt.org> <20130310230600.GC3824@gobelin>
In-Reply-To: <20130310230600.GC3824@gobelin>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-03-11 12:06 AM, Karl Beldan wrote:
> On Sun, Mar 10, 2013 at 11:27:01PM +0100, Felix Fietkau wrote:
>> On 2013-03-10 11:16 PM, Karl Beldan wrote:
>> > On Tue, Mar 05, 2013 at 02:29:11PM +0100, Felix Fietkau wrote:
>> >> On 2013-03-04 9:45 PM, john wrote:
>> >> > On Mon, Mar 04, 2013 at 09:12:04PM +0100, Johannes Berg wrote:
>> >> >> On Mon, 2013-03-04 at 19:27 +0100, Karl Beldan wrote:
>> >> >> > From: Karl Beldan <karl.beldan@rivierawaves.com>
>> >> >> > 
>> >> >> > Currently it gets it from the sdata. This uses and updates the ad-hoc
>> >> >> > masks of the ieee80211_tx_rate_control instead of copying them.
>> >> >> 
>> >> >> Is there any need to update them?
>> >> >> 
>> >> >> The change for "mask" seems to make it less efficient since it could
>> >> >> otherwise be put into a register.
>> >> >> 
>> >> > Totally, this commit spares the 10bytes copy of mcs_mask but adds a less
>> >> > efficient indirection to mask.
>> >> > I thought of it but kept the symmetry with mcs_mask.
>> >> > Apparently you wouldn't mind the dissymmetry so I will re-send using mask
>> >> > by value, plus I wrote "updates .." where it is more like "lets the
>> >> > ad-hoc masks get overwritten".
>> >> It seems to me that all of this could be made more efficient by default
>> >> if a mcs mask pointer is only passed to rate control if the user
>> >> actually configured a MCS mask. Also, filtering out rates from the mask
>> >> that the sta does not support seems a bit unnecessary, since the rate
>> >> control usually looks at the HT capabilities and the sta's mcs rx mask
>> >> anyway.
>> >> 
>> > Filtering is necessary to lookup alternative downgrade/upgrade rates.
>> Right, but the code could be changed to only do the filtering if
>> mac80211 needs to look up an alternative downgrade/upgrade rate.
>> 
> With this I agree.
> Do you have strong opinions wrt basic rates ? The current code might tx
> mc/bc with non-basic rates.
The only strong opinion I have about the rate masking code is that it
shouldn't waste precious CPU cycles in a hot path ;)

- Felix

