Return-Path: <SRS0=CpGI=PI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0FADC43612
	for <linux-wireless@archiver.kernel.org>; Mon, 31 Dec 2018 09:07:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BAAAD20B1F
	for <linux-wireless@archiver.kernel.org>; Mon, 31 Dec 2018 09:07:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727040AbeLaJH3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 31 Dec 2018 04:07:29 -0500
Received: from smtprelay0215.hostedemail.com ([216.40.44.215]:49336 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726461AbeLaJH3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 31 Dec 2018 04:07:29 -0500
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 3306F837F242;
        Mon, 31 Dec 2018 09:07:27 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: rule16_23cc80d796000
X-Filterd-Recvd-Size: 2955
Received: from XPS-9350.home (unknown [47.151.153.53])
        (Authenticated sender: joe@perches.com)
        by omf11.hostedemail.com (Postfix) with ESMTPA;
        Mon, 31 Dec 2018 09:07:25 +0000 (UTC)
Message-ID: <9de7579ee09f4b1724201c7d7655c539e0a35868.camel@perches.com>
Subject: Re: [PATCH] NFC: st95hf: clean up indentation, add in missing tab
 on return statement
From:   Joe Perches <joe@perches.com>
To:     Colin King <colin.king@canonical.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Daniel Mack <daniel@zonque.org>, linux-wireless@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 31 Dec 2018 01:07:24 -0800
In-Reply-To: <20181230133801.7237-1-colin.king@canonical.com>
References: <20181230133801.7237-1-colin.king@canonical.com>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.30.1-1build1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, 2018-12-30 at 13:38 +0000, Colin King wrote:
> A return statement is not indented enough, fix this by adding the
> missing tab.
[]
> diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
[]
> @@ -672,7 +672,7 @@ static int st95hf_error_handling(struct st95hf_context *stcontext,
>  			result = -ETIMEDOUT;
>  		else
>  			result = -EIO;
> -	return  result;
> +		return  result;
>  	}
>  
>  	/* Check for CRC err only if CRC is present in the tag response */

trivia: this might read better using direct returns

 drivers/nfc/st95hf/core.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/nfc/st95hf/core.c b/drivers/nfc/st95hf/core.c
index 2b26f762fbc3..227b5f6dc26f 100644
--- a/drivers/nfc/st95hf/core.c
+++ b/drivers/nfc/st95hf/core.c
@@ -662,17 +662,15 @@ static int st95hf_error_handling(struct st95hf_context *stcontext,
 				 struct sk_buff *skb_resp,
 				 int res_len)
 {
-	int result = 0;
 	unsigned char error_byte;
 	struct device *dev = &stcontext->nfcdev->dev;
 
 	/* First check ST95HF specific error */
 	if (skb_resp->data[0] & ST95HF_ERR_MASK) {
 		if (skb_resp->data[0] == ST95HF_TIMEOUT_ERROR)
-			result = -ETIMEDOUT;
+			return -ETIMEDOUT;
 		else
-			result = -EIO;
-	return  result;
+			return -EIO;
 	}
 
 	/* Check for CRC err only if CRC is present in the tag response */
@@ -684,7 +682,7 @@ static int st95hf_error_handling(struct st95hf_context *stcontext,
 				/* CRC error occurred */
 				dev_err(dev, "CRC error, byte received = 0x%x\n",
 					error_byte);
-				result = -EIO;
+				return -EIO;
 			}
 		}
 		break;
@@ -695,12 +693,12 @@ static int st95hf_error_handling(struct st95hf_context *stcontext,
 			/* CRC error occurred */
 			dev_err(dev, "CRC error, byte received = 0x%x\n",
 				error_byte);
-			result = -EIO;
+			return -EIO;
 		}
 		break;
 	}
 
-	return result;
+	return 0;
 }
 
 static int st95hf_response_handler(struct st95hf_context *stcontext,


