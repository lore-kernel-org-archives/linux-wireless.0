Return-Path: <SRS0=8CYu=OJ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CACBEC65BAE
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 04:34:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8EBEA20863
	for <linux-wireless@archiver.kernel.org>; Fri, 30 Nov 2018 04:34:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="BRnfZODI";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Tr2XFNMZ"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8EBEA20863
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbeK3PmD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 30 Nov 2018 10:42:03 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:56724 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726375AbeK3PmD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 30 Nov 2018 10:42:03 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 6588960B1E; Fri, 30 Nov 2018 04:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543552443;
        bh=IPcjawDDQ2wOvSnSyDZUHPRyG8N34E5C/gWejrog3Sk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=BRnfZODIDQzMIcGETuYY7TvVp4twHDyLyohflrmZX0xUtxExdOqKJQkouqw3tPB4H
         9oUs23ScgDDW1ZyitjKYNfrnG0D/qy+5mh4QSfLsaZoqVdtA16xu+WbNhwmVmw89Vy
         wWWjX9Sp13AWl4rrS1popxUWNr+7rKfyZ/kKUu5s=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id BF22F60722;
        Fri, 30 Nov 2018 04:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1543552433;
        bh=IPcjawDDQ2wOvSnSyDZUHPRyG8N34E5C/gWejrog3Sk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Tr2XFNMZbmfJLvR52SQtGHPxVHn4h1zbxYnaJElJUyLLRYf/nBGfMJjs5Q2xB+Xpq
         V8TYFwCK/nv21C3WIsiNmhWntz0FDiO3A0u4ngVaFPQAYoMv1974nnZ17SafV5rkWr
         lk0oNctwte/b6KRxfsyGi1r3uqeMsqaB37z7Kxhg=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org BF22F60722
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Wireless <linux-wireless@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Sara Sharon <sara.sharon@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kees Cook <keescook@google.com>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: Re: linux-next: build warnings after merge of the wireless-drivers-next tree
References: <20181130120555.1d35eb6b@canb.auug.org.au>
Date:   Fri, 30 Nov 2018 06:33:47 +0200
In-Reply-To: <20181130120555.1d35eb6b@canb.auug.org.au> (Stephen Rothwell's
        message of "Fri, 30 Nov 2018 12:05:55 +1100")
Message-ID: <87lg5b5glw.fsf@kamboji.qca.qualcomm.com>
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
> After merging the wireless-drivers-next tree, today's linux-next build
> (x86_64 allmodconfig) produced these warnings:
>
> drivers/net/wireless/intel/iwlwifi/iwl-drv.c: In function 'iwl_parse_tlv_firmware':
> drivers/net/wireless/intel/iwlwifi/iwl-drv.c:1098:7: warning: this statement may fall through [-Wimplicit-fallthrough=]
>     if (iwlwifi_mod_params.enable_ini)
>        ^
> drivers/net/wireless/intel/iwlwifi/iwl-drv.c:1100:3: note: here
>    default:
>    ^~~~~~~
> drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c: In function 'iwl_parse_fw_dbg_tlv':
> drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c:203:4: warning: this statement may fall through [-Wimplicit-fallthrough=]
>     iwl_fw_dbg_copy_tlv(trans, tlv, true);
>     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c:204:3: note: here
>    default:
>    ^~~~~~~
>
> Introduced by commit
>
>   f14cda6f3b31 ("iwlwifi: trans: parse and store debug ini TLVs")
>
> These are noted because I use -Wimplict-fallthrough
>
> The warnings can be suppressed by adding a comment like
> 	/* fall through */
> at the appropriate place to indicate that the fallthough is intended.

I take it that -Wimplict-fallthrough is not enabled by default yet? So
Dave and Linus won't see these warnings?

What I'm planning is to send a pull request to Dave today and fix these
warnings in the next pull request. Does that sound good?

-- 
Kalle Valo
