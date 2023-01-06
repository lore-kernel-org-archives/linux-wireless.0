Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A87F7C5479D
	for <linux-wireless@archiver.kernel.org>; Fri,  6 Jan 2023 10:18:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjAFKS4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 6 Jan 2023 05:18:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233760AbjAFKS3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 6 Jan 2023 05:18:29 -0500
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4750D26E8
        for <linux-wireless@vger.kernel.org>; Fri,  6 Jan 2023 02:18:26 -0800 (PST)
Received: (wp-smtpd smtp.wp.pl 15989 invoked from network); 6 Jan 2023 11:18:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1673000303; bh=PNw2w9IynA9dhg+0BXAX2mG+8xC0xN3sSjZgRTrUy2k=;
          h=From:To:Cc:Subject;
          b=HvFKJqvncCfqqvdgOT31sdIinFMMK4bGhMdyXTLJUqTMIRsozJYlADS/MNdaGjPXF
           0ebhJaQpD+M7OkAFN1R3b0d8Rqrjt5FTCuMlHk+tZr69yarOmD5+m/d4CEUoGO//ZS
           clfVqosQZgQ5rNvQfDY2TErCjDunRjfN1W30UcDY=
Received: from 89-64-1-45.dynamic.chello.pl (HELO localhost) (stf_xl@wp.pl@[89.64.1.45])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <jiapeng.chong@linux.alibaba.com>; 6 Jan 2023 11:18:23 +0100
Date:   Fri, 6 Jan 2023 11:18:23 +0100
From:   Stanislaw Gruszka <stf_xl@wp.pl>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     helmut.schaa@googlemail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Abaci Robot <abaci@linux.alibaba.com>
Subject: Re: [PATCH v2] wifi: rt2x00: Remove useless else if
Message-ID: <20230106101823.GA994926@wp.pl>
References: <20230106022731.111243-1-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106022731.111243-1-jiapeng.chong@linux.alibaba.com>
X-WP-MailID: 9c2c211b270cb0c6755bfb4135db918b
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [YXO0]                               
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Jan 06, 2023 at 10:27:31AM +0800, Jiapeng Chong wrote:
> The assignment of the else and else if branches is the same, so the else
> if here is redundant, so we remove it.
> 
> ./drivers/net/wireless/ralink/rt2x00/rt2800lib.c:8927:9-11: WARNING:
> possible condition with no effect (if == else).
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3631
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
