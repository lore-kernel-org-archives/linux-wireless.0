Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.224]:18081 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613AbXLDS7a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 13:59:30 -0500
Received: by wr-out-0506.google.com with SMTP id c49so3078728wra
        for <linux-wireless@vger.kernel.org>; Tue, 04 Dec 2007 10:59:29 -0800 (PST)
Message-ID: <4755A382.5000806@gmail.com> (sfid-20071204_185938_603003_625E4173)
Date: Tue, 04 Dec 2007 18:59:14 +0000
MIME-Version: 1.0
To: Dan Williams <dcbw@redhat.com>
CC: Dave <kilroyd@googlemail.com>, linux-wireless@vger.kernel.org
Subject: Re: [RFC PATCH] [try 2] orinoco: more reliable scan handling
References: <1191946643.20183.2.camel@localhost.localdomain>	 <20071010183251.GK5962@tuxdriver.com>	 <1192074985.31110.4.camel@localhost.localdomain>	 <47489C2D.7030606@gmail.com> <1196790911.14982.4.camel@localhost.localdomain>
In-Reply-To: <1196790911.14982.4.camel@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1
From: Dave <kilroyd@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Williams wrote:
> On Sat, 2007-11-24 at 21:48 +0000, Dave wrote:
>> Dan Williams wrote:
>>> Bring scan result handling more in line with drivers like ipw.  Scan
>>> results are aggregated and a BSS dropped after 15 seconds if no beacon
>>> is received.  This allows the driver to interact better with userspace
>>> where more than one process may request scans or results at any time.
>> I've only seen this recently, and am using it as a basis for some other changes. However I've noticed a couple issues:
>>
>>> +static int orinoco_process_scan_results(struct net_device *dev,
>>> +					unsigned char *buf,
>>> +					int len)
>>> +{
>>  <snip>
>>> +		/* Try to update an existing bss first */
>>> +		list_for_each_entry(bss, &priv->bss_list, list) {
>>> +			if (compare_ether_addr(bss->bss.a.bssid, atom->a.bssid))
>>                         if (!compare_ether_addr(bss->bss.a.bssid, atom->a.bssid))
>>
>> So that we proceed to the next bss when ether_addr doesn't match. Otherwise this loop never matches.
> 
> compare_ether_addr(), like memcmp, returns 0 when the two arguments
> match.  So I think this is OK.

Agreed. My mistake.

>  What the loop should be doing is trying
> to find a BSSID + ESSID match and just update the last_seen value, which
> from my reread is what it's doing here...

Agreed.

If something in userspace triggers a scan every 10 seconds, the scan results will always be the same (the oldest).

If that is the desired behaviour (or we don't care about this misuse) this is fine. Personally I'd expect the results to be updated, but I've only recently started messing with wireless drivers.

Thanks,

Dave.
