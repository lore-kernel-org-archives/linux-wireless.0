Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E5A2C00449
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 02:25:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 652492084D
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 02:25:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gGfrBXft"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 652492084D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbeJFJ0r (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 05:26:47 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:39341 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726913AbeJFJ0r (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 05:26:47 -0400
Received: by mail-pg1-f179.google.com with SMTP id r9-v6so5466105pgv.6;
        Fri, 05 Oct 2018 19:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:message-id:date:user-agent:mime-version
         :content-transfer-encoding:content-language;
        bh=HJN9qMF3a6jMmQc7BguOTW85vNjCcjakU1s57xEU9CI=;
        b=gGfrBXftcP6BSCs3aPPqdWl1qC+EyWB64k4BHzGt2DDEI9dUtI2NmfP59ZYx3XpO9n
         e7mBPYCCW6bQBsEm+kWxDrdb5YNw+6ADZpPKL+T9gcEUO1dXAJHZbjvJUuuWg6nCzm58
         mBQR09Cea3D9BVH7aoZTFOhMi9e0oP2UAnZcZGSJ/I6BnZTdeJtlmcZEbCZB1zLoE+5P
         /Ys5CeQ6wiLAWHhME7hC+LEBKf50XtSbXGZRgUdbCT2QYtefojN9xwEcmYQLGwzAj8yT
         ifiIyPlxKWd64Kq63aOBCxT6C6LgsRvEs7u6iDtzDyFCj08+Sso9SnVv4V6un2rDZnZf
         lsug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=HJN9qMF3a6jMmQc7BguOTW85vNjCcjakU1s57xEU9CI=;
        b=TP81vjVkfyWYTAs7MsV9K4e0I0McGwICaFzaAyeSz8Kv2qV8GZDsKCYnrwXl4wk27U
         ZgBrn719h20eqjFxDfdP6J0iRPfS/9LYbKeqdX/zrm8x3n9Rrj6MvNWZD5vh2+B4JNSC
         4fYdhX/SPivimiSrdIiXCXfWuhDNyh+dRl+GGqHk5rtHzzMyhMmVa57YyIDOolzokRX3
         2sTyiipmn9IkOH1lsvXRyWwovotb3atqI6LkM0AVxZwzZnjgx5oAkm/kdbNZmV0djbIy
         zbO0gN/UGFBakMm7jL+8RTx6NGZWMdrCAKxHUX3Bq4Scu9muD2SBE4tafDQgb07Z1ucr
         eCWw==
X-Gm-Message-State: ABuFfojz7NInbimKHVl36sn0KvxR0SMxEVt1FpHe7UKOM36M1eWZXlx0
        wu94SL7vVfmiywFUta5101L9g/j/
X-Google-Smtp-Source: ACcGV62FPMReHbLlY1TyBH4l+Xb4uTQXLmeyh58h6TIlIyDfeSDAyHxza4wLsIiIAgW8Tw3tlJciXQ==
X-Received: by 2002:a63:da17:: with SMTP id c23-v6mr12785113pgh.23.1538792718457;
        Fri, 05 Oct 2018 19:25:18 -0700 (PDT)
Received: from ?IPv6:2402:f000:1:1501:200:5efe:166.111.71.3? ([2402:f000:1:1501:200:5efe:a66f:4703])
        by smtp.gmail.com with ESMTPSA id p13-v6sm20601403pfd.65.2018.10.05.19.25.16
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 05 Oct 2018 19:25:17 -0700 (PDT)
From:   Jia-Ju Bai <baijiaju1990@gmail.com>
Subject: [Report] net: wireless: iwlegacy: Several possible data races
To:     sgruszka@redhat.com, kvalo@codeaurora.org, davem@davemloft.net
Cc:     linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Message-ID: <be47676b-baf3-7655-ff83-8b3ed370c624@gmail.com>
Date:   Sat, 6 Oct 2018 10:25:13 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.2.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

****** Possible race 0 ******
CPU0:
il4965_mac_tx
     il4965_tx_skb
         line 1687: spin_lock_irqsave(&il->lock, flags)
         line 1894: q->write_ptr = il_queue_inc_wrap(...) [WRITE]

CPU1:
il4965_irq_tasklet
     il_txq_update_write_ptr
         line 2749: il_wr(..., txq->q.write_ptr); [READ]
         line 2757: _il_wr(..., txq->q.write_ptr); [READ]

CPU2:
il_bg_watchdog
     il_check_stuck_queue
         line 4817: if (q->read_ptr == q->write_ptr) [READ]

CPU3:
il4965_irq_tasklet
     il4965_rx_handle
         line 4827, function pointer: il->handlers[pkt->hdr.cmd] (il, rxb);
         il4965_hdl_tx
             il_queue_used
                 line 868: return q->write_ptr >= ... q->write_ptr ... 
[READ]

As for q->write_ptr, the WRITE operation in CPU0 is performed with holding
a spinlock il->lock, but the READ operations in CPU1, CPU2 and CPU3
are performed without holding this spinlock, so there may exist data races.

****** Possible race 1 ******
CPU0:
il4965_irq_tasklet
     il4965_rx_handle
         line 4827, function pointer: il->handlers[pkt->hdr.cmd] (il, rxb);
         il4965_hdl_tx
             line 2834: spin_lock_irqsave(&il->sta_lock, flags)
             il4965_tx_queue_reclaim
                 line 2490: q->read_ptr = ... [WRITE]

CPU1:
il_bg_watchdog
     il_check_stuck_queue
         line 4817: q->read_ptr == q->write_ptr [READ]

As for q->read_ptr, the WRITE operation in CPU0 is performed with
holding a spinlock il->sta_lock, but the READ operation in CPU1 is
performed without holding this spinlock, so there may exist a data race.

****** Possible race 2 ******
CPU0:
il4965_mac_tx
     il4965_tx_skb
         line 1687: spin_lock_irqsave(&il->lock, flags)
         line 1863: txq->need_update = 1 [WRITE]

CPU1:
il4965_irq_tasklet
     il_txq_update_write_ptr
         line 2731: if (txq->need_update == 0) [READ]

As for txq->need_update, the WRITE operation in CPU0 is performed with
holding a spinlock il->lock, but the READ operation in CPU1 is performed
without holding this spinlock, so there may exist a data race.

I do not find good ways to fix these possible data races, so I only 
report them.


Best wishes,
Jia-Ju Bai
