Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F03CDC43217
	for <linux-wireless@archiver.kernel.org>; Fri, 27 May 2022 09:01:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350471AbiE0JBy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 27 May 2022 05:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351186AbiE0JBR (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 27 May 2022 05:01:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEB15131F1D;
        Fri, 27 May 2022 01:58:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB9D761DAA;
        Fri, 27 May 2022 08:58:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C52C385B8;
        Fri, 27 May 2022 08:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653641887;
        bh=vtIL1AtMpLcio7YqtKfT6YKBW9nOoxqbyZgQaIm/YHY=;
        h=From:To:Cc:Subject:Date:From;
        b=InbCzu+6Zsz6QSOHa7uUWZigezehIi/o3brESO4ewqp/awp28k46VeWfVvJ8WOq0m
         JrqnW68ZjTfcmG0bPzdlqIcmMW4VYBfI1M2/wTvKd0eHCUm2liPXMiaiFvcm4WmiHq
         dkEVINT9+KJF7ryb2S1rzp77i0SCwJ9gL2bBjY3eHoAw5874iygJrQDXwH+2dtsqix
         UuGMZSOII4v9ostIZdF8ZZs7fA+qyCztGAxlDxqub+Y+b1MVomr40lueTxtqaj4oTk
         th9ed7w9abDZB/M56wM5q3v5WpV1CNHow9rxNw1Zs3aGK+cMLBDsZh21SgVIYr3miJ
         OsrwusV6zZrKw==
From:   Kalle Valo <kvalo@kernel.org>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: wireless for-next branches
Date:   Fri, 27 May 2022 11:58:03 +0300
Message-ID: <87a6b3qrms.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Stephen,

We are experimenting how we could take "next-next" patches during merge
windows and avoid accumulation of patches for the period which is in
practice three weeks for wireless patches. To do that could you please
change linux-next to pull from wireless trees for-next branches instead
of main branches? So the new locations are:

git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless.git for-next
git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-next.git for-next

The idea we have is that wireless-next for-next branch is not updated
during the merge window and then the "next-next" patches will not be
included in linux-next until the merge window has closed.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
