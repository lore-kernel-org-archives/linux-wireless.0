Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B9D2C0015E
	for <linux-wireless@archiver.kernel.org>; Wed, 19 Jul 2023 18:04:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbjGSSEt (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 19 Jul 2023 14:04:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjGSSEs (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 19 Jul 2023 14:04:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBF741FC4
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jul 2023 11:04:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8911D617D1
        for <linux-wireless@vger.kernel.org>; Wed, 19 Jul 2023 18:04:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD84EC433C8;
        Wed, 19 Jul 2023 18:04:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689789887;
        bh=xYpAE5H2J8bZg3VbWq2s6IOWG2qmZuWZRNxTeVXt0HA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NHBtnPMpNxS2zVW2Z4Uufiw8Pb5+zt1WBdQxyXLY6A4k82/dz5LgOAqKiUSxyShbV
         zrSnYwXnXrtFUdupBJL9xonf7i5igVvHFe+0OjmRbWTBcjhAU402flHaECYk8QcaT/
         uM1V3n1w3mGNqE/UYdMP66+oqOs9DLmvthn1feDzbkz/OUdtZpsNbsG3Ch1UcbGXsd
         3OeXt2wQEKsvkqbl2h1UK9uUlV845i7sLlX6fncm3S+rqYSXvENHIBQ9gztqxIipvC
         Vmw768zM1d/HEzjPkqDfOIFrpN8qiw6sh2iy3MNncquyQNmf/RVtF/DiCkNCKzG5BE
         kdhaHW3qzi/2Q==
Date:   Wed, 19 Jul 2023 11:04:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ilan Peer <ilan.peer@intel.com>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wifi: cfg80211: Fix return value in scan logic
Message-ID: <20230719110445.45c2b30b@kernel.org>
In-Reply-To: <20230719110018.565eff67@kernel.org>
References: <20230719145120.739521-1-ilan.peer@intel.com>
        <20230719110018.565eff67@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 19 Jul 2023 11:00:18 -0700 Jakub Kicinski wrote:
> > This bug was introduced in commit c8cb5b854b40f
> > ('nl80211/cfg80211: support 6 GHz scanning').  
> 
> And if it does indeed have user-visible impact please use the formal
> Fixes tag format.

Oh yeah, it's from a user report on the list. You should definitely add
a Fixes tag, and Link: (possibly multiple if there were multiple) to
the report.
