Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.3]:32777 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447Ab2AZT1W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Jan 2012 14:27:22 -0500
Received: from localhost (smtp-filter.ukfsn.org [192.168.54.205])
	by mail.ukfsn.org (Postfix) with ESMTP id 45A74DEBA5
	for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 19:27:19 +0000 (GMT)
Received: from mail.ukfsn.org ([192.168.54.25])
	by localhost (smtp-filter.ukfsn.org [192.168.54.205]) (amavisd-new, port 10024)
	with ESMTP id lJ596PwJlx40 for <linux-wireless@vger.kernel.org>;
	Thu, 26 Jan 2012 19:58:36 +0000 (GMT)
Received: from stargate.localnet (unknown [84.45.236.142])
	by mail.ukfsn.org (Postfix) with ESMTP id CD901DEB9E
	for <linux-wireless@vger.kernel.org>; Thu, 26 Jan 2012 19:27:18 +0000 (GMT)
From: David Goodenough <david.goodenough@btconnect.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [RFC 0/7] hostap: add DFS master ability
Date: Thu, 26 Jan 2012 19:27:17 +0000
References: <1327581689-22090-1-git-send-email-victorg@ti.com>
In-Reply-To: <1327581689-22090-1-git-send-email-victorg@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201201261927.17754.david.goodenough@btconnect.com> (sfid-20120126_202725_836168_C7299246)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 26 Jan 2012, Victor Goldenshtein wrote:
> This patch set (with nl/cfg/mac80211 patch series) adds support for DFS
> (Dynamic Frequency Selection) according 802.11h.
> 
> 
> Main idea
> ===================
> 
> DFS master algorithm is implemented in the hostapd, while nl/cfg/mac80211
> will pipe relevant commands/events to the driver/hostapd.
As I understand it hostapd is not involved in mesh (802.11s) networks,
so how does this integrate there?  As I understand it 802.11s is entirely
done in the kernel.

David
> 
> Based on the assumption that the device/driver supports radar interference
> detection i.e., it is capable to generate radar_detected event by using
> different pattern detection techniques:
> 
> 
> 1. Pattern detection in the HW: the device generates 'radar_detected'
> event. 2. Pattern detection in the driver: the driver receives radar
> pulses from the device and generates 'radar detected' event.
> 
> 
> Main DFS procedures
> ===================
> 
> 1. Hostapd gets driver's dfs capabilities.
> 
> 2. If 80211h is enabled in the hostapd.conf and the driver supports one of
> the above radar detection techniques, hostapd may use DFS channels.
> 
> 3. Hostapd selects an operational channel (default from hostapd.conf), if
> selected channel is a DFS channel, hostapd sends start_radar_detection
> command to the device/driver which starts monitoring for radar
> interference while hostapd sets a timer for a CAC (Channel Availability
> Check) time, which is 60 seconds.
> 
> 4. As CAC timer expires and no radar has been detected, hostapd may
> continue with the init flow, otherwise if interference is detected hostapd
> selects another channel (random selection) and repeats the CAC on the new
> channel (in case the new channel is also a DFS channel), while the
> original channel is added to a "black list" for a period of
> ''No-Occupancy'' time (time that the channel can't be used/selected).
> 
> 5. While using the channel the device/driver continuously monitors for
> potential radar interference. If interference is detected hostapd notified
> with 'radar detected' event, which selects a new channel and triggers a
> channel switch procedure, if the new channel is also a DFS channel,
> hostapd performs the CAC test, once it's successfully passed hostapd
> instructs the driver to initiate the transmission on the channel.
> 
> 
> Victor Goldenshtein (7):
>   hostapd: implement dfs drv ops functions
>   hostapd: add channel switch ability
>   hostapd: add dfs events
>   hostapd: add dfs support into interface init flow
>   nl80211: add support to enable TX on oper-channel
>   nl80211: add channel switch command/event
>   nl80211: add start radar detection command/event
> 
>  hostapd/config_file.c        |   10 +++
>  src/ap/ap_config.h           |    4 +
>  src/ap/ap_drv_ops.c          |   34 +++++++++
>  src/ap/ap_drv_ops.h          |    4 +
>  src/ap/beacon.c              |   16 ++++
>  src/ap/drv_callbacks.c       |   40 +++++++++++
>  src/ap/hostapd.c             |  158
> ++++++++++++++++++++++++++++++++++++++++-- src/ap/hostapd.h             | 
>  10 +++
>  src/ap/hw_features.c         |   48 ++++++++++---
>  src/ap/hw_features.h         |   10 +++
>  src/ap/ieee802_11.c          |  116 +++++++++++++++++++++++++++++++
>  src/ap/ieee802_11.h          |    4 +
>  src/drivers/driver.h         |   87 +++++++++++++++++++++++-
>  src/drivers/driver_common.c  |    2 +
>  src/drivers/driver_nl80211.c |  125 +++++++++++++++++++++++++++++++++
>  src/utils/eloop.c            |    4 +
>  src/utils/eloop.h            |    7 ++
>  17 files changed, 662 insertions(+), 17 deletions(-)

