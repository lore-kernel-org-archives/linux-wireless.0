Return-Path: <SRS0=VbuY=V3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7AB5AC0650F
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Jul 2019 06:34:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4DE992054F
	for <linux-wireless@archiver.kernel.org>; Tue, 30 Jul 2019 06:34:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727373AbfG3Geb (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 30 Jul 2019 02:34:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33012 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726490AbfG3Geb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 30 Jul 2019 02:34:31 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 5EBBA307D90D;
        Tue, 30 Jul 2019 06:34:31 +0000 (UTC)
Received: from localhost (unknown [10.43.2.114])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 064EF5D9C5;
        Tue, 30 Jul 2019 06:34:30 +0000 (UTC)
Date:   Tue, 30 Jul 2019 08:34:04 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "briannorris@chromium.org" <briannorris@chromium.org>
Subject: Re: [PATCH v2 5/5] rtw88: add BT co-existence support
Message-ID: <20190730063403.GA3174@redhat.com>
References: <1564023211-3138-1-git-send-email-yhchuang@realtek.com>
 <1564023211-3138-6-git-send-email-yhchuang@realtek.com>
 <20190729081211.GB2066@redhat.com>
 <F7CD281DE3E379468C6D07993EA72F84D1881C82@RTITMBSVM04.realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D1881C82@RTITMBSVM04.realtek.com.tw>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.48]); Tue, 30 Jul 2019 06:34:31 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Jul 30, 2019 at 03:13:35AM +0000, Tony Chuang wrote:
> > Those coex response skb buffers are allocated in rtw_pci_rx_isr(),
> > but I do not see where they are freed (seems we do not process
> > them in c2h_work which does dev_kfree_skb()).
> 
> You're right, that SKB leaked. Should free them after responded.
> I will send v2 to fix it :)

FWIW maybe would be better to process coex commands entairly in
c2h_work ? Not sure if that would work or really would be better,
just an idea you can consider :-) 

Stanislaw
