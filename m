Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25319 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758980Ab2JLLmD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Oct 2012 07:42:03 -0400
Message-ID: <5077F4F3.8030409@qca.qualcomm.com> (sfid-20121012_134218_776980_A2C1D8D3)
Date: Fri, 12 Oct 2012 13:46:11 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	Linux Wireless List <linux-wireless@vger.kernel.org>,
	Jouni Malinen <j@w1.fi>,
	Stanislav Yakovlev <stas.yakovlev@gmail.com>,
	Dan Williams <dcbw@redhat.com>, Bing Zhao <bzhao@marvell.com>,
	Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH 1/3] wireless: drivers: make use of WLAN_EID_VENDOR_SPECIFIC
References: <1350037696-23747-1-git-send-email-arend@broadcom.com> <1350037696-23747-2-git-send-email-arend@broadcom.com>
In-Reply-To: <1350037696-23747-2-git-send-email-arend@broadcom.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/12/2012 01:28 PM, Arend van Spriel wrote:
> The include file linux/ieee80211.h contains three definitions for
> the same thing in enum ieee80211_eid due to historic changes:
> 
> /* Information Element IDs */
> enum ieee80211_eid {
>     :
>     WLAN_EID_WPA = 221,
>     WLAN_EID_GENERIC = 221,
>     WLAN_EID_VENDOR_SPECIFIC = 221,
>     :
> };
>
> The standard refers to this as "vendor specific" element so the
> other two definitions are better not used. This patch changes the
> wireless drivers to use one definition, ie. WLAN_EID_VENDOR_SPECIFIC.

Why not remove _WPA and _GENERIC from ieee80211.h at the same time so
that nobody else won't use them in the future?

> Cc: Kalle Valo <kvalo@qca.qualcomm.com>
> Cc: Jouni Malinen <j@w1.fi>
> Cc: Stanislav Yakovlev <stas.yakovlev@gmail.com>
> Cc: Dan Williams <dcbw@redhat.com>
> Cc: Bing Zhao <bzhao@marvell.com>
> Cc: Larry Finger <Larry.Finger@lwfinger.net>
> Signed-off-by: Arend van Spriel <arend@broadcom.com>

For the ath6kl part:

Acked-by: Kalle Valo <kvalo@qca.qualcomm.com>

Kalle
