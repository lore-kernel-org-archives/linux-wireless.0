Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gg0-f174.google.com ([209.85.161.174]:47478 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab2HBScq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Aug 2012 14:32:46 -0400
Received: by ggnl2 with SMTP id l2so1792435ggn.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Aug 2012 11:32:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1343889136.4458.2.camel@jlt3.sipsolutions.net>
References: <1343855731-27920-1-git-send-email-thomas@cozybit.com> <1343889136.4458.2.camel@jlt3.sipsolutions.net>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Thu, 2 Aug 2012 11:32:24 -0700
Message-ID: <CAG6hwVNYeGCW_kseQhfu_pEYAM+xU1sGEQmaOiJeGQ30eioKJA@mail.gmail.com> (sfid-20120802_203249_727462_850E703A)
Subject: Re: [PATCH] mac80211: improve cleanup when leaving mesh
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 1, 2012 at 11:32 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Wed, 2012-08-01 at 14:15 -0700, Thomas Pedersen wrote:
>> A couple improvements to cleanup when stopping a mesh:
>>
>>  - flush mpath entries.
>>  - flush sta entries per-sdata so we don't remove entries belonging to
>>    other vifs on the same hw.
>>
>> Signed-off-by: Thomas Pedersen <thomas@cozybit.com>
>> ---
>>  net/mac80211/mesh.c |    3 ++-
>>  1 files changed, 2 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
>> index 764593d..21c02c6 100644
>> --- a/net/mac80211/mesh.c
>> +++ b/net/mac80211/mesh.c
>> @@ -618,7 +618,8 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
>>
>>       ifmsh->mesh_id_len = 0;
>>       ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
>> -     sta_info_flush(local, NULL);
>> +     sta_info_flush(local, sdata);
>> +     mesh_path_flush_by_iface(sdata);
>
> We can remove ieee80211_clean_sdata() then, right?

Yes, looks like any mesh cleanup can happen in the netdev ops. Thanks!

Thomas
