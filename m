Return-Path: <SRS0=KylO=Z2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C3E9C43603
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Dec 2019 06:56:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A0F6F206DB
	for <linux-wireless@archiver.kernel.org>; Wed,  4 Dec 2019 06:00:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cwvgZJ0j";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="f9hK/pok"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725958AbfLDGAD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 4 Dec 2019 01:00:03 -0500
Received: from a27-21.smtp-out.us-west-2.amazonses.com ([54.240.27.21]:49362
        "EHLO a27-21.smtp-out.us-west-2.amazonses.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725791AbfLDGAC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Dec 2019 01:00:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=zsmsymrwgfyinv5wlfyidntwsjeeldzt; d=codeaurora.org; t=1575439202;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID;
        bh=0o0a6TPT1s7PFwAcgXu8HHPTctk2Q0tP9BRyTRbd49k=;
        b=cwvgZJ0jQfiG9SPmTMeNQcPAyYXCuTVobOPRuOwlAvLtf6beWT4oCGtXS4YYoxB+
        KkTIc9UOHTjLgDlNry+0edDUmOvQwDOsR+8ibdcBtnsIE6UV+yXPkiG2+/nLphu2Dbn
        usZ1bPpVmzVjCKWFypOaY+SFZlWuS6CnHdU9Q4ls=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
        s=gdwg2y3kokkkj5a55z2ilkup5wp5hhxx; d=amazonses.com; t=1575439202;
        h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:Cc:Subject:In-Reply-To:References:Message-ID:Feedback-ID;
        bh=0o0a6TPT1s7PFwAcgXu8HHPTctk2Q0tP9BRyTRbd49k=;
        b=f9hK/pokK/qKX8SqS8Je7uXBBxfO3/pw/yT/aXDrf1ZAf5pfiO/pRpZElBg8OALK
        aLV176szlscd4hXd10hiyAXf7o9swy8GBkfl9/9nM6fWUrwxa7TEbH+bjAzlrxloru3
        0Ih93wsL2gI/hSA6bVzgMXvXPS/hpcnap+mNSiTY=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 4 Dec 2019 06:00:01 +0000
From:   vthiagar@codeaurora.org
To:     John Crispin <john@phrozen.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        ath11k@lists.infradead.org, linux-wireless-owner@vger.kernel.org
Subject: Re: [RESEND 6/9] ath11k: add debugfs for TWT debug calls
In-Reply-To: <20191204053713.3064-7-john@phrozen.org>
References: <20191204053713.3064-1-john@phrozen.org>
 <20191204053713.3064-7-john@phrozen.org>
Message-ID: <0101016ecf7e75e8-c437f8fc-1c94-4c0d-8965-be3d32169ecf-000000@us-west-2.amazonses.com>
X-Sender: vthiagar@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
X-SES-Outgoing: 2019.12.04-54.240.27.21
Feedback-ID: 1.us-west-2.CZuq2qbDmUIuT3qdvXlRHZZCpfZqZ4GtG9v3VKgRyF0=:AmazonSES
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-12-04 11:07, John Crispin wrote:
> These new debugfs files allow us to manually add/del/pause/resume TWT
> dialogs for test/debug purposes.
> 

Information such as how these debugfs entries are supposed to be used
could be helpful.

Vasanth
