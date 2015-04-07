Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:33608 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbbDGFRH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Apr 2015 01:17:07 -0400
Received: by ignm3 with SMTP id m3so2678091ign.0
        for <linux-wireless@vger.kernel.org>; Mon, 06 Apr 2015 22:17:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQ=UUbfi5D9ZbN5Rxb20f5xpzuYQMo392=P++Qyhz8Hs+w@mail.gmail.com>
References: <5523273F.4060803@candelatech.com>
	<CA+BoTQ=UUbfi5D9ZbN5Rxb20f5xpzuYQMo392=P++Qyhz8Hs+w@mail.gmail.com>
Date: Tue, 7 Apr 2015 07:17:06 +0200
Message-ID: <CALhHN=oCvQ=SvobWTvc3geK-66k2+YDzB1HqSguCxTeV0QzWwg@mail.gmail.com> (sfid-20150407_071712_024288_B4E85940)
Subject: Re: ath10k to ath9k IBSS, ath9k has interface-combinations issue
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Ben Greear <greearb@candelatech.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 April 2015 at 07:12, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 7 April 2015 at 02:39, Ben Greear <greearb@candelatech.com> wrote:
>> Has anyone tried running ath10k to ath9k IBSS?
>>
>> I'm trying this with a somewhat hacked 4.0-rc6 kernel,
>> and latest wpa_supplicant.
>>
>> ath9k to ath9k works with and without encryption, and ath10k to ath10k works
>> (w/out encryption at least).
>>
>> But, if I try to tell ath10k to connect to ath9k, then the ath9k reports
>> interface combinations
>> issues and will not associate.  I've added some debug, and the issue is the
>> 'num==0' part here:
>>
>>
>> int cfg80211_check_combinations(struct wiphy *wiphy,
>>                                 const int num_different_channels,
>>                                 const u8 radar_detect,
>>                                 const int iftype_num[NUM_NL80211_IFTYPES])
>> {
>>         int err, num = 0;
>>
>>         err = cfg80211_iter_combinations(wiphy, num_different_channels,
>>                                          radar_detect, iftype_num,
>>                                          cfg80211_iter_sum_ifcombs, &num);
>>         if (err) {
>>                 pr_info("cfg-comb-check: failed to iterate combinations\n");
>>                 return err;
>>         }
>>         if (num == 0) {
>>                 pr_info("cfg-comb-check: iter-combinations returned
>> num==0\n");
>>                 return -EBUSY;
>>         }
>>
>>         return 0;
>> }
>> EXPORT_SYMBOL(cfg80211_check_combinations);
>>
>> There should be exactly one interface on this radio that is admin-up, and it
>> is the
>> one that I am trying to make run in adhoc mode.
>>
>> Any ideas on this?
>
> IBSS with non-fixed or dfs channel? It would bump
> num_different_channels and yield no valid combinations. But why would
> that work fine with, e.g. ath9k-ath9k otherwise - no idea.
>

Check this discussion (ibss + p2p_device - this could be one you hit).
http://www.spinics.net/lists/linux-wireless/msg134447.html

BR
Janusz
