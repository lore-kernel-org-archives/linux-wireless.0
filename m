Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:40362 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582AbaCKOWj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Mar 2014 10:22:39 -0400
Received: by mail-ig0-f182.google.com with SMTP id uy17so11338856igb.3
        for <linux-wireless@vger.kernel.org>; Tue, 11 Mar 2014 07:22:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <531ED921.5040601@openwrt.org>
References: <1393073299-4831-1-git-send-email-nbd@openwrt.org>
	<CAGXE3d_wmuDi2kUjvhLGxSFMAxwcYgjLXJ78fPgyHmDN7m0cSw@mail.gmail.com>
	<531ED921.5040601@openwrt.org>
Date: Tue, 11 Mar 2014 15:22:38 +0100
Message-ID: <CAGXE3d-ku6EZsAo6ZksXxU4g9KTANnphmSGz3H_NUMfkaJGnew@mail.gmail.com> (sfid-20140311_152242_790298_8FB749AD)
Subject: Re: [PATCH 3.14] ath9k: fix ps-poll responses under a-mpdu sessions
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 11, 2014 at 10:36 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2014-03-11 10:28, Helmut Schaa wrote:
>> On Sat, Feb 22, 2014 at 1:48 PM, Felix Fietkau <nbd@openwrt.org> wrote:
>>> When passing tx frames to the U-APSD queue for powersave poll responses,
>>> the ath_atx_tid pointer needs to be passed to ath_tx_setup_buffer for
>>> proper sequence number accounting.
>>>
>>> This fixes high latency and connection stability issues with ath9k
>>> running as AP and a few kinds of mobile phones as client, when PS-Poll
>>> is heavily used
>>>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>>> ---
>>
>> Hi Felix,
>>
>> this commit introduced a regression for me when using Intel Win7
>> clients on a ath9k AP.
>>
>> I was not able to track the exact issue down yet :( but it seems to be
>> related to the Intel
>> client constantly tearing down the BA session and entering/leaving PS mode.
>>
>> Any idea?
> Please make some packet captures and describe more clearly what the
> regression is. Do you see connections stalling, big latencies, etc?

>From what I can see with this patch action frames (like ADDBA and DELBA) get
sequence numbers from TID 0 assigned instead of a seq number from the global
counter. And that seems to "confuse" the client.

The following patch solves the issue for me and seems to still keep
Felix original intention ...

Thoughts?


>From 67282f91e649d946617276b94ee9d48c25fe1521 Mon Sep 17 00:00:00 2001
From: Helmut Schaa <helmut.schaa@googlemail.com>
Date: Tue, 11 Mar 2014 15:11:49 +0100
Subject: [PATCH] ath9k: Fix sequence number assignment for non-data frames


Signed-off-by: Helmut Schaa <helmut.schaa@googlemail.com>
---
 drivers/net/wireless/ath/ath9k/xmit.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c
b/drivers/net/wireless/ath/ath9k/xmit.c
index fafacfe..bda3432 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -2187,7 +2187,8 @@ int ath_tx_start(struct ieee80211_hw *hw, struct
sk_buff *skb,
         txq->stopped = true;
     }

-    if (txctl->an)
+    if (txctl->an &&
+        ieee80211_is_data_present(hdr->frame_control))
         tid = ath_get_skb_tid(sc, txctl->an, skb);

     if (info->flags & IEEE80211_TX_CTL_PS_RESPONSE) {
-- 
1.8.1.4
