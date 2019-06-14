Return-Path: <SRS0=mNjQ=UN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E24C31E4B
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Jun 2019 14:10:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5F91A21537
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Jun 2019 14:10:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbfFNOKt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Jun 2019 10:10:49 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:42664 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728391AbfFNOKt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Jun 2019 10:10:49 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hbmul-00022V-PB; Fri, 14 Jun 2019 16:10:47 +0200
Message-ID: <c025150aad17bbe62595c4969ea2f53f009419d3.camel@sipsolutions.net>
Subject: Re: [PATCH v3 0/3] mac80211/ath11k: HE mesh support
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Sven Eckelmann <sven@narfation.org>, linux-wireless@vger.kernel.org
Cc:     ath11k@lists.infradead.org
Date:   Fri, 14 Jun 2019 16:10:46 +0200
In-Reply-To: <20190612193510.29489-1-sven@narfation.org> (sfid-20190612_213642_840659_91049B7E)
References: <20190612193510.29489-1-sven@narfation.org>
         (sfid-20190612_213642_840659_91049B7E)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Sven,

Two comments:

1) It seems to me that patches 1/2 really should be in opposite order,
   since you can't really claim HE mesh support in hwsim when you don't
   have it in mac80211?
   Or maybe I misunderstand?

2) This series breaks the wpas_mesh_max_peering wpa_supplicant/hwsim
   test, and I'm not sure why. Perhaps some length calculations are bad?

johannes

