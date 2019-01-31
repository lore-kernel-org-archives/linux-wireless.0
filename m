Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A57F7C282D9
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 13:46:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 784942085B
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 13:46:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cqdyy2ni";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="Rai4dGL0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732804AbfAaNqK (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 08:46:10 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:42954 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726863AbfAaNqK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 08:46:10 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 228AF616BC; Thu, 31 Jan 2019 13:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548942369;
        bh=FyDvtRqWZNusY3iQVJRNtBm5Mik/68wOKA+b+VRX/f4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=cqdyy2nia1UeyWgPRuiVmTQDCsYBsbNtxZCB5tczBcmcF76FivW/Wb3kq+un+VUHh
         +TR/Nj99IxInXLYlTUEHrDp7USmx2nTdVspt+kVPLg3dvdZt1p/uQWD/dU1IobT1wO
         U2x+2IUUhA9M5omtgERV+PzCDEiQiq90snii7jXQ=
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 478DF616BD;
        Thu, 31 Jan 2019 13:46:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1548942367;
        bh=FyDvtRqWZNusY3iQVJRNtBm5Mik/68wOKA+b+VRX/f4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Rai4dGL0If7fa+TYOtrhycdystENXWBtKynax8l9bbU1GH3RBcsp5pFza8FXH1bq0
         cLSnIrDAKk7e4p4JVlJJVPkuad9RAJu4zrFl+C9fz3z1tw8xX+H8ZM+z6mY9bCUhI9
         cpe70nh9X5Pl5yV1kRirU0P/dcL0XKZ/bl484p0Q=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 478DF616BD
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
From:   Kalle Valo <kvalo@codeaurora.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Wireless <linux-wireless@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: linux-next: build warning after merge of the wireless-drivers-next tree
References: <20190131104626.62ff05ce@canb.auug.org.au>
        <9455f1b9e746f2c28d1573ccdce3836ece42cd8a.camel@coelho.fi>
Date:   Thu, 31 Jan 2019 15:46:03 +0200
In-Reply-To: <9455f1b9e746f2c28d1573ccdce3836ece42cd8a.camel@coelho.fi> (Luca
        Coelho's message of "Thu, 31 Jan 2019 01:51:44 +0200")
Message-ID: <875zu5j5yc.fsf@kamboji.qca.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.5 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Luca Coelho <luca@coelho.fi> writes:

> On Thu, 2019-01-31 at 10:46 +1100, Stephen Rothwell wrote:
>> Hi all,
>> 
>> After merging the wireless-drivers-next tree, today's linux-next
>> build
>> (x86_64 allmodconfig) produced this warning:
>> 
>> drivers/net/wireless/intel/iwlwifi/mvm/rxmq.c:195:13: warning:
>> 'iwl_mvm_add_rtap_sniffer_config' defined but not used [-Wunused-
>> function]
>>  static void iwl_mvm_add_rtap_sniffer_config(struct iwl_mvm *mvm,
>>              ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> 
>> Introduced by commit
>> 
>>   9bf13bee2d74 ("iwlwifi: mvm: include configured sniffer AID in
>> radiotap")
>
> This was a conflict resolution damage in one of the patches I applied. 
> We already have a fix for it[1] and Kalle will apply it to wireless-
> drivers-next soon.
>
> Sorry for the trouble, but somehow I didn't see this warning and
> kbuildbot also reported successful compilation with it. :(
>
> [1] https://patchwork.kernel.org/patch/10788503/

I applied the fix now:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git/commit/?id=3864be551405b582ae38fbcdfdbb6e49052f5f6d

-- 
Kalle Valo
