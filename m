Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f183.google.com ([209.85.221.183]:55430 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab0EKLXv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 May 2010 07:23:51 -0400
Received: by qyk13 with SMTP id 13so7926474qyk.1
        for <linux-wireless@vger.kernel.org>; Tue, 11 May 2010 04:23:50 -0700 (PDT)
Date: Tue, 11 May 2010 13:23:33 +0200
From: Dan Carpenter <error27@gmail.com>
To: Sujith.Manoharan@atheros.com
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 5/5] ath9k_htc: Fix array overflow
Message-ID: <20100511112332.GZ27064@bicker>
References: <19433.14244.829946.555964@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <19433.14244.829946.555964@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 11, 2010 at 04:25:32PM +0530, Sujith.Manoharan@atheros.com wrote:
> Use ENDPOINT_MAX instead of HST_ENDPOINT_MAX.
> This fixes a stack corruption issue.
> 
> This is based on a patch sent by Dan Carpenter <error27@gmail.com>.
> 

There is a bit missing.  The tmp_endpoint variable is always non-null 
here.  Can you just roll this into your patch?

Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/drivers/net/wireless/ath/ath9k/htc_hst.c b/drivers/net/wireless/ath/ath9k/htc_hst.c
index 6a062a3..02e8e0f 100644
--- a/drivers/net/wireless/ath/ath9k/htc_hst.c
+++ b/drivers/net/wireless/ath/ath9k/htc_hst.c
@@ -124,7 +124,7 @@ static void htc_process_conn_rsp(struct htc_target *target,
 			}
 		}
 
-		if (!tmp_endpoint)
+		if (tepid == ENDPOINT0)
 			return;
 
 		endpoint->service_id = service_id;
