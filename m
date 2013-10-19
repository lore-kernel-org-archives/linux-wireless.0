Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:57672 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052Ab3JSMjH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 19 Oct 2013 08:39:07 -0400
Received: by mail-lb0-f178.google.com with SMTP id o14so64277lbi.37
        for <linux-wireless@vger.kernel.org>; Sat, 19 Oct 2013 05:39:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1382017495.14410.4.camel@jlt4.sipsolutions.net>
References: <1381773079-2678-1-git-send-email-janusz.dziedzic@tieto.com>
	<1382017495.14410.4.camel@jlt4.sipsolutions.net>
Date: Sat, 19 Oct 2013 14:39:05 +0200
Message-ID: <CALhHN=rq2teB0etcg7c-LbjSHgg8DnOtuR-daEVo4J77ceY6iQ@mail.gmail.com> (sfid-20131019_143928_608440_7BB7D844)
Subject: Re: [PATCH] mac80211_hwsim: Add iface comb for DFS
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 October 2013 15:44, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2013-10-14 at 19:51 +0200, Janusz Dziedzic wrote:
>> Add iface combination that allow DFS support.
>> Add also debugfs dfs_simulate_radar file that
>> can be used to simulate radar event.
>> This could be usefull for mac80211/cfg80211/
>
> typo: useful
>
>> @@ -1714,6 +1716,7 @@ static void mac80211_hwsim_free(void)
>>
>>       list_for_each_entry_safe(data, tmpdata, &tmplist, list) {
>>               debugfs_remove(data->debugfs_group);
>> +             debugfs_remove(data->debugfs_radar);
>
> I think it would be good to convert to debugfs_remove_recursive first -
> that avoids the need for the new dentry pointer as well as the remove
> here. Can you do that (as a separate patch)?
>
Sure, I will prepare patch.

>> +static int hwsim_write_simulate_radar(void *dat, u64 val)
>> +{
>> +     struct mac80211_hwsim_data *data = dat;
>> +
>> +     ieee80211_radar_detected(data->hw);
>> +
>> +     return 0;
>> +}
>> +
>> +DEFINE_SIMPLE_ATTRIBUTE(hwsim_simulate_radar, NULL,
>> +                     hwsim_write_simulate_radar, "%llu\n");
>
> Does the u64 make sense? Probably doesn't matter much, but seems weird
> to be so specific for a file that really doesn't care about the value?
Yes this doesn't matter much. I am not sure what put there.

BR
Janusz
