Return-Path: <SRS0=IsUp=WP=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6120EC3A59D
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Aug 2019 10:12:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 41ACB2087B
	for <linux-wireless@archiver.kernel.org>; Mon, 19 Aug 2019 10:12:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727200AbfHSKMr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 19 Aug 2019 06:12:47 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:38874 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726703AbfHSKMq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Aug 2019 06:12:46 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hzeea-0007a4-Nk; Mon, 19 Aug 2019 12:12:44 +0200
Message-ID: <9985fddfb059640f36665efc9c1ef2dc0bdb7662.camel@sipsolutions.net>
Subject: Re: Implementing Mikrotik IE
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Josef Miegl <josef@miegl.cz>,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Date:   Mon, 19 Aug 2019 12:12:43 +0200
In-Reply-To: <20190816113818.ohktykc4fyetzyvq@pepin-laptop.localdomain> (sfid-20190816_133830_699223_6B854E12)
References: <20190815152844.k5mmddvbwrohkzr6@pepin-laptop.localdomain>
         <3a079683-6f57-3b42-f909-90c46e14f14f@newmedia-net.de>
         <20190816111044.4ntizgmpa3twbzcg@pepin-laptop.localdomain>
         <e8129acb-fc32-c85c-b504-ab8777a3f1a3@newmedia-net.de>
         <20190816113818.ohktykc4fyetzyvq@pepin-laptop.localdomain>
         (sfid-20190816_133830_699223_6B854E12)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2019-08-16 at 13:38 +0200, Josef Miegl wrote:
> On Fri, Aug 16, 2019 at 01:15:30PM +0200, Sebastian Gottschall wrote:
> > in station mode you are right. you need to modify mac80211.
> Even if I don't need to capture the IE back? All I want is to include
> extra vendor IE in client assoc/reassoc frames. If this is something the
> current wireless stack cannot do, perhaps it should be implemented.

Contrary to what Sebastian states, it certainly is possible today,
although not through wpa_supplicant's config file, only through the
wpa_cli interface, using the VENDOR_ELEM_ADD command. There are various
tests showing how to use this.

johannes


