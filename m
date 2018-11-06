Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BF16C32789
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:27:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 637C22085B
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 16:27:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="LTPBMcP2";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="SxUb8Peh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 637C22085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389187AbeKGBxq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 20:53:46 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:33508 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388959AbeKGBxq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 20:53:46 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 8533E605FD; Tue,  6 Nov 2018 16:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541521667;
        bh=hak7JmpKfbEsmUVQrUKOFCd7R496jkbfgrC0TQ1YqiU=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=LTPBMcP2AtknKy6z+gYv1Kdt9y8E85FFsjVh2r0ElZYBKhydJ5MWTnZci8pJdvz8u
         mAkLfaPNVwBwAdf+Z3Xalg/TcnraTnwLNVDvU8YOm2zVqYglWuVDm8t/adm+Inqqof
         tQFDsy7tdnFBIDzrzhWh0MQ8ghGYE34uUR0gghnE=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 6C3DD603D2;
        Tue,  6 Nov 2018 16:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1541521667;
        bh=hak7JmpKfbEsmUVQrUKOFCd7R496jkbfgrC0TQ1YqiU=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=SxUb8PehLgcEAXvE5yK69HyrNQ8C872cyKEN257dVhmTf9ov0ystZb2K7vMzRy99P
         J4oeVfSmm0xQNbmugILwQ2Bwv0opuPQNF5gTtXc5TTqMktzh/Pitp5XYojriQ3tuRR
         Y1HrqfrYYKfyn8nhQbMKPW60v++oyKYmxrQCB+OA=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 6C3DD603D2
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/5] ath9k: dynack: use authentication messages for 'late'
 ack
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <9ec0b086cfa7199bf7bc70d3118e9f835808b907.1541190974.git.lorenzo.bianconi@redhat.com>
References: <9ec0b086cfa7199bf7bc70d3118e9f835808b907.1541190974.git.lorenzo.bianconi@redhat.com>
To:     Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Cc:     linux-wireless@vger.kernel.org, koen.vandeputte@ncentric.com
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20181106162747.8533E605FD@smtp.codeaurora.org>
Date:   Tue,  6 Nov 2018 16:27:47 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo.bianconi@redhat.com> wrote:

> In order to properly support dynack in ad-hoc mode running
> wpa_supplicant, take into account authentication frames for
> 'late ack' detection. This patch has been tested on devices
> mounted on offshore high-voltage stations connected through
> ~24Km link
> 
> Reported-by: Koen Vandeputte <koen.vandeputte@ncentric.com>
> Tested-by: Koen Vandeputte <koen.vandeputte@ncentric.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>

5 patches applied to ath-next branch of ath.git, thanks.

3831a2a0010c ath9k: dynack: use authentication messages for 'late' ack
5e3d4718b157 ath9k: dynack: move debug log after buffer increments
9d3d65a91f02 ath9k: dynack: check da->enabled first in sampling routines
0c60c490830a ath9k: dynack: make ewma estimation faster
55bb78d265c6 ath9k: dynack: remove 'experimental' tag

-- 
https://patchwork.kernel.org/patch/10666101/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

