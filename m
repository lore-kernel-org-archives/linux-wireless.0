Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:51504 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751819Ab2JMCsf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 22:48:35 -0400
Received: by mail-ie0-f174.google.com with SMTP id k13so5701053iea.19
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2012 19:48:35 -0700 (PDT)
Message-ID: <5078D67F.20208@lwfinger.net> (sfid-20121013_044846_774823_1ACBBD9C)
Date: Fri, 12 Oct 2012 21:48:31 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>, Jouni Malinen <j@w1.fi>,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	Dan Williams <dcbw@redhat.com>, Bing Zhao <bzhao@marvell.com>
Subject: Re: [PATCH 1/3] wireless: drivers: make use of WLAN_EID_VENDOR_SPECIFIC
References: <1350037696-23747-1-git-send-email-arend@broadcom.com> <1350037696-23747-2-git-send-email-arend@broadcom.com>
In-Reply-To: <1350037696-23747-2-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/12/2012 05:28 AM, Arend van Spriel wrote:
> The include file linux/ieee80211.h contains three definitions for
> the same thing in enum ieee80211_eid due to historic changes:
>
> /* Information Element IDs */
> enum ieee80211_eid {
>      :
>      WLAN_EID_WPA = 221,
>      WLAN_EID_GENERIC = 221,
>      WLAN_EID_VENDOR_SPECIFIC = 221,
>      :
> };
>
> The standard refers to this as "vendor specific" element so the
> other two definitions are better not used. This patch changes the
> wireless drivers to use one definition, ie. WLAN_EID_VENDOR_SPECIFIC.
>
> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Cc: Jouni Malinen <j@w1.fi>
> Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>
> Cc: Dan Williams <dcbw@redhat.com>
> Cc: Bing Zhao <bzhao@marvell.com>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>
> ---
> The prism54 and rtl8712 drivers use WLAN_EID_GENERIC as well, but have
> their own definition so those are not changed. They may consider using
> linux/ieee80211.h.

Arend,

Thanks for the r8712u suggestion.

Larry


