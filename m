Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f171.google.com ([209.85.217.171]:42484 "EHLO
	mail-lb0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982AbbA3IRh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 03:17:37 -0500
Received: by mail-lb0-f171.google.com with SMTP id u14so35035137lbd.2
        for <linux-wireless@vger.kernel.org>; Fri, 30 Jan 2015 00:17:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54CB2338.2070502@gmail.com>
References: <CACna6rykYmq6ucTHJ40vcySOFYs3qeim_ZOpNQsNGzyFo=w-aQ@mail.gmail.com>
	<54CB2338.2070502@gmail.com>
Date: Fri, 30 Jan 2015 09:17:36 +0100
Message-ID: <CACna6rzXoVdf_7sD4Fio5793kXco5so7=wRisfCcbWt+U2CLKQ@mail.gmail.com> (sfid-20150130_091741_165664_1EE1B66C)
Subject: Re: cfg80211_ops: deauthentication & disassociation
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: wim torfs <wtorfs@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30 January 2015 at 07:22, wim torfs <wtorfs@gmail.com> wrote:
> On 01/29/2015 11:55 PM, Rafał Miłecki wrote:
>> So I started analyzing this with the base case: mac80211
>> (ieee80211_del_station). I expected to find a place where mac80211
>> constructs deauth/disassoc management frame and transmits it. But I
>> really couldn't. It seems that all ieee80211_del_station does is
>> calling __sta_info_destroy / __sta_info_destroy_part1 /
>> __sta_info_destroy_part2.
>> Did I miss something? Or does mac80211 really ignore sending proper
>> management frames in this case?
>
> If you look further into __sta_info_destroy, you will notice a callback to
> cfg80211_del_sta (net/wireless/nl80211.c), notifying the removal of the
> station information.
> cfg80211_del_sta composes a netlink message, notifying everyone interested
> about the removal of the station:
> hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_DEL_STATION);
>
> In hostapd, there is a routine that monitors such netlink messages,
> process_global_event, which eventually parses the CMD_DEL_STATION event in
> nl80211_del_station_event, where a call is made to drv_event_disassoc if the
> current device is indeed in AP mode.
> So eventually, it is the hostapd that triggers the transmission of the
> disassociation packet.

I indeed missed the way cfg80211_del_sta works and hostapd's event
handler for this. That explains a lot.

I've checked ath6kl, brcmfmac and mwifiex and they don't seem to call
cfg80211_del_sta. AFAIU it's because they handle sending
disassoc/deauth packet on their own (and the don't want e.g. hostapd
to do this), is that correct?


> I hope my explanation is correct and it helps you to make things more clear.

Absolutely, thanks a lot!

-- 
Rafał
