Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCF13C65BAE
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 09:48:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8238820882
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 09:48:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="WwAZHyIx";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="mHcyNNzB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8238820882
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728042AbeLMJsj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 04:48:39 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:41346 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727928AbeLMJsi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 04:48:38 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id D4CDA602FA; Thu, 13 Dec 2018 09:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544694517;
        bh=gXF475Fqg4Xa25XzmnWgPzKJITyNrLr0C9phPnXHcOY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=WwAZHyIxJySdiKUpouSbffLmh7NQTQarJOGrz8VCfqtLoVsDfJ0lpfvTYA2wHvTOx
         KYMq51RfH0fIOBaOIFZL+jluhe+P0iesmY0I7lDVssrOmX3vfJ+w2rno3uki4sXGvD
         coFFoa0sKr0bO9wvQ6cii0kKq2rXqSvmBUMyk77o=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id F305F6095E;
        Thu, 13 Dec 2018 09:48:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544694516;
        bh=gXF475Fqg4Xa25XzmnWgPzKJITyNrLr0C9phPnXHcOY=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=mHcyNNzBnmn/QmhK29El8pIA4njE26Y63nlMdC+FpSVzx9o1Q/55yysOIGZ3cJIjg
         Zy1tqvsU04r4TtBebexSac8CeMP7kmFYL+uE5VGg8SRTPuKLOlAvHwvsuRNxp6pZ2q
         h51tX5p+SoxBBnryQpBhJe9Cg9Jn0VWHXqWEV55E=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org F305F6095E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     yhchuang@realtek.com, Larry.Finger@lwfinger.net,
        linux-wireless@vger.kernel.org, pkshih@realtek.com,
        tehuang@realtek.com
Subject: Re: [PATCH v2 00/13] rtw88: mac80211 driver for Realtek 802.11ac wireless network chips
References: <1542367879-28880-1-git-send-email-yhchuang@realtek.com>
        <20181212090743.GA13331@redhat.com>
Date:   Thu, 13 Dec 2018 11:48:32 +0200
In-Reply-To: <20181212090743.GA13331@redhat.com> (Stanislaw Gruszka's message
        of "Wed, 12 Dec 2018 10:07:43 +0100")
Message-ID: <87bm5pzrin.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stanislaw Gruszka <sgruszka@redhat.com> writes:

> On Fri, Nov 16, 2018 at 07:31:06PM +0800, yhchuang@realtek.com wrote:
>> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
>> 
>> This is a new mac80211 driver for Realtek 802.11ac wireless network chips.
>> rtw88 supports 8822BE and 8822CE chips, and will be able to support
>> multi-vif combinations in run-time.
>> 
>> For now, only PCI bus is supported, but rtw88 was originally designed
>> to optionally support three buses includes USB & SDIO. USB & SDIO modules
>> will soon be supported by rtw88, with configurable core module to fit
>> with different bus modules in the same time.
>
> Kalle, is here anything that stop the driver being merged ?

First of all, thanks for reviewing this. It helps a lot.

Before I'm willing to apply this needs review both from Johannes and me.
And of course some build testing in pending branch, I'll try to setup
that ASAP.

-- 
Kalle Valo
