Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D0578C4332F
	for <linux-wireless@archiver.kernel.org>; Fri,  3 Nov 2023 05:56:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbjKCF4R (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 3 Nov 2023 01:56:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbjKCF4Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 3 Nov 2023 01:56:16 -0400
Received: from mx4.wp.pl (mx4.wp.pl [212.77.101.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDD61CA
        for <linux-wireless@vger.kernel.org>; Thu,  2 Nov 2023 22:56:11 -0700 (PDT)
Received: (wp-smtpd smtp.wp.pl 13373 invoked from network); 3 Nov 2023 06:56:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1698990969; bh=hYbfMvR5plFPpgTl+p4rc2cQMPKAnWh6GC4Sf8TtPmE=;
          h=From:To:Cc:Subject;
          b=AeDmBG1RsaLeAsYM02oLJzAIYFtWd7FzbWQDTi2rvXAodyrej0b7GNcWr+uMJSIQo
           cuFhtQe1kRoBaWDDj0+RLS3RAMrCFAsAIZXQZ/jtBJrw/E6LxVP49+hcaQfKH0OQIa
           sYZlDhMRdY/7UFGVE7hWJh3ol8rsOuCHKoYJQ19E=
Received: from 89-64-13-175.dynamic.chello.pl (HELO localhost) (stf_xl@wp.pl@[89.64.13.175])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <yangshiji66@outlook.com>; 3 Nov 2023 06:56:09 +0100
Date:   Fri, 3 Nov 2023 06:56:08 +0100
From:   Stanislaw Gruszka <stf_xl@wp.pl>
To:     Shiji Yang <yangshiji66@outlook.com>
Cc:     linux-wireless@vger.kernel.org, Kalle Valo <kvalo@kernel.org>
Subject: Re: [PATCH 3/3] wifi: rt2x00: restart beacon queue when hardware
 reset
Message-ID: <20231103055608.GB27419@wp.pl>
References: <20231028121532.5397-1-yangshiji66@outlook.com>
 <TYAP286MB0315339CF8B38FC1286CF39DBCA3A@TYAP286MB0315.JPNP286.PROD.OUTLOOK.COM>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <TYAP286MB0315339CF8B38FC1286CF39DBCA3A@TYAP286MB0315.JPNP286.PROD.OUTLOOK.COM>
X-WP-MailID: 9c6cd4ee399c8e6a86d7225a4d47f122
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [oYM0]                               
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Oct 28, 2023 at 08:15:32PM +0800, Shiji Yang wrote:
> When a hardware reset is triggered, all registers are reset, so all
> queues are forced to stop in hardware interface. However, mac80211
> will not automatically stop the queue. If we don't manually stop the
> beacon queue, the queue will be deadlocked and unable to start again.
> This patch fixes the issue where Apple devices cannot connect to the
> AP after calling ieee80211_restart_hw().
> 
> Signed-off-by: Shiji Yang <yangshiji66@outlook.com>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
