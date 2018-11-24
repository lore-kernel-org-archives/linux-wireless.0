Return-Path: <SRS0=FFSH=OD=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B0CEC43441
	for <linux-wireless@archiver.kernel.org>; Sat, 24 Nov 2018 08:23:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C58420865
	for <linux-wireless@archiver.kernel.org>; Sat, 24 Nov 2018 08:23:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4C58420865
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbeKXTKk (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 24 Nov 2018 14:10:40 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:60018 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbeKXTKj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 24 Nov 2018 14:10:39 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gQTDH-0007Cw-By; Sat, 24 Nov 2018 09:22:51 +0100
Message-ID: <d0ba9821e46e1111bc483188466bb68dc1bb3c4a.camel@sipsolutions.net>
Subject: Re: [PATCH mac80211-next v4] mac80211-next: rtnetlink wifi
 simulation device
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Cody Schuffelen <schuffelen@google.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, kernel-team@android.com,
        Alistair Strachan <astrachan@google.com>,
        Greg Hartman <ghartman@google.com>,
        Tristan Muntsinger <muntsinger@google.com>
Date:   Sat, 24 Nov 2018 09:22:48 +0100
In-Reply-To: <20181121031449.255314-1-schuffelen@google.com> (sfid-20181121_041657_585863_43EBAA86)
References: <20181121031449.255314-1-schuffelen@google.com>
         (sfid-20181121_041657_585863_43EBAA86)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-11-20 at 19:14 -0800, Cody Schuffelen wrote:
> 
> +config VIRT_WIFI
> +	bool "Wifi wrapper for ethernet drivers"

The built bot complaint is most likely because of this being bool rather
than tristate (CFG80211=m, VIRT_WIFI=y, I guess, didn't check), I
thought this was because of the wrong reasons and should be back to
tristate?

I can change it back, let me know.

johannes

