Return-Path: <SRS0=QiZU=RR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9752DC43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 15:52:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 53B4420811
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Mar 2019 15:52:42 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jCzKomOW";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="jCzKomOW"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726585AbfCNPwl (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Mar 2019 11:52:41 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48550 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726431AbfCNPwl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Mar 2019 11:52:41 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 99C476053D; Thu, 14 Mar 2019 15:52:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552578760;
        bh=eocVKavULQQu1t2v2+nMguUPDHBO3EPC7oB2VYCV1tA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=jCzKomOW1pSHzt6vPK4df3DVgGRqddiP2Tm09NjxcZ0BNI7uT5nC8Cm56U7KtfwQs
         4LTAFFSat9B6CWegz17glsFnrawT6W4vSiRDoWfvH8XuHcr/o+u7SEJYCbDV214DO5
         P4q6MFHSeqWDtl1+x0KXdASF076H1WflNG1+9kbs=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 946CF60265;
        Thu, 14 Mar 2019 15:52:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552578760;
        bh=eocVKavULQQu1t2v2+nMguUPDHBO3EPC7oB2VYCV1tA=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=jCzKomOW1pSHzt6vPK4df3DVgGRqddiP2Tm09NjxcZ0BNI7uT5nC8Cm56U7KtfwQs
         4LTAFFSat9B6CWegz17glsFnrawT6W4vSiRDoWfvH8XuHcr/o+u7SEJYCbDV214DO5
         P4q6MFHSeqWDtl1+x0KXdASF076H1WflNG1+9kbs=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 946CF60265
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tom Psyborg <pozega.tomislav@gmail.com>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] ath9k: drop redundant code in ar9003_hw_set_channel
References: <1552417843-10935-1-git-send-email-pozega.tomislav@gmail.com>
        <1552417843-10935-2-git-send-email-pozega.tomislav@gmail.com>
        <87o96f1cya.fsf@codeaurora.org>
        <CAKR_QVL+4f4Y8Edj_tVeDefa0YMJM6N5mrBnXUF6MnxEJ98=gQ@mail.gmail.com>
        <87zhpxzit5.fsf@codeaurora.org>
        <CAKR_QV+Ogamn1uZxkOCAiNrPQ4PrMmqb-mMcuhY74MGS44An5w@mail.gmail.com>
Date:   Thu, 14 Mar 2019 17:52:36 +0200
In-Reply-To: <CAKR_QV+Ogamn1uZxkOCAiNrPQ4PrMmqb-mMcuhY74MGS44An5w@mail.gmail.com>
        (Tom Psyborg's message of "Thu, 14 Mar 2019 15:10:48 +0100")
Message-ID: <8736np5u7v.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tom Psyborg <pozega.tomislav@gmail.com> writes:

> Done.

Thanks. I see v2 now:

https://patchwork.kernel.org/project/linux-wireless/list/?series=91659

-- 
Kalle Valo
