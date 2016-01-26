Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:9590 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756145AbcAZMpY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Jan 2016 07:45:24 -0500
Subject: Re: [RFC V3 0/2] nl80211: allow configuration of BSS selection
To: Johannes Berg <johannes@sipsolutions.net>
References: <1453802508-30195-1-git-send-email-arend@broadcom.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend van Spriel <arend@broadcom.com>
Message-ID: <56A76A60.6060503@broadcom.com> (sfid-20160126_134528_118005_1CFEC9F0)
Date: Tue, 26 Jan 2016 13:45:20 +0100
MIME-Version: 1.0
In-Reply-To: <1453802508-30195-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 26-1-2016 11:01, Arend van Spriel wrote:
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
>  - incorporate comments from Johannes Berg (may have missed some).
>  - split nl80211 patch in two separate patches.
> 
> V3:
>  - remove enum nl80211_bss_select_primitive.
>  - reword documentation of nl80211_bss_select_attr enum values.
> 
> Arend van Spriel (3):
>   nl80211: add extended feature for BSS selection support
>   nl80211: add bss selection attribute to CONNECT command
>   brcmfmac: add support for nl80211 BSS_SELECT feature

Hmmm. Made a bit of a mess with this version. Let's go to V4.

Regards,
Arend

>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 63 +++++++++++++++++-
>  .../wireless/broadcom/brcm80211/brcmfmac/common.c  | 38 ++++++-----
>  .../wireless/broadcom/brcm80211/brcmfmac/core.h    |  1 +
>  include/net/cfg80211.h                             | 34 ++++++++++
>  include/uapi/linux/nl80211.h                       | 42 ++++++++++++
>  net/wireless/core.c                                |  4 ++
>  net/wireless/nl80211.c                             | 76 ++++++++++++++++++++++
>  7 files changed, 240 insertions(+), 18 deletions(-)
> 
