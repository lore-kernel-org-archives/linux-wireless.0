Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yi0-f46.google.com ([209.85.218.46]:45156 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953Ab1ADNNp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Jan 2011 08:13:45 -0500
Received: by yib18 with SMTP id 18so3405310yib.19
        for <linux-wireless@vger.kernel.org>; Tue, 04 Jan 2011 05:13:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1294145621.4166.118.camel@wimaxnb.nmp.nokia.com>
References: <1293352070-17513-1-git-send-email-eliad@wizery.com>
	<1294145621.4166.118.camel@wimaxnb.nmp.nokia.com>
Date: Tue, 4 Jan 2011 15:13:44 +0200
Message-ID: <AANLkTikWGzNjjRM6q-8W30Uq7uo5hSf3cjOeDk6oP7_k@mail.gmail.com>
Subject: Re: [PATCH] wl12xx: don't join upon disassociation
From: Eliad Peller <eliad@wizery.com>
To: Juuso Oikarinen <juuso.oikarinen@nokia.com>
Cc: Luciano Coelho <luciano.coelho@nokia.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jan 4, 2011 at 2:53 PM, Juuso Oikarinen
<juuso.oikarinen@nokia.com> wrote:
> On Sun, 2010-12-26 at 10:27 +0200, ext Eliad Peller wrote:
>> wl12xx "rejoins" upon every BSS_CHANGED_BSSID notification.
>> However, there is no need to rejoin after disassociation, so just
>> filter out the case when the new bssid is 00:00:00:00:00:00.
>>
>> Signed-off-by: Eliad Peller <eliad@wizery.com>
>> ---
>>  drivers/net/wireless/wl12xx/main.c |   24 ++++++++++++++----------
>>  1 files changed, 14 insertions(+), 10 deletions(-)
>>
>> diff --git a/drivers/net/wireless/wl12xx/main.c b/drivers/net/wireless/wl12xx/main.c
>> index 062247e..7aa783c 100644
>> --- a/drivers/net/wireless/wl12xx/main.c
>> +++ b/drivers/net/wireless/wl12xx/main.c
>> @@ -1944,19 +1944,23 @@ static void wl1271_op_bss_info_changed(struct ieee80211_hw *hw,
>>           memcmp(wl->bssid, bss_conf->bssid, ETH_ALEN)) {
>>                       memcpy(wl->bssid, bss_conf->bssid, ETH_ALEN);
>>
>> -                     ret = wl1271_cmd_build_null_data(wl);
>> -                     if (ret < 0)
>> -                             goto out_sleep;
>> +                     if (!is_zero_ether_addr(wl->bssid)) {
>> +                             ret = wl1271_cmd_build_null_data(wl);
>> +                             if (ret < 0)
>> +                                     goto out_sleep;
>>
>> -                     ret = wl1271_build_qos_null_data(wl);
>> -                     if (ret < 0)
>> -                             goto out_sleep;
>> +                             ret = wl1271_build_qos_null_data(wl);
>> +                             if (ret < 0)
>> +                                     goto out_sleep;
>>
>> -                     /* filter out all packets not from this BSSID */
>> -                     wl1271_configure_filters(wl, 0);
>> +                             /* filter out all packets not from this BSSID */
>> +                             wl1271_configure_filters(wl, 0);
>>
>> -                     /* Need to update the BSSID (for filtering etc) */
>> -                     do_join = true;
>> +                             /*
>> +                              * Need to update the BSSID (for filtering etc)
>> +                              */
>> +                             do_join = true;
>> +                     }
>>       }
>>
>>       if (changed & BSS_CHANGED_ASSOC) {
>
> The device still stays joined after disassoc, right? I guess the device
> should be receiving/transmitting frames while not idle.
>
> That is why we did have a specific dummy-join in disassoc, and also the
> BSSID filters etc are cleared!
>
the patch doesn't unjoin, it just prevents rejoining (and some other
configurations) to an "empty" bssid, so it shouldn't affect the
current join state.
the actual unjoin will only be only executed when the device goes idle.
