Return-Path: <SRS0=yxJm=R7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79687C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Mar 2019 21:36:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 438782184C
	for <linux-wireless@archiver.kernel.org>; Thu, 28 Mar 2019 21:36:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="AtmVassZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727434AbfC1VgL (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 28 Mar 2019 17:36:11 -0400
Received: from [208.74.158.174] ([208.74.158.174]:35768 "EHLO
        mail3.candelatech.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726476AbfC1VgL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 28 Mar 2019 17:36:11 -0400
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id D1969137545;
        Thu, 28 Mar 2019 14:36:10 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com D1969137545
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1553808970;
        bh=1nCpZ86tbZ30zrxGgV1qfoEx1Ne9LIIdUmg8muX0w6w=;
        h=To:From:Subject:Date:From;
        b=AtmVassZCrufvohD1q0xYu7Dyn/qEX5EP9l/7TqFchONJPrLPSY/Fei5MiZYzBW9z
         wujvi4BxXv1CsMCDVNFX+zb/fLmq/Uzp20zjNufW0GvpS3uJm6DqZ8HO+pfynPPmHp
         y+k2C9X9Pqvt/UfD1l3bR57BQ+mHec99ClNkxSLo=
To:     "hostap@lists.infradead.org" <hostap@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
From:   Ben Greear <greearb@candelatech.com>
Subject: Action frame sent as TID 6
Organization: Candela Technologies
Message-ID: <ca8c5af0-207f-458b-3858-037417513323@candelatech.com>
Date:   Thu, 28 Mar 2019 14:36:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

While debugging some issues with neighbor query action frames, I ran into
an interesting set of issues.

For reasons I do not yet understand, sometimes wpa_supplicant has bss->freq == 0
when associated, and so sending an action frame chooses to send a 'command'
frame instead of an mlme frame, because it thinks we are doing off-channel tx.

When this happens, I end up seeing the action frame sent out on TID 6 in
the ath10k firmware.  This fails to send for a variety of reasons.

When supplicant evidently has the proper bss->freq, then action frames
go through the mlme code path, and then I see frames hit the ath10k
firmware on the mgt tid as expected.

I can hack around this in several different places, but in hopes of doing
this more correctly:  What exactly is supposed to configure the TID
for off-channel TX?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

