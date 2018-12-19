Return-Path: <SRS0=qpxp=O4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A44DFC43387
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 07:52:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 73EA621850
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Dec 2018 07:52:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="RlYTbMWN";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="nmTgCWLa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728065AbeLSHwB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Dec 2018 02:52:01 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:46604 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726917AbeLSHwB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Dec 2018 02:52:01 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 1C45061A78; Wed, 19 Dec 2018 07:52:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545205920;
        bh=vPJPSBfcE5dlO4CSVYuIdL6ZNToCC2zNbkeVWdqvM+c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=RlYTbMWN5cmdADdS0v+m30XeytNcbbe4HuaaWohUh0S5Tx8iEIuYQYh7GZYe/ljUu
         IgtnRGnYjsRsZ7MMvpJU1bNOGp7C9PfuxGuLCsfjBXLI3cdfKt/cqCzuGyMgZD3GBO
         ljm4+VjA6i/0DadItn2VxQp4FGr6BKKXpXqzh+7I=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id B834E61A69;
        Wed, 19 Dec 2018 07:51:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1545205919;
        bh=vPJPSBfcE5dlO4CSVYuIdL6ZNToCC2zNbkeVWdqvM+c=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=nmTgCWLaqp5GsLA9qmF2zwy4CkPAuvjjzOOs3f8CDuS6Ag2V1emVQu0Kme/2KN4tE
         Gteagxodja5CKpRffifOdkO6GZThP9HHXj0PdfIxOCb20wnvMY3MHBcYpPxhJlWx2L
         6LRUUQg3fBxGKeQaWtPZ3UzBKur3bAjlhuRYg3lo=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org B834E61A69
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
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: Re: linux-next: build warnings after merge of the wireless-drivers-next tree
References: <20181130120555.1d35eb6b@canb.auug.org.au>
        <20181219134738.4efed34f@canb.auug.org.au>
Date:   Wed, 19 Dec 2018 09:51:53 +0200
In-Reply-To: <20181219134738.4efed34f@canb.auug.org.au> (Stephen Rothwell's
        message of "Wed, 19 Dec 2018 13:47:38 +1100")
Message-ID: <871s6evtra.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> On Fri, 30 Nov 2018 12:05:55 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>
>> After merging the wireless-drivers-next tree, today's linux-next build
>> (x86_64 allmodconfig) produced these warnings:
>> 
>> drivers/net/wireless/intel/iwlwifi/iwl-drv.c: In function 'iwl_parse_tlv_firmware':
>> drivers/net/wireless/intel/iwlwifi/iwl-drv.c:1098:7: warning: this statement may fall through [-Wimplicit-fallthrough=]
>>     if (iwlwifi_mod_params.enable_ini)
>>        ^
>> drivers/net/wireless/intel/iwlwifi/iwl-drv.c:1100:3: note: here
>>    default:
>>    ^~~~~~~
>> drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c: In function 'iwl_parse_fw_dbg_tlv':
>> drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c:203:4: warning: this statement may fall through [-Wimplicit-fallthrough=]
>>     iwl_fw_dbg_copy_tlv(trans, tlv, true);
>>     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c:204:3: note: here
>>    default:
>>    ^~~~~~~
>> 
>> Introduced by commit
>> 
>>   f14cda6f3b31 ("iwlwifi: trans: parse and store debug ini TLVs")
>> 
>> These are noted because I use -Wimplict-fallthrough
>> 
>> The warnings can be suppressed by adding a comment like
>> 	/* fall through */
>> at the appropriate place to indicate that the fallthough is intended.
>
> I am still seeing these warnings (but in the net-next tree now) and I
> do not see a fix patch in the wireless-drivers-next tree.

Luca did submit a patch[1] for cfg80211 to fix those but I don't see any
patches for iwlwifi (even in the one pending pull request he sent), not
sure what happened. I know that Luca is already on holidays but adding
Emmanuel, maybe he can help here?

[1] https://patchwork.kernel.org/patch/10732065/

-- 
Kalle Valo
