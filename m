Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:58186 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754575AbaBUJrH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Feb 2014 04:47:07 -0500
Received: by mail-lb0-f174.google.com with SMTP id l4so2148368lbv.5
        for <linux-wireless@vger.kernel.org>; Fri, 21 Feb 2014 01:47:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1392972748.4346.37.camel@jlt4.sipsolutions.net>
References: <1392231266-28479-1-git-send-email-janusz.dziedzic@tieto.com>
	<1392972748.4346.37.camel@jlt4.sipsolutions.net>
Date: Fri, 21 Feb 2014 10:47:06 +0100
Message-ID: <CALhHN=ovcEvFsYSjc_dZSS0j0Zmiq-y6y2Kwo5RK1Qpb456MbQ@mail.gmail.com> (sfid-20140221_104720_849661_4CEBC016)
Subject: Re: [PATCH 1/4] cfg80211: regulatory, introduce DFS CAC time
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 21 February 2014 09:52, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2014-02-12 at 19:54 +0100, Janusz Dziedzic wrote:
>
>> +++ b/include/net/regulatory.h
>> @@ -155,6 +155,7 @@ struct ieee80211_reg_rule {
>>       struct ieee80211_freq_range freq_range;
>>       struct ieee80211_power_rule power_rule;
>>       u32 flags;
>> +     u32 dfs_cac_ms;
>>  };
>
> Does that really have to be per channel? That's a significant investment
> into bss size since we have a lot of channel structs.
>
This seems easiest way to handle ETSI VHT80/40 case for channels with
different CAC time (eg):
VHT80:
- 116 (60s)
- 120 (600s)
- 124 (600s)
- 128 (600s)

VHT40/HT40:
- 132 (600s)
- 136 (60s)

>> +     if (rule1->dfs_cac_ms > rule2->dfs_cac_ms)
>> +             intersected_rule->dfs_cac_ms = rule1->dfs_cac_ms;
>> +     else
>> +             intersected_rule->dfs_cac_ms = rule2->dfs_cac_ms;
>
> please just use max() or max_t() if needed (shouldn't be)
>
OK

>> @@ -2245,9 +2258,10 @@ static void print_rd_rules(const struct ieee80211_regdomain *rd)
>>       const struct ieee80211_reg_rule *reg_rule = NULL;
>>       const struct ieee80211_freq_range *freq_range = NULL;
>>       const struct ieee80211_power_rule *power_rule = NULL;
>> -     char bw[32];
>> +     const int size = 32;
>> +     char bw[size], cac_time[size];
>
> I don't like that, size is const but it seems likely that sparse/smatch
> may complain. I've already changed some of the below code to just use
> sizeof(bw), please do that here as well.
>
OK

BR
Janusz
