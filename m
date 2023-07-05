Return-Path: <linux-wireless-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 20907EB64DA
	for <linux-wireless@archiver.kernel.org>; Wed,  5 Jul 2023 21:04:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbjGEVEi (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 5 Jul 2023 17:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbjGEVEh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Jul 2023 17:04:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 483C919A0
        for <linux-wireless@vger.kernel.org>; Wed,  5 Jul 2023 14:04:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DB1F961726
        for <linux-wireless@vger.kernel.org>; Wed,  5 Jul 2023 21:04:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AD58C433C8;
        Wed,  5 Jul 2023 21:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688591075;
        bh=XfSejfuQje00cEYfSIGodZnbKv+9bbpUIAWUVWcqECU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HGoLrRK/yFvsqcVDXQ/g3cL61AymAcmjXs7RjqoAKHWKp03QDIpsmp6v7aLTww7IO
         ueLZ1VlkMQkixHSa189/ZrfKUCSCvwny9VIjzT4jfzMeFPZDmGbPw+0iny1x44It9n
         nyuvXM+Fj/eTGgkYuUuELu/WkYLMwstV8jRxdPi7njWLMUopgg4YZJJFH5wuMaQl3q
         MUzmh96QsA/T0Cz9VknU9/RVQ7HvICUgdm6ptFR09KXVB1PyIBaEIN8T3mTrJivrOC
         ywb6nrLHweEutoxd132k4Bvd/wgVZL+ETsXN9gQsqVtJdgMFjF83b54+RPhNqQqLwg
         bG2RgW8qYySDA==
Date:   Wed, 5 Jul 2023 14:04:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     <Ajay.Kathat@microchip.com>
Cc:     <linux-wireless@vger.kernel.org>, <Claudiu.Beznea@microchip.com>,
        <Sripad.Balwadgi@microchip.com>
Subject: Re: [PATCH] wifi: wilc1000: change firmware path from 'atmel' to
 'microchip/wilc'
Message-ID: <20230705140434.3a7b1705@kernel.org>
In-Reply-To: <20230705140338.77896d11@kernel.org>
References: <20230630012136.1330784-1-ajay.kathat@microchip.com>
        <20230705140338.77896d11@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 5 Jul 2023 14:03:38 -0700 Jakub Kicinski wrote:
> On Fri, 30 Jun 2023 01:22:31 +0000 Ajay.Kathat@microchip.com wrote:
> > To inline the linux-firmware path with driver, the firmware path is changed
> > from 'atmel' to 'microchip/wilc'. This path change will be submitted to
> > 'linux-firmware' as well.  
> 
> How are you going to make this backward compatible?
> Users aren't required to update linux-firmware and kernel at the same
> time.

I guess I should have looked at the next patch on the list ;)
Please mention how the backward compatibly is assured in the commit
message.
