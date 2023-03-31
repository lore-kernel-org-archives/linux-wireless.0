Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68BA0C6FD18
	for <linux-wireless@archiver.kernel.org>; Fri, 31 Mar 2023 11:10:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbjCaLKc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 31 Mar 2023 07:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231593AbjCaLKW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 31 Mar 2023 07:10:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7395170A;
        Fri, 31 Mar 2023 04:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E1B8B82E8B;
        Fri, 31 Mar 2023 11:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D572C433EF;
        Fri, 31 Mar 2023 11:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680261014;
        bh=exRDOu4Px6sVej6+eWIMsBnr/fUPC2Vchvz/9blygBQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=To4ZTFcxbxrJ5+hKj8J5+U3aMd1zp6Jb003GTCxveNwwieXBo6K4eGh5aV2bgzk2H
         rr5jOtiCnF2HOZz6mki36/SjQtdJOwz+S0WnfPnatWW6bkYaZdTrQdg8sCOFYcuByI
         aHZq/zNYWhjr7Oix47sfzJAUBjERpOJSSh5XJ178nxYlRbaR3wBR+zz3dvF+qNRsiy
         XtIqVCJh1r8k8tKU+eMmqERzdCnjSfDXZarsxQfCM9Qd7cYYjb0EG0uVRbh5YH/Tsb
         dz4ihq5cRSFQhXEPbemXVgpAx9RiDo/v2EON2XHAAYQkriDg3MxAzrbCS8GMmD9WPP
         6Fcq5fmStYG1A==
From:   Kalle Valo <kvalo@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Wireless <linux-wireless@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes.berg@intel.com>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build warning after merge of the wireless-next tree
References: <20230323141548.659479ef@canb.auug.org.au>
Date:   Fri, 31 Mar 2023 14:10:10 +0300
In-Reply-To: <20230323141548.659479ef@canb.auug.org.au> (Stephen Rothwell's
        message of "Thu, 23 Mar 2023 14:15:48 +1100")
Message-ID: <87y1ndb2i5.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> After merging the wireless-next tree, today's linux-next build (htmldocs)
> produced this warning:
>
> Documentation/driver-api/80211/mac80211-advanced:214:
> /home/sfr/next/next/net/mac80211/sta_info.h:628: ERROR: Unexpected
> indentation.
>
> Introduced by commit
>
>   fe4a6d2db3ba ("wifi: mac80211: implement support for yet another
> mesh A-MSDU format")

Thanks, this commit should fix it:

https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git/commit/?id=f102424befd3751386f3e2f2c70c5a1948248622

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
