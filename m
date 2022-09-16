Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EA9EC54EE9
	for <linux-wireless@archiver.kernel.org>; Fri, 16 Sep 2022 05:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiIPFhU (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 16 Sep 2022 01:37:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbiIPFhT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Sep 2022 01:37:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 367E56F56B
        for <linux-wireless@vger.kernel.org>; Thu, 15 Sep 2022 22:37:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F76AB823AE
        for <linux-wireless@vger.kernel.org>; Fri, 16 Sep 2022 05:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB342C433C1;
        Fri, 16 Sep 2022 05:37:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663306635;
        bh=jM5saF8A2jQF85Jq+EzNXODocbAeHuLf4n0rQwVxZlo=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=Smf2uhH/NHhercMlEbVhAZ7OFahC35FBj7VSPD8BLfXVIsx4AeKb+pLgxupUxJT5Y
         +DdisgxqyoafWZkhCj1xh0t3MsNbzhN2BHRDfDe3PvNz+X34AHkwulQbLhMOsIvzGJ
         fN5nYnNGBKT3ZAHzOrZvBtvO18UQLvcd76MMdymAwSWdAxjzg1ypXGTESt91J1zJ6A
         edLw/4T+P4oRE0cHrNSG2sUmW3GM7FM0DRtvwmjA1D6vRM9/9o013hFklas3WlR756
         SaqHfdrb1C4j/5svet+YZ54nHXPhht417Ex9TpkIpLdK6piNpntTx2lsAMZ4lXFUBS
         EIiOBulJb8vfA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
Cc:     sean.wang@mediatek.com, lorenzo.bianconi@redhat.com,
        Soul.Huang@mediatek.com, YN.Chen@mediatek.com,
        Leon.Yen@mediatek.com, Eric-SY.Chang@mediatek.com,
        Deren.Wu@mediatek.com, km.lin@mediatek.com,
        jenhao.yang@mediatek.com, robin.chiu@mediatek.com,
        Eddie.Chen@mediatek.com, ch.yeh@mediatek.com,
        posh.sun@mediatek.com, ted.huang@mediatek.com,
        Stella.Chang@mediatek.com, Tom.Chou@mediatek.com,
        steve.lee@mediatek.com, jsiuda@google.com, frankgor@google.com,
        kuabhs@google.com, druth@google.com, abhishekpandit@google.com,
        shawnku@google.com, linux-wireless@vger.kernel.org,
        linux-mediatek@lists.infradead.org
Subject: Re: [PATCH v2] mt76: mt7921: fix antenna signal are way off in monitor mode
References: <0f95fcdb8511ec765040c8fe85c1fa09437e8ef5.1659574985.git.objelf@gmail.com>
        <982053de-7bc0-0d4e-9eb7-9da0be559058@nbd.name>
Date:   Fri, 16 Sep 2022 08:37:07 +0300
In-Reply-To: <982053de-7bc0-0d4e-9eb7-9da0be559058@nbd.name> (Felix Fietkau's
        message of "Thu, 15 Sep 2022 12:37:27 +0200")
Message-ID: <8735crc22k.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Felix Fietkau <nbd@nbd.name> writes:

> On 04.08.22 03:07, sean.wang@mediatek.com wrote:
>> From: Sean Wang <sean.wang@mediatek.com>
>>
>> Group 3 in RxD is disabled in monitor mode. We should use the group 5 in
>> RxD instead to fix antenna signal way off issue, e.g we would see the
>> incorrect antenna signal value in wireshark. On the other hand, Group 5
>> wouldn't be used in STA or AP mode, so the patch shouldn't cause any
>> harm to those modes.
>>
>> Fixes: cbaa0a404f8d ("mt76: mt7921: fix up the monitor mode")
>> Reported-by: Adrian Granados <agranados@gmail.com>
>> Co-developed-by: Deren Wu <deren.wu@mediatek.com>
>> Signed-off-by: Deren Wu <deren.wu@mediatek.com>
>> Signed-off-by: Sean Wang <sean.wang@mediatek.com>
>
> This patch has been line wrapped and does not apply. Please resend.

And please use "wifi:" in the title.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
