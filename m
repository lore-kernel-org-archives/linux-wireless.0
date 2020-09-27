Return-Path: <SRS0=HCd0=DE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C81BFC4346E
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Sep 2020 17:10:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 36A1823718
	for <linux-wireless@archiver.kernel.org>; Sun, 27 Sep 2020 17:10:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=nbd.name header.i=@nbd.name header.b="RrEkrF8F"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726310AbgI0RKF (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 27 Sep 2020 13:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726149AbgI0RKF (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 27 Sep 2020 13:10:05 -0400
Received: from nbd.name (nbd.name [IPv6:2a01:4f8:221:3d45::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4AB7C0613CE
        for <linux-wireless@vger.kernel.org>; Sun, 27 Sep 2020 10:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nbd.name;
         s=20160729; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:
        MIME-Version:Date:Message-ID:References:Cc:To:Subject:From:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=cuBki/a01Gw312W1/MiJ2xljS95DMWfcUu7o+X3KNqc=; b=RrEkrF8FxblepDdZLqqk3/QpI1
        ze1uZJMGZdHVhCmrqPGklJwUKWKmuaD3C2mnJgLXtpOq7IDT/uHLqUzy2qNKViUSqoKp1sc39TUyz
        S8UrIkkV6ZkeQcQLlgznpP43V4CtMNqEIgJcESirDpBKRWaITldS25QAhlly5ERlpLn0=;
Received: from p4ff134da.dip0.t-ipconnect.de ([79.241.52.218] helo=nf.local)
        by ds12 with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <nbd@nbd.name>)
        id 1kMaBR-00026h-HK; Sun, 27 Sep 2020 19:09:57 +0200
From:   Felix Fietkau <nbd@nbd.name>
Subject: [PATCH] mt76: mt7615: enable beacon filtering by default for offload
 fw
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Sean Wang <sean.wang@mediatek.com>
References: <bfe45686ca8d8b5db2b27e33859bea7450f7b920.1601133687.git.lorenzo@kernel.org>
 <a4e15f9f-a296-f862-6216-ed3b40423aa7@nbd.name>
 <CAJ0CqmU7TwUuuSJLVMM-ymgRigM-YuNDBrSOgzHi1R-wcFjr=g@mail.gmail.com>
Message-ID: <80630d1a-c088-6204-eeb5-e9366be19b60@nbd.name>
Date:   Sun, 27 Sep 2020 19:09:56 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <CAJ0CqmU7TwUuuSJLVMM-ymgRigM-YuNDBrSOgzHi1R-wcFjr=g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org


On 2020-09-27 18:27, Lorenzo Bianconi wrote:
>>
>> On 2020-09-26 17:22, Lorenzo Bianconi wrote:
>> > In order to reduce cpu cycles, enable hw beacon filter by default if the
>> > device is running offload fw
>> >
>> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>> The beacon filtering part and runtime pm needs to take into account that
>> there could be more than one vif and we might be running an AP as well.
>>
>> - Felix
>>
> 
> Do you mean we should run mt7615_mcu_set_bss_pm() for other vif types, e.g. AP?
> IIUC the fw can manage the rx beacon offload even for other modes.
> 
> @Sean: do we need to send any other message to mcu for rx beacon
> offload for AP mode? Can the fw properly manage it?
I think we need to clear MT_WF_RFCR_DROP_OTHER_BEACON (since it's a
global bit) and maybe also dev->pm.enable if we have an active interface
that is not in client mode.

- Felix
