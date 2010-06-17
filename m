Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48970 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259Ab0FQSt6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jun 2010 14:49:58 -0400
Received: by gye5 with SMTP id 5so234719gye.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Jun 2010 11:49:57 -0700 (PDT)
Message-ID: <4C1A6E4F.6000708@cortland.com>
Date: Thu, 17 Jun 2010 12:49:51 -0600
From: Steve Brown <sbrown@cortland.com>
MIME-Version: 1.0
To: Bob Copeland <me@bobcopeland.com>
CC: ath5k-devel@venema.h4ckr.net, linux-wireless@vger.kernel.org
Subject: Re: OOPS in ath5k when setting coverage class
References: <4C1926E7.1070503@cortland.com> <AANLkTil-qhJ7fO3RNm4xwG1fA6uKeTkrD352ICU-z8Ab@mail.gmail.com>
In-Reply-To: <AANLkTil-qhJ7fO3RNm4xwG1fA6uKeTkrD352ICU-z8Ab@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/17/2010 11:39 AM, Bob Copeland wrote:
> On Wed, Jun 16, 2010 at 3:32 PM, Steve Brown<sbrown@cortland.com>  wrote:
>    
>>  From the printk's, it appears that ah->ah_current_channel isn't set at the
>> time of the callback.
>>
>> The following produces the oops with compat-wireless-2010-06-10.
>>      
> Thanks for the report - your analysis looks spot on.
> I'll take a look tonight.
>
>    
I went a little further and tested the following patch.

If it makes sense to you, I'll submit it.

Steve

---

--- a/drivers/net/wireless/ath/ath5k/pcu.c.orig    2010-06-17 
10:41:29.070150186 -0600
+++ b/drivers/net/wireless/ath/ath5k/pcu.c    2010-06-17 
10:56:27.529275091 -0600
@@ -251,7 +251,6 @@
  static unsigned int ath5k_hw_get_default_slottime(struct ath5k_hw *ah)
  {
      struct ieee80211_channel *channel = ah->ah_current_channel;
-
      if (channel->hw_value & CHANNEL_TURBO)
          return 6; /* both turbo modes */

@@ -846,13 +845,23 @@
  void ath5k_hw_set_coverage_class(struct ath5k_hw *ah, u8 coverage_class)
  {
      /* As defined by IEEE 802.11-2007 17.3.8.6 */
-    int slot_time = ath5k_hw_get_default_slottime(ah) + 3 * coverage_class;
-    int ack_timeout = ath5k_hw_get_default_sifs(ah) + slot_time;
-    int cts_timeout = ack_timeout;
+    int slot_time, ack_timeout, cts_timeout;
+
+    ah->ah_coverage_class = coverage_class;

+    /*
+     * If channel isn't set, just exit.
+     * We will be called again on a channel change.
+     */
+    if (ah->ah_current_channel == NULL)
+        return;
+
+    slot_time = ath5k_hw_get_default_slottime(ah) + 3 * coverage_class;
      ath5k_hw_set_slot_time(ah, slot_time);
+
+    ack_timeout = ath5k_hw_get_default_sifs(ah) + slot_time;
      ath5k_hw_set_ack_timeout(ah, ack_timeout);
-    ath5k_hw_set_cts_timeout(ah, cts_timeout);

-    ah->ah_coverage_class = coverage_class;
+    cts_timeout = ack_timeout;
+    ath5k_hw_set_cts_timeout(ah, cts_timeout);
  }
