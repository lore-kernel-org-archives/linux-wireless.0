Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f49.google.com ([74.125.82.49]:43710 "EHLO
        mail-wm0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750998AbdISH4Z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Sep 2017 03:56:25 -0400
Received: by mail-wm0-f49.google.com with SMTP id a137so16944989wma.0
        for <linux-wireless@vger.kernel.org>; Tue, 19 Sep 2017 00:56:25 -0700 (PDT)
Subject: Re: [TDLS PATCH V3 1/5] mac80211: Enable TDLS peer buffer STA feature
To: yintang@qti.qualcomm.com, ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <TDLS for ath10k patchset v3>
 <1505790913-28377-1-git-send-email-yintang@qti.qualcomm.com>
 <1505790913-28377-2-git-send-email-yintang@qti.qualcomm.com>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <db428527-cb2b-5136-24c2-be2fca9e2407@broadcom.com> (sfid-20170919_095629_313381_9836835D)
Date: Tue, 19 Sep 2017 09:56:22 +0200
MIME-Version: 1.0
In-Reply-To: <1505790913-28377-2-git-send-email-yintang@qti.qualcomm.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19-09-17 05:15, yintang@qti.qualcomm.com wrote:
> From: Yingying Tang <yintang@qti.qualcomm.com>
> 
> Enable TDLS peer buffer STA feature.
> Set extended capability bit to enable buffer STA when driver
> support it.
> 
> Signed-off-by: Yingying Tang <yintang@qti.qualcomm.com>
> ---
>   include/net/cfg80211.h |    3 +++
>   net/mac80211/tdls.c    |    5 ++++-
>   2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> index f12fa52..edefc25 100644
> --- a/include/net/cfg80211.h
> +++ b/include/net/cfg80211.h
> @@ -3249,6 +3249,8 @@ struct cfg80211_ops {
>    *	beaconing mode (AP, IBSS, Mesh, ...).
>    * @WIPHY_FLAG_HAS_STATIC_WEP: The device supports static WEP key installation
>    *	before connection.
> + * @WIPHY_FLAG_SUPPORT_TDLS_BUFFER_STA: Device support buffer STA when TDLS is
> + *	established.

If I am not mistaken no new wiphy flags are supposed to be added. 
Although this might be something not reported to user-space, right? Have 
a look at struct wiphy::ext_features.

Regards,
Arend
