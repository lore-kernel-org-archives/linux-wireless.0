Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:37653 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932144AbaLDMDS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2014 07:03:18 -0500
Received: by mail-ig0-f171.google.com with SMTP id z20so14501780igj.10
        for <linux-wireless@vger.kernel.org>; Thu, 04 Dec 2014 04:03:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54784001.7020706@broadcom.com>
References: <54784001.7020706@broadcom.com>
Date: Thu, 4 Dec 2014 13:03:17 +0100
Message-ID: <CACna6rzGB7EvMbiteWGbwjdmx+LMZymdk_04L_RKiFkT0hokvA@mail.gmail.com> (sfid-20141204_130325_747050_1DC87502)
Subject: Re: Multiple-BSSID issues with hostapd
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Jouni Malinen <j@w1.fi>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 28 November 2014 at 10:27, Arend van Spriel <arend@broadcom.com> wrote:
> For the brcmfmac we started working on Multiple-BSSID support and came
> across some issues with hostapd that are listed listed below.
>
> BSS1 setup on netdev wlan0
> BSS2 setup on netdev wlan0_0
>
> * get_station() done on wrong netdev
>
> observed:
> Upon association of STA1 with BSS2 (wlan0_0) a get_station() is done for
> STA1 with wlan0 as netdev.
> expected:
> get_station() for STA1 with wlan0_0 as netdev. We verified that wlan0_0
> ifindex was used in NL80211_CMD_NEW_STATION event.

Did you do any progress on this?

According to the nl80211.h you are correct of course, every
NL80211_CMD_foo_STATION command should include NL80211_ATTR_IFINDEX.

There are two functions in driver_nl80211.c where
NL80211_CMD_GET_STATION is used.

1) nl80211_get_link_signal
It fills NL80211_ATTR_IFINDEX in the following way:
NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, drv->ifindex);

2) i802_read_sta_data
It fills NL80211_ATTR_IFINDEX in the following way:
NLA_PUT_U32(msg, NL80211_ATTR_IFINDEX, if_nametoindex(bss->ifname));

Did you track down which of the above functions in the one sending
wrong NL80211_ATTR_IFINDEX?
