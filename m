Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f176.google.com ([209.85.220.176]:48288 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaGCMg3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jul 2014 08:36:29 -0400
Received: by mail-vc0-f176.google.com with SMTP id ik5so136233vcb.7
        for <linux-wireless@vger.kernel.org>; Thu, 03 Jul 2014 05:36:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140628205414.GA17825@localhost>
References: <1403987726-17576-1-git-send-email-me@bobcopeland.com>
	<20140628205414.GA17825@localhost>
Date: Thu, 3 Jul 2014 20:36:28 +0800
Message-ID: <CAEFj987rJW6bH7bZQKT1W2RzMVB2BnOyWABRQRHwbrCSuOAUig@mail.gmail.com> (sfid-20140703_143634_510932_6ACC7F91)
Subject: Re: [PATCH 1/2] mac80211: mesh_plink: handle confirm frames with new plid
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: "devel@lists.open80211s.org" <devel@lists.open80211s.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Bob

What is the consequence if we don't handle this case? Is the peer
going to do the re-auth again?

Regards,
Chun-Yeow

On Sun, Jun 29, 2014 at 4:54 AM, Bob Copeland <me@bobcopeland.com> wrote:
> [oops, +linux-wireless]
> On Sat, Jun 28, 2014 at 04:35:25PM -0400, Bob Copeland wrote:
>> The 802.11 standard says when processing a plink confirm
>> frame:
>>
>> "If the peerLinkID in the mesh peering instance has not been
>> set, the Local Link ID field of the Mesh Peering Confirm
>> request shall be copied into the peerLinkID in the mesh
>> peering instance."
>>
>> We were only doing this when receiving an open peering frame,
>> but it could happen that the open frame gets lost and so we
>> should handle this case rather than rejecting the confirm and
>> failing the whole peering process.
>>
>> Reported-by: Yu Niiro <yu.niiro@gmail.com>
>> Signed-off-by: Bob Copeland <me@bobcopeland.com>
>> ---
>>  net/mac80211/mesh_plink.c | 7 ++++++-
>>  1 file changed, 6 insertions(+), 1 deletion(-)
>>
>> diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
>> index 63b8741..c47194d 100644
>> --- a/net/mac80211/mesh_plink.c
>> +++ b/net/mac80211/mesh_plink.c
>> @@ -959,7 +959,8 @@ mesh_plink_get_event(struct ieee80211_sub_if_data *sdata,
>>               if (!matches_local)
>>                       event = CNF_RJCT;
>>               if (!mesh_plink_free_count(sdata) ||
>> -                 (sta->llid != llid || sta->plid != plid))
>> +                 sta->llid != llid ||
>> +                 (sta->plid && sta->plid != plid))
>>                       event = CNF_IGNR;
>>               else
>>                       event = CNF_ACPT;
>> @@ -1080,6 +1081,10 @@ mesh_process_plink_frame(struct ieee80211_sub_if_data *sdata,
>>               goto unlock_rcu;
>>       }
>>
>> +     /* 802.11-2012 13.3.7.2 - update plid on CNF if not set */
>> +     if (!sta->plid && event == CNF_ACPT)
>> +             sta->plid = plid;
>> +
>>       changed |= mesh_plink_fsm(sdata, sta, event);
>>
>>  unlock_rcu:
>> --
>> 2.0.0.rc2
>>
>
> --
> Bob Copeland %% www.bobcopeland.com
> _______________________________________________
> Devel mailing list
> Devel@lists.open80211s.org
> http://lists.open80211s.org/cgi-bin/mailman/listinfo/devel
