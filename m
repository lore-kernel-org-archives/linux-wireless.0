Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80693C7EE2D
	for <linux-wireless@archiver.kernel.org>; Thu, 25 May 2023 16:17:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238599AbjEYQRQ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 May 2023 12:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235784AbjEYQRO (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 May 2023 12:17:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 299B5139;
        Thu, 25 May 2023 09:16:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7BEE60B01;
        Thu, 25 May 2023 16:16:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0024C433D2;
        Thu, 25 May 2023 16:16:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1685031418;
        bh=TJiBJ2DgCNX45ZQwl5QA2StCRdzzXCcqJIJYACkob9g=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=FXTZLoihJeobgoDjkkqDM0xJJSFZLzGPrc0F529nvBAHdtndXNdS0SmbHTQNQTKBA
         6z+tZ2RGxfUcrsw1GU5GFGtSkUNbVvEeK0me9ayjgMLq1Gzlpr2haN5Gn+Prv/5Pi8
         zPuGzK0nyn0QiRTQ6kOuegN4sqzohw6X2AoDOv5vS3lpQQoo/x8w+NOEgtpdPZ53f/
         L18wye0xolFS2OS4/RTBiTlHBqwEvFEtm64rxs3afu3QrhLJ73Ohan6puu3B2h+9yt
         ANzQIjKf4jCBZBedRDIDgZ7glrT9ff2Dbhhuaewxc9JYqbUQzTqpGpOTL1Uef/Uu74
         SNBz5Vg2/ZQCg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [wireless] wifi: wl3501_cs: Fix an error handling path in
 wl3501_probe()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <7cc9c9316489b7d69b36aeb0edd3123538500b41.1684569865.git.christophe.jaillet@wanadoo.fr>
References: <7cc9c9316489b7d69b36aeb0edd3123538500b41.1684569865.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     Dominik Brodowski <linux@dominikbrodowski.net>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        linux-wireless@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168503141504.22756.5325042313582442239.kvalo@kernel.org>
Date:   Thu, 25 May 2023 16:16:56 +0000 (UTC)
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> Should wl3501_config() fail, some resources need to be released as already
> done in the remove function.
> 
> Fixes: 15b99ac17295 ("[PATCH] pcmcia: add return value to _config() functions")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Patch applied to wireless-next.git, thanks.

391af06a02e7 wifi: wl3501_cs: Fix an error handling path in wl3501_probe()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/7cc9c9316489b7d69b36aeb0edd3123538500b41.1684569865.git.christophe.jaillet@wanadoo.fr/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

