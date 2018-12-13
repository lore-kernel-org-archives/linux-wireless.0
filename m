Return-Path: <SRS0=opxv=OW=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11A59C65BAE
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 09:46:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9BDC20873
	for <linux-wireless@archiver.kernel.org>; Thu, 13 Dec 2018 09:46:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="k+EGzFV1";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Rko4b6Mn"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A9BDC20873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727826AbeLMJqc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 13 Dec 2018 04:46:32 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:39238 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727210AbeLMJqc (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Dec 2018 04:46:32 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9CDC960312; Thu, 13 Dec 2018 09:46:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544694391;
        bh=yXdk/NTXRecYFaSwJUtylA8Q08/bu2kPPbGu5NIIZP8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=k+EGzFV1vMvaK2YywH5Lewzsw0VbrCDprG9rQ+BOTWIFHQVCjrFcd4zBB1RbBUG6g
         DAApnBOImEh0cqUmipUD21RRFNe3EHts751BQ7xHZ0RnJRU55mEtqrttKkOlFmy5N4
         iQH7OY6piuoz4IAofeTCLgE5ayTFvLT8nXku4ifM=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 189466071A;
        Thu, 13 Dec 2018 09:46:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1544694390;
        bh=yXdk/NTXRecYFaSwJUtylA8Q08/bu2kPPbGu5NIIZP8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Rko4b6Mn+KWGRXbP4e6Z09d2Jjx4E2OmqWQdREuQuCiHVN5C1RKZ7ErKJm54LD95a
         vKPfSsaUUDEHlvYCUqXe0Yq+K84ZXyAvK60mwUMmx03SO+ySjo92X4452L6bNiEHdS
         DADaakgx0N0oLpUDrIu4wxyCu4gkOLVdHIIlUU98=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 189466071A
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     "Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>
Subject: Re: [PATCH v2 01/13] rtw88: main files
References: <1542367879-28880-1-git-send-email-yhchuang@realtek.com>
        <1542367879-28880-2-git-send-email-yhchuang@realtek.com>
        <F7CD281DE3E379468C6D07993EA72F84D175FAF9@RTITMBSVM02.realtek.com.tw>
Date:   Thu, 13 Dec 2018 11:46:26 +0200
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D175FAF9@RTITMBSVM02.realtek.com.tw>
        (Tony Chuang's message of "Fri, 7 Dec 2018 08:23:21 +0000")
Message-ID: <87ftv1zrm5.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Tony Chuang <yhchuang@realtek.com> writes:

> This patch added a comment about our watch dog timer, please let me
> know if you are OK with it. Also if you have other questions about the
> series, just point it out and I will try to fix it. Thanks.

Thanks, I'll try to review the driver soon.

But PLEASE do not top post, it makes my use of patchwork much more
difficult. Just look at yourself how hard this page is to read now
because you decided to include the full patch in your reply:

https://patchwork.kernel.org/patch/10686099/

More info here:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#do_not_top_post_and_edit_your_quotes

-- 
Kalle Valo
