Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56127 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab1CFXsQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Mar 2011 18:48:16 -0500
Received: by iyb26 with SMTP id 26so3472262iyb.19
        for <linux-wireless@vger.kernel.org>; Sun, 06 Mar 2011 15:48:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1299447258.5082.164.camel@wwguy-huron>
References: <1299257511-5241-1-git-send-email-sgruszka@redhat.com> <1299447258.5082.164.camel@wwguy-huron>
From: Daniel Halperin <dhalperi@cs.washington.edu>
Date: Sun, 6 Mar 2011 15:47:55 -0800
Message-ID: <AANLkTimNjxguAFcRr-mJr-pPMkf6zTxzm4k7oV+6zngG@mail.gmail.com>
Subject: Re: [PATCH 1/3] iwlwifi: move rx handlers code to iwl-rx.c
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This fixes the error for me.
Dan

index 7dc2d39..e3ba4d5 100644
--- a/drivers/net/wireless/iwlwifi/iwl-rx.c
+++ b/drivers/net/wireless/iwlwifi/iwl-rx.c
@@ -30,6 +30,7 @@
 #include <linux/etherdevice.h>
 #include <linux/slab.h>
 #include <net/mac80211.h>
+#include <linux/sched.h>
 #include <asm/unaligned.h>
 #include "iwl-eeprom.h"
 #include "iwl-dev.h"
-- 
1.7.0.4



On Sun, Mar 6, 2011 at 1:34 PM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> Hi Stanislaw,
>
> On Fri, 2011-03-04 at 08:51 -0800, Stanislaw Gruszka wrote:
>> Put generic rx_handlers (except iwlagn_rx_reply_compressed_ba) to
>> iwl-rx.c . Make functions static and change prefix from iwlagn_ to
>> iwl_ . Beautify iwl_setup_rx_handlers and do some other minor coding
>> style changes.
>>
>> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
>> ---
> this patch break the compiling
>
> drivers/net/wireless/iwlwifi/iwl-rx.c:778:17: error: undefined
> identifier 'TASK_INTERRUPTIBLE'
>  CC [M]  drivers/net/wireless/iwlwifi/iwl-rx.o
> drivers/net/wireless/iwlwifi/iwl-rx.c: In function
> ‘iwl_rx_card_state_notif’:
> drivers/net/wireless/iwlwifi/iwl-rx.c:778: error: ‘TASK_INTERRUPTIBLE’
> undeclared (first use in this function)
> drivers/net/wireless/iwlwifi/iwl-rx.c:778: error: (Each undeclared
> identifier is reported only once
> drivers/net/wireless/iwlwifi/iwl-rx.c:778: error: for each function it
> appears in.)
> make[1]: *** [drivers/net/wireless/iwlwifi/iwl-rx.o] Error 1
> make: *** [_module_drivers/net/wireless/iwlwifi] Error 2
>
>
> Thanks
> Wey
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
