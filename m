Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED0BAC54EE9
	for <linux-wireless@archiver.kernel.org>; Fri,  2 Sep 2022 08:46:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235916AbiIBIqY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 2 Sep 2022 04:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235948AbiIBIpz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 2 Sep 2022 04:45:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C939A47E;
        Fri,  2 Sep 2022 01:44:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A15E62129;
        Fri,  2 Sep 2022 08:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A800DC433D6;
        Fri,  2 Sep 2022 08:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662108291;
        bh=pru3KgiHjYBk/40M6hUqyO6pVQW0ylbsFZNCWGwZ2mA=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=N2+4+n3cQsK2vZ2QCYsgDGpraYd1AmZ4N7tEBP0TC2B/sdTPn9hjO4E/BAhNXxXFm
         5+MeGEt43JdvlGFMMvXOIAgP9Ouqqn6K49l3ga47XVTLZb2emJIxVI8boYzhXbp+Q7
         QPMPhusWG2kqfz7TQ5RodVu+oyvY9Xh3m5UyycjuFdbnhdA1SBjfh2Oe9pYx4CAxpA
         fmQREWUIdCm49oMAYdW4oOZoyJJx6e9vpJjZ3zyVVN3IGTjhJedWcuppkQI+cq0Kb+
         wV4xCMotL/o8pcefCFo6JU9ywrK0eAk8UQO6KwN9znX45j/9aZfQafhLtRyoYhsd4n
         r9zu188btrF8w==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: wifi: wfx: prevent underflow in wfx_send_pds()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <Yv8eX7Xv2ubUOvW7@kili>
References: <Yv8eX7Xv2ubUOvW7@kili>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     =?iso-8859-1?q?J=E9r=F4me?= Pouiller <jerome.pouiller@silabs.com>,
        linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <166210828663.24345.249472656523771487.kvalo@kernel.org>
Date:   Fri,  2 Sep 2022 08:44:50 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Dan Carpenter <dan.carpenter@oracle.com> wrote:

> This does a "chunk_len - 4" subtraction later when it calls:
> 
> 	ret = wfx_hif_configuration(wdev, buf + 4, chunk_len - 4);
> 
> so check for "chunk_len" is less than 4.
> 
> Fixes: dcbecb497908 ("staging: wfx: allow new PDS format")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> Reviewed-by: Jérôme Pouiller <jerome.pouiller@silabs.com>

Patch applied to wireless-next.git, thanks.

f97c81f5b7f8 wifi: wfx: prevent underflow in wfx_send_pds()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/Yv8eX7Xv2ubUOvW7@kili/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

