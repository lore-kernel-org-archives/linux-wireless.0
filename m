Return-Path: <SRS0=x8ok=SU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C495C10F0E
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 13:49:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2CA8120674
	for <linux-wireless@archiver.kernel.org>; Thu, 18 Apr 2019 13:49:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Z8mjcjZu";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BeFIejL7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389189AbfDRNtI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 18 Apr 2019 09:49:08 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:60932 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388073AbfDRNtH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Apr 2019 09:49:07 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id C230C6086B; Thu, 18 Apr 2019 13:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555595346;
        bh=0+qifr9xO9IbP3wkVCtTen21O2jfNgRqZTzi3+4eezo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Z8mjcjZuapBjuinor0LLVkHoLipMdBvt8IrIInX7i2NmPR/DAfCFFJvXS1IGOxyiE
         YtIwu/rzPR88ZWdLHzYWeCR12mVccGI1ilnrnZwXYiYxR/eryQdsQcVhTpE9omchSa
         y+LfA8WPtbzMgouUZqtKp1bAh1UwEJ20Zgfo7p30=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 69A546086B;
        Thu, 18 Apr 2019 13:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1555595345;
        bh=0+qifr9xO9IbP3wkVCtTen21O2jfNgRqZTzi3+4eezo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BeFIejL7h7WiCanmXBjzMhCfzOCrZ3PJ69mFqpVQnAcGl+smN2hqBx/TJbfbaquIz
         i1p7bRRKcyM/pKtPT2sp3HUFcC0Z14ogTMzEfGM1HnOc4b2VuFiOMxFFyUtaTKQ+I/
         6o+2a//ae//f6K0CSglpXQgB8byDg2P02dZnSd38=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 69A546086B
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Wireless <linux-wireless@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: linux-next: manual merge of the wireless-drivers-next tree with the wireless-drivers tree
References: <20190415120133.40c0f343@canb.auug.org.au>
Date:   Thu, 18 Apr 2019 16:49:02 +0300
In-Reply-To: <20190415120133.40c0f343@canb.auug.org.au> (Stephen Rothwell's
        message of "Mon, 15 Apr 2019 12:01:33 +1000")
Message-ID: <87o9532zld.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi all,
>
> Today's linux-next merge of the wireless-drivers-next tree got a conflict
> in:
>
>   drivers/net/wireless/intel/iwlwifi/iwl-trans.h
>
> between commit:
>
>   07d35b4270ef ("iwlwifi: use sync nmi in case of init flow failure")
>
> from the wireless-drivers tree and commit:
>
>   4b1831e48974 ("iwlwifi: dbg_ini: support HW error trigger")
>
> from the wireless-drivers-next tree.
>
> I fixed it up (see below) and can carry the fix as necessary. This
> is now fixed as far as linux-next is concerned, but any non trivial
> conflicts should be mentioned to your upstream maintainer when your tree
> is submitted for merging.  You may also want to consider cooperating
> with the maintainer of the conflicting tree to minimise any particularly
> complex conflicts.

Thanks, I'll let Dave know about this when he pulls w-d-next.

-- 
Kalle Valo
