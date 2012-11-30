Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:41221 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758851Ab2K3RGV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Nov 2012 12:06:21 -0500
Message-ID: <50B8E787.2090903@etit.tu-chemnitz.de> (sfid-20121130_180632_140287_A712AFB7)
Date: Fri, 30 Nov 2012 09:06:15 -0800
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: javier@cozybit.com, thomas@cozybit.com,
	linux-wireless@vger.kernel.org
Subject: Re: [RFCv2 08/13] mac80211: add power save support structure to mesh
 interface
References: <1353701934-12752-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>  <1353701934-12752-9-git-send-email-marco.porsch@etit.tu-chemnitz.de> <1354277360.10035.20.camel@jlt4.sipsolutions.net>
In-Reply-To: <1354277360.10035.20.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks again for all your comments!

On 11/30/2012 04:09 AM, Johannes Berg wrote:
> On Fri, 2012-11-23 at 12:18 -0800, Marco Porsch wrote:
>
>> +++ b/net/mac80211/mesh.c
>> @@ -657,10 +657,16 @@ void ieee80211_stop_mesh(struct ieee80211_sub_if_data *sdata)
>>   	ifmsh->mesh_id_len = 0;
>>   	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BEACON_ENABLED);
>>
>> +	/* free all potentially still buffered group-addressed frames */
>> +	local->total_ps_buffered -= skb_queue_len(&ifmsh->ps.bc_buf);
>> +	skb_queue_purge(&ifmsh->ps.bc_buf);
>> +
>>   	/* flush STAs and mpaths on this iface */
>>   	sta_info_flush(sdata->local, sdata);
>>   	mesh_path_flush_by_iface(sdata);
>
> the queue purge would seem to be in the wrong spot

Where would you recommend to put it then?
My idea was that after the (DTIM) beacon is disabled these buffered 
broadcasts are stuck either way, so they can be purged.

>> +#ifdef CONFIG_MAC80211_MESH
>> +	} else if (sta->sdata->vif.type == NL80211_IFTYPE_MESH_POINT) {
>
> maybe use vif_is_mesh anyway for consistency?
>
> johannes
>
>

