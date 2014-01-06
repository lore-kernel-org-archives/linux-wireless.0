Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f172.google.com ([209.85.223.172]:41000 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093AbaAFSEY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Jan 2014 13:04:24 -0500
Received: by mail-ie0-f172.google.com with SMTP id qd12so19209278ieb.31
        for <linux-wireless@vger.kernel.org>; Mon, 06 Jan 2014 10:04:24 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20140106150716.GA5358@magnum.frso.rivierawaves.com>
References: <529CF2D6.1080008@gmail.com> <1386017965-13641-12-git-send-email-egrumbach@gmail.com>
 <20140106150716.GA5358@magnum.frso.rivierawaves.com>
From: Eyal Shapira <eyal@wizery.com>
Date: Mon, 6 Jan 2014 20:04:03 +0200
Message-ID: <CAF8O4-y4K_0G=3e2fcNzfJuGSz6WwrUU3EyL1H3B7Z6-koGFyw@mail.gmail.com> (sfid-20140106_190427_656878_444FC978)
Subject: Re: [PATCH 12/13] iwlwifi: mvm: rs: overhaul search cycle state machine
To: Karl Beldan <karl.beldan@gmail.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless@vger.kernel.org,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 6, 2014 at 5:07 PM, Karl Beldan <karl.beldan@gmail.com> wrote:
> On Mon, Dec 02, 2013 at 10:59:24PM +0200, Emmanuel Grumbach wrote:
>> From: Eyal Shapira <eyal@wizery.com>
>>
>> Rewrite the search cycle state machine to use a more data
>> oriented approach where the different Tx columns (configs)
>> limitations and next columns to search are reprsented in
>> tables which are easy to change. This overhaul also includes
>> several major fixes:
>>
>> 1. Prevent going back to a specific Tx column in a search
>> cycle if it was already explored.
>>
>> 2. Avoid switching to a Tx column that doesn't have any chance
>> if it performs perfectly to beat the current throughput we're
>> getting.
>>
>> These issues were degrading throughput as they were causing
>> switching to "bad" Tx columns.
>>
>> Signed-off-by: Eyal Shapira <eyal@wizery.com>
>> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
>> ---
>>  drivers/net/wireless/iwlwifi/mvm/rs.c |  921 +++++++++++++++------------------
>>  drivers/net/wireless/iwlwifi/mvm/rs.h |   64 +--
>>  2 files changed, 458 insertions(+), 527 deletions(-)
>>
>> @@ -1772,7 +1712,7 @@ static void rs_rate_scale_perform(struct iwl_mvm *mvm,
> [...]
>> -     if (done_search && !lq_sta->stay_in_tbl) {
>> +     if (done_search && lq_sta->rs_state == RS_STATE_SEARCH_CYCLE_ENDED) {
>>               /* If the "active" (non-search) mode was legacy,
> [...]
>
> Hi,
>
> Trying -testing right now on my laptop and this commit broke aggregation.
>

Thanks Karl for the report.
I'm seeing Tx aggregation. Note that it doesn't start off immediately
but only after enough traffic went through for us to explore different
Tx configurations.

Some questions:
1. How do you see aggregation is broken ? sniffer or just lower
throughput you're getting ?
2. What's the chip ?
3. Do you connect in 11n or 11ac ?
4. Any chance you can set module parameter debug=0x04100000 and send the logs ?
Configuring IWLWIFI_DEBUG is required.

> I haven't looked at the code but this seemed to help :
> -       if (done_search && lq_sta->rs_state == RS_STATE_SEARCH_CYCLE_ENDED) {
> +       if (done_search && lq_sta->rs_state != RS_STATE_STAY_IN_COLUMN)

This wouldn't be good as it might get us stuck on non optimal Tx
configurations before exploring other better ones.

Thanks,
Eyal
