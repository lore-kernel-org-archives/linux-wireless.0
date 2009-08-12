Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtitmf2.realsil.com.cn ([60.250.210.236]:2140 "EHLO
	mf2.realtek.com.tw" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751572AbZHLGjO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Aug 2009 02:39:14 -0400
Message-ID: <4A82639F.6000908@realsil.com.cn>
Date: Wed, 12 Aug 2009 14:39:27 +0800
From: david woo <xinhua_wu@realsil.com.cn>
MIME-Version: 1.0
To: Javier Cardona <javier@cozybit.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"andrey@cozybit.com" <andrey@cozybit.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"devel@lists.open80211s.org" <devel@lists.open80211s.org>
Subject: Re: diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
References: <1249986145-6531-1-git-send-email-xinhua_wu@realsil.com.cn>     <1249987806.5705.0.camel@johannes.local>     <4A815A3B.3080404@realsil.com.cn> <445f43ac0908111842g5e43cd22i372e9b4608de98a6@mail.gmail.com>
In-Reply-To: <445f43ac0908111842g5e43cd22i372e9b4608de98a6@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Javier,

Thanks for your comments.

Javier Cardona 写道:
> David,
> 
> Thanks for the patch.
> 
> 2009/8/11 david woo <xinhua_wu@realsil.com.cn>:
>> [PATCH] mac80211: Fix preq frame process and peer link frame baselen.
>>
>> This patch is just to fix rreq reply condition, and peer link confirm frame baselen.
>>
>> Signed-off-by: David Woo <xinhua_wu@realsil.com.cn>
>> ---
>> diff --git a/net/mac80211/mesh_hwmp.c b/net/mac80211/mesh_hwmp.c
>> index e1a763e..c065854 100644
>> --- a/net/mac80211/mesh_hwmp.c
>> +++ b/net/mac80211/mesh_hwmp.c
>> @@ -397,7 +397,8 @@ static u32 hwmp_route_info_get(struct ieee80211_sub_if_data *sdata,
>>
>>  static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
>>                                    struct ieee80211_mgmt *mgmt,
>> -                                   u8 *preq_elem, u32 metric) {
>> +                                   u8 *preq_elem, u32 metric)
>> +{
> 
> nak
> 
>>        struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
>>        struct mesh_path *mpath;
>>        u8 *dst_addr, *orig_addr;
>> @@ -430,7 +431,7 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
>>                        if ((!(mpath->flags & MESH_PATH_DSN_VALID)) ||
>>                                        DSN_LT(mpath->dsn, dst_dsn)) {
>>                                mpath->dsn = dst_dsn;
>> -                               mpath->flags &= MESH_PATH_DSN_VALID;
>> +                               mpath->flags |= MESH_PATH_DSN_VALID;
> 
> This is a valid fix:  at this point we should set the "destination
> sequence number" valid flag, not zero all flags.
> 
>>                        } else if ((!(dst_flags & MP_F_DO)) &&
>>                                        (mpath->flags & MESH_PATH_ACTIVE)) {
>>                                reply = true;
>> @@ -447,14 +448,15 @@ static void hwmp_preq_frame_process(struct ieee80211_sub_if_data *sdata,
>>
>>        if (reply) {
>>                lifetime = PREQ_IE_LIFETIME(preq_elem);
>> -               ttl = ifmsh->mshcfg.dot11MeshTTL;
>> -               if (ttl != 0)
>> +               ttl = PREQ_IE_TTL(preq_elem);
>> +               if (ttl != 0) {
>> +                       ttl = ifmsh->mshcfg.dot11MeshTTL;
> 
> Nak.  The reply to a preq should have the locally configured TTL and
> not the TTL that was in the PREP.
> 
  Yes, I agree with you, and this patch is just to check whether this PREQ is valid with 
  the ttl it contains instead of local TTL, and the local TTL has also been provided for 
  PREP further process.

>>                        mesh_path_sel_frame_tx(MPATH_PREP, 0, dst_addr,
>>                                cpu_to_le32(dst_dsn), 0, orig_addr,
>>                                cpu_to_le32(orig_dsn), mgmt->sa, 0, ttl,
>>                                cpu_to_le32(lifetime), cpu_to_le32(metric),
>>                                0, sdata);
>> -               else
>> +               } else
>>                        ifmsh->mshstats.dropped_frames_ttl++;
>>        }
>>
>> diff --git a/net/mac80211/mesh_plink.c b/net/mac80211/mesh_plink.c
>> index cb14253..ffcbad7 100644
>> --- a/net/mac80211/mesh_plink.c
>> +++ b/net/mac80211/mesh_plink.c
>> @@ -409,7 +409,7 @@ void mesh_rx_plink_frame(struct ieee80211_sub_if_data *sdata, struct ieee80211_m
>>        baselen = (u8 *) mgmt->u.action.u.plink_action.variable - (u8 *) mgmt;
>>        if (mgmt->u.action.u.plink_action.action_code == PLINK_CONFIRM) {
>>                baseaddr += 4;
>> -               baselen -= 4;
>> +               baselen += 4;
> 
> I'm confused with this.  Could you actually establish plinks after
> changing this?
  With the baseaddr steps with 4 bytes, while the baselen minus with 4 bytes, it's to avoid 
  following element parser in random with last 8 bytes.
  ===> ieee802_11_parse_elems(baseaddr, len - baselen, &elems);

 baseaddr               
  |<------------------->|

 baseaddr+4  
     |<--len - baselen->|<-4->|<-4->| (baselen -= 4)
     |<--len - baselen->|             (baselen += 4) 
           
> 
> Can you resubmit the patch with only the MESH_PATH_DSN_VALID for now?
> 
> Thanks!
> 
> Javier
> 
> 
> ------Please consider the environment before printing this e-mail. 
> 
> 

David
