Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11126C433B4
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Apr 2021 09:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D220F60FD8
	for <linux-wireless@archiver.kernel.org>; Sun, 11 Apr 2021 09:42:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235283AbhDKJmQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 11 Apr 2021 05:42:16 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:44408 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S235267AbhDKJmL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Apr 2021 05:42:11 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=[192.168.100.150])
        by farmhouse.coelho.fi with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94)
        (envelope-from <luca@coelho.fi>)
        id 1lVWbA-000Jkf-MR; Sun, 11 Apr 2021 12:41:46 +0300
Message-ID: <b35c9cfbf275d1581ccbc2b2dba39d316a725079.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Ben Greear <greearb@candelatech.com>, kvalo@codeaurora.org,
        ilan.peer@intel.com
Cc:     linux-wireless@vger.kernel.org
Date:   Sun, 11 Apr 2021 12:41:44 +0300
In-Reply-To: <aa0dae40-1565-2bb0-b33f-0da82a8de137@candelatech.com>
References: <20210331091452.543321-1-luca@coelho.fi>
         <iwlwifi.20210331121101.7c7bd00e0aeb.Ib226ad57e416b43a710c36a78a617d4243458b99@changeid>
         <aa0dae40-1565-2bb0-b33f-0da82a8de137@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 06/12] iwlwifi: mvm: Add support for 6GHz passive scan
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2021-03-31 at 05:03 -0700, Ben Greear wrote:
> On 3/31/21 2:14 AM, Luca Coelho wrote:
> > From: Ilan Peer <ilan.peer@intel.com>
> > 
> > When doing scan while 6GHz channels are not enabled, the 6GHz band
> > is not scanned. Thus, if there are no APs on the 2GHz and 5GHz bands
> > (that will allow discovery of geographic location etc. that would
> > allow enabling the 6GHz channels) but there are non collocated APs
> > on 6GHz PSC channels these would never be discovered.
> > 
> > To overcome this, FW added support for performing passive UHB scan
> > in case no APs were discovered during scan on the 2GHz and 5GHz
> > channels.
> > 
> > Add support for enabling such scan when the following conditions are
> > met:
> > 
> > - 6GHz channels are supported but not enabled by regulatory.
> > - Station interface is not associated or less than a defined time
> >    interval passed from the last resume or HW reset flows.
> > - At least 4 channels are included in the scan request
> > - The scan request includes the widlcard SSID.
> > - At least 50 minutes passed from the last 6GHz passive scan.
> 
> Why are you trying so hard to not do passive scans?  This seems like it
> is set up for all sorts of frustration.

This is because of regulatory restrictions.  Maybe Ilan can clarify
more.

--
Cheers,
Luca.

