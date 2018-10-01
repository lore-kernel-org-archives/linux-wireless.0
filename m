Return-Path: <SRS0=txZa=MN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B909CC43143
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:04:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 54A4E208D9
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Oct 2018 14:04:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LYYb4p4K";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="W6TAWwxV"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 54A4E208D9
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729433AbeJAUl4 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Oct 2018 16:41:56 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60162 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729134AbeJAUl4 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Oct 2018 16:41:56 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 51C6760CA5; Mon,  1 Oct 2018 14:03:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538402638;
        bh=+BVFqxZAgDCZzoEDuYJ9WulXtA3KsWNQ3b+6w9wVRtk=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LYYb4p4KO9vfVN+KISJ2BV7iCMfT/BzYTS15XxV9N8r+Uy403oAFROFt6U8B0rw4A
         T46JajJOSWMxWYhs+ZJs1VACnwPMJn4vLYjIkYmENmPK/5iym2jW+61Wy0j8Xy2WOd
         lh+pfH1cMmjRZpDeB5U+h/09HYsZ6qDW6ESX+4Vg=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 99D6960CA5;
        Mon,  1 Oct 2018 14:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538402637;
        bh=+BVFqxZAgDCZzoEDuYJ9WulXtA3KsWNQ3b+6w9wVRtk=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=W6TAWwxVVckjfKYDPliLyOVqPQEUlXW+LNCrkOEHGfO2JvJCxClz1fb4s+57YARAH
         lL6UFBnNIcmuYLHXnVHdwHQB+fA36tzyprz/Ok2lqWM/TTsa817K6XHbUF/rt4WrtY
         QjUX5aHjlsUaxAcppgRnW2sCpCir4yusThRgj52g=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 99D6960CA5
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCHv2] ath10k: Advertize beacon_int_min_gcd as 100 while bring
 up multi vaps
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1537272446-22329-1-git-send-email-mkenna@codeaurora.org>
References: <1537272446-22329-1-git-send-email-mkenna@codeaurora.org>
To:     Maharaja Kennadyrajan <mkenna@codeaurora.org>
Cc:     ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Maharaja Kennadyrajan <mkenna@codeaurora.org>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181001140358.51C6760CA5@smtp.codeaurora.org>
Date:   Mon,  1 Oct 2018 14:03:58 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Maharaja Kennadyrajan <mkenna@codeaurora.org> wrote:

> With the latest firmware design, the beacon interval should be
> greater than 100 to bring the multiple vaps.
> 
> Set beacon_int_min_gcd to 100, when the wmi service
> WMI_SERVICE_VDEV_DIFFERENT_BEACON_INTERVAL_SUPPORT is enabled
> in the firmware. If not, beacon_int_min_gcd will be set
> to the default value 1.
> 
> Tested in QCA4019 with firmware ver 10.4-3.2.1.1-00015
> Tested in QCA9888 with firmware ver 10.4-3.5.1-0005
> 
> Signed-off-by: Maharaja Kennadyrajan <mkenna@codeaurora.org>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

Patch applied to ath-next branch of ath.git, thanks.

4600563f9319 ath10k: advertize beacon_int_min_gcd as 100 while bring up multi vaps

-- 
https://patchwork.kernel.org/patch/10604255/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

