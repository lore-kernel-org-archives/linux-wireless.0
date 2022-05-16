Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25CD9C433EF
	for <linux-wireless@archiver.kernel.org>; Mon, 16 May 2022 16:36:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232623AbiEPQgi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 16 May 2022 12:36:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343776AbiEPQgG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 16 May 2022 12:36:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D756DF60
        for <linux-wireless@vger.kernel.org>; Mon, 16 May 2022 09:36:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB82EB8125C
        for <linux-wireless@vger.kernel.org>; Mon, 16 May 2022 16:36:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23A0C385AA;
        Mon, 16 May 2022 16:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652718959;
        bh=4Gr2UMaY2vre3+l0Z/vZmHdEqnbxdBbORKHtVrhxuf4=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=pALU45M6RSdK7jSjZMMdMmT87g+XckxPnvwriAOxW2RocPj0T7rqueRaOH5CMTSX4
         0bVD4qTCPAO8oWZ5hN9HtxuBPE/fEVj4z+Ty9rYC2aDj6yOLkyrbYLRbdciFCvB5qs
         4p8xu7r+OJ2OCG21fOiKl6l8XWbB6LFkYg5hE5cMnHkwVH/EiAQnzg6RNZcP88leDC
         +Sxup/j7d/MO+CtBgjG5j/dAXnTSpCyKAojtm3b/N1Ch3Z9e4HUvTtPF87rUROTVDv
         BMEL2wraQbVhgeCJ5qzsI5v4/p9O46vML6zIaWPs3MkbfbPgh0xMmo5btb3JVPOCYt
         3zdhA6/A1MBNA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Maxime Bizon <mbizon@freebox.fr>
Cc:     ath10k@lists.infradead.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: fix misreported tx bandwidth for 160Mhz
References: <cd2735a40da7f4fcc5323e3fca3775e7b5402ece.camel@freebox.fr>
        <87o7zx4fue.fsf@kernel.org>
        <c4bf5262bc250afd9c9e52248f1b576a7882c8d4.camel@freebox.fr>
Date:   Mon, 16 May 2022 19:35:54 +0300
In-Reply-To: <c4bf5262bc250afd9c9e52248f1b576a7882c8d4.camel@freebox.fr>
        (Maxime Bizon's message of "Mon, 16 May 2022 18:23:25 +0200")
Message-ID: <87fsl94eqd.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Maxime Bizon <mbizon@freebox.fr> writes:

> On Mon, 2022-05-16 at 19:11 +0300, Kalle Valo wrote:
>
>> On what ath10k hardware and afirmware version did you test this? I
>> can add that to the commit log.
>> 
>
> QCA9984 
> 10.4-3.10-00047

Thanks, I added that in the pending branch.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
