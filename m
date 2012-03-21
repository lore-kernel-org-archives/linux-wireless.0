Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:55229 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424Ab2CURjJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Mar 2012 13:39:09 -0400
Received: by vcqp1 with SMTP id p1so1244981vcq.19
        for <linux-wireless@vger.kernel.org>; Wed, 21 Mar 2012 10:39:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAPjQAd_v+jez4woV+=rp3LB8QTgPDT=CX0oixjcu7=fUZscm6w@mail.gmail.com>
References: <1332333182-11941-1-git-send-email-yeohchunyeow@gmail.com> <CAPjQAd_v+jez4woV+=rp3LB8QTgPDT=CX0oixjcu7=fUZscm6w@mail.gmail.com>
From: Thomas Pedersen <thomas@cozybit.com>
Date: Wed, 21 Mar 2012 10:33:18 -0700
Message-ID: <CAG6hwVPnTvKDdPvcWi682DJhFOXMw2fR+o_Vxt48UNfv1Uy5Ug@mail.gmail.com> (sfid-20120321_183937_528044_723A8830)
Subject: Re: [PATCH] mac80211: fix the RANN propagation issues
To: Javier Cardona <javier@cozybit.com>
Cc: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	linville@tuxdriver.com, devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
>> index f80a9e3..fcfebc7 100644
>> --- a/net/mac80211/mesh_hwmp.c
>> +++ b/net/mac80211/mesh_hwmp.c
>> @@ -88,6 +88,7 @@ static inline u32 u16_field_get(u8 *preq_elem, int offset, bool ae)
>>  #define MSEC_TO_TU(x) (x*1000/1024)
>>  #define SN_GT(x, y) ((long) (y) - (long) (x) < 0)
>>  #define SN_LT(x, y) ((long) (x) - (long) (y) < 0)
>> +#define SN_EQ(x, y) ((long) (x) - (long) (y) == 0)
>
> I never understood the point of these macros so I'm not too happy
> about seeing another one creep in :)
> Can someone explain why we need them?  Why not just use good
> old-fashioned '=='  (and '<' or '>')?
>

I suggested using these macros to remain consistent with other places
in the code. Looking at them again, I don't see how "u32 < u32" , etc.
might fail. If no one has any insight into why this might be a bug,
just use ordinary conditionals for now. Later (if you feel like it),
you can submit a patch removing these macros.

>>  #define net_traversal_jiffies(s) \
>>        msecs_to_jiffies(s->u.mesh.mshcfg.dot11MeshHWMPnetDiameterTraversalTime)
>> @@ -732,11 +733,12 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
>>                                struct ieee80211_rann_ie *rann)
>>  {
>>        struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
>> +       struct ieee80211_local *local = sdata->local;
>> +       struct sta_info *sta;
>>        struct mesh_path *mpath;
>>        u8 ttl, flags, hopcount;
>>        u8 *orig_addr;
>> -       u32 orig_sn, metric;
>> -       u32 interval = ifmsh->mshcfg.dot11MeshHWMPRannInterval;
>> +       u32 orig_sn, metric, metric_txsta, interval;
>>        bool root_is_gate;
>>
>>        ttl = rann->rann_ttl;
>> @@ -749,6 +751,7 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
>>        root_is_gate = !!(flags & RANN_FLAG_IS_GATE);
>>        orig_addr = rann->rann_addr;
>>        orig_sn = le32_to_cpu(rann->rann_seq);
>> +       interval = le32_to_cpu(rann->rann_interval);
>>        hopcount = rann->rann_hopcount;
>>        hopcount++;
>>        metric = le32_to_cpu(rann->rann_metric);
>> @@ -761,6 +764,14 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
>>                        orig_addr, mgmt->sa, root_is_gate);
>>
>>        rcu_read_lock();
>> +       sta = sta_info_get(sdata, mgmt->sa);
>> +       if (!sta) {
>> +               rcu_read_unlock();
>> +               return;
>> +       }
>> +
>> +       metric_txsta = airtime_link_metric_get(local, sta);
>> +
>>        mpath = mesh_path_lookup(orig_addr, sdata);
>>        if (!mpath) {
>>                mesh_path_add(orig_addr, sdata);
>> @@ -780,14 +791,16 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
>>                mesh_queue_preq(mpath, PREQ_Q_F_START | PREQ_Q_F_REFRESH);
>>        }
>>
>> -       if (mpath->sn < orig_sn && ifmsh->mshcfg.dot11MeshForwarding) {
>> +       if ((SN_LT(mpath->sn, orig_sn) || (SN_EQ(mpath->sn, orig_sn) &&
>> +          metric < mpath->rann_metric)) && ifmsh->mshcfg.dot11MeshForwarding) {
>
> i.e.
>
> if ((mpath->sn < orig_sn || (mpath->sn == orig_sn && metric <
> mpath->rann_metric))
>    && ifmsh->mshcfg.dot11MeshForwarding) {
>
>
>>                mesh_path_sel_frame_tx(MPATH_RANN, flags, orig_addr,
>>                                       cpu_to_le32(orig_sn),
>>                                       0, NULL, 0, broadcast_addr,
>>                                       hopcount, ttl, cpu_to_le32(interval),
>> -                                      cpu_to_le32(metric + mpath->metric),
>> +                                      cpu_to_le32(metric + metric_txsta),
>>                                       0, sdata);
>>                mpath->sn = orig_sn;
>> +               mpath->rann_metric = metric + metric_txsta;
>>        }
>>
>>        /* Using individually addressed PREQ for root node */
>> --
>> 1.7.0.4
>>
>
> Thanks,
>
> Javier
