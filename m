Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:54470 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbcANJPK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2016 04:15:10 -0500
Message-ID: <5697671B.2040302@broadcom.com> (sfid-20160114_101530_397654_CE4277A9)
Date: Thu, 14 Jan 2016 10:15:07 +0100
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>
Subject: Re: [RFC V2 0/3] nl80211: allow configuration of BSS selection
References: <1452678583-20086-1-git-send-email-arend@broadcom.com>
In-Reply-To: <1452678583-20086-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/13/2016 10:49 AM, Arend van Spriel wrote:
> This patch series adds support for configuration of BSS selection done by
> the driver and/or firmware. It allows user-space to pass selection criteria
> with the NL80211_CMD_CONNECT using NL80211_ATTR_BSS_SELECT. When user-space
> does provide this attribute and no explicit BSSID is provided it will pass
> the BSS selection criteria to the driver if the driver supports it.
>
> When multiple BSS-es are found belonging to the same ESS, ie. Infra-BSS with
> same SSID, the criteria can be used to select a BSS. The criteria defined are:
>
> 1. RSSI based selection.
> 2. Band selection, RSSI based selection.
> 3. RSSI adjustment in given band, RSSI based selection.
>
> V2:
>   - incorporate comments from Johannes Berg (may have missed some).
>   - split nl80211 patch in two separate patches.

I looked into the suggested mac80211 "demo", but it seems this bss 
selection could be handled in net/wireless/sme.c for drivers support 
.assoc() and friends instead of .connect(). However, I recall Jouni 
suggesting to have NL80211_ATTR_BSS_SELECT in NL80211_CMD_ASSOC as well. 
So I guess wpa_s uses that command directly?

Regards,
Arend

> Arend van Spriel (3):
>    nl80211: add extended feature for BSS selection support
>    nl80211: add bss selection attribute to CONNECT command
>    brcmfmac: add support for nl80211 BSS_SELECT feature
>
>   drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 63 ++++++++++++++++
>   drivers/net/wireless/brcm80211/brcmfmac/common.c   | 38 ++++++----
>   drivers/net/wireless/brcm80211/brcmfmac/core.h     |  1 +
>   include/net/cfg80211.h                             | 34 +++++++++
>   include/uapi/linux/nl80211.h                       | 52 +++++++++++++
>   net/wireless/core.c                                |  5 ++
>   net/wireless/nl80211.c                             | 86 ++++++++++++++++++++++
>   7 files changed, 264 insertions(+), 15 deletions(-)
>

