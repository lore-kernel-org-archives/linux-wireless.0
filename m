Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46143 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752759Ab2KTJL1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 04:11:27 -0500
Received: by mail-ob0-f174.google.com with SMTP id wc20so5717812obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Nov 2012 01:11:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1353398144.10872.144.camel@cumari.coelho.fi>
References: <1353343170-26516-1-git-send-email-eliad@wizery.com>
	<1353343170-26516-13-git-send-email-eliad@wizery.com>
	<1353398144.10872.144.camel@cumari.coelho.fi>
Date: Tue, 20 Nov 2012 11:11:26 +0200
Message-ID: <CAB3XZEf1x2OvdzgfDkh6z0mQPdFsvX-AXmrmML-zCC8W8HU2RQ@mail.gmail.com> (sfid-20121120_101131_777901_79EC8C4B)
Subject: Re: [PATCH 12/15] wlcore: specify correct supported_rates
From: Eliad Peller <eliad@wizery.com>
To: Luciano Coelho <coelho@ti.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 20, 2012 at 9:55 AM, Luciano Coelho <coelho@ti.com> wrote:
> On Mon, 2012-11-19 at 18:39 +0200, Eliad Peller wrote:
>> The supported_rates field should contain all our supported
>> rates, even if the remote peer doesn't support them.
>>
>> (use CONF_TX_AP_ENABLED_RATES for bg rates, as the possible
>> rates are the same for ap and sta)
>
> Maybe the macro should be renamed then?
>
sure.

>> @@ -461,7 +462,14 @@ int wl12xx_cmd_role_start_sta(struct wl1271 *wl, struct wl12xx_vif *wlvif)
>>       cmd->sta.ssid_len = wlvif->ssid_len;
>>       memcpy(cmd->sta.ssid, wlvif->ssid, wlvif->ssid_len);
>>       memcpy(cmd->sta.bssid, vif->bss_conf.bssid, ETH_ALEN);
>> -     cmd->sta.local_rates = cpu_to_le32(wlvif->rate_set);
>> +
>> +     supported_rates = CONF_TX_AP_ENABLED_RATES | CONF_TX_MCS_RATES |
>> +                       wlcore_hw_sta_get_ap_rate_mask(wl, wlvif);
>> +     if (wlvif->p2p)
>> +             supported_rates &= ~CONF_TX_CCK_RATES;
>
> Why not do this when creating the vif (init_vif_data)? I think this kind
> of code doesn't belong in the cmd function.  Seem better to adjust
> wlvif->rate_set.
>
well, this value is used only here. i don't think adding it to wl
struct and initializing it in a different place is really better.
however, i don't mind doing so if you insist :)

Eliad.
