Return-Path: <SRS0=BviI=RB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A16FEC10F0B
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 21:23:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 59286218AC
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Feb 2019 21:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1551216238;
	bh=IoYBkaMnhxom4ron8Z8G3EYbGIdfYJ7SqN/5D7MO0cE=;
	h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
	 List-ID:From;
	b=fxaBIJ5I7lsx++KEjb15Q39pQ+Dzk/UzwhAYsf9r2jZT6lfGcbKIZPn50+a/CYbFO
	 TvTzabzXGpDNL9VoZsFYd7RP2Hx80KjZUebz9c3n7h9PBTDQ9sZ1eLDrEM9j9wIoY/
	 q4y+swHFPMmmrdgvxDtCsi+oI4DMEQoQAExV1XVE=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728842AbfBZVX5 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Feb 2019 16:23:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:60278 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727823AbfBZVXz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Feb 2019 16:23:55 -0500
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F97C2186A;
        Tue, 26 Feb 2019 21:23:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1551216234;
        bh=IoYBkaMnhxom4ron8Z8G3EYbGIdfYJ7SqN/5D7MO0cE=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=zwyNmKsJd3wzEd/MqhqBvGX/Rd/aKfWvg0O+6CiATA7dsyow1a1aKZHxUBtPfZHQQ
         9/HGCVD7wG/c07nKvX1/lTApL5n6XnPySEnYBZebyjX4u+Kp6qCGDgfwBJiJOumlco
         9mfczyh3mEmXpj5F9Toai/Bz5iUXyLIrdyAlpB5Y=
Date:   Tue, 26 Feb 2019 21:23:53 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] mac80211: allocate tailroom for forwarded mesh packets
In-Reply-To: <20190222122115.68485-1-nbd@nbd.name>
References: <20190222122115.68485-1-nbd@nbd.name>
Message-Id: <20190226212354.6F97C2186A@mail.kernel.org>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v4.20.12, v4.19.25, v4.14.103, v4.9.160, v4.4.176, v3.18.136.

v4.20.12: Build OK!
v4.19.25: Build OK!
v4.14.103: Failed to apply! Possible dependencies:
    0c3d5a96d5e5 ("net: drivers/net: Remove unnecessary skb_copy_expand OOM messages")

v4.9.160: Failed to apply! Possible dependencies:
    0c3d5a96d5e5 ("net: drivers/net: Remove unnecessary skb_copy_expand OOM messages")
    c38c39bf7cc0 ("mac80211: Fix headroom allocation when forwarding mesh pkt")
    d8da0b5d64d5 ("mac80211: Ensure enough headroom when forwarding mesh pkt")

v4.4.176: Failed to apply! Possible dependencies:
    0c3d5a96d5e5 ("net: drivers/net: Remove unnecessary skb_copy_expand OOM messages")
    c38c39bf7cc0 ("mac80211: Fix headroom allocation when forwarding mesh pkt")
    d8da0b5d64d5 ("mac80211: Ensure enough headroom when forwarding mesh pkt")

v3.18.136: Failed to apply! Possible dependencies:
    0c3d5a96d5e5 ("net: drivers/net: Remove unnecessary skb_copy_expand OOM messages")
    c38c39bf7cc0 ("mac80211: Fix headroom allocation when forwarding mesh pkt")
    d8da0b5d64d5 ("mac80211: Ensure enough headroom when forwarding mesh pkt")


How should we proceed with this patch?

--
Thanks,
Sasha
