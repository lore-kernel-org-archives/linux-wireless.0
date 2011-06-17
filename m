Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:42636 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752353Ab1FQSfv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jun 2011 14:35:51 -0400
Received: by qyk29 with SMTP id 29so617162qyk.19
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jun 2011 11:35:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4DFA8DBF.9080301@openwrt.org>
References: <4DF93116.700@gnu.org>
	<4DF96668.3040007@openwrt.org>
	<4DFA7BAD.7060405@gnu.org>
	<4DFA8DBF.9080301@openwrt.org>
Date: Fri, 17 Jun 2011 14:35:50 -0400
Message-ID: <BANLkTinT6M6mkYPPHbdvXECCPDcqv99LeQ@mail.gmail.com> (sfid-20110617_203555_228267_28578FD2)
Subject: Re: ath9k WDS panic without CONFIG_ATH9K_RATE_CONTROL
From: Bill Jordan <bjordan@rajant.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Pavel Roskin <proski@gnu.org>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Felix,

On Thu, Jun 16, 2011 at 7:11 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> For 802.11n you need proper HT capabilites anyway. I think it usually
> doesn't make much sense to use WDS without AP interfaces, but if you
> consider it worth adding support for, then please build your patches on top
> of my patch series.

I've got your patches and I'm seeing a problem with (an admittedly) odd case.

I've got 2 APs, both using ath9k cards/drivers. One of them is
configured to use WEP, the other has no security. I'm establishing a
WDS connection between them.

Since WEP is incompatible with HT, that AP's beacons only include
a/b/g rates. The open AP happily sends lower rate packets to the WEP
AP.

However, since beacon from the open AP contains HT rates. In
ieee80211_wds_rx_queued_mgmt, the WEP ap calls
ieee80211_ht_cap_ie_to_sta_ht_cap, and adds HT rates to the station.
"iw wlan0wds0 station dump" reports that the tx bitrate is an HT rate
(58.5 MBit/s MCS 6). However, the actual behavior of the radio is
horrible. Packets take a long time (frequently well over a second) to
be transmitted by the radio.

I believe this is an issue with transmitting HT rates while WEP is
configured. If I comment out the call to
ieee80211_ht_cap_ie_to_sta_ht_cap in  ieee80211_wds_rx_queued_mgmt on
the WEP AP, I get decent transmit performance (at 54.0 Mbit/s). If I
turn off WEP on the AP, I get good transmit performance at HT rates.

I believe the call to ieee80211_ht_cap_ie_to_sta_ht_cap in
ieee80211_wds_rx_queued_mgmt needs to be conditioned on the radio not
being in WEP. But I haven't figured out a convenient way to determine
this.

-- Bill Jordan --
