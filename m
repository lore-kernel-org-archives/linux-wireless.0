Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B0EEC61DA4
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Feb 2023 19:33:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229633AbjBPTc7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 16 Feb 2023 14:32:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjBPTc6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Feb 2023 14:32:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FACF15556;
        Thu, 16 Feb 2023 11:32:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24A7DB8291F;
        Thu, 16 Feb 2023 19:32:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72DBC433D2;
        Thu, 16 Feb 2023 19:32:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676575974;
        bh=Ed1QrY032IHssILnq469lkx1M28sJqaC/65BhKKHDO0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=IinXeA8Q6u5GiyNCvN74qD9YrsZtJ8p3gsChQkUSm333h4OCm0bdKosVFTrb+kZoX
         pu5e0DsujLmTa4vWdfyyr0y9nGhNo1rV7/MM4mexhLBAh0cJoPGSnAZ4DwZ5urjJh8
         diY1yvtKzDEzEU+PsX2pd5qH3BICCovqKKiBquGB5Q2l8PJJEvUW+7nKpoItEH1VX0
         NcBip4pdwwmnEs0Dw+kKTaqUTHhIknWtIe6iYAmwmcoRS5iILUBQK9b901wtCT74B6
         18JypSv7IWI7qsPA/aciXha23V8i4EAO9i4FYurCGypKvNRqI6nb39SaFK2cRbdMLM
         0l8mQBkrbDcag==
Date:   Thu, 16 Feb 2023 11:32:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-next-2023-03-16
Message-ID: <20230216113253.2cbb360e@kernel.org>
In-Reply-To: <20230216105406.208416-1-johannes@sipsolutions.net>
References: <20230216105406.208416-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 16 Feb 2023 11:54:05 +0100 Johannes Berg wrote:
> Here's a last (obviously) set of new work for -next. The
> major changes are summarized in the tag below.
> 
> Please pull and let me know if there's any problem.

Could you follow up soon with fixes for the compilation warnings?

drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c:441:21: warning: unused function 'iwl_dbgfs_is_match' [-Wunused-function]
static inline char *iwl_dbgfs_is_match(char *name, char *buf)
                    ^

there are also 2 new fortify string warnings (could be false positives).
