Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f174.google.com ([209.85.192.174]:36475 "EHLO
        mail-pf0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755158AbeCVNyv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 22 Mar 2018 09:54:51 -0400
Received: by mail-pf0-f174.google.com with SMTP id 68so3366679pfx.3
        for <linux-wireless@vger.kernel.org>; Thu, 22 Mar 2018 06:54:51 -0700 (PDT)
Subject: Re: [RFC v5 0/9] EAPoL over NL80211
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20180313215942.29176-1-denkenz@gmail.com>
 <1521645199.2645.34.camel@sipsolutions.net>
 <6c4a389a-55e1-5af2-cac2-1754fce7fabf@gmail.com>
 <1521714493.19621.5.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <0603f0fc-8a89-6ef4-5e9a-1d59569efa44@gmail.com> (sfid-20180322_153306_155126_0D957AFD)
Date: Thu, 22 Mar 2018 08:54:46 -0500
MIME-Version: 1.0
In-Reply-To: <1521714493.19621.5.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> However, it doesn't actually matter at all - we shouldn't get there
> with VLAN interface. EAPOL frames are always sent out to the
> corresponding AP interface, see ieee80211_rx_h_data:
> 
>          if (rx->sdata->vif.type == NL80211_IFTYPE_AP_VLAN &&
>              unlikely(port_control) && sdata->bss) {
>                  sdata = container_of(sdata->bss, struct ieee80211_sub_if_data,
>                                       u.ap);
>                  dev = sdata->dev;
>                  rx->sdata = sdata;
>          }
> 

Okay, that makes things easier.  However, it does bring up a question. 
Should we be symmetric and remove AP_VLAN as a valid target of control 
port frames?  E.g. drop NL80211_IFTYPE_AP_VLAN case in patch 2 of the 
series.  In effect we'd require all control port frame traffic to go 
over the master interface.

> 
>>>> - JOIN_IBSS & JOIN_MESH don't seem to support control_port_ethertype or
>>>> control_port_no_encrypt.  Should struct cfg80211_crypto_settings parsed inside
>>>> nl80211_crypto_settings be added to ibss_params or mesh_config/mesh_setup?
>>>
>>> I don't think it matters - they just don't support this now and don't
>>> really need to.
>>>
>>
>> Except that the eapol over nl80211 flag is being sent in security
>> settings.  This covers STA/AP/P2P_GO/P2P_CLIENT.  We need some way of
>> passing this information for mesh & ibss.
> 
> Not sure I understand what you're saying. Can't we just say the flag
> isn't permitted in those modes?

I'm the one confused now.  You wanted me to add IFTYPE_IBSS in 
nl80211_tx_control_port in your earlier feedback :)

Let me try to restate what I said earlier in a different way and see if 
it makes things a bit clearer:

So in patch 9, we set sdata->control_port_over_nl80211 based on 
parameters passed into start_ap or mgd_assoc.  The 
control_port_over_nl80211 flag is passed in cfg80211_crypto_settings 
structure that is part of the relevant parameters structure.  If 
sdata->control_port_over_nl80211 is true, then we actually redirect the 
control port frames to nl80211.

So my question is, if we want to support IBSS/MESH, should we:
1. add the whole cfg80211_crypto_settings to the IBSS/MESH parameters,
2. add the control_port_over_nl80211 flag directly to IBSS/MESH parameters
3. Pass the flag some other way?
4. Or drop IBSS/MESH from patch 2 (nl80211_tx_control_port) completely?

Regards,
-Denis
