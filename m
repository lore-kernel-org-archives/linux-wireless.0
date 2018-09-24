Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm1-f68.google.com ([209.85.128.68]:40728 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726241AbeIXOQq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 24 Sep 2018 10:16:46 -0400
Received: by mail-wm1-f68.google.com with SMTP id o2-v6so2453907wmh.5
        for <linux-wireless@vger.kernel.org>; Mon, 24 Sep 2018 01:15:52 -0700 (PDT)
Subject: Re: [PATCH v3] brcmsmac: AP mode: update beacon when TIM changes
To: Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
References: <20180911172618.13049-1-alimjalnasrawy@gmail.com>
 <20180923095425.10292-1-alimjalnasrawy@gmail.com>
Cc: linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        brcm80211-dev-list@cypress.com, Kalle Valo <kvalo@codeaurora.org>
From: Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <1d03765b-2643-1c86-f0e7-b42664252f08@broadcom.com> (sfid-20180924_101555_769099_B680D5F5)
Date: Mon, 24 Sep 2018 10:15:49 +0200
MIME-Version: 1.0
In-Reply-To: <20180923095425.10292-1-alimjalnasrawy@gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/23/2018 11:54 AM, Ali MJ Al-Nasrawy wrote:
> Beacons are not updated to reflect TIM changes. This is not compliant with
> power-saving client stations as the beacons do not have valid TIM and can cause
> the network to stall at random occasions with highly variable latencies.
> Fix it by updating beacon templates on mac80211 set_tim callback.
>
> Addresses an issue described in:
> https://marc.info/?i=20180911163534.21312d08%20()%20manjaro
>
> Signed-off-by: Ali MJ Al-Nasrawy <alimjalnasrawy@gmail.com>
> ---

Missing 'v1 -> v2' in this changelog.

Regards,
Arend

> v2 -> v3:
> 	- removed tabs from blank lines
> 	- extended the commit message to answer "Why"
>
>  .../broadcom/brcm80211/brcmsmac/mac80211_if.c | 21 +++++++++++++++++++
>  .../broadcom/brcm80211/brcmsmac/main.h        |  1 +
>  2 files changed, 22 insertions(+)
