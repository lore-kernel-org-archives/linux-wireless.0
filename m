Return-Path: <SRS0=IMqP=SN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEB0EC10F13
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 23:13:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BEF120850
	for <linux-wireless@archiver.kernel.org>; Thu, 11 Apr 2019 23:13:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Caztiqwv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726748AbfDKXNf (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 11 Apr 2019 19:13:35 -0400
Received: from mail-it1-f169.google.com ([209.85.166.169]:54924 "EHLO
        mail-it1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726630AbfDKXNf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 11 Apr 2019 19:13:35 -0400
Received: by mail-it1-f169.google.com with SMTP id a190so4265639ite.4
        for <linux-wireless@vger.kernel.org>; Thu, 11 Apr 2019 16:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=NFD91hUg3kjc1aLXrjAfQLbS4sSh3tkkHy6+tdYVlvY=;
        b=Caztiqwv7ns8Ogg7gjh6ontX1agw9dWjnG/aaGQQBJVieSW1B4HYqtELatctNdGifh
         AvHFOtEs9y0cyMcuF2JiPM9qMAiwNuq684eAWFBBJD/D4v/mmn0VUf0PfzIk9Q7ssaJR
         lieF79AH+hufW4ZVGanrUIjtdZ/irDBk99VjisPbiR5l/GCb4dQf+1sop/MIyZ3kMom4
         3yPlt0KXdYyUBfi66BOp/W3oIXyEqXA8cJ2yRzi63lQH/rA0drDS+mkteJngKv2kNcdQ
         8Z23/KHY/8O67ONsL1Mr5OjCgsY1dOyD0Wso+er6IRlxJz4K+9Hy0GZGDXcAmYrOgEo5
         x/hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=NFD91hUg3kjc1aLXrjAfQLbS4sSh3tkkHy6+tdYVlvY=;
        b=YV6UVwvQRnAh9+srduJlrORT58F9ErGUfuOw0XpH/B/hZM4WX1R4bVcdtBX7fGTona
         N90Oc4+oBFTO8vI5UaLjmMq4xUe7Q/LzhQiIMUfzxzsyG8XRkSQ7pose0/+APc6kQPni
         Eu7WH06QfxnFYlTWxOIzTjIT7HFP7rtLJYsChdatrjW7iBJ6yBitTdnGMLbFhgHJYDdK
         zqvlY7zjXKwopj5IsB7ESOlxJ6+WupkOrDMUFzwBO+3dHDnLCYNxw34jp4rfPujRoLsX
         uQngMeotCxkDp4P/rj+kyT223F07WhvYxWpy/5YXhMXMTW1X5Acfg4cPcHe5uK/TYGSZ
         0YHA==
X-Gm-Message-State: APjAAAXlY+ZHX/eMFPKavLMzeUmq5EM2R6wCcZbyFnv2haixnh9UHxXZ
        vpfMIQGcT7GpInrxzQX69S5esNppQ3xGR6pVMCCu5ek0lDk=
X-Google-Smtp-Source: APXvYqyhXFl+SOAwPpEgTjyaVsK7xnEaUuxbosg5lm8L79vIH7y+z4DUH+Bh9VcPFqHzN881ZrfoXjLSWnD2zBfiD18=
X-Received: by 2002:a24:2f49:: with SMTP id j70mr10520059itj.122.1555024414140;
 Thu, 11 Apr 2019 16:13:34 -0700 (PDT)
MIME-Version: 1.0
From:   Joshua Zhao <swzhao@gmail.com>
Date:   Thu, 11 Apr 2019 16:13:23 -0700
Message-ID: <CAKmTU=rcMYRg0oays=9AAwBaEnUDo3bMzfdW-5ytpUfaTvc2qg@mail.gmail.com>
Subject: Zero TID queue stats in dump_htt_stats?
To:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,
I'm running ath10k driver on QCA IPQ4019. When I enable htt_stats_mask
by "echo 0x1FFFF >
/sys/kernel/debug/ieee80211/phy0/ath10k/htt_stats_mask" I can see tx
rates / rx rates / etc get updated. But the TID queue related stats
are always 0.
Is this known and expected?  Is there anything related to that now
fq_codel in mac80211 handles txq scheduling?

Thanks,
Joshua
