Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50396 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755158Ab1KHQFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 11:05:09 -0500
Received: by bke11 with SMTP id 11so532973bke.19
        for <linux-wireless@vger.kernel.org>; Tue, 08 Nov 2011 08:05:07 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1320766360.24797.5.camel@jlt3.sipsolutions.net>
References: <1320762928-6782-1-git-send-email-arik@wizery.com>
 <1320762928-6782-2-git-send-email-arik@wizery.com> <1320766360.24797.5.camel@jlt3.sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Tue, 8 Nov 2011 18:04:50 +0200
Message-ID: <CA+XVXffzmfOPEqJ=LhAhXwAjAjBJKtQOnOsRMHW8stodm0saFw@mail.gmail.com> (sfid-20111108_170513_542387_2780E4E3)
Subject: Re: [PATCH v3 2/3] nl80211: Pass probe response data to drivers
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 8, 2011 at 17:32, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2011-11-08 at 16:35 +0200, Arik Nemtsov wrote:
>> Pass probe-response data from usermode via beacon parameters.
>>
>> Signed-off-by: Guy Eilam <guy@wizery.com>
>> Signed-off-by: Arik Nemtsov <arik@wizery.com>
>> ---
>> v1->3:
>> Set the probe response data as part of the addset_beacon function, instead
>> of set_bss. This makes more sense since the probe response is always
>> updated with the beacon.
>>
>> include/linux/nl80211.h |    4 ++++
>>  include/net/cfg80211.h  |    4 ++++
>>  net/wireless/nl80211.c  |    9 +++++++++
>>  3 files changed, 17 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/nl80211.h b/include/linux/nl80211.h
>> index e74afc4..3fa03b3 100644
>> --- a/include/linux/nl80211.h
>> +++ b/include/linux/nl80211.h
>> @@ -1114,6 +1114,8 @@ enum nl80211_commands {
>>   *   In addition this attribute holds a bitmap of the supported protocols
>>   *   for offloading using &enum nl80211_probe_resp_offload_support_attr.
>>   *
>> + * @NL80211_ATTR_PROBE_RESP: Probe Response template data
>> + *
>
> That should say what kind of data is expected -- I think a full frame in
> this case? Should it really be a full frame though? Maybe ath6kl
> requires something else and we can make this somehow compatible with
> both?

I can be more verbose in the description, sure. The probe-resp IEs are
a subset of the full probe-resp template, so I guess we could give ath6kl a
start_pos, end_pos into the full probe_resp buffer.

But IMHO it's cleaner the way it is now.
