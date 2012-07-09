Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:36515 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab2GIQz3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 12:55:29 -0400
Received: by yhmm54 with SMTP id m54so11087575yhm.19
        for <linux-wireless@vger.kernel.org>; Mon, 09 Jul 2012 09:55:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1341852841.4455.51.camel@jlt3.sipsolutions.net>
References: <1341852581-8456-1-git-send-email-arik@wizery.com> <1341852841.4455.51.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Mon, 9 Jul 2012 19:55:13 +0300
Message-ID: <CA+XVXfeHHBUnOp4hxt=Fh-6w530MMFffTVspX8nF7T3tTbvLNg@mail.gmail.com> (sfid-20120709_185532_317572_6DCE5D50)
Subject: Re: [PATCH] mac80211: fix invalid band deref building preq IEs
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 9, 2012 at 7:54 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Mon, 2012-07-09 at 19:49 +0300, Arik Nemtsov wrote:
>> The function building probe-request IEs does not validate the band is
>> supported before dereferencing it. This can result in a panic when
>> all bands are traversed, as done during sched-scan start.
>>
>> Warn when this happens and return an empty probe request. Also fix
>> sched-scan to not waste memory on unsupported bands.
>>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> ---
>> This is not cc stable since the panic only started happening once
>> the 60Ghz band was added. Apparently all sched-scan drivers supported
>> all possible bands until then.
>>
>>
>>  net/mac80211/scan.c |    3 +++
>>  net/mac80211/util.c |    2 ++
>>  2 files changed, 5 insertions(+)
>>
>> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
>> index 379f178..1ff04f6 100644
>> --- a/net/mac80211/scan.c
>> +++ b/net/mac80211/scan.c
>> @@ -928,6 +928,9 @@ int ieee80211_request_sched_scan_start(struct ieee80211_sub_if_data *sdata,
>>       }
>>
>>       for (i = 0; i < IEEE80211_NUM_BANDS; i++) {
>> +             if (!local->hw.wiphy->bands[i])
>> +                     continue;
>> +
>>               local->sched_scan_ies.ie[i] = kzalloc(2 +
>>                                                     IEEE80211_MAX_SSID_LEN +
>>                                                     local->scan_ies_len +
>> diff --git a/net/mac80211/util.c b/net/mac80211/util.c
>> index 64493a7..503412a 100644
>> --- a/net/mac80211/util.c
>> +++ b/net/mac80211/util.c
>> @@ -999,6 +999,8 @@ int ieee80211_build_preq_ies(struct ieee80211_local *local, u8 *buffer,
>>       int ext_rates_len;
>>
>>       sband = local->hw.wiphy->bands[band];
>> +     if (!WARN_ON_ONCE(sband))
>> +             return 0;
>
> That's not right :-)

heh. yea I guess I didn't test it with the WARN_ON :)
