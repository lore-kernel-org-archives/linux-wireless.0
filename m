Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36555 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755580Ab2EGI6M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 May 2012 04:58:12 -0400
Received: by yenm10 with SMTP id m10so3456260yen.19
        for <linux-wireless@vger.kernel.org>; Mon, 07 May 2012 01:58:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1336376603.4325.3.camel@jlt3.sipsolutions.net>
References: <1336106215-7431-1-git-send-email-yeohchunyeow@gmail.com>
	<1336376603.4325.3.camel@jlt3.sipsolutions.net>
Date: Mon, 7 May 2012 16:58:11 +0800
Message-ID: <CAEFj9857DWGCcnF20nKYEDb0_p1K_iYLR1F=oLNAx6NjwPQE9w@mail.gmail.com> (sfid-20120507_105816_074718_5AE6DC15)
Subject: Re: [PATCH] fix the increment of unicast/multicast counters for
 forwarded PREQ
From: Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, javier@cozybit.com,
	linville@tuxdriver.com, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi, Johannes

If the destination address is not broadcast frame, the number of
forwarded unicast frame is increased. And the other way round. Not
correct?

+		if (!is_multicast_ether_addr(da))
+			ifmsh->mshstats.fwded_unicast++;
+		else
+			ifmsh->mshstats.fwded_mcast++;

Regards,
Chun-Yeow

On Mon, May 7, 2012 at 3:43 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2012-05-04 at 12:36 +0800, Chun-Yeow Yeoh wrote:
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
>> @@ -603,7 +603,10 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
>>                               hopcount, ttl, cpu_to_le32(lifetime),
>>                               cpu_to_le32(metric), cpu_to_le32(preq_id),
>>                               sdata);
>> -             ifmsh->mshstats.fwded_mcast++;
>> +             if (da != broadcast_addr)
>
> In addition to what Javier said. Err. Think about this comparison again.
>
> johannes
>
