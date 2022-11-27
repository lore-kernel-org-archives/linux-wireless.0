Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB169C4332F
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Nov 2022 14:38:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiK0OiD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 27 Nov 2022 09:38:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbiK0OiD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Nov 2022 09:38:03 -0500
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F547BC89
        for <linux-wireless@vger.kernel.org>; Sun, 27 Nov 2022 06:38:00 -0800 (PST)
Received: (wp-smtpd smtp.wp.pl 13133 invoked from network); 27 Nov 2022 15:37:57 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1669559877; bh=8cgHSPBj9NAR3GliVBYUYBwjL9DKVTnKCj2I4eiOCUg=;
          h=From:To:Cc:Subject;
          b=RZa8O624vKfS8SBhgPea4Kl5aaUtjgwd36uyI60ZJaRdSzssNcOOYOqQmzPExKzN2
           Yw4n5zZE/+YqSIEeHDO6nzuly45JN+H7/MD8RRisbP+pg2jJWXi/itzducM7A8UBsu
           XdHQ+Eni44CN7TZfFoXY31x2BdABqQE0VsGdmGNI=
Received: from 89-64-15-29.dynamic.chello.pl (HELO localhost) (stf_xl@wp.pl@[89.64.15.29])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <jnyb.de@gmail.com>; 27 Nov 2022 15:37:57 +0100
Date:   Sun, 27 Nov 2022 15:37:56 +0100
From:   Stanislaw Gruszka <stf_xl@wp.pl>
To:     Ioannis Barkas <jnyb.de@gmail.com>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: PRO/Wireless 4965 Intel WPA2,3 SSID connection problem #1
Message-ID: <20221127143756.GA550513@wp.pl>
References: <CADUzMVbWG9HC7gh=z_HMm2J7Wjgfbr4myY9YGHsPB4jGc6H+yQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADUzMVbWG9HC7gh=z_HMm2J7Wjgfbr4myY9YGHsPB4jGc6H+yQ@mail.gmail.com>
X-WP-MailID: fd97ddb0b2fed42c01a63ff968de9540
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [MYNk]                               
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Nov 25, 2022 at 09:44:17PM +0200, Ioannis Barkas wrote:

Hi
> /build/linux-JDy9aa/linux-5.19.0/drivers/net/wireless/intel/iwlegacy/4965-rs.c:671:18
> [  700.609078] shift exponent -1 is negative
> [  700.609088] CPU: 5 PID: 0 Comm: swapper/5 Tainted: P           O
>   5.19.0-21-generic #21-Ubuntu
> [  700.609099] Hardware name: Gigabyte Technology Co., Ltd.
> GA-880GMA-USB3/GA-880GMA-USB3, BIOS F4e 05/24/2012
> [  700.609105] Call Trace:
> [  700.609111]  <IRQ>
> [  700.609120]  show_stack+0x4e/0x61
> [  700.609139]  dump_stack_lvl+0x4a/0x6d
> [  700.609153]  dump_stack+0x10/0x18
> [  700.609163]  ubsan_epilogue+0x9/0x43
> [  700.609174]  __ubsan_handle_shift_out_of_bounds.cold+0x61/0xef
> [  700.609189]  ? __smp_call_single_queue+0x61/0xa0
> [  700.609203]  il4965_rs_get_adjacent_rate.constprop.0.cold+0x17/0x9c [iwl4965]

Could you test if below patch make this UBSAN error gone and card is working properly ?

Regards
Stanislaw

diff --git a/drivers/net/wireless/intel/iwlegacy/4965-rs.c b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
index 718efb1aa1b0..2baefb7c152c 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
@@ -667,7 +667,7 @@ il4965_rs_get_adjacent_rate(struct il_priv *il, u8 idx, u16 rate_mask,
 		u32 mask;
 
 		/* Find the previous rate that is in the rate mask */
-		i = idx - 1;
+		i = max_t(int, idx - 1, 0);
 		for (mask = (1 << i); i >= 0; i--, mask >>= 1) {
 			if (rate_mask & mask) {
 				low = i;
