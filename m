Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:38039 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807Ab2EDGpw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 02:45:52 -0400
Received: by yenm10 with SMTP id m10so2001207yen.19
        for <linux-wireless@vger.kernel.org>; Thu, 03 May 2012 23:45:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPjQAd8YK9Zy17z5KQ2uxVk7mH2qK-SLT3UObbU46NTkGv-cDA@mail.gmail.com>
References: <1336106215-7431-1-git-send-email-yeohchunyeow@gmail.com>
	<CAPjQAd8YK9Zy17z5KQ2uxVk7mH2qK-SLT3UObbU46NTkGv-cDA@mail.gmail.com>
Date: Fri, 4 May 2012 14:45:51 +0800
Message-ID: <CAEFj984a030KGmhkfaDdDKGXmW_+FKyi8TJiGZ=doS2ZhX3CqQ@mail.gmail.com> (sfid-20120504_084556_778011_297ECB40)
Subject: Re: [PATCH] fix the increment of unicast/multicast counters for
 forwarded PREQ
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Javier Cardona <javier@cozybit.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@lists.open80211s.org" <devel@lists.open80211s.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Javier

Will do.

Chun-Yeow

On Fri, May 4, 2012 at 2:17 PM, Javier Cardona <javier@cozybit.com> wrote:
> Hi Yeoh,
>
>
> On Friday, May 4, 2012, Chun-Yeow Yeoh wrote:
>>
>> Forwarded PREQ is either unicast or multicast. The appropriate counters
>> should be incremented accordingly.
>>
>> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
>> ---
>>  net/mac80211/mesh_hwmp.c |    5 ++++-
>>  1 files changed, 4 insertions(+), 1 deletions(-)
>>
>> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
>> index 503016f..f0695e5 100644
>> --- a/net/mac80211/mesh_hwmp.c
>> +++ b/net/mac80211/mesh_hwmp.c
>> @@ -603,7 +603,10 @@ static void hwmp_preq_frame_process(struct
>> ieee80211_sub_if_data *sdata,
>>                                hopcount, ttl, cpu_to_le32(lifetime),
>>                                cpu_to_le32(metric), cpu_to_le32(preq_id),
>>                                sdata);
>> -               ifmsh->mshstats.fwded_mcast++;
>> +               if (da != broadcast_addr)
>> +                       ifmsh->mshstats.fwded_unicast++;
>> +               else
>> +                       ifmsh->mshstats.fwded_mcast++;
>>                ifmsh->mshstats.fwded_frames++;
>>        }
>>  }
>> --
>> 1.7.0.4
>
>
> I think you should check for multicast, not just bcast.  And use the
> existing helper function to do so.
>
> Javier
>
>
> --
> Javier Cardona
> cozybit Inc.
> http://www.cozybit.com
