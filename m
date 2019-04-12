Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69E12C10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 09:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3834C20850
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 09:49:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1555062557;
	bh=CsGKp0e/YhHueO2jmHUFN5h0ZBDlz58EfEN+zgSBNwM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=eBAS75CJ2+vEldB7WuOQ+jIk22l5rEeShKWAJ5p2ti9nO/pj6nRNjhJJcHN73sGh1
	 Y77jiWbpa3UYPQDYsE5pSoS+daw27GEqnf/ctci/Bfk6nIDgNq3b8Dhw3TMLflDH2t
	 rF8TGxFpBmX7gu478aE2UiBzUufhbNPGxuPW7N9Q=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfDLJtM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 05:49:12 -0400
Received: from mx2.suse.de ([195.135.220.15]:38946 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726794AbfDLJtL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 05:49:11 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 2F650ABCF;
        Fri, 12 Apr 2019 09:49:10 +0000 (UTC)
Date:   Fri, 12 Apr 2019 11:49:08 +0200
From:   Michal Hocko <mhocko@kernel.org>
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        linux-wireless@vger.kernel.org
Cc:     LKML <linux-kernel@vger.kernel.org>
Subject: Re: iwlwifi: BUG: unable to handle kernel paging request at
 ffffc90000e1c808
Message-ID: <20190412094908.GA5223@dhcp22.suse.cz>
References: <20190411210404.GC4743@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190411210404.GC4743@dhcp22.suse.cz>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu 11-04-19 23:07:20, Michal Hocko wrote:
> Hi,
> I have just encountered the following splat with 5.1-rc4. Is this a
> known problem? Greping throug older logs show that "Error sending SCAN_CFG_CMD"
> is not new. In older kernels it was followed by "Start IWL Error Log Dump:"
> but it oopsed now. I was running 5.0 previously. Let me know if you need
> more information.

FTR It happened again with 5.1.0-rc2-00001-ga3ac7917b730

-- 
Michal Hocko
SUSE Labs
