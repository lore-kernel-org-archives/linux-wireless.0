Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from krieglstein.org ([176.28.13.145]:50948 "EHLO krieglstein.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750937AbeAWPUE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Jan 2018 10:20:04 -0500
From: Tim Sander <tim@krieglstein.org>
To: linux-wireless <linux-wireless@vger.kernel.org>,
        shikha.singh@st.com
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>
Subject: PATCH for nfcst (out of tree stuff)  was Re: [linux-nfc] st95hf driver not working with neard 0.16
Date: Tue, 23 Jan 2018 16:20:02 +0100
Message-ID: <3546776.J2PkCpDXvZ@dabox> (sfid-20180123_162008_854333_4099F755)
In-Reply-To: <6803968.AFljYLBCnO@dabox>
References: <6803968.AFljYLBCnO@dabox>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi 

Am Montag, 22. Januar 2018, 17:51:51 CET schrieb Tim Sander:
<snip>
> When using the st,stnfc driver linked at the beginning it works with tags:
> nfctool -d nfc0 -p initiate
> Start polling on nfc0 as initiator
> 
> Targets found for nfc0
>   Tags: [ tag3 ]
>   Devices: [ ]
> 
> But as soon as i put a X-NUCLEO-NFC04A1 board on the st95hf reader i get the
> following output:
> skbuff: skb_over_panic: text:7f05c48c len:514 put:514 head:9dd26e00
> data:9dd26e01 tail:0x9dd27003 end:0x9dd26f40 dev:<NULL> ------------[ cut
> here ]------------
At least for the out of tree nfcst driver there i was able to fix the error.
The bugsplat shows that the needed space for the buffer is 514 byte,
so by increasing the buffer size to that, the error went away.
---
 drivers/nfc/nfcst/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nfc/nfcst/core.c b/drivers/nfc/nfcst/core.c
index 1dba0aae5a97..732d7fd61929 100644
--- a/drivers/nfc/nfcst/core.c
+++ b/drivers/nfc/nfcst/core.c
@@ -63,7 +63,7 @@
 #define DEVICE_TAILROOM_LEN            1
 
 /* Command Response interface */
-#define MAX_RESPONSE_BUFFER_SIZE       280
+#define MAX_RESPONSE_BUFFER_SIZE       514
 #define ECHORESPONSE                   0x55
 #define DEVICE_ERR_MASK                        0xF
 #define DEVICE_TIMEOUT_ERROR           0x87
-- 
2.7.4

Best regards
Tim
