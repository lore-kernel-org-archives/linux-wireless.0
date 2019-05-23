Return-Path: <SRS0=ngAs=TX=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC94CC04AAC
	for <linux-wireless@archiver.kernel.org>; Thu, 23 May 2019 07:36:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 95514204EC
	for <linux-wireless@archiver.kernel.org>; Thu, 23 May 2019 07:36:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="odbmwpSu";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="YqbxrEix"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729519AbfEWHgH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 23 May 2019 03:36:07 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60474 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbfEWHgG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 May 2019 03:36:06 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C719860E5F; Thu, 23 May 2019 07:35:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558596966;
        bh=aWu4pdFmpvQ75xec0lLJC7Dv8TlKRn6q2MtI9jfarNc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=odbmwpSu3Ss32JEA464QfZjFxvs8TkObIwwS+rHy/KvC33dAeILh3VBj2uygsxasn
         TiZng2jIE64IKb0IrCFWl8dqfMhhTokS6eve6H7WPSjqqwmQOvsJy9dWuOyezRzcLv
         6CF5++MjwWoYOrFHsK5BLLd+cvwMxGXQuQFTX2z8=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B67BB614DC;
        Thu, 23 May 2019 07:35:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558596954;
        bh=aWu4pdFmpvQ75xec0lLJC7Dv8TlKRn6q2MtI9jfarNc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=YqbxrEixjF0irQj14hHl7XdxtPRPFX7QHPHtFT1YGZ0SCPjMIhAtWdZVTyckVa2Eo
         OWGVN259guZ9xqlRnObGWvld5bDk1kZIBi3wrppTVVH91o4hgrumAM7IoNdyThFR8O
         f+LDUgyR+30wUZVy6gljAq+D6jYinLUJHxS9b0gE=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B67BB614DC
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Daniel Drake <drake@endlessm.com>
Cc:     ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Endless Linux Upstreaming Team <linux@endlessm.com>
Subject: Re: ath10k QCA9377 firmware crashes and fails to recover
References: <CAD8Lp45wxQ3vL_ttq-yKYDxscjn2KyJVCx_vJBCn+u8Yc5QtOQ@mail.gmail.com>
Date:   Thu, 23 May 2019 10:35:49 +0300
In-Reply-To: <CAD8Lp45wxQ3vL_ttq-yKYDxscjn2KyJVCx_vJBCn+u8Yc5QtOQ@mail.gmail.com>
        (Daniel Drake's message of "Wed, 22 May 2019 21:19:14 -0600")
Message-ID: <87h89lei7e.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Daniel Drake <drake@endlessm.com> writes:

> We are experiencing failures with QCA9377 wifi, using Linux 4.18 and
> Linux 5.0 with the latest firmware version:
>
> ath10k_pci 0000:02:00.0: firmware crashed! (guid
> 54a4649a-1240-4459-9442-9d498c49de79)
> ath10k_pci 0000:02:00.0: qca9377 hw1.1 target 0x05020001 chip_id
> 0x003821ff sub 1a3b:2b31
> ath10k_pci 0000:02:00.0: kconfig debug 0 debugfs 1 tracing 1 dfs 0 testmode 0
> ath10k_pci 0000:02:00.0: firmware ver WLAN.TF.1.0-00002-QCATFSWPZ-5
> api 5 features ignore-otp crc32 c3e0d04f

Is this a regression? For example, have you tried older firmware
versions?

-- 
Kalle Valo
