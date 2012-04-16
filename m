Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:41542 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750759Ab2DPRlL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Apr 2012 13:41:11 -0400
Message-ID: <4F8C59B2.20207@candelatech.com> (sfid-20120416_194136_514668_C645BE15)
Date: Mon, 16 Apr 2012 10:41:06 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v3] mac80211: Support on-channel scan option.
References: <1334248689-23018-1-git-send-email-greearb@candelatech.com> (sfid-20120412_183929_638765_C70D881D) <4F8C57CC.4090505@sipsolutions.net>
In-Reply-To: <4F8C57CC.4090505@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/16/2012 10:33 AM, Johannes Berg wrote:
> Did you test it?

Yes.  I added my old can-scan-one patch on top of this
so that as soon as one station is associated the rest
of the hostap-generated scans can just scan the current channel. I
then bring up 100 or so virtual stations and they all scan
and do their thing...

I also tried some manual scans on a fixed frequency.  Those
appeared to work, though I got scan results for APs on different
channels.  Does that seem right?  I can't see how my patch
would affect that sort of thing one way or another...

If you have some suggestions for other ways to test this
please let me know.

>> + /* If we are scanning only on the current channel, then
>> + * we do not need to stop normal activities
>> + */
>> + unsigned long next_delay;
>> +
>> + __set_bit(SCAN_ONCHANNEL_SCANNING,&local->scanning);
>> + ieee80211_recalc_idle(local);
>> + /* Notify driver scan is starting, keep order of operations
>> + * same as normal software scan, in case that matters. */
>> + drv_sw_scan_start(local);
>> + ieee80211_configure_filter(local); /* accept probe-responses */
>> + /* We need to ensure power level is at max for scanning. */
>> + ieee80211_hw_config(local, 0);
>
> a few blank lines would be nice :)

Sure, will do.

>> + if ((req->channels[0]->flags&
>> + IEEE80211_CHAN_PASSIVE_SCAN) ||
>> + !local->scan_req->n_ssids) {
>
> That formatting is a bit off it seems. Or is that just my mailer?

Well, it looked OK to me..though when I replied my mailer
certainly made it look funky.  I'll re-run it through checkpatch
just in case.

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

