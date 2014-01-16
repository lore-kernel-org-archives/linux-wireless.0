Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34255 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751520AbaAPLlh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Jan 2014 06:41:37 -0500
Received: by mail-bk0-f46.google.com with SMTP id u15so1117119bkz.5
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jan 2014 03:41:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB3XZEe0yM2F4C5DbWE+BjDVn92Sv_=k5EiUpokZjF1QugdSWw@mail.gmail.com>
References: <1389787494-7361-1-git-send-email-michal.kazior@tieto.com>
	<1389787494-7361-10-git-send-email-michal.kazior@tieto.com>
	<CAB3XZEe0yM2F4C5DbWE+BjDVn92Sv_=k5EiUpokZjF1QugdSWw@mail.gmail.com>
Date: Thu, 16 Jan 2014 12:41:33 +0100
Message-ID: <CA+BoTQnW+MRk-KQxkwHQ8WFhLERqTu98QWwKSw654FPAp0wBHg@mail.gmail.com> (sfid-20140116_124140_652455_029473B0)
Subject: Re: [RFC 9/9] mac80211: implement multi-interface CSA
From: Michal Kazior <michal.kazior@tieto.com>
To: Eliad Peller <eliad@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 January 2014 12:04, Eliad Peller <eliad@wizery.com> wrote:
> On Wed, Jan 15, 2014 at 2:04 PM, Michal Kazior <michal.kazior@tieto.com> wrote:
>> This implements a fairly simple multi-interface
>> CSA. It doesn't support multiple channel
>> contexts so it doesn't support multi-channel.
>>
>> Once a CSA is started other CSA requests are
>> denied until the first one is completed. A single
>> CSA may affect multiple interfaces. CSA can happen
>> only if it all target CSA chandefs are compatible
>> and it affects all interfaces are sharing a single
>> channel context exclusively.
>>
>> A new worker is introduced: csa_complete_work
>> which is used to account per-interface countdowns
>> and issue the actual channel switch after last
>> interface completes its CSA.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> ---
> [...]
>
>>
>> +static int ieee80211_ap_beacon_presp_backup(struct ieee80211_sub_if_data *sdata)
>> +{
>> +       struct beacon_data *beacon;
>> +       struct probe_resp *probe_resp;
>> +
>> +       beacon = sdata_dereference(sdata->u.ap.beacon, sdata);
>> +       if (beacon) {
>> +               sdata->u.ap.prev_beacon = kmemdup(beacon, sizeof(beacon) +
>> +                                                 beacon->head_len +
>> +                                                 beacon->tail_len, GFP_KERNEL);
>> +               if (!sdata->u.ap.prev_beacon)
>> +                       return -ENOMEM;
>> +       }
>> +
> you must also update the pointers here...

You're right, thanks!


Michał
