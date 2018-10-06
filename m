Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01EABC65C30
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 12:32:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A48822084D
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 12:32:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kTsRRshK";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="kTsRRshK"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A48822084D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbeJFTfW (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 15:35:22 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:50836 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727202AbeJFTfW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 15:35:22 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D963C60C4E; Sat,  6 Oct 2018 12:32:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538829135;
        bh=pD4IaPeqy4W6gyGWt55RKB2as3P+6aPS09TUajh/Opg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kTsRRshKMC4vxPX5u9U0OoYgilnbrDajlbHw7Q6geEq+ayicr7+TpJIxzbGKTosbz
         hFVH35v2uSucvek25rBvqEwCxuAhOgkFWC5rC00vPDBJlmTWU9aj3/BAE3AlpeZ1p2
         8T83j04JiHI1beMwqKgmuYsMHUzLTRMvUQe9Bv0Y=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B225460BF4;
        Sat,  6 Oct 2018 12:32:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538829135;
        bh=pD4IaPeqy4W6gyGWt55RKB2as3P+6aPS09TUajh/Opg=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kTsRRshKMC4vxPX5u9U0OoYgilnbrDajlbHw7Q6geEq+ayicr7+TpJIxzbGKTosbz
         hFVH35v2uSucvek25rBvqEwCxuAhOgkFWC5rC00vPDBJlmTWU9aj3/BAE3AlpeZ1p2
         8T83j04JiHI1beMwqKgmuYsMHUzLTRMvUQe9Bv0Y=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B225460BF4
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Stanislaw Gruszka <sgruszka@redhat.com>,
        "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC v2 04/12] rtw88: trx files
References: <1538553748-26364-1-git-send-email-yhchuang@realtek.com>
        <1538553748-26364-5-git-send-email-yhchuang@realtek.com>
        <20181004131908.GD16819@redhat.com>
        <F7CD281DE3E379468C6D07993EA72F84D172A2BC@RTITMBSVM01.realtek.com.tw>
Date:   Sat, 06 Oct 2018 15:32:11 +0300
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D172A2BC@RTITMBSVM01.realtek.com.tw>
        (Tony Chuang's message of "Fri, 5 Oct 2018 09:20:01 +0000")
Message-ID: <878t3bfe7o.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tony Chuang <yhchuang@realtek.com> writes:

>> > +	pkt_info->bmc = bmc;
>> > +	pkt_info->sec_type = sec_type;
>> > +	pkt_info->tx_pkt_size = skb->len;
>> > +	pkt_info->offset = chip->tx_pkt_desc_sz;
>> > +	pkt_info->qsel = skb->priority;
>> 
>> Shouldn't be qsel somehow mapped from skb->priority ?
>
> Firmware handles it.

What if meaning of skb->priority changes in the future? I don't think
it's safe to provide kernel internal values to firmware, you should do
some kind of mapping in the driver.

-- 
Kalle Valo
