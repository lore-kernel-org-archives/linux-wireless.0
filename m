Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F18A4C3DA7C
	for <linux-wireless@archiver.kernel.org>; Mon,  2 Jan 2023 04:01:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229674AbjABEBr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 1 Jan 2023 23:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjABEBp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 1 Jan 2023 23:01:45 -0500
Received: from mx0.riseup.net (mx0.riseup.net [198.252.153.6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F65BBD0
        for <linux-wireless@vger.kernel.org>; Sun,  1 Jan 2023 20:01:42 -0800 (PST)
Received: from fews1.riseup.net (fews1-pn.riseup.net [10.0.1.83])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256
         client-signature RSA-PSS (2048 bits) client-digest SHA256)
        (Client CN "mail.riseup.net", Issuer "R3" (not verified))
        by mx0.riseup.net (Postfix) with ESMTPS id 4Nlhxy0cV1z9slr;
        Mon,  2 Jan 2023 04:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1672632102; bh=Djj7C6+JjkmMT7mxUTxv46ab9dTnFZNEb5YhNRpyjAM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nzj4h8eAuHH8kYbd3j6LzyvB3uPng43T5no+NawiEfwPvkqhR+BKNrHrPp4UEOKmh
         X9Xz2kFA+Pv0+9oUo/Vu9C8aRp7I9oPqT9clc2Wd58pgiV5iOlwuumCu2b3ax1nL6h
         mTeupuWXfKhvwaskZdcXnkThVmzTJfTfJa0xS66w=
X-Riseup-User-ID: 449FE3E42DDDF3A325B329708943F7DB8B442FC3847D819FF11583971F815A16
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by fews1.riseup.net (Postfix) with ESMTPSA id 4Nlhxw5HrXz5vLh;
        Mon,  2 Jan 2023 04:01:40 +0000 (UTC)
From:   Dang Huynh <danct12@riseup.net>
To:     linux-wireless@vger.kernel.org
Cc:     Felix Fietkau <nbd@nbd.name>, johannes@sipsolutions.net
Subject: Re: [PATCH v4] wifi: mac80211: fix initialization of rx->link and
 rx->link_sta
Date:   Mon, 02 Jan 2023 11:01:38 +0700
Message-ID: <6879486.31r3eYUQgx@melttower>
In-Reply-To: <20221217085624.52077-1-nbd@nbd.name>
References: <20221217085624.52077-1-nbd@nbd.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Using a CF-WU785AC (MT7612U) with this patch applied on top of kernel 6.1.2, I 
can confirm that this fixed my kernel panic issue.

Tested-by: Dang Huynh <danct12@riseup.net>


