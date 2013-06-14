Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:41009 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab3FNVjy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Jun 2013 17:39:54 -0400
Received: by mail-wg0-f52.google.com with SMTP id b12so917228wgh.19
        for <linux-wireless@vger.kernel.org>; Fri, 14 Jun 2013 14:39:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1370953615.8356.34.camel@jlt4.sipsolutions.net>
References: <1370280859-9860-1-git-send-email-ashok@cozybit.com> <1370953615.8356.34.camel@jlt4.sipsolutions.net>
From: Ashok Nagarajan <ashok@cozybit.com>
Date: Fri, 14 Jun 2013 14:39:32 -0700
Message-ID: <CACcxo+o2qHZxLPjtqqctmFb7-BuNkELfdK0_MXQNCDR-KmbLcg@mail.gmail.com> (sfid-20130614_233956_472934_33FCE656)
Subject: Re: [PATCH 1/2] iw: Allow user to provide freq during mesh join
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	John Linville <linville@tuxdriver.com>,
	devel@lists.open80211s.org, Javier Cardona <javier@cozybit.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 11, 2013 at 5:26 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2013-06-03 at 10:34 -0700, Ashok Nagarajan wrote:
>> Allow user to configure frequency and channel type during mesh join command.
>>
>> Signed-off-by: Ashok Nagarajan <ashok@cozybit.com>
>> ---
>>  mesh.c |   49 ++++++++++++++++++++++++++++++++++++++++++++++---
>>  1 files changed, 46 insertions(+), 3 deletions(-)
>>
>> diff --git a/mesh.c b/mesh.c
>> index 5a09b62..ec202c9 100644
>> --- a/mesh.c
>> +++ b/mesh.c
>> @@ -431,8 +431,18 @@ static int join_mesh(struct nl80211_state *state, struct nl_cb *cb,
>>  {
>>       struct nlattr *container;
>>       float rate;
>> -     int bintval, dtim_period;
>> +     int bintval, dtim_period, i;
>>       char *end;
>> +     static const struct {
>> +             const char *name;
>> +             unsigned int val;
>> +     } htmap[] = {
>> +             { .name = "HT20", .val = NL80211_CHAN_HT20, },
>> +             { .name = "HT40+", .val = NL80211_CHAN_HT40PLUS, },
>> +             { .name = "HT40-", .val = NL80211_CHAN_HT40MINUS, },
>> +             { .name = "NOHT", .val = NL80211_CHAN_NO_HT, },
>> +     };
>
> I think you should use chandefs already, to allow for VHT. Also, it'd be
> good to refactor the channel parsing for this, monitor and IBSS (though
> I wonder why I haven't done that already?)
>

Sure. That makes sense. I will get that in the next version.

Thanks,
Ashok
> johannes
>



--
Ashok Raj Nagarajan,
cozybit Inc.
http://www.cozybit.com
