Return-Path: <SRS0=AjP+=NE=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,USER_AGENT_MUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70F44C67863
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 11:22:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40E33207DD
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Oct 2018 11:22:24 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40E33207DD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727610AbeJXTuG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 15:50:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57742 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727000AbeJXTuG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 15:50:06 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 92C30308FBA2;
        Wed, 24 Oct 2018 11:22:22 +0000 (UTC)
Received: from localhost (unknown [10.40.205.135])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A6D185B681;
        Wed, 24 Oct 2018 11:22:21 +0000 (UTC)
Date:   Wed, 24 Oct 2018 13:22:20 +0200
From:   Stanislaw Gruszka <sgruszka@redhat.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Joonwoo Park <joonwpark81@gmail.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Rajat Jain <rajatja@google.com>,
        Kirtika Ruchandani <kirtika@chromium.org>
Subject: Re: [PATCH] iwlwifi: pcie: align licensing to dual GPL/BSD
Message-ID: <20181024112219.GA23126@redhat.com>
References: <20181024070436.4466-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181024070436.4466-1-johannes@sipsolutions.net>
User-Agent: Mutt/1.8.3 (2017-05-23)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Wed, 24 Oct 2018 11:22:22 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Oct 24, 2018 at 09:04:36AM +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> These files have a long history of code changes, but analysing
> the remaining code leads to having only a few changes that are
> not already owned by Intel, notably from
>  - Andy Lutomirski <luto@amacapital.net>
>  - Joonwoo Park <joonwpark81@gmail.com>
>  - Kirtika Ruchandani <kirtika@chromium.org>
>  - Rajat Jain <rajatja@google.com>
>  - Stanislaw Gruszka <sgruszka@redhat.com>
> remaining in the code today.
> 
> Note that
>  - I myself was working for Intel and for any possibly code
>    that might be before my employment there give permission
>  - Wizery employees were working for Intel
> 
> More specifically, we identified the following commits that
> (partially may) remain today:
> 
> 25c03d8e8c13 Joonwoo Park <joonwpark81@gmail.com>      ("iwlwifi: do not schedule tasklet when rcv unused irq")
> f36d04abe684 Stanislaw Gruszka <sgruszka@redhat.com>   ("iwlwifi: use dma_alloc_coherent")
> 387f3381f732 Stanislaw Gruszka <sgruszka@redhat.com>   ("iwlwifi: fix dma mappings and skbs leak")
> 2624e96ce16b Stanislaw Gruszka <sgruszka@redhat.com>   ("iwlwifi: fix possible data overwrite in hcmd callback")
> bfe4b80e9f73 Stanislaw Gruszka <sgruszka@redhat.com>   ("iwlwifi: always check if got h/w access before write")
> d536c32b45d2 Andy Lutomirski <luto@amacapital.net>     ("iwlwifi: pcie: log when waking the NIC for hcmd submission fails")
> a6d24fad00d9 Rajat Jain <rajatja@google.com>           ("iwlwifi: pcie: dump registers when HW becomes inaccessible")
> fb12777ab59b Kirtika Ruchandani <kirtika@chromium.org> ("iwlwifi: Add more call-sites for pcie reg dumper")
> 3a73a30049f2 Stanislaw Gruszka <sgruszka@redhat.com>   ("iwlwifi: cleanup/fix memory barriers")
> aa5affbacb24 Stanislaw Gruszka <sgruszka@redhat.com>   ("iwlwifi: dump stack when fail to gain access to the device")
> 
> Align the licenses with their permission to clean up and to
> make it all identical.
> 
> CC: Joonwoo Park <joonwpark81@gmail.com>
> CC: Stanislaw Gruszka <sgruszka@redhat.com>
> CC: Andy Lutomirski <luto@amacapital.net>
> CC: Rajat Jain <rajatja@google.com>
> CC: Kirtika Ruchandani <kirtika@chromium.org>
> Acked-by: Johannes Berg <johannes@sipsolutions.net>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Acked-by: Stanislaw Gruszka <sgruszka@redhat.com>
