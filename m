Return-Path: <SRS0=eo9X=ZL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_2 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AE20C432C0
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Nov 2019 13:36:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 595DF222F2
	for <linux-wireless@archiver.kernel.org>; Tue, 19 Nov 2019 13:36:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbfKSNf7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 19 Nov 2019 08:35:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:47754 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725798AbfKSNf7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 19 Nov 2019 08:35:59 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 35F11B1D3;
        Tue, 19 Nov 2019 13:35:57 +0000 (UTC)
Message-ID: <1574170553.28617.10.camel@suse.com>
Subject: Re: WARNING in ath6kl_htc_pipe_rx_complete
From:   Oliver Neukum <oneukum@suse.com>
To:     syzbot <syzbot+555908813b2ea35dae9a@syzkaller.appspotmail.com>,
        andreyknvl@google.com, davem@davemloft.net, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Date:   Tue, 19 Nov 2019 14:35:53 +0100
In-Reply-To: <0000000000008123610596c36579@google.com>
References: <0000000000008123610596c36579@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.26.6 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Am Donnerstag, den 07.11.2019, 07:34 -0800 schrieb syzbot:
> Hello,
> 
> syzbot found the following crash on:
> 
> HEAD commit:    d60bbfea usb: raw: add raw-gadget interface
> git tree:       https://github.com/google/kasan.git usb-fuzzer
> console output: https://syzkaller.appspot.com/x/log.txt?x=1029829ae00000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=79de80330003b5f7
> dashboard link: https://syzkaller.appspot.com/bug?extid=555908813b2ea35dae9a
> compiler:       gcc (GCC) 9.0.0 20181231 (experimental)
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1388a2aae00000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=13aa35dce00000
> 
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: syzbot+555908813b2ea35dae9a@syzkaller.appspotmail.com

#syz test: https://github.com/google/kasan.git d60bbfea

From d289a4973b869117a5a7f70297b0cecffceb8289 Mon Sep 17 00:00:00 2001
From: Oliver Neukum <oneukum@suse.com>
Date: Mon, 18 Nov 2019 19:23:25 +0100
Subject: [PATCH] ath6kl: reduce WARN to dev_dbg() in callback

The warn is triggered on a known race condition
that is correctly handled. Using WARN() hinders automated
testing. Reducing severity.

Signed-off-by: Oliver Neukum <oneukum@suse.com>
---
 drivers/net/wireless/ath/ath6kl/htc_pipe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/htc_pipe.c b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
index c68848819a52..9b88d96bfe96 100644
--- a/drivers/net/wireless/ath/ath6kl/htc_pipe.c
+++ b/drivers/net/wireless/ath/ath6kl/htc_pipe.c
@@ -960,8 +960,8 @@ static int ath6kl_htc_pipe_rx_complete(struct ath6kl *ar, struct sk_buff *skb,
 	 * Thus the possibility of ar->htc_target being NULL
 	 * via ath6kl_recv_complete -> ath6kl_usb_io_comp_work.
 	 */
-	if (WARN_ON_ONCE(!target)) {
-		ath6kl_err("Target not yet initialized\n");
+	if (!target) {
+		ath6kl_dbg(ATH6KL_DBG_HTC, "Target not yet initialized\n");
 		status = -EINVAL;
 		goto free_skb;
 	}
-- 
2.16.4

