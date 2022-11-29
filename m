Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5648C4332F
	for <linux-wireless@archiver.kernel.org>; Tue, 29 Nov 2022 17:46:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236124AbiK2Rq6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 29 Nov 2022 12:46:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230217AbiK2Rq6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 29 Nov 2022 12:46:58 -0500
Received: from mx3.wp.pl (mx3.wp.pl [212.77.101.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3DA354B1B
        for <linux-wireless@vger.kernel.org>; Tue, 29 Nov 2022 09:46:56 -0800 (PST)
Received: (wp-smtpd smtp.wp.pl 16798 invoked from network); 29 Nov 2022 18:46:50 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1669744011; bh=ILLcT4WS3rS+gDqY1tRV38ue5NVY73E0E0M2/l/vwys=;
          h=From:To:Cc:Subject;
          b=bwQwnlVgrmVKm5sGagmx8Bl4WtyyxM3V1QabRhZrQYi3unyK3sYDvCBP2OcU7HdQH
           e4a9PxtW7GoxlllXNaaZnMzEnZlal1AK99+1jmjaRpKpFH/0evaKfhwiPGox3Kql3m
           GJzhtboBNtGtqPVwHjT80ybHx955fFvx5yF5GdBE=
Received: from 89-64-15-29.dynamic.chello.pl (HELO localhost) (stf_xl@wp.pl@[89.64.15.29])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <jnyb.de@gmail.com>; 29 Nov 2022 18:46:50 +0100
Date:   Tue, 29 Nov 2022 18:46:50 +0100
From:   Stanislaw Gruszka <stf_xl@wp.pl>
To:     Ioannis Barkas <jnyb.de@gmail.com>
Cc:     linux-wireless@vger.kernel.org
Subject: Re: PRO/Wireless 4965 Intel WPA2,3 SSID connection problem #1
Message-ID: <20221129174650.GA620872@wp.pl>
References: <CADUzMVb6QKX-dhVpFXvUJ2MXMf93vK1RC+R8JqAPxExBSisA0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADUzMVb6QKX-dhVpFXvUJ2MXMf93vK1RC+R8JqAPxExBSisA0A@mail.gmail.com>
X-WP-MailID: 47f8432ffa0790db3ade368606849fdc
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [IQPU]                               
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Ioannis

On Tue, Nov 29, 2022 at 12:34:38AM +0200, Ioannis Barkas wrote:
> I have figured everything out with MX Linux and created a new kernel
> based on 6.0 that it works well on my test PC as well. Then I applied
> your patch along with some debugging options. Unfortunately the
> problem remains and it continues to be unable to connect at the
> desired WPA2,3 based network.

Regarding patch, it was for UBSAN error, but looking at your other emails,
the problem you have is more general. I think you should try swcrypto=1
module option.

Regards
Stanislaw

