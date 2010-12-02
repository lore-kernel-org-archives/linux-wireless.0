Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38931 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757995Ab0LBVYv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 2 Dec 2010 16:24:51 -0500
Received: by qwb7 with SMTP id 7so8842887qwb.19
        for <linux-wireless@vger.kernel.org>; Thu, 02 Dec 2010 13:24:51 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1291320849.3481.55.camel@jlt3.sipsolutions.net>
References: <20101201205939.009530439@sipsolutions.net> <20101201210226.159495600@sipsolutions.net>
 <1291279510.3481.17.camel@jlt3.sipsolutions.net> <AANLkTik_C90v-313Pq_dPY7fE1OFG2X0uv8Ys+uGQFRt@mail.gmail.com>
 <1291320849.3481.55.camel@jlt3.sipsolutions.net>
From: Javier Cardona <javier@cozybit.com>
Date: Thu, 2 Dec 2010 13:24:30 -0800
Message-ID: <AANLkTi=8yikvhvbUS86FZabM5qXbZ1LNHeT+2JQGU+QS@mail.gmail.com>
Subject: Re: [RFC 5/5 v2] cfg80211/mac80211: add mesh join/leave commands
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Steve Derosier <steve@cozybit.com>,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

Thanks for reviewing.  You were right: scanning did stop beaconing
forever and your suggested fix resolved that.  So the patch is now:

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 107a0cb..2de6976 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -246,7 +246,8 @@ void ieee80211_bss_info_change_notify(struct
ieee80211_sub_if_data *sdata,
                                        !!sdata->u.ibss.presp;
                                break;
                        case NL80211_IFTYPE_MESH_POINT:
-                               sdata->vif.bss_conf.enable_beacon = true;
+                               sdata->vif.bss_conf.enable_beacon =
+                                       !!sdata->u.mesh.mesh_id_len;
                                break;
                        default:
                                /* not reached */
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index d814fab..63e1188 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -530,6 +530,11 @@ void ieee80211_start_mesh(struct
ieee80211_sub_if_data *sdata)
 void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
 {
        struct ieee80211_local *local = sdata->local;
+       struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
+
+       ifmsh->mesh_id_len = 0;
+       ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
+       sta_info_flush(local, NULL);

        del_timer_sync(&sdata->u.mesh.housekeeping_timer);
        del_timer_sync(&sdata->u.mesh.mesh_path_root_timer);

We have not run our full suite but we tested legacy interface mesh up,
joining, leaving and rejoining different meshes and all seems to work.
 Feel free to add my tested-by or signoff tags.

Thanks!

Javier


On Thu, Dec 2, 2010 at 12:14 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> Javier,
>
>> Looks good from this end, including the new iw commands.
>
> Thanks!
>
>> The only
>> issue that we observed is that now that we can leave and join a new
>> mesh, we need to do some more state cleanup on stop_mesh.  Otherwise
>> we could move to a new mesh and still talk to the previous peers.  I
>> think this would be sufficient:
>>
>> diff --git a/net/mac80211/main.c b/net/mac80211/main.c
>> index 107a0cb..b1242b6 100644
>> --- a/net/mac80211/main.c
>> +++ b/net/mac80211/main.c
>> @@ -246,7 +246,6 @@ void ieee80211_bss_info_change_notify(struct
>> ieee80211_sub_if_data *sdata,
>>                                         !!sdata->u.ibss.presp;
>>                                 break;
>>                         case NL80211_IFTYPE_MESH_POINT:
>> -                               sdata->vif.bss_conf.enable_beacon = true;
>>                                 break;
>>                         default:
>
> Oh, indeed. I think this should be
>        sdata->vif.bss_conf.enable_beacon = !!mesh_id_len;
>
> though.
>
>> diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
>> index d814fab..cc458dd 100644
>> --- a/net/mac80211/mesh.c
>> +++ b/net/mac80211/mesh.c
>> @@ -522,6 +522,7 @@ void ieee80211_start_mesh(struct
>> ieee80211_sub_if_data *sdata)
>>         ieee80211_mesh_root_setup(ifmsh);
>>         ieee80211_queue_work(&local->hw, &sdata->work);
>>         sdata->vif.bss_conf.beacon_int = MESH_DEFAULT_BEACON_INTERVAL;
>> +       sdata->vif.bss_conf.enable_beacon = true;
>
> Because otherwise, if you just do this, scanning will stop beaconing
> forever...
>
>>         ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON |
>>                                                 BSS_CHANGED_BEACON_ENABLED |
>>                                                 BSS_CHANGED_BEACON_INT);
>> @@ -530,6 +531,13 @@ void ieee80211_start_mesh(struct
>> ieee80211_sub_if_data *sdata)
>>  void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
>>  {
>>         struct ieee80211_local *local = sdata->local;
>> +       struct ieee80211_if_mesh *ifmsh = &sdata->u.mesh;
>> +
>> +       ifmsh->mesh_id_len = 0;
>
> Yeah good catch.
>
>> +       memset(ifmsh->mesh_id, 0, IEEE80211_MAX_MESH_ID_LEN);
>
> That shouldn't really be necessary.
>
>> +       sdata->vif.bss_conf.enable_beacon = false;
>
> Nor would that with the change I proposed, I think.
>
>> +       ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
>> +       sta_info_flush(local, NULL);
>
> Yup, good changes.
>
> Would you mind briefly testing the beacon change I proposed above?
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Javier Cardona
cozybit Inc.
http://www.cozybit.com
