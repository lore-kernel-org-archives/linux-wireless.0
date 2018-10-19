Return-Path: <SRS0=smuk=M7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41661ECDE43
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 06:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E319F21470
	for <linux-wireless@archiver.kernel.org>; Fri, 19 Oct 2018 06:48:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E319F21470
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726790AbeJSOxN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 19 Oct 2018 10:53:13 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:47278 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726584AbeJSOxN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 19 Oct 2018 10:53:13 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gDOaD-0003sI-Jj; Fri, 19 Oct 2018 08:48:29 +0200
Message-ID: <5f46e668ef6f4a273b8b5d65dce1efc6c1aa2ffa.camel@sipsolutions.net>
Subject: Re: [PATCH] nl80211: Emit a NEW_INTERFACE on iftype change
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Andrew Zaborowski <andrew.zaborowski@intel.com>,
        linux-wireless@vger.kernel.org
Date:   Fri, 19 Oct 2018 08:48:14 +0200
In-Reply-To: <20181019023722.6226-1-andrew.zaborowski@intel.com> (sfid-20181019_043741_800644_1B4E9562)
References: <20181019023722.6226-1-andrew.zaborowski@intel.com>
         (sfid-20181019_043741_800644_1B4E9562)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, 2018-10-19 at 04:37 +0200, Andrew Zaborowski wrote:
> Let userspace learn about iftype changes by sending an
> NL80211_CMD_NEW_INTERFACE when handling a NL80211_CMD_SET_INTERFACE
> command.  There seems to be no other place where the iftype can change:
> nl80211_set_interface is the only caller of cfg80211_change_iface which
> is the only caller of ops->change_virtual_intf.

Why not use SET_INTERFACE? I think I'd be more comfortable with that,
since it's not really used now and existing userspace might do weird
things with NEW_INTERFACE?

johannes

