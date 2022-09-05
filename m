Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2E72ECAAD3
	for <linux-wireless@archiver.kernel.org>; Mon,  5 Sep 2022 17:31:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231658AbiIERbj (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 5 Sep 2022 13:31:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231630AbiIERbh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Sep 2022 13:31:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 652055A2E2
        for <linux-wireless@vger.kernel.org>; Mon,  5 Sep 2022 10:31:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E60916144D
        for <linux-wireless@vger.kernel.org>; Mon,  5 Sep 2022 17:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A412C433D6;
        Mon,  5 Sep 2022 17:31:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662399090;
        bh=hjSUIFLLP713kGAkqYkFD9HnQwl67J2zTmeFtfJwdyc=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=KjvXTg0fO2mu7tGnq9WvnI/+l1tTLRgurn0wxXuKmkqj1DTbjIKUKTQheNICkJoE2
         DtDJMWiy16mbtpRee5+g+4kSocwzyDDQepC5UrGLwLINZog5VG92xU0lztk7DY3HSX
         03sxHjEtiHtEj6NrzS4LCxhOHFGXjG4oKMvTty/hN91B/t34p726HVip4l8N6xdQH/
         QbC5EDc/u09u+RG9Ly8XS82pOurg61CPlx4QbGA6SMCxHGFVM4yGWePbVMVHmvCzpv
         e2cCDOyLm0dPc7VphTNHzyYu79AEO4q6Q7uVpGbYs07ULWPKxC4myWZ5/l22Qv1s37
         K1ZuKT6n7bJHg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Ping-Ke Shih <pkshih@realtek.com>
Cc:     "linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ath12k\@lists.infradead.org" <ath12k@lists.infradead.org>
Subject: Re: [PATCH 31/50] wifi: ath12k: add mac.c
References: <20220812161003.27279-1-kvalo@kernel.org>
        <20220812161003.27279-32-kvalo@kernel.org>
        <c9c4f3027e294e148bd595e3db1a62a8@realtek.com>
Date:   Mon, 05 Sep 2022 20:31:24 +0300
In-Reply-To: <c9c4f3027e294e148bd595e3db1a62a8@realtek.com> (Ping-Ke Shih's
        message of "Mon, 15 Aug 2022 06:09:40 +0000")
Message-ID: <87h71laftf.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Ping-Ke Shih <pkshih@realtek.com> writes:

>> +static int get_num_chains(u32 mask)
>> +{
>> +	int num_chains = 0;
>> +
>> +	while (mask) {
>> +		if (mask & BIT(0))
>> +			num_chains++;
>> +		mask >>= 1;
>> +	}
>> +
>> +	return num_chains;
>> +}
>
> use hweight32()?

Yup, we'll fix that. Thanks!

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
