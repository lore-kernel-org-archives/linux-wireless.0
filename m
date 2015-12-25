Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f46.google.com ([74.125.82.46]:34831 "EHLO
	mail-wm0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751564AbbLYKI5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Dec 2015 05:08:57 -0500
Received: by mail-wm0-f46.google.com with SMTP id l126so201931536wml.0
        for <linux-wireless@vger.kernel.org>; Fri, 25 Dec 2015 02:08:57 -0800 (PST)
Subject: Re: [RFC 0/2] nl80211: allow configuration of BSS selection
To: Arend van Spriel <arend@broadcom.com>, johannes@sipsolutions.net
References: <1450959550-19655-1-git-send-email-arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
From: Arend van Spriel <aspriel@gmail.com>
Message-ID: <567D15B8.6080704@gmail.com> (sfid-20151225_110901_535979_90463BFF)
Date: Fri, 25 Dec 2015 11:08:56 +0100
MIME-Version: 1.0
In-Reply-To: <1450959550-19655-1-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24-12-15 13:19, Arend van Spriel wrote:
> This patch series adds support for configuration of BSS selection done by
> the driver and/or firmware. It allows user-space to pass selection criteria
> with the NL80211_CMD_CONNECT using NL80211_ATTR_BSS_SELECT. When user-space
> does provide this attribute and no explicit BSSID is provided it will pass
> the BSS selection criteria to the driver if the driver supports it.
> 
> When multiple BSS-es are found belonging to the same ESS, ie. Infra-BSS with
> same SSID, the criteria can be used to select a BSS. The criteria defined are:
> 
> 1. select BSS in specific band regardless RSSI level.

Not really regardless, but band would take precedence. So if there are
two BSS-es in the specified band it will still select the one with
highest RSSI.

> 2. adjust RSSI level for BSS-es in specified band.

I defined the attribute as unsigned, but maybe there are scenarios that
justify a signed value here. People may prefer using 5G band as it is
usually more quiet and channels are further apart. However, range can be
limited so people may use a penalty on RSSI, ie. a negative value.

Gr. AvS

> Open issue:
> -----------
> * NL80211_CMD_CONNECT support ATTR_MAC and ATTR_MAC_HINT. When ATTR_MAC is
>   used BSS selection criteria are ignored. What about ATTR_MAC_HINT?
> 
> Arend van Spriel (2):
>   nl80211: add extended feature for BSS selection support
>   brcmfmac: add support for nl80211 BSS_SELECT feature
> 
>  drivers/net/wireless/brcm80211/brcmfmac/cfg80211.c | 47 ++++++++++++++++++++++
>  drivers/net/wireless/brcm80211/brcmfmac/common.c   | 38 ++++++++++-------
>  drivers/net/wireless/brcm80211/brcmfmac/core.h     |  1 +
>  include/net/cfg80211.h                             | 17 ++++++++
>  include/uapi/linux/nl80211.h                       | 35 ++++++++++++++++
>  net/wireless/nl80211.c                             | 46 +++++++++++++++++++++
>  6 files changed, 169 insertions(+), 15 deletions(-)
> 
