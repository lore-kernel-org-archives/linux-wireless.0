Return-Path: <SRS0=CFp0=SD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12E0EC43381
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 13:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D633F20870
	for <linux-wireless@archiver.kernel.org>; Mon,  1 Apr 2019 13:20:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=candelatech.com header.i=@candelatech.com header.b="eEVBAnBL"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727029AbfDANU1 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 1 Apr 2019 09:20:27 -0400
Received: from [208.74.158.174] ([208.74.158.174]:43054 "EHLO
        mail3.candelatech.com" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1726762AbfDANU1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 1 Apr 2019 09:20:27 -0400
Received: from [192.168.100.195] (50-251-239-81-static.hfc.comcastbusiness.net [50.251.239.81])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail3.candelatech.com (Postfix) with ESMTPSA id D575413C2B8;
        Mon,  1 Apr 2019 06:20:26 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mail3.candelatech.com D575413C2B8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=candelatech.com;
        s=default; t=1554124827;
        bh=UbYEp2v+TCYvofXnzNRPiMmKx0u8wIaRUtksroWmJdg=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=eEVBAnBLesSZHlputGDsQDYjbkfdL8ec6rQiTUFwpS6D7+6DULw+FNjd2qWaPO1IX
         URaOJX1d1gFxSEhf11ZEbi2xtaIjaj7ro+n7Y2fBDau+/dD7xBU+X7LWk12FmDtMGp
         uxuokMUsS0cyEmJZqVentePNeQoTj1JyFj3DleSg=
Subject: Re: [RFC V3 2/2] ath10k: add tx hw 802.11 encapusaltion offloading
 support
To:     John Crispin <john@phrozen.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org,
        Shashidhar Lakkavalli <slakkavalli@datto.com>,
        Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
References: <20190401131416.22646-1-john@phrozen.org>
 <20190401131416.22646-3-john@phrozen.org>
From:   Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
Message-ID: <21eba716-42d0-91ea-a3c0-336c184ce605@candelatech.com>
Date:   Mon, 1 Apr 2019 06:20:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <20190401131416.22646-3-john@phrozen.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 4/1/19 6:14 AM, John Crispin wrote:
> From: Vasanthakumar Thiagarajan <vthiagar@qti.qualcomm.com>
> 
> This patch adds support for ethernet rxtx mode to the driver. The feature
> is enabled via a new module parameter. If enabled to driver will enable
> the feature on a per vif basis if all other requirements were met.
> 
> Testing on a IPQ4019 based hardware shows a increase in TCP throughput
> of ~20% when the feature is enabled.

Hello,

Do you have an idea of where this improvement comes from?  Is it CPU load on
the host, or does firmware somehow work better in this mode?

And, does UDP also show improvement?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

