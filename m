Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:36202 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752385AbeCUPS3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 11:18:29 -0400
Received: by mail-pf0-f171.google.com with SMTP id 68so2095973pfx.3
        for <linux-wireless@vger.kernel.org>; Wed, 21 Mar 2018 08:18:29 -0700 (PDT)
Subject: Re: [RFC v5 0/9] EAPoL over NL80211
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20180313215942.29176-1-denkenz@gmail.com>
 <1521645199.2645.34.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <6c4a389a-55e1-5af2-cac2-1754fce7fabf@gmail.com> (sfid-20180321_161837_247987_B2B77DE7)
Date: Wed, 21 Mar 2018 10:18:26 -0500
MIME-Version: 1.0
In-Reply-To: <1521645199.2645.34.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 03/21/2018 10:13 AM, Johannes Berg wrote:
> 
>> TODO:
> 
> That was well-hidden :)

Sorry.  I assumed people read the change log :)

> 
>> - It is unclear to me how AP_VLAN and AP interfaces should synchronize on
>> conn_owner_nlportid.  This is required for tx_control_port to work.
> 
> I'm not really sure what you mean? Technically I guess an AP_VLAN could
> have a different owner from an AP, but if the AP goes down all the
> AP_VLANs go down with it already anyway.

So the issue is that when mac80211 calls cfg80211_rx_control_port and 
subsequently __nl80211_rx_control_port, we grab the nlportid from the 
wdev.  So if that isn't synchronized, then AP_VLAN devices won't be 
sending the EAPoL frames to the right place.

> 
>> - JOIN_IBSS & JOIN_MESH don't seem to support control_port_ethertype or
>> control_port_no_encrypt.  Should struct cfg80211_crypto_settings parsed inside
>> nl80211_crypto_settings be added to ibss_params or mesh_config/mesh_setup?
> 
> I don't think it matters - they just don't support this now and don't
> really need to.
> 

Except that the eapol over nl80211 flag is being sent in security 
settings.  This covers STA/AP/P2P_GO/P2P_CLIENT.  We need some way of 
passing this information for mesh & ibss.

Regards,
-Denis
