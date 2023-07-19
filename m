Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87EFBC001DC
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Jul 2023 10:38:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbjGSKiX (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Jul 2023 06:38:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231285AbjGSKhv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2023 06:37:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02B5A11D
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jul 2023 03:37:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DFF8613C5
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jul 2023 10:37:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904CAC433C7;
        Wed, 19 Jul 2023 10:37:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689763065;
        bh=fNXKnjOUddOBoxPZLQEvBHhEM0J9YHh1AUWYrBJHiUQ=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=LLrUl5BdJ6eU0E262jahWLeDYL4v1jWQwqQ3LkAlW8IbUFo+zqie/Zc0rlur/RcwV
         vfvdndgrxFBcF9ZOXdJnlaT6eDhNoiiC1/yWd/9PqenntBagbdLFlKYvHGRnqRTGt0
         XeXUtWNObyJZsfdpxrYHDj6wuZUkl7F6A3aeyacYY4jMMvJ5J3jki6eGvTfTBD2+2b
         wfNP0YLtSZOT86rcVOzQFDI2Tm9uqgcasyGERKzD+JhtMZiHLy2qc5Aqgd16OQnKua
         0vYB7jMfKJOgZZvXO8ArTGdSk41iLcS/3f33qCBtrwiSRXfppZG+ViHIQvtH3a2dfR
         Y1+wBlHt4Jjgg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     <Ajay.Kathat@microchip.com>, <linux-wireless@vger.kernel.org>,
        <Claudiu.Beznea@microchip.com>, <Sripad.Balwadgi@microchip.com>
Subject: Re: [PATCH] wifi: wilc1000: change firmware path from 'atmel' to
 'microchip/wilc'
References: <20230630012136.1330784-1-ajay.kathat@microchip.com>
        <20230705140338.77896d11@kernel.org>
        <5500a007-4e52-f8dc-2535-3baa7decfe52@microchip.com>
        <20230705172754.61ca21ae@kernel.org>
Date:   Wed, 19 Jul 2023 13:37:39 +0300
In-Reply-To: <20230705172754.61ca21ae@kernel.org> (Jakub Kicinski's message of
        "Wed, 5 Jul 2023 17:27:54 -0700")
Message-ID: <87cz0o2nm4.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/28.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

>> In order to address scenario#1, a fallback method that loads the FW from
>> the older path(/atmel) can be added in the driver. I think that change
>> will make it compatible for scenario#1.
>> Please suggest, if there is a generic/recommended approach to handle
>> backward compatibility for FW path change.
>
> I'm afraid you need to request from both new and old patch for some
> time. Push the change to linux-firmware, but make driver be compatible
> with both for maybe three full releases? Then the risk of someone still
> having stale linux-firmware goes down quite a bit.

I would say at least minimum of two years, preferably more to make it
possible to upgrade kernel on LTS distro releases.

> TBH renaming FW paths, much like renaming drivers is usually more risk
> than reward.

I agree, it's just extra work without no actually benefit. Maybe an
exception here is iwlwifi, that should be fixed as that clutters the top
level firmware directory with dozens of files:

https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
