Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qt0-f176.google.com ([209.85.216.176]:35548 "EHLO
        mail-qt0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753387AbdHGMYR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 Aug 2017 08:24:17 -0400
Received: by mail-qt0-f176.google.com with SMTP id p3so1470725qtg.2
        for <linux-wireless@vger.kernel.org>; Mon, 07 Aug 2017 05:24:17 -0700 (PDT)
Subject: Re: [PATCH v2 1/3] brcmfmac: set wpa_auth to WPA_AUTH_DISABLED in
 AP/OPEN security mode
To: Wright Feng <wright.feng@cypress.com>, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@codeaurora.org
References: <1501753079-1758-1-git-send-email-wright.feng@cypress.com>
Cc: linux-wireless@vger.kernel.org, brcm80211-dev-list.pdl@broadcom.com
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <59885BEE.7090102@broadcom.com> (sfid-20170807_142426_985661_2DF4F7FA)
Date: Mon, 7 Aug 2017 14:24:14 +0200
MIME-Version: 1.0
In-Reply-To: <1501753079-1758-1-git-send-email-wright.feng@cypress.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 8/3/2017 11:37 AM, Wright Feng wrote:
> brcmfmac: set wpa_auth to WPA_AUTH_DISABLED in AP/OPEN security mode
>
> When setting wpa_auth to WPA_AUTH_NONE(1) in AP mode with WEP security,
> firmware will set privacy bit and add WPA OUI in VENDOR IE in beacon and
> probe response. The security type in softAP beacons confuse the
> supplicant in client side, and the user client will see [WPA-?] in
> supplicant scan result. So we set WPA_AUTH_DISABLED in softAP mode with
> OPEN security.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> Signed-off-by: Wright Feng <wright.feng@cypress.com>
> ---
> v2: fix typo in commit message
> ---
>   drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
