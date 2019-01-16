Return-Path: <SRS0=vb4L=PY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 53B1CC43444
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 11:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 239AF2082F
	for <linux-wireless@archiver.kernel.org>; Wed, 16 Jan 2019 11:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389821AbfAPLVc (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 16 Jan 2019 06:21:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49402 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730420AbfAPLVc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Jan 2019 06:21:32 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id DE988C0703AB;
        Wed, 16 Jan 2019 11:21:31 +0000 (UTC)
Received: from localhost (unknown [10.40.205.109])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4D32B1059594;
        Wed, 16 Jan 2019 11:21:31 +0000 (UTC)
Date:   Wed, 16 Jan 2019 12:21:30 +0100
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Bernd Edlinger <bernd.edlinger@hotmail.de>
Cc:     Helmut Schaa <helmut.schaa@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rt61pci: Work around a firmware bug with shared keys
Message-ID: <20190116112129.GC5234@redhat.com>
References: <AM0PR07MB3874E8F6ADD41C4E1BCBE43EE4810@AM0PR07MB3874.eurprd07.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR07MB3874E8F6ADD41C4E1BCBE43EE4810@AM0PR07MB3874.eurprd07.prod.outlook.com>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.32]); Wed, 16 Jan 2019 11:21:32 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Jan 15, 2019 at 02:01:29PM +0000, Bernd Edlinger wrote:
> Apparently the rt2x61 firmware fails temporarily to decode
> broadcast packets if the shared keys are not assigned
> in the "correct" sequence. At the same time unicast
> packets work fine, since they are encrypted with the
> pairwise key.
> 
> At least with WPA2 CCMP mode the shared keys are
> set in the following sequence: keyidx=1, 2, 1, 2.
> After a while only keyidx 2 gets decrypted, and
> keyidx 1 is ignored, probably because there is never
> a keyidx 3.
> 
> Symptoms are arping -b works for 10 minutes, since
> keyidx=2 is used for broadcast, and then it stops
> working for 10 minutes, because keyidx=1 is used.
> That failure mode repeats forever.
> 
> Note, the firmware does not even know which keyidx
> corresponds to which hw_key_idx so the firmware is
> trying to be smarter than the driver, which is bound
> to fail.
> 
> As workaround the function rt61pci_config_shared_key
> requests software decryption of the shared keys,
> by returning EOPNOTSUPP. However, pairwise keys are
> still handled by hardware which works just fine.
> 
> Signed-off-by: Bernd Edlinger <bernd.edlinger@hotmail.de>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
