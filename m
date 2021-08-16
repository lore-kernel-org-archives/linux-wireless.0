Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC0F5C4338F
	for <linux-wireless@archiver.kernel.org>; Mon, 16 Aug 2021 11:54:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CE6426323D
	for <linux-wireless@archiver.kernel.org>; Mon, 16 Aug 2021 11:54:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbhHPLzZ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 16 Aug 2021 07:55:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbhHPLzY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 Aug 2021 07:55:24 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36F5FC061764
        for <linux-wireless@vger.kernel.org>; Mon, 16 Aug 2021 04:54:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=aOpoZaetcZQnnRA0uKN7QU2Rzjn197f3bRPgPzR+YW4=; b=FoKXRqxHm9ezvl2YdU03NYwWeE
        iK68Z6GJUb6VDs8Mr3y7/Ax+bSUQMJpVMqHGn27V/wYQXKW6gY7zP2Az1UtEDEq598MHwkLygZCVb
        TBshKRYZdNxUG4JCoWP2ibtptnawR8iAfPIHayus8i+y83F26gON32pMzIPBPaW8tYvs=;
Received: from p4ff13206.dip0.t-ipconnect.de ([79.241.50.6] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1mFbCY-0005gd-T2; Mon, 16 Aug 2021 13:54:46 +0200
Subject: Re: [PATCH 2/3] mt76: mt7915: rework debugfs queue info
To:     Ryder Lee <ryder.lee@mediatek.com>
Cc:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Evelyn Tsai <evelyn.tsai@mediatek.com>,
        linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
        Sujuan Chen <sujuan.chen@mediatek.com>
References: <3f393508b9ed8251f4e2408356110af092c8ad3e.1629073504.git.ryder.lee@mediatek.com>
 <a36459de6c378583c84ea737101ce2a2da0c8f5b.1629073504.git.ryder.lee@mediatek.com>
From:   Felix Fietkau <nbd@nbd.name>
Message-ID: <ec48be04-d5f5-5221-c99b-401c91d05710@nbd.name>
Date:   Mon, 16 Aug 2021 13:54:46 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <a36459de6c378583c84ea737101ce2a2da0c8f5b.1629073504.git.ryder.lee@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2021-08-16 02:32, Ryder Lee wrote:
> Complete PSE/PLE queue statistics, including per-sta AC queue
> information.
> 
> Co-developed-by: Sujuan Chen <sujuan.chen@mediatek.com>
> Signed-off-by: Sujuan Chen <sujuan.chen@mediatek.com>
> Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Does this depend on any other patches? I'm getting compile errors
because of missing defines like MT_CTX0

- Felix
