Return-Path: <SRS0=FjVT=OO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1FE5C04EB9
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 08:50:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B1F6720850
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Dec 2018 08:50:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="azx8eYf2"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B1F6720850
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbeLEIun (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Dec 2018 03:50:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:40196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726866AbeLEIun (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Dec 2018 03:50:43 -0500
Received: from localhost (5356596B.cm-6-7b.dynamic.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 972CD2084C;
        Wed,  5 Dec 2018 08:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1543999843;
        bh=oVmThZbyGkwhcs6MnLcUJQ+OcavpLjf7yo+9FKQsflo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=azx8eYf2EU+SYMtHcVQdTzlzeDT9qEvdd2TuSOOOgyb49qGOtB2JaRJcWJYtb4jiO
         cWoErOVPltKBQprQjzU7D1YmaS0PkRUyS0h11prGPWrOyCq07/DnDWLwzTlncMIk06
         14ju9sSAPBu9LYSGgY3HWNfggVwZExNwJwKrJ4pc=
Date:   Wed, 5 Dec 2018 09:50:40 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ajay.Kathat@microchip.com
Cc:     linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        johannes@sipsolutions.net, Adham.Abozaeid@microchip.com
Subject: Re: [PATCH 00/29] staging: wilc1000: avoid deferring of cfg80211
 operation callback
Message-ID: <20181205085040.GA23974@kroah.com>
References: <1543773663-20561-1-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1543773663-20561-1-git-send-email-ajay.kathat@microchip.com>
User-Agent: Mutt/1.11.0 (2018-11-25)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sun, Dec 02, 2018 at 06:02:13PM +0000, Ajay.Kathat@microchip.com wrote:
>  6 files changed, 755 insertions(+), 2012 deletions(-)

Nice code removal, patch series all now applied.

greg k-h
