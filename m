Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7589AC77B72
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Apr 2023 13:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbjDNNp0 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Apr 2023 09:45:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjDNNpZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Apr 2023 09:45:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62F3DE4
        for <linux-wireless@vger.kernel.org>; Fri, 14 Apr 2023 06:45:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0492464801
        for <linux-wireless@vger.kernel.org>; Fri, 14 Apr 2023 13:45:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925EAC433D2;
        Fri, 14 Apr 2023 13:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681479923;
        bh=YfnfqBYq07ltEE3TdfomvsacgiMG4Bwk9GrbcUT2Qc8=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kfr3CvBediZC39N7ntqXIOJci3T3oXDlD8pzrl/SZkftGls9AuTW4KpDErJMzDQNV
         pg+Z3TDA1Ke/DCNQSQ4Uy/kIg0VPtmUPkvXyvS+LOQydREiiBuf6b5M6na7rcIqra8
         I3Fa3TEUZGZN0p0FG4o9PhFiKNslx3WXyCczHhRXIDwyR63cazKb0c+3HGQ2iU2/lz
         8on+63lcx8VXHJShYegkINyq1yterbX9/tYO0u7YWAJTwuTdjFkiBS95qDaMvz/aFa
         ZiItPPNSEeldPlYIq/l+dcK42/IyqjFvqceDZ1GvdX1rUhxiolomHdv3L0+uUhHCzv
         Rwzka0XtzkRPQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Yi Kuo <yi@yikuo.dev>
Cc:     gregory.greenman@intel.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] iwlwifi: pcie: add device id 51F1 for killer 1675
References: <20230410222221.27587-1-yi@yikuo.dev>
Date:   Fri, 14 Apr 2023 16:45:20 +0300
In-Reply-To: <20230410222221.27587-1-yi@yikuo.dev> (Yi Kuo's message of "Tue,
        11 Apr 2023 06:22:21 +0800")
Message-ID: <87bkjqshlb.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Yi Kuo <yi@yikuo.dev> writes:

> I have a Killer AX1675i card with device id 51f1,
> showing "No config found for PCI dev 51f1/1672" in dmesg.
>
> Adding the new device id 51F1 for 1675i fixes the issue.
> Also adding it for 1675s.
>
> Signed-off-by: Yi Kuo <yi@yikuo.dev>
> ---
>  drivers/net/wireless/intel/iwlwifi/pcie/drv.c | 2 ++
>  1 file changed, 2 insertions(+)

"wifi:" missing from title.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
