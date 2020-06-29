Return-Path: <SRS0=lFlT=AK=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1DCEC433E0
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Jun 2020 19:36:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CEFAE20672
	for <linux-wireless@archiver.kernel.org>; Mon, 29 Jun 2020 19:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733053AbgF2Tau (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 29 Jun 2020 15:30:50 -0400
Received: from smtprelay0012.hostedemail.com ([216.40.44.12]:43666 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732588AbgF2Tat (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 29 Jun 2020 15:30:49 -0400
Received: from smtprelay.hostedemail.com (10.5.19.251.rfc1918.com [10.5.19.251])
        by smtpgrave08.hostedemail.com (Postfix) with ESMTP id 3E23118003EE1
        for <linux-wireless@vger.kernel.org>; Mon, 29 Jun 2020 05:21:09 +0000 (UTC)
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay03.hostedemail.com (Postfix) with ESMTP id 097AD837F24C;
        Mon, 29 Jun 2020 05:21:09 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: rest95_0500c7f26e6c
X-Filterd-Recvd-Size: 4167
Received: from perches-mx.perches.com (imap-ext [216.40.42.5])
        (Authenticated sender: webmail@joe@perches.com)
        by omf03.hostedemail.com (Postfix) with ESMTPA;
        Mon, 29 Jun 2020 05:21:08 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 28 Jun 2020 22:21:08 -0700
From:   Joe Perches <joe@perches.com>
To:     pkshih@realtek.com
Cc:     kvalo@codeaurora.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] rtlwifi: 8821ae: remove unused path B parameters from
 swing table
In-Reply-To: <20200629032937.17374-2-pkshih@realtek.com>
References: <20200629032937.17374-1-pkshih@realtek.com>
 <20200629032937.17374-2-pkshih@realtek.com>
User-Agent: Roundcube Webmail/1.4-rc2
Message-ID: <be95d3c3e40e3670ed368b0df4ba397a@perches.com>
X-Sender: joe@perches.com
X-Originating-IP: [47.151.133.149]
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2020-06-28 20:29, pkshih@realtek.com wrote:
> From: Ping-Ke Shih <pkshih@realtek.com>
> 
> 8821AE is a 1x1 chip, so swing parameters for path B aren't necessary.

Then all the now unused arrays could be removed as well.
---
  .../net/wireless/realtek/rtlwifi/rtl8821ae/dm.c    | 34 
----------------------
  1 file changed, 34 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c 
b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
index 194d56a98ef2..97a30ccf0b27 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8821ae/dm.c
@@ -191,14 +191,6 @@ static const u8 
rtl8812ae_delta_swing_table_idx_5ga_p[][DEL_SW_IDX_SZ] = {
  	10, 10, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11, 11},
  };

-static const u8 rtl8821ae_delta_swing_table_idx_24gb_n[] = {
-	0, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6,
-	6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 10, 10, 10};
-
-static const u8 rtl8821ae_delta_swing_table_idx_24gb_p[]  = {
-	0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8,
-	8, 9, 9, 10, 10, 11, 11, 12, 12, 12, 12, 12, 12};
-
  static const u8 rtl8821ae_delta_swing_table_idx_24ga_n[]  = {
  	0, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6,
  	6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 10, 10, 10};
@@ -207,14 +199,6 @@ static const u8 
rtl8821ae_delta_swing_table_idx_24ga_p[] = {
  	0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8,
  	8, 9, 9, 10, 10, 11, 11, 12, 12, 12, 12, 12, 12};

-static const u8 rtl8821ae_delta_swing_table_idx_24gcckb_n[] = {
-	0, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6,
-	6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 10, 10, 10};
-
-static const u8 rtl8821ae_delta_swing_table_idx_24gcckb_p[] = {
-	0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8,
-	8, 9, 9, 10, 10, 11, 11, 12, 12, 12, 12, 12, 12};
-
  static const u8 rtl8821ae_delta_swing_table_idx_24gccka_n[] = {
  	0, 1, 1, 2, 2, 2, 3, 3, 3, 4, 4, 4, 5, 5, 5, 6, 6,
  	6, 7, 7, 7, 8, 8, 8, 9, 9, 9, 10, 10, 10};
@@ -223,24 +207,6 @@ static const u8 
rtl8821ae_delta_swing_table_idx_24gccka_p[] = {
  	0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8,
  	8, 9, 9, 10, 10, 11, 11, 12, 12, 12, 12, 12, 12};

-static const u8 rtl8821ae_delta_swing_table_idx_5gb_n[][DEL_SW_IDX_SZ] 
= {
-	{0, 0, 1, 2, 3, 3, 4, 5, 6, 6, 7, 8, 9, 9, 10, 11,
-	12, 12, 13, 14, 15, 15, 16, 16, 16, 16, 16, 16, 16, 16},
-	{0, 0, 1, 2, 3, 3, 4, 5, 6, 6, 7, 8, 9, 9, 10, 11,
-	12, 12, 13, 14, 15, 15, 16, 16, 16, 16, 16, 16, 16, 16},
-	{0, 0, 1, 2, 3, 3, 4, 5, 6, 6, 7, 8, 9, 9, 10, 11,
-	12, 12, 13, 14, 15, 15, 16, 16, 16, 16, 16, 16, 16, 16},
-};
-
-static const u8 rtl8821ae_delta_swing_table_idx_5gb_p[][DEL_SW_IDX_SZ] 
= {
-	{0, 0, 1, 2, 3, 3, 4, 5, 6, 6, 7, 8, 9, 9, 10, 11,
-	12, 12, 13, 14, 15, 15, 16, 16, 16, 16, 16, 16, 16, 16},
-	{0, 0, 1, 2, 3, 3, 4, 5, 6, 6, 7, 8, 9, 9, 10, 11,
-	12, 12, 13, 14, 15, 15, 16, 16, 16, 16, 16, 16, 16, 16},
-	{0, 0, 1, 2, 3, 3, 4, 5, 6, 6, 7, 8, 9, 9, 10, 11,
-	12, 12, 13, 14, 15, 15, 16, 16, 16, 16, 16, 16, 16, 16},
-};
-
  static const u8 rtl8821ae_delta_swing_table_idx_5ga_n[][DEL_SW_IDX_SZ] 
= {
  	{0, 0, 1, 2, 3, 3, 4, 5, 6, 6, 7, 8, 9, 9, 10, 11,
  	12, 12, 13, 14, 15, 15, 16, 16, 16, 16, 16, 16, 16, 16},

