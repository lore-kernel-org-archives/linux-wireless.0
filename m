Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:50328 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754113Ab2KSUHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Nov 2012 15:07:24 -0500
Message-ID: <50AA9177.5030408@etit.tu-chemnitz.de> (sfid-20121119_210732_407369_5D27E6C4)
Date: Mon, 19 Nov 2012 12:07:19 -0800
From: Marco Porsch <marco.porsch@etit.tu-chemnitz.de>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: javier@cozybit.com, linux-wireless@vger.kernel.org,
	Ivan Bezyazychnyy <ivan.bezyazychnyy@gmail.com>,
	Mike Krinkin <krinkin.m.u@gmail.com>,
	Max Filippov <jcmvbkbc@gmail.com>
Subject: Re: [RFC 05/14] mac80211: mesh power mode indication in transmitted
 frames
References: <1353134886-13256-1-git-send-email-marco.porsch@etit.tu-chemnitz.de>  <1353134886-13256-6-git-send-email-marco.porsch@etit.tu-chemnitz.de> <1353143459.9543.19.camel@jlt4.sipsolutions.net>
In-Reply-To: <1353143459.9543.19.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

First of all; thanks for all the comments.

On 11/17/2012 01:10 AM, Johannes Berg wrote:
> On Fri, 2012-11-16 at 22:47 -0800, Marco Porsch wrote:
>
>> --- a/net/mac80211/mesh.h
>> +++ b/net/mac80211/mesh.h
>> @@ -30,6 +30,7 @@ enum mesh_config_capab_flags {
>>   	MESHCONF_CAPAB_ACCEPT_PLINKS = BIT(0),
>>   	MESHCONF_CAPAB_FORWARDING = BIT(3),
>>   	MESHCONF_CAPAB_TBTT_ADJUSTING = BIT(5),
>> +	MESHCONF_CAPAB_POWER_SAVE_LEVEL	= BIT(6),
>
> Please move this entire enum to ieee80211.h first (in a separate patch).
>
> It should also be u16 values and be put into the frame as a u16, since
> the field is a u16 field apparently.

Sorry, I don't get that one. According to IEEE80211-2012 8.4.2.100 Mesh 
Configuration element and 8.4.2.100.8 Mesh Capability, the capability 
field is just u8.
It is currently written as follows:

mesh.c : mesh_add_meshconf_ie

/* Mesh capability */
*pos = MESHCONF_CAPAB_FORWARDING;
*pos |= ifmsh->accepting_plinks ?
     MESHCONF_CAPAB_ACCEPT_PLINKS : 0x00;
*pos++ |= ifmsh->adjusting_tbtt ?
     MESHCONF_CAPAB_TBTT_ADJUSTING : 0x00;

Should I change anything? Just move the enum?

>
> (yes, it's a bit harsh to demand this of you, but since we don't have a
> mesh maintainer who's cleaning up that code ...)
>
>> +void ieee80211_set_mesh_ps_flags(struct ieee80211_sub_if_data *sdata,
>> +				 struct sta_info *sta,
>> +				 struct ieee80211_hdr *hdr)
>> +{
>> +	enum nl80211_mesh_power_mode pm;
>> +	__le16 *qc;
>> +
>> +	BUG_ON(is_unicast_ether_addr(hdr->addr1) &&
>> +	       ieee80211_is_data_qos(hdr->frame_control) &&
>> +	       !sta);
>
> NACK.
>
>> +++ b/net/mac80211/wme.c
>> @@ -184,7 +184,18 @@ void ieee80211_set_qos_hdr(struct ieee80211_sub_if_data *sdata,
>>
>>   		/* qos header is 2 bytes */
>>   		*p++ = ack_policy | tid;
>> -		*p = ieee80211_vif_is_mesh(&sdata->vif) ?
>> -			(IEEE80211_QOS_CTL_MESH_CONTROL_PRESENT >> 8) : 0;
>> +
>> +		if (!ieee80211_vif_is_mesh(&sdata->vif)) {
>> +			*p = 0;
>> +			return;
>
> I'd rather you refactor the function to return early in the case of the
> frame not being a Data QoS frame, and then put the mesh stuff all inside
> the if.
>
> johannes
>
>

