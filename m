Return-Path: <SRS0=pQzZ=MS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55635C64EB8
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 09:46:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E09A120834
	for <linux-wireless@archiver.kernel.org>; Sat,  6 Oct 2018 09:46:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Uw2K6yBd";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="EwPE1tGN"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E09A120834
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbeJFQtd (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 6 Oct 2018 12:49:33 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:48394 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726409AbeJFQtd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 6 Oct 2018 12:49:33 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1200C60C1B; Sat,  6 Oct 2018 09:46:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538819216;
        bh=iim0YP18UDBmsi752cAyIVRrWh5R3e6yYdLOmGn1Iyo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Uw2K6yBdC274ATG7Mvg0QQb4t57XdhOcDjg6bGp/akHyclHPINEQXMjfL8PnNl3oi
         FHLiDVgSsCYb9O68aJ/9mHVj9skKifnTAKzGgJltJa8yJAUjYz1rFSzWa72kUzaMEB
         f3rfQn81aAhH+J5heb8hM4OMI00bE2/zikgR76Gs=
Received: from potku.adurom.net (88-114-240-52.elisa-laajakaista.fi [88.114.240.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BB84860818;
        Sat,  6 Oct 2018 09:46:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1538819215;
        bh=iim0YP18UDBmsi752cAyIVRrWh5R3e6yYdLOmGn1Iyo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=EwPE1tGNZT48pYPRzNgxpH1N2gYkmWB8WrPT8EPqROXOmyflCJGOS0c8O+0lAPzZa
         hQBFL+VKCaZAihpjAbu8GJtjuJPLLRekYhnRV/5z2MkVr1nIiriIaTeFydgFdc9xTi
         h3WMI311oiqnVgvDJuObasjEMBOrasw9wnA6ODp4=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BB84860818
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull request: mt76 2018-10-05
References: <783b92c4-0fba-35d8-9fdb-2c3462aa9f7f@nbd.name>
Date:   Sat, 06 Oct 2018 12:46:51 +0300
In-Reply-To: <783b92c4-0fba-35d8-9fdb-2c3462aa9f7f@nbd.name> (Felix Fietkau's
        message of "Fri, 5 Oct 2018 20:10:27 +0200")
Message-ID: <87sh1jh0fo.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> Here's another large batch of mt76 code cleanup / deduplication / fixes
>
> - Felix
>
> The following changes since commit e1c02eb16a9c742178874a7d1a08d300981715fb:
>
>   qtnfmac: implement dump_station support for STA mode (2018-10-05 14:01:44 +0300)
>
> are available in the Git repository at:
>
>   https://github.com/nbd168/wireless tags/mt76-for-kvalo-2018-10-05
>
> for you to fetch changes up to 06ac97c2e58c7b32bf950ac53976c4260687d386:
>
>   mt76x0: pci: report firmware version using ethtool (2018-10-05 20:05:46 +0200)
>
> ----------------------------------------------------------------
> mt76 patches for 4.20
>
> * unify code between mt76x0, mt76x2
> * mt76x0 fixes
> * another fix for rx buffer allocation regression on usb
> * move mt76x2 source files to mt76x2 folder
> * more work on mt76x0e support
>
> ----------------------------------------------------------------

I have to drop this as it doesn't build for me:

drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c: In function 'mt76x0e_load_firmware':
drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c:119:28: error: passing argument 1 of 'mt76x02_set_ethtool_fwver' from incompatible pointer type [-Werror=incompatible-pointer-types]
  mt76x02_set_ethtool_fwver(dev, hdr);
                            ^~~
In file included from drivers/net/wireless/mediatek/mt76/mt76x0/mcu.h:18:0,
                 from drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.c:20:
drivers/net/wireless/mediatek/mt76/mt76x0/../mt76x02_mcu.h:108:6: note: expected 'struct mt76_dev *' but argument is of type 'struct mt76x02_dev *'
 void mt76x02_set_ethtool_fwver(struct mt76_dev *dev,
      ^~~~~~~~~~~~~~~~~~~~~~~~~
cc1: some warnings being treated as errors
scripts/Makefile.build:305: recipe for target 'drivers/net/wireless/mediatek/mt76/mt76x0/pci_mcu.o' failed

-- 
Kalle Valo
