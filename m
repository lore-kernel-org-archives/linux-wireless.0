Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 463EEC001DC
	for <linux-wireless@archiver.kernel.org>; Thu, 27 Jul 2023 16:29:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234283AbjG0Q3t (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 27 Jul 2023 12:29:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234280AbjG0Q3s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 27 Jul 2023 12:29:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DAAA30F9
        for <linux-wireless@vger.kernel.org>; Thu, 27 Jul 2023 09:29:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2AE9261E91
        for <linux-wireless@vger.kernel.org>; Thu, 27 Jul 2023 16:29:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BE05C433C7;
        Thu, 27 Jul 2023 16:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690475383;
        bh=kVFC99jJRlmdXMNhJFcFYfviubIHE7J5Ygi42v1zFfs=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=uvzWOlDcRpwUgAChG0NrvR78czcPDKMVIYWIkfVOVd/zBbHEqZxfkZbSzhRAdL4f+
         KQktQUMBlR2cPeJr6lOBV5+fktc9/tBdpxw6dTm7obyytz4wPT1tFKmrkQKc1JgdAN
         J0LmwAa6KvoGqETcJDbREP0szaKzXr+C6VcHAwG4zKm4mOOEZ3SOmOgkFpysUSCFIW
         fLGWGK2DcNmc/72/mpsgI9Os9rihbzDobK3J2oZU084gcY/TNPOYi75H69WH/uk1Uq
         5I0GGcwvzGMsnLTMQjOGR+i+35Wcnap1XhkcKz4iU9CUzrJTCKTpdusgFzXels6m7i
         RbWfQPPcDIL0w==
From:   Kalle Valo <kvalo@kernel.org>
To:     Aditya Kumar Singh <quic_adisi@quicinc.com>
Cc:     <ath11k@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
        <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/3] wifi: cfg80211: export DFS CAC time and usable
 state helper functions
References: <20230607124647.27682-1-quic_adisi@quicinc.com>
        <20230607124647.27682-2-quic_adisi@quicinc.com>
        <5e45705e-b1d1-a0dc-2c3d-455fb433e93f@quicinc.com>
Date:   Thu, 27 Jul 2023 19:29:40 +0300
In-Reply-To: <5e45705e-b1d1-a0dc-2c3d-455fb433e93f@quicinc.com> (Aditya Kumar
        Singh's message of "Thu, 27 Jul 2023 17:35:28 +0530")
Message-ID: <87lef1z5aj.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Aditya Kumar Singh <quic_adisi@quicinc.com> writes:

> On 6/7/2023 18:16, Aditya Kumar Singh wrote:
>> cfg80211 has cfg80211_chandef_dfs_usable() function to know whether
>> at least one channel in the chandef is in usable state or not. Also,
>> cfg80211_chandef_dfs_cac_time() function is there which tells the CAC
>> time required for the given chandef.
>> Make these two functions visible to drivers by exporting their
>> symbol
>> to global list of kernel symbols.
>> Lower level drivers can make use of these two functions to be aware
>> if CAC is required on the given chandef and for how long. For example
>> drivers which maintains the CAC state internally can make use of these.
>> Signed-off-by: Aditya Kumar Singh <quic_adisi@quicinc.com>
>> ---
> Hi Johannes,
>
> Do you have any comments for this patch?

The wireless trees are closed for July:

https://lore.kernel.org/all/87y1kncuh4.fsf@kernel.org/

Though I changed my plans and came back earlier.

And honestly these kind of emails don't really help. If a maintainer is
busy (and they usually are) sending more mails will do the opposite. If
you want to speed up your review help the maintainer somehow, for
example by reviewing or testing other patches etc which can reduce the
load of the maintainer.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
