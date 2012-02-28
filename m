Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58776 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab2B1EFg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 23:05:36 -0500
Received: by iagj37 with SMTP id j37so685056iag.19
        for <linux-wireless@vger.kernel.org>; Mon, 27 Feb 2012 20:05:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAG6hwVPoWFdbS2FGOeZcCn8msQm63-GOmMbamH57LRpG2rf6Rw@mail.gmail.com>
References: <1330427636-3350-1-git-send-email-yeohchunyeow@gmail.com> <CAG6hwVPoWFdbS2FGOeZcCn8msQm63-GOmMbamH57LRpG2rf6Rw@mail.gmail.com>
From: Javier Cardona <javier@cozybit.com>
Date: Mon, 27 Feb 2012 20:05:16 -0800
Message-ID: <CAPjQAd9bF=yP9V5wM+iVFcxGbyVRibOuH2=rwz6PScZoi_LKPg@mail.gmail.com> (sfid-20120228_050540_228745_59ACEEC1)
Subject: Re: [PATCH v3] mac80211: Fix the generation of PREQs in proactive
 RANN mechanism of HWMP
To: devel@lists.open80211s.org
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	linville@tuxdriver.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 27, 2012 at 7:10 PM, Thomas Pedersen <thomas@cozybit.com> wrote:
> Hi Chun-Yeow,
>
> On Tue, Feb 28, 2012 at 3:13 AM, Chun-Yeow Yeoh <yeohchunyeow@gmail.com> wrote:
>> According to Section Y.7.4 Actions on receipt of proactive RANN, an individually
>> addressed PREQ should be generated towards the neighbor peer mesh STA indicated
>> in the RANN Sender Address field in the forwarding information.
>>
>> Signed-off-by: Chun-Yeow Yeoh <yeohchunyeow@gmail.com>
>> Signed-off-by: Javier Cardona <javier@cozybit.com>
>> ---
>>  net/mac80211/mesh.h      |    4 ++++
>>  net/mac80211/mesh_hwmp.c |   25 ++++++++++++++++++++-----
>>  2 files changed, 24 insertions(+), 5 deletions(-)
>>
>> diff --git a/net/mac80211/mesh.h b/net/mac80211/mesh.h
>> index bd14bd2..4b0a9e8 100644
>> --- a/net/mac80211/mesh.h
>> +++ b/net/mac80211/mesh.h
>> @@ -86,6 +86,8 @@ enum mesh_deferred_task_flags {
>>  * @state_lock: mesh path state lock used to protect changes to the
>>  * mpath itself.  No need to take this lock when adding or removing
>>  * an mpath to a hash bucket on a path table.
>> + * @rann_snd_addr: the RANN sender address
>> + * @is_root: the destination station of this path is a root node
>>  * @is_gate: the destination station of this path is a mesh gate
>>  *
>>  *
>> @@ -110,6 +112,8 @@ struct mesh_path {
>>        u8 discovery_retries;
>>        enum mesh_path_flags flags;
>>        spinlock_t state_lock;
>> +       u8 rann_snd_addr[ETH_ALEN];
>> +       bool is_root;
>>        bool is_gate;
>>  };
>
> Why not simply use mpath->dst as the root node address? Is there ever
> a situation in which mpath->dst != mpath->rann_snd_addr?

rann_snd_addr is the address of the rann transmitter (i.e. prev hop),
not the address of the root.
The spec mentions that this is the path to use to send unicast PREQs,
and not to use the forwarding table info.

>>
>> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
>> index cae4071..cc7f8af 100644
>> --- a/net/mac80211/mesh_hwmp.c
>> +++ b/net/mac80211/mesh_hwmp.c
>> @@ -512,8 +512,9 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
>>                                    u8 *preq_elem, u32 metric)
>>  {
>>        struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
>> -       struct mesh_path *mpath;
>> +       struct mesh_path *mpath = NULL;
>>        u8 *target_addr, *orig_addr;
>> +       const u8 *da;
>>        u8 target_flags, ttl;
>>        u32 orig_sn, target_sn, lifetime;
>>        bool reply = false;
>> @@ -590,9 +591,13 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
>>                flags = PREQ_IE_FLAGS(preq_elem);
>>                preq_id = PREQ_IE_PREQ_ID(preq_elem);
>>                hopcount = PREQ_IE_HOPCOUNT(preq_elem) + 1;
>> +               if (mpath && mpath->is_root)
>> +                       da = mpath->rann_snd_addr;
>> +               else
>> +                       da = broadcast_addr;
>
> Maybe make these a ternary conditional.
>
>>                mesh_path_sel_frame_tx(MPATH_PREQ, flags, orig_addr,
>>                                cpu_to_le32(orig_sn), target_flags, target_addr,
>> -                               cpu_to_le32(target_sn), broadcast_addr,
>> +                               cpu_to_le32(target_sn), da,
>>                                hopcount, ttl, cpu_to_le32(lifetime),
>>                                cpu_to_le32(metric), cpu_to_le32(preq_id),
>>                                sdata);
>> @@ -741,8 +746,8 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
>>        if (memcmp(orig_addr, sdata->vif.addr, ETH_ALEN) == 0)
>>                return;
>>
>> -       mhwmp_dbg("received RANN from %pM (is_gate=%d)", orig_addr,
>> -                       root_is_gate);
>> +       mhwmp_dbg("received RANN from %pM via neighbour %pM (is_gate=%d)",
>> +                       orig_addr, mgmt->sa, root_is_gate);
>>
>
> Also, when is orig_addr != mgmt->sa?

orig_addr would be the original source of the RANN, while mgmt->sa
would be the previous transmitter of the RANN.

>>        rcu_read_lock();
>>        mpath = mesh_path_lookup(orig_addr, sdata);
>> @@ -773,6 +778,11 @@ static void hwmp_rann_frame_process(struct ieee80211_sub_if_data *sdata,
>>                                       0, sdata);
>>                mpath->sn = orig_sn;
>>        }
>> +
>> +       /* Using individually addressed PREQ for root node */
>> +       memcpy(mpath->rann_snd_addr, mgmt->sa, ETH_ALEN);
>> +       mpath->is_root = true;
>> +
>>        if (root_is_gate)
>>                mesh_path_add_gate(mpath);
>>
>> @@ -908,6 +918,7 @@ void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
>>        struct mesh_preq_queue *preq_node;
>>        struct mesh_path *mpath;
>>        u8 ttl, target_flags;
>> +       const u8 *da;
>>        u32 lifetime;
>>
>>        spin_lock_bh(&ifmsh->mesh_preq_queue_lock);
>> @@ -970,9 +981,13 @@ void mesh_path_start_discovery(struct ieee80211_sub_if_data *sdata)
>>                target_flags = MP_F_RF;
>>
>>        spin_unlock_bh(&mpath->state_lock);
>> +       if (!mpath->is_root)
>> +               da = broadcast_addr;
>> +       else
>> +               da = mpath->rann_snd_addr;
>
> Ternary.
>
>>        mesh_path_sel_frame_tx(MPATH_PREQ, 0, sdata->vif.addr,
>>                        cpu_to_le32(ifmsh->sn), target_flags, mpath->dst,
>> -                       cpu_to_le32(mpath->sn), broadcast_addr, 0,
>> +                       cpu_to_le32(mpath->sn), da, 0,
>>                        ttl, cpu_to_le32(lifetime), 0,
>>                        cpu_to_le32(ifmsh->preq_id++), sdata);
>>        mod_timer(&mpath->timer, jiffies + mpath->discovery_timeout);
>> --
>> 1.7.0.4
>>
>
> Thomas
> _______________________________________________
> Devel mailing list
> Devel@lists.open80211s.org
> http://open80211s.com/mailman/listinfo/devel



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
