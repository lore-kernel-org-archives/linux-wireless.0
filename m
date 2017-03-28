Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f172.google.com ([209.85.220.172]:33043 "EHLO
        mail-qk0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754450AbdC1KvO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 28 Mar 2017 06:51:14 -0400
Received: by mail-qk0-f172.google.com with SMTP id f11so61503761qkb.0
        for <linux-wireless@vger.kernel.org>; Tue, 28 Mar 2017 03:50:45 -0700 (PDT)
Subject: Re: [RFC v2 2/2] cfg80211: support 4-way handshake offloading for
 802.1X
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20170221123758.5339-1-johannes@sipsolutions.net>
 <20170221123758.5339-2-johannes@sipsolutions.net>
Cc: Avraham Stern <avraham.stern@intel.com>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <5274c4b4-9bce-208c-e3f2-640d54b81a30@broadcom.com> (sfid-20170328_125400_417188_D9126A2E)
Date: Tue, 28 Mar 2017 12:50:37 +0200
MIME-Version: 1.0
In-Reply-To: <20170221123758.5339-2-johannes@sipsolutions.net>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 21-2-2017 13:37, Johannes Berg wrote:
> From: Avraham Stern <avraham.stern@intel.com>
> 
> Add API for setting the PMK to the driver. For FT support, allow
> setting also the PMK-R0 Name.
> 
> This can be used by drivers that support 4-Way handshake offload
> while IEEE802.1X authentication is managed by upper layers.

So looking at wpa_supplicant RFC patches I see that it now diverts
driver_nl80211_set_key() for ALG_PMK case to the new api. So why not
extending CMD_NEW_KEY to support ALG_PMK?

Regards,
Arend
