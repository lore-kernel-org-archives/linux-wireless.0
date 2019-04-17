Return-Path: <SRS0=eC3p=ST=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79887C10F12
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 07:34:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41DAD2073F
	for <linux-wireless@archiver.kernel.org>; Wed, 17 Apr 2019 07:34:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728851AbfDQHeB (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 17 Apr 2019 03:34:01 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:53516 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726237AbfDQHeA (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 17 Apr 2019 03:34:00 -0400
Received: from 91-156-6-193.elisa-laajakaista.fi ([91.156.6.193] helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <luca@coelho.fi>)
        id 1hGf4v-0006fu-5B; Wed, 17 Apr 2019 10:33:57 +0300
Message-ID: <748205b02961167b0926d4afe8d9ad9cb37bf6ef.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Michal Hocko <mhocko@kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-wireless@vger.kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>
Date:   Wed, 17 Apr 2019 10:33:56 +0300
In-Reply-To: <20190416183634.GB655@dhcp22.suse.cz>
References: <20190411210404.GC4743@dhcp22.suse.cz>
         <20190412094908.GA5223@dhcp22.suse.cz>
         <20190416183634.GB655@dhcp22.suse.cz>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: iwlwifi: BUG: unable to handle kernel paging request at
 ffffc90000e1c808
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-04-16 at 20:36 +0200, Michal Hocko wrote:
> On Fri 12-04-19 11:49:08, Michal Hocko wrote:
> > On Thu 11-04-19 23:07:20, Michal Hocko wrote:
> > > Hi,
> > > I have just encountered the following splat with 5.1-rc4. Is this
> > > a
> > > known problem? Greping throug older logs show that "Error sending
> > > SCAN_CFG_CMD"
> > > is not new. In older kernels it was followed by "Start IWL Error
> > > Log Dump:"
> > > but it oopsed now. I was running 5.0 previously. Let me know if
> > > you need
> > > more information.
> > 
> > FTR It happened again with 5.1.0-rc2-00001-ga3ac7917b730
> 
> Is there anything more I can provide to help with this issue. I had
> to
> go back to 5.0 because the system is not really usable after the
> oops.

Michal, thanks for reporting and all the data.  We have a fix for it
and I'm going to send it out in a second.  Please try it out and let us
know whether it works for you.

--
Cheers,
Luca.

