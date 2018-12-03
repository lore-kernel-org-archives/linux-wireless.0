Return-Path: <SRS0=6FTc=OM=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30F7BC04EBF
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 13:34:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E532520850
	for <linux-wireless@archiver.kernel.org>; Mon,  3 Dec 2018 13:34:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Eu7EEWyd";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="VNEgVOx3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E532520850
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbeLCNeg (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 3 Dec 2018 08:34:36 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:53284 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725861AbeLCNef (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 3 Dec 2018 08:34:35 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1139560B1E; Mon,  3 Dec 2018 13:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543844013;
        bh=PB3D5L6g+jjsMX3IP1Fe7mEV1OkvjJMGd+yqV5HQnD4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Eu7EEWydyRUSI0tyEfGzYNl54bNNeuw34cLYHa/330SviWSs2kHAXy8jjeTIyWOMq
         IjPy1DkNIhSFr4d8JiS5J1mCyMN6EX0RZmWmoaKHcFW5DnAMrgAbaxA2m4qxD7ckwA
         DCaqZggE5TzvUpI3lfvlDsVy+HsOqVy0aKHz3Vqk=
Received: from x230.qca.qualcomm.com (37-33-92-201.bb.dnainternet.fi [37.33.92.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id EC4CE60AD8;
        Mon,  3 Dec 2018 13:33:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543844012;
        bh=PB3D5L6g+jjsMX3IP1Fe7mEV1OkvjJMGd+yqV5HQnD4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=VNEgVOx3wnvHxGo7qpjq7TuifyKZxwX6mOrrGvtPORjgNf3zwwiZy7KAsKClbxcPt
         qbAYFM86Gt74wAUTcxj4E4R5YXqSKwAZBaMoEJbqdRb0MCY9HPQitZQ2/bpOYQD3j/
         skobnC881eTFzI6Pbg9JTfkIie5tyeq1eIzbp01o=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org EC4CE60AD8
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Yangtao Li <tiny.windzz@gmail.com>
Cc:     merez@codeaurora.org, davem@davemloft.net,
        linux-wireless@vger.kernel.org, wil6210@qti.qualcomm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wireless/wil6210: convert to DEFINE_SHOW_ATTRIBUTE
References: <20181203132557.12269-1-tiny.windzz@gmail.com>
Date:   Mon, 03 Dec 2018 15:33:28 +0200
In-Reply-To: <20181203132557.12269-1-tiny.windzz@gmail.com> (Yangtao Li's
        message of "Mon, 3 Dec 2018 08:25:57 -0500")
Message-ID: <874lbug2fr.fsf@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yangtao Li <tiny.windzz@gmail.com> writes:

> Use DEFINE_SHOW_ATTRIBUTE macro to simplify the code.
>
> Signed-off-by: Yangtao Li <tiny.windzz@gmail.com>

The prefix for the title should be just "wil6210:", I can fix that.

-- 
Kalle Valo
