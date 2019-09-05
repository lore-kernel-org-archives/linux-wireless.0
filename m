Return-Path: <SRS0=82ey=XA=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F3AAC43331
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Sep 2019 20:11:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C79132067B
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Sep 2019 20:11:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HTFni/y9";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="HTFni/y9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388907AbfIEULj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 5 Sep 2019 16:11:39 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:59614 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730777AbfIEULj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Sep 2019 16:11:39 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id A7641602EE; Thu,  5 Sep 2019 20:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567714298;
        bh=To3WAd2bX7Z10le6Dxnqd0HRZWxcwydt0jg9aBddT84=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HTFni/y9kfhEJySNZKHm3OqnNcoaeJvcVgAXkbq8q3iXISpA5wCRNF+DKaCk4eP4t
         gJRs5MTkIqrS0TYVmos628bGZbO9Si63GfhOkxp6w3cY71kcDTEDuXAF4wKQAEEnuF
         ooGKDTHyqUkr2AS4uC9Z9noTNitnKFeGNABoJI0Q=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 3ADF260592;
        Thu,  5 Sep 2019 20:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1567714298;
        bh=To3WAd2bX7Z10le6Dxnqd0HRZWxcwydt0jg9aBddT84=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HTFni/y9kfhEJySNZKHm3OqnNcoaeJvcVgAXkbq8q3iXISpA5wCRNF+DKaCk4eP4t
         gJRs5MTkIqrS0TYVmos628bGZbO9Si63GfhOkxp6w3cY71kcDTEDuXAF4wKQAEEnuF
         ooGKDTHyqUkr2AS4uC9Z9noTNitnKFeGNABoJI0Q=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 05 Sep 2019 13:11:38 -0700
From:   Jeff Johnson <jjohnson@codeaurora.org>
To:     Wen Gong <wgong@codeaurora.org>
Cc:     ath10k@lists.infradead.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org,
        linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH v2] mac80211: Store max_mtu in ieee80211_hw
In-Reply-To: <1567587484-31930-1-git-send-email-wgong@codeaurora.org>
References: <1567587484-31930-1-git-send-email-wgong@codeaurora.org>
Message-ID: <8d156cf1983fb973c9ff5d9d15fb070d@codeaurora.org>
X-Sender: jjohnson@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2019-09-04 01:58, Wen Gong wrote:
> Make it possibly for drivers to adjust the default mat_mtu

nit: mat_mtu => max_mtu
