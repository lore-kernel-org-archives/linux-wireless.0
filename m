Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E233ECDB46E
	for <linux-wireless@archiver.kernel.org>; Thu, 12 Oct 2023 15:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344081AbjJLP4c (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 12 Oct 2023 11:56:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343986AbjJLP4a (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2023 11:56:30 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80A89C6
        for <linux-wireless@vger.kernel.org>; Thu, 12 Oct 2023 08:56:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45980C433C7;
        Thu, 12 Oct 2023 15:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697126188;
        bh=Zrg9V546WCSensWGA9/PHBSdUYk0odDitoKotkVzj2Q=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=aQQZsDPQsQRQG0n9w+OOUrEYnaot5STc+71j9yVBlzEfxSOUfXnSsEU7Z94NY7pqA
         JOqBT6BIymWBAxhykksTuAESml/7YVh2ebYpmN+2cHMloTMnBa3JvOnmUm7HOQaLzf
         /cUprJl8BBYI1wNW1zwLfkWQoze/6xdtOs+O8kvXDuwxMHl/+6f1Hsx9t0Ew0sL9PU
         Cd3z+WezPlUj+7t6UI5g5amqHS3lZFAqkF+5u0s3oCx1JHuTToeXpmgFsqaeTxQjpx
         ckn4uVkbsbz7359GRKsR73C0s3KFWUzmWRlAaz3DN9PAH36LjahVHUORHIrh6h4BAO
         NBQ8pYFtZs/xQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     gregory.greenman@intel.com
Cc:     johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 01/16] wifi: iwlwifi: fw: increase fw_version string
 size
References: <20231012153950.f4465b4b4e2b.Idced2e8d63c492872edcde1a3ce2cdd6cc0f8eb7@changeid>
Date:   Thu, 12 Oct 2023 18:59:00 +0300
In-Reply-To: <20231012153950.f4465b4b4e2b.Idced2e8d63c492872edcde1a3ce2cdd6cc0f8eb7@changeid>
        (gregory greenman's message of "Thu, 12 Oct 2023 15:41:48 +0300")
Message-ID: <877cnrg7cr.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

gregory.greenman@intel.com writes:

> From: Gregory Greenman <gregory.greenman@intel.com>
>
> In reality 64 bytes are enough to hold fw version string,
> but some compilers can complain (with W=1) that output may be
> truncated when building this string with snprintf.
> Increase the size to avoid this sort of warnings and state
> explicitely that we want the size to be trancated to 32 bytes.
>
> Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>

Thanks, I don't see warnings from iwlwifi anymore.

Tested-by: Kalle Valo <kvalo@kernel.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
