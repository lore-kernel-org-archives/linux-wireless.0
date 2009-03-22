Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:36144 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbZCVELn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2009 00:11:43 -0400
Received: by fxm2 with SMTP id 2so1359657fxm.37
        for <linux-wireless@vger.kernel.org>; Sat, 21 Mar 2009 21:11:40 -0700 (PDT)
From: Marek Vasut <marek.vasut@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Marvell CF8381
Date: Sun, 22 Mar 2009 05:11:50 +0100
Cc: libertas-dev@lists.infradead.org, hs4233@mail.mn-solutions.de
References: <200903220127.21836.marek.vasut@gmail.com>
In-Reply-To: <200903220127.21836.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200903220511.50229.marek.vasut@gmail.com> (sfid-20090322_051148_655459_21864B2F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sunday 22 of March 2009 01:27:21 Marek Vasut wrote:
> Hi,
> I've finally got this card working ...
> See the patches below.


One more thing - I also had to apply the following patch in order to get 
region code detected properly.

le16_to_cpu(cmd.regioncode) = 0x3031 for me and Im definitelly not in spain, 
but 0x30 (eu) looks reasonable.

diff --git a/drivers/net/wireless/libertas/cmd.c 
b/drivers/net/wireless/libertas/cmd.c
index 639dd02..ce32bc9 100644
--- a/drivers/net/wireless/libertas/cmd.c
+++ b/drivers/net/wireless/libertas/cmd.c
@@ -123,7 +123,7 @@ int lbs_update_hw_spec(struct lbs_private *priv)
         * only ever be 8-bit, even though the field size is 16-bit.  Some 
firmware
         * returns non-zero high 8 bits here.
         */
-       priv->regioncode = le16_to_cpu(cmd.regioncode) & 0xFF;
+       priv->regioncode = (le16_to_cpu(cmd.regioncode) & 0xFF00) >> 8;

        for (i = 0; i < MRVDRV_MAX_REGION_CODE; i++) {
                /* use the region code to search for the index */
