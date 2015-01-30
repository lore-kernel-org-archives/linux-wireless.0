Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:37614 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750908AbbA3GWw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Jan 2015 01:22:52 -0500
Received: by mail-wg0-f42.google.com with SMTP id x13so25154534wgg.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 Jan 2015 22:22:50 -0800 (PST)
Message-ID: <54CB2338.2070502@gmail.com> (sfid-20150130_072254_856965_19BDD982)
Date: Fri, 30 Jan 2015 07:22:48 +0100
From: wim torfs <wtorfs@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: cfg80211_ops: deauthentication & disassociation
References: <CACna6rykYmq6ucTHJ40vcySOFYs3qeim_ZOpNQsNGzyFo=w-aQ@mail.gmail.com>
In-Reply-To: <CACna6rykYmq6ucTHJ40vcySOFYs3qeim_ZOpNQsNGzyFo=w-aQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I will try to answer your question, please correct me if I'm wrong.

On 01/29/2015 11:55 PM, Rafał Miłecki wrote:
> Hi,
>
> I'm looking at deauthentication&  disassociation with cfg80211 API.
> AFAIK both frames can be send by STA as well as AP (according to the
> standard). I was looking info few cfg80211 callbacks and have few
> questions.
>
> 1) @disassoc
> I think it's just for disassociating from AP. Is that correct?
>

I also think so, since all code is located in the mlme section
Did not look into that in detail though, so I could be wrong.

> 2) @del_station
> Now, this gets tricky for me. I think this callback is for AP mode to
> deauthenticae/disassociate a STA.

correct, this is only allowed for iftypes of NL80211_IFTYPE_AP, 
NL80211_IFTYPE_AP_VLAN, NL80211_IFTYPE_MESH_POINT or 
NL80211_IFTYPE_P2P_GO. (see net/wireless/nl80211.c: nl80211_del_station)

  It seems hostapd follows the same
> idea as in driver_nl80211.c it uses NL80211_CMD_DEL_STATION for both:
> deauth and disassoc (without building own frame).
>
> So I started analyzing this with the base case: mac80211
> (ieee80211_del_station). I expected to find a place where mac80211
> constructs deauth/disassoc management frame and transmits it. But I
> really couldn't. It seems that all ieee80211_del_station does is
> calling __sta_info_destroy / __sta_info_destroy_part1 /
> __sta_info_destroy_part2.
> Did I miss something? Or does mac80211 really ignore sending proper
> management frames in this case?


If you look further into __sta_info_destroy, you will notice a callback 
to cfg80211_del_sta (net/wireless/nl80211.c), notifying the removal of 
the station information.
cfg80211_del_sta composes a netlink message, notifying everyone 
interested about the removal of the station:
hdr = nl80211hdr_put(msg, 0, 0, 0, NL80211_CMD_DEL_STATION);

In hostapd, there is a routine that monitors such netlink messages, 
process_global_event, which eventually parses the CMD_DEL_STATION event 
in nl80211_del_station_event, where a call is made to drv_event_disassoc 
if the current device is indeed in AP mode.
So eventually, it is the hostapd that triggers the transmission of the 
disassociation packet.

I hope my explanation is correct and it helps you to make things more clear.

Wim.



