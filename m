Return-Path: <SRS0=pyzf=O5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A403C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 07:16:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3480820815
	for <linux-wireless@archiver.kernel.org>; Thu, 20 Dec 2018 07:16:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NUkiApGK";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BHpQn4nG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730258AbeLTHQ0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 20 Dec 2018 02:16:26 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42532 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727644AbeLTHQZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 20 Dec 2018 02:16:25 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6B2CC601C3; Thu, 20 Dec 2018 07:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545290185;
        bh=+PcWnHwNMFepoU94ab3DQWsgsinsNZ6Uq+DVhrOqD60=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=NUkiApGKQUyo1ijKSBcKF7Xli+oImVLNNIZrZt597cpnZxvDrK3medrPYGbwSEuoY
         Io5FNEEAeDh95eTvdBX6lBsZ4o/REn8LAfw07+tdGvd6K2Z4wZx+wmtepddQmvQ/ej
         VY18SlyuOP1ouexQEDdXVZJGMEqo7buEDNyGqymQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id AF03E6074E;
        Thu, 20 Dec 2018 07:16:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545290185;
        bh=+PcWnHwNMFepoU94ab3DQWsgsinsNZ6Uq+DVhrOqD60=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=BHpQn4nG7lLyLpNXvrY2BskvnlRN8PriCRkeWU6uOgnVze3X5KbLU4apNft8Pi66T
         yTXVewh4HxYhNnC6HZlNJNFnldkQPH03vW5TiAi38QhGV4ca7QrxTxB/4bjqrBnngU
         wtSCC4SXhmR2f9c+Ge/OkFq/eRrVzcD1rGV2Tcpw=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org AF03E6074E
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v2] iwlwifi: dbg_ini: fix bad ini tlv parsing
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20181219093619.9867-1-emmanuel.grumbach@intel.com>
References: <20181219093619.9867-1-emmanuel.grumbach@intel.com>
To:     Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc:     linux-wireless@vger.kernel.org, sara.sharon@intel.com,
        sfr@canb.auug.org.au,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181220071625.6B2CC601C3@smtp.codeaurora.org>
Date:   Thu, 20 Dec 2018 07:16:25 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Emmanuel Grumbach <emmanuel.grumbach@intel.com> wrote:

> From: Shahar S Matityahu <shahar.s.matityahu@intel.com>
> 
> Add a break at the end of the ini tlv case.
> Fix both the internal and external tlv parsing.
> 
> Signed-off-by: Shahar S Matityahu <shahar.s.matityahu@intel.com>
> Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Patch applied to wireless-drivers-next.git, thanks.

19de2fa86e69 iwlwifi: dbg_ini: fix bad ini tlv parsing

-- 
https://patchwork.kernel.org/patch/10736967/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

