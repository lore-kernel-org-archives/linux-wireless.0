Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CBCAFC43332
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Jan 2021 01:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A754723442
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Jan 2021 01:59:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728891AbhANB6q (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 13 Jan 2021 20:58:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:54086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729543AbhAMXkF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 13 Jan 2021 18:40:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BF55823383;
        Wed, 13 Jan 2021 23:29:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610580593;
        bh=EQJe8YysK2tcSoGTGUzG3jrrjUDLm0Dv5OUBJ2bLzDs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GVoQEn2xdJUKGdv+fcd+if0u+jXtTD8ueIY8vDd6pGq0Z7JJbKwh6DUXXTHqoZgeQ
         gc4DLbnRfIAGRcdQEhMaZ1ie+vc6TxPDQ7Fglntc2CVq8n4CqLPbdYqfoijrL4Zgs3
         S140DtZv6G82abaRy6XovZBV1psy8bF2RYOyJaqFAtLnDHuTwuqTON0eHdTLDk+CwD
         WZeS28cGXGSjhYxlSGlZoV9oLQvh3xxw2EUjB3Nc9V31sGFOAb8x7clZ71Yn0WmUZT
         SjaNK0wcUj4vby2dPvGsHMOtxTKslcj4qa323AFlwQJ7KiMQlJkxcNterMRJZhzLUi
         bgpStCpfQgXjg==
Date:   Wed, 13 Jan 2021 15:29:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     linux-wireless@vger.kernel.org, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH] mt7601u: use ieee80211_rx_list to pass frames to the
 network stack as a batch
Message-ID: <20210113152953.05dd40b4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <5c72fa2dda45c1ae3f285af80c02f3db23341d85.1610580222.git.lorenzo@kernel.org>
References: <5c72fa2dda45c1ae3f285af80c02f3db23341d85.1610580222.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 14 Jan 2021 00:26:26 +0100 Lorenzo Bianconi wrote:
> Similar to mt76 driver, rely on ieee80211_rx_list in order to
> improve icache footprint
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Jakub Kicinski <kuba@kernel.org>
