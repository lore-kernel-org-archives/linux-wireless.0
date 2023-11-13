Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71327C4332F
	for <linux-wireless@archiver.kernel.org>; Mon, 13 Nov 2023 12:39:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjKMMjI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 13 Nov 2023 07:39:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjKMMjH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2023 07:39:07 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FCBC1715
        for <linux-wireless@vger.kernel.org>; Mon, 13 Nov 2023 04:39:04 -0800 (PST)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A471DC433C8;
        Mon, 13 Nov 2023 12:39:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1699879144;
        bh=R+CjkpzyaORCz7DvJnV6q9L1BjwMqH+lJd6twu6VJrQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=uvletBgFW8VEONuy297MVMqKiAChpSbb+S0oFd8LQdcJ6SrzaPqxAhm+hXxmkn8B0
         PyXSjMTTixHdz9HAvCNiC0PA3XAfvSdMINeNvCNn+XtGwsB57OFzYQVX/Kv2yHZN+8
         mLFS3Vksl0ekLDefVz1UzOas+hCVLqbzn+RXruwZ9u9Jy0EmOn+FPbdWWOv62zLECJ
         w4zmeGE4LtJDrPcPdgRqrjCnsh2dJtVUoujELLBhWuPIOP4fSurB1pzzA7bPGcf+Yg
         a2zguyLVXy9wtAq219eIt7JmuwjtJT2tHHvqynJZOPpx5P0w47kQK2SngbIn5GLYf4
         m36bDuTHEujIQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com,
        nbd@nbd.name, sean.wang@mediatek.com, deren.wu@mediatek.com
Subject: Re: [PATCH wireless] wifi: mt76: mt7925: fix typo in
 mt7925_init_he_caps
References: <7de6e939dc75ee08f05bf1ee73253aa7eeccf28e.1699869649.git.lorenzo@kernel.org>
        <87cywdvox0.fsf@kernel.org> <ZVIXQx4nb25pO0EP@lore-desk>
Date:   Mon, 13 Nov 2023 14:39:00 +0200
In-Reply-To: <ZVIXQx4nb25pO0EP@lore-desk> (Lorenzo Bianconi's message of "Mon,
        13 Nov 2023 13:32:03 +0100")
Message-ID: <87v8a5u8t7.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Lorenzo Bianconi <lorenzo@kernel.org> writes:

>> Lorenzo Bianconi <lorenzo@kernel.org> writes:
>> 
>> > Use iftype for interface type switch in mt7925_init_he_caps routine
>> >
>> > Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver
>> > for mt7925 chips")
>> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>> 
>> What issue does this fix? In other words, what are the user visible
>> symptoms?
>
> Since we are using i (equal to 8 after the for loop above) instead of iftype
> we are missing some HE capabilities exposed to userspace (we are hitting the
> switch default branch). I agree this is something not so harmful and we can
> apply this fix to Felix's tree instead, up to you.

No no, this is fine for the wireless tree :) I just want to document if
this is fixing a real issue which users can see or just a theoretical
fix you found during code review. It makes handling fixes a lot easier
when we have this documented in the commit message.

No need to resend because of this, I can update the commit log if you
tell me what to add.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
