Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:46524 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756005Ab2GFVpT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Jul 2012 17:45:19 -0400
Message-ID: <4FF75C6C.9030108@candelatech.com> (sfid-20120706_234524_437152_32195FFE)
Date: Fri, 06 Jul 2012 14:45:16 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 0/3] mac80211 scanning restructuring
References: <1341608733-7503-1-git-send-email-johannes@sipsolutions.net>  <4FF758DB.5010206@candelatech.com> <1341610508.16893.26.camel@jlt3.sipsolutions.net>
In-Reply-To: <1341610508.16893.26.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/06/2012 02:35 PM, Johannes Berg wrote:
> On Fri, 2012-07-06 at 14:30 -0700, Ben Greear wrote:
>> On 07/06/2012 02:05 PM, Johannes Berg wrote:
>>> I decided that with multi-channel coming and thus us using more
>>> virtual interfaces, the scanning code was going to be the first
>>> victim of some factoring ;-)
>>>
>>> Please review. The only thing that isn't quite clear to me is
>>> whether or not I can really remove the channel == oper_channel
>>> check, but it's only applied to probe resp/beacon frames so it
>>> seems a bit pointless to try to keep it?
>>
>> For what it's worth, I don't see any problems with the patches.
>
> :-)
> I think you should see much fewer calls to cfg80211 with this when
> beacons are received, when you have many virtual interfaces, but I'm not
> sure how you'd see that unless you carefully measure CPU utilization.
>
>> Another enhancement I was thinking about would be to allow
>> vifs to piggy-back on other vif's scans.  Instead of
>> returning EBUSY when another vif is already scanning, just
>> register to receive the scanning vif's results when it finishes.
>
> Hmm, yes, technically that's possible. However, you'd have to verify
> that it used exactly the same scan parameters, which seems like a lot of
> overhead? Given that we give you the scan parameters in the nl80211
> event when the scan finishes (at least I think we do), you could even do
> this optimisation in userspace, when -EBUSY is returned?

I was thinking to only enable the wait-for-peer-scan logic if
peer and requested scans are 'normal', or some simple subset of
mostly-normal that is easy to check for.  It would still always
be valid to return EBUSY if you cannot obviously share scan results.

Main issue that I see is that if one interface is constantly scanning
in wpa_supplicant because it can't find what it's looking for,
you can often get a failure if you manually run 'iw scan'
on the command line, and that is exactly when you often DO want
to see some manual scan results :)

I've already optimized wpa_supplicant to share scans in user-space
some time back (and code has been upstream for a while), and that is
a big help..but doesn't help non-supplicant programs.

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com



