Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.219]:15312 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751583AbcJCLDn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Oct 2016 07:03:43 -0400
Subject: Re: [PATCH] mac80211: fix CMD_FRAME for AP_VLAN
To: Johannes Berg <johannes@sipsolutions.net>
References: <1474786035-15410-1-git-send-email-michael-dev@fami-braun.de>
 <1475235707.17481.44.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
From: "M. Braun" <michael-dev@fami-braun.de>
Message-ID: <c9271e31-a000-1b60-edbf-33524b10e185@fami-braun.de> (sfid-20161003_130346_745931_6CA01741)
Date: Mon, 3 Oct 2016 13:03:30 +0200
MIME-Version: 1.0
In-Reply-To: <1475235707.17481.44.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 30.09.2016 um 13:41 schrieb Johannes Berg:
>> -		sta = sta_info_get(sdata, mgmt->da);
>> +		if (ieee80211_vif_is_mesh(&sdata->vif))
>> +			sta = sta_info_get(sdata, mgmt->da);
>> +		else
>> +			sta = sta_info_get_bss(sdata, mgmt->da);
>>
> I don't see why you need to distinguish between mesh and non-mesh
> here?
> get_bss() will ignore the BSS pointer if it's NULL, and that will
> always be the case when the type is mesh, so ... why?

because the in ieee80211_mgmt_tx the

>        case NL80211_IFTYPE_AP:
>        case NL80211_IFTYPE_AP_VLAN:
>        case NL80211_IFTYPE_P2P_GO:
> ...
>                rcu_read_lock();
>                if (ieee80211_vif_is_mesh(&sdata->vif))
>                        sta = sta_info_get(sdata, mgmt->da);
>                else
>                        sta = sta_info_get_bss(sdata, mgmt->da);
>                rcu_read_unlock();
>

does it the same way and I wanted to go safe and not change the mesh path.

michael
