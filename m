Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:53746 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143AbaFKPs7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Jun 2014 11:48:59 -0400
Message-ID: <53987A6A.7080209@candelatech.com> (sfid-20140611_174903_967679_92D7411F)
Date: Wed, 11 Jun 2014 08:48:58 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: More confusion with regulatory issues.
References: <53979E9A.5010308@candelatech.com> <CAB=NE6VDr8C=2XZZhnyFKeowDMA-K05_ySw=jDS5gz4+7xs3NA@mail.gmail.com> <CALhHN=oeiDOR=yaX4Eibs69QmbEVeJU065xamdrmatW_gXBnEA@mail.gmail.com> <53986859.4040805@candelatech.com>
In-Reply-To: <53986859.4040805@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/11/2014 07:31 AM, Ben Greear wrote:
> On 06/11/2014 03:34 AM, Janusz Dziedzic wrote:
> 
>> This could be the same issue like fixed in:
>> cfg80211: reg: setup correct alpha2 after intersection (Ben could you
>> try with this patch?)
>>
>> Orginal scenario I descibe:
>> - insmod cfg80211.ko
>> - iw reg set FR (1)
>> - modprobe ath10k_pci (US hint)
>> - intersection and country set as "98"
>> - no way to setup new country using iw reg set   (here hostapd startup
>> will failed)
>>
>> But I can imagine also that we have two cards, both using cfg80211.ko
>> So, first card driver loaded set regulatory eg. FR
>> Next we load ath10k --> intersection "98"
>> Next run hostapd - and fail because no way to change regulatory and
>> get correct DFS region
>>
>> BTW:
>> There is no problem (no intersection) when move "iw reg set" after
>> modprobe ath10k - seems strange logic issue here ...
> 
> With your patch, I no longer see the '98' regdomain, but
> I still see DFS-UNSET.  Is that expected?  How do I get DFS
> to work (and, should it actually be enabled in this case?)
> 
> [root@ath10k-2220 ~]# iw reg get
> country US: DFS-UNSET
> 	(2402 - 2472 @ 40), (N/A, 30)
> 	(5170 - 5250 @ 80), (N/A, 17)
> 	(5250 - 5330 @ 80), (N/A, 23), DFS
> 	(5735 - 5835 @ 80), (N/A, 30)
> 	(57240 - 63720 @ 2160), (N/A, 40)
> [root@ath10k-2220 ~]#

After more debugging, I noticed this:

We are getting regulatory update from core, intersecting US with world-regulatory
domain.  But, the dfs region is un-specified for both of these.  I was expecting
the US domain to use the FCC dfs region.

[    7.895189] cfg80211: 5715000 KHz - 5860000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.895190] cfg80211: Updating information on frequency 5825 MHz with regulatory rule:
[    7.895191] cfg80211: 5715000 KHz - 5860000 KHz @ 80000 KHz), (N/A mBi, 3000 mBm)
[    7.895260] cfg80211: Ignoring regulatory request set by core since the driver uses its own custom regulatory domain
[    7.895929] cfg80211: Calling CRDA for country: US
[    7.895942] cfg80211: Calling CRDA for country: US
[    7.901380] cfg80211: set-regdom, lr->initiator: 2 domain: US
[    7.907423] cfg80211: regdom-intersect, rd1: ffff880220ea5000  rd2: ffff8800371aa700
[    7.915047] cfg80211: regdom-intersect, rd1: US  rd2: 00
....
[    8.220870] cfg80211: reg-rules-intersect, US  00
[    8.224454] cfg80211: reg-rules-intersect, US  00
[    8.227943] cfg80211: dfs-region, region1: 0  region2: 0

And a bit related, I was thinking the dfs-region intersection might
be more useful as is written below?

static enum nl80211_dfs_regions
reg_intersect_dfs_region(const enum nl80211_dfs_regions dfs_region1,
			 const enum nl80211_dfs_regions dfs_region2)
{
	pr_err("dfs-region, region1: %d  region2: %d\n",
	       dfs_region1, dfs_region2);
	if (dfs_region1 != dfs_region2) {
		if (dfs_region1 == NL80211_DFS_UNSET)
			return dfs_region2;
		if (dfs_region2 == NL80211_DFS_UNSET)
			return dfs_region1;
		return NL80211_DFS_UNSET;
	}
	return dfs_region1;
}


Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

