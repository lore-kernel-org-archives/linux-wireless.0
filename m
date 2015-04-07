Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:33097 "EHLO
	mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753597AbbDGRfg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2015 13:35:36 -0400
Message-ID: <55241567.3010703@candelatech.com> (sfid-20150407_193629_455713_C0EAE63B)
Date: Tue, 07 Apr 2015 10:35:35 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: Michal Kazior <michal.kazior@tieto.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath10k to ath9k IBSS, ath9k has interface-combinations issue
References: <5523273F.4060803@candelatech.com> <CA+BoTQ=UUbfi5D9ZbN5Rxb20f5xpzuYQMo392=P++Qyhz8Hs+w@mail.gmail.com> <CALhHN=oCvQ=SvobWTvc3geK-66k2+YDzB1HqSguCxTeV0QzWwg@mail.gmail.com> <552406E4.50600@candelatech.com>
In-Reply-To: <552406E4.50600@candelatech.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/07/2015 09:33 AM, Ben Greear wrote:
> On 04/06/2015 10:17 PM, Janusz Dziedzic wrote:
>> On 7 April 2015 at 07:12, Michal Kazior <michal.kazior@tieto.com> wrote:
>>> On 7 April 2015 at 02:39, Ben Greear <greearb@candelatech.com> wrote:
>>>> Has anyone tried running ath10k to ath9k IBSS?
>>>>
>>>> I'm trying this with a somewhat hacked 4.0-rc6 kernel,
>>>> and latest wpa_supplicant.
>>>>
>>>> ath9k to ath9k works with and without encryption, and ath10k to ath10k works
>>>> (w/out encryption at least).
>>>>
>>>> But, if I try to tell ath10k to connect to ath9k, then the ath9k reports
>>>> interface combinations
>>>> issues and will not associate.  I've added some debug, and the issue is the
>>>> 'num==0' part here:
>>>>
>>>>
>>>> int cfg80211_check_combinations(struct wiphy *wiphy,
>>>>                                 const int num_different_channels,
>>>>                                 const u8 radar_detect,
>>>>                                 const int iftype_num[NUM_NL80211_IFTYPES])
>>>> {
>>>>         int err, num = 0;
>>>>
>>>>         err = cfg80211_iter_combinations(wiphy, num_different_channels,
>>>>                                          radar_detect, iftype_num,
>>>>                                          cfg80211_iter_sum_ifcombs, &num);
>>>>         if (err) {
>>>>                 pr_info("cfg-comb-check: failed to iterate combinations\n");
>>>>                 return err;
>>>>         }
>>>>         if (num == 0) {
>>>>                 pr_info("cfg-comb-check: iter-combinations returned
>>>> num==0\n");
>>>>                 return -EBUSY;
>>>>         }
>>>>
>>>>         return 0;
>>>> }
>>>> EXPORT_SYMBOL(cfg80211_check_combinations);
>>>>
>>>> There should be exactly one interface on this radio that is admin-up, and it
>>>> is the
>>>> one that I am trying to make run in adhoc mode.
>>>>
>>>> Any ideas on this?
>>>
>>> IBSS with non-fixed or dfs channel? It would bump
>>> num_different_channels and yield no valid combinations. But why would
>>> that work fine with, e.g. ath9k-ath9k otherwise - no idea.
>>>
>>
>> Check this discussion (ibss + p2p_device - this could be one you hit).
>> http://www.spinics.net/lists/linux-wireless/msg134447.html
> 
> That patch is in my tree already, so must be something else.

First, I was wrong...I have some bug (or maybe user-error) and
I had 2 VAP running on this radio when I did not think they were
running.

The combination check is failing because this check below is failing for the third set of combinations:

int cfg80211_iter_combinations(struct wiphy *wiphy,
			       const int num_different_channels,
			       const u8 radar_detect,
			       const int iftype_num[NUM_NL80211_IFTYPES],
			       void (*iter)(const struct ieee80211_iface_combination *c,
					    void *data),
			       void *data)
.....
		if (num_interfaces > c->max_interfaces) {
			pr_info("%i: iter-comb, num > max: %d > %d\n",
				i, num_interfaces, c->max_interfaces);
			continue;
		}

In my case, num_interfaces is 3 here when I get to i == 2.

'iw phy wiphy1 info' has this:

	valid interface combinations:
		 * #{ managed } <= 2048, #{ AP, mesh point } <= 8, #{ P2P-client, P2P-GO } <= 1,
		   total <= 2048, #channels <= 1, STA/AP BI must match
		 * #{ WDS } <= 2048,
		   total <= 2048, #channels <= 1, STA/AP BI must match
		 * #{ IBSS, AP, mesh point } <= 1,
		   total <= 1, #channels <= 1, STA/AP BI must match, radar detect widths: { 20 MHz (no HT), 20 MHz }

For the third set, why limit to a single interface.  Can't we run IBSS + AP
(and plus stations, for that matter), all at the same time with ath9k?

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

