Return-Path: <SRS0=eag0=5R=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D82F6C43331
	for <linux-wireless@archiver.kernel.org>; Wed,  1 Apr 2020 07:10:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5E772071A
	for <linux-wireless@archiver.kernel.org>; Wed,  1 Apr 2020 07:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731977AbgDAHKJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 1 Apr 2020 03:10:09 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:33582 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731823AbgDAHKJ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 1 Apr 2020 03:10:09 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1jJXVo-00BTc1-Co; Wed, 01 Apr 2020 09:10:08 +0200
Message-ID: <a2fe2cad3c93ae8516568b6a8f5395dae6d9ba30.camel@sipsolutions.net>
Subject: Re: [RFC 6/7] nl80211: add KHz frequency offset for most wifi
 commands
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Thomas Pedersen <thomas@adapt-ip.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Date:   Wed, 01 Apr 2020 09:10:06 +0200
In-Reply-To: <20200401062150.3324-7-thomas@adapt-ip.com>
References: <20200401062150.3324-1-thomas@adapt-ip.com>
         <20200401062150.3324-7-thomas@adapt-ip.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 (3.34.4-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2020-03-31 at 23:21 -0700, Thomas Pedersen wrote:
> 
> TODO: several of these commands will eventually just
> ignore the _OFFSET component, like _JOIN_MESH,
> _CMD_RADAR_DETECT, etc. Should return an error to give
> user a hint things won't work as expected?

Wouldn't most of them already require that a channel with the given
frequency exists, and thus fail anyway?

johannes

