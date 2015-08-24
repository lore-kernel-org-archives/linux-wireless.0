Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw3-out.broadcom.com ([216.31.210.64]:60523 "EHLO
	mail-gw3-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753921AbbHXOPb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Aug 2015 10:15:31 -0400
Message-ID: <55DB26FC.1060707@broadcom.com> (sfid-20150824_161553_165681_098B28B0)
Date: Mon, 24 Aug 2015 16:15:24 +0200
From: Arend van Spriel <arend@broadcom.com>
MIME-Version: 1.0
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
CC: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>
Subject: Re: [PATCH V2 3/7] brcmfmac: Increase nr of supported flowrings.
References: <1439708139-7527-1-git-send-email-arend@broadcom.com>	<1439708139-7527-4-git-send-email-arend@broadcom.com> <CACna6ryL04p-cHptZnvYZ9fvnGn3FafN9PPNxsMPPfmdkSEjnA@mail.gmail.com>
In-Reply-To: <CACna6ryL04p-cHptZnvYZ9fvnGn3FafN9PPNxsMPPfmdkSEjnA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/19/2015 11:56 PM, Rafał Miłecki wrote:
> On 16 August 2015 at 08:55, Arend van Spriel <arend@broadcom.com> wrote:
>> From: Hante Meuleman <meuleman@broadcom.com>
>>
>> Next generation devices will have firmware which will have more
>> than 256 flowrings. This patch increases the maximum number of
>> supported flowrings to 512.
>>
>> Reviewed-by: Arend Van Spriel <arend@broadcom.com>
>> Reviewed-by: Franky (Zhenhui) Lin <frankyl@broadcom.com>
>> Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
>> Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
>> Signed-off-by: Arend van Spriel <arend@broadcom.com>
>
> This is a patch that for my device triggers:
> Unable to handle kernel NULL pointer dereference at virtual address 00000014
>
> It seems to happen even when using only 1 AP interface.

Hi Rafał,

What happens is that your platform has no memory to allocate a flowring 
for tx and there is a bug in handling the returned error. Can you try it 
with following applied. You will still have memory issue so for OpenWrt 
you may need to limit to 256 anyway. Hante found another issue with 
hash_id in struct brcmf_flowring so we are not entirely sure which issue 
caused the null pointer deref so your feedback is appreciated.

Regards,
Arend
---
  drivers/net/wireless/brcm80211/brcmfmac/flowring.c | 4 ++--
  1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c 
b/drivers/net/wi
index 5b7a8ee..9fb50b3 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/flowring.c
@@ -151,11 +151,11 @@ u32 brcmf_flowring_create(struct brcmf_flowring 
*flow, u8
                                 break;
                 }
                 if (i == flow->nrofrings)
-                       return -ENOMEM;
+                       return BRCMF_FLOWRING_INVALID_ID;

                 ring = kzalloc(sizeof(*ring), GFP_ATOMIC);
                 if (!ring)
-                       return -ENOMEM;
+                       return BRCMF_FLOWRING_INVALID_ID;

                 memcpy(hash[hash_idx].mac, mac, ETH_ALEN);
                 hash[hash_idx].fifo = fifo;
-- 
1.9.1


