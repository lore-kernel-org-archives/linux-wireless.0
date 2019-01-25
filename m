Return-Path: <SRS0=MEvv=QB=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0C06C41518
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 12:41:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CA3482146E
	for <linux-wireless@archiver.kernel.org>; Fri, 25 Jan 2019 12:41:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727728AbfAYMlp (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 25 Jan 2019 07:41:45 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:56686 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726122AbfAYMlo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Jan 2019 07:41:44 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92-RC4)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gn0nm-0000ew-Iy; Fri, 25 Jan 2019 13:41:42 +0100
Message-ID: <ffc4c9e611784b1367e187d092b846381a4cfdc0.camel@sipsolutions.net>
Subject: Re: [PATCH 17/24] cfg80211: Include the PMK and PMKID in
 NL80211_CMD_EXTERNAL_AUTH
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org,
        Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date:   Fri, 25 Jan 2019 13:41:41 +0100
In-Reply-To: <20181215090325.31604-18-luca@coelho.fi>
References: <20181215090325.31604-1-luca@coelho.fi>
         <20181215090325.31604-18-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 2018-12-15 at 11:03 +0200, Luca Coelho wrote:
> From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
> 
> This is needed for the devices that manage PMKSA caching internally and
> don't implement SET/DEL PMKSA commands.

It'd be nice to have more explanation here. Is this for station side? or
AP side? I would've guessed AP side based on the fact that I also have 
https://patchwork.kernel.org/patch/10777175/ which also adds the PMKID,
but since you talk about PMKSA caching and that's only added for AP side
in https://patchwork.kernel.org/patch/10769745/ I'm confused.

--> changes requested

I've asked Jouni to take a look at the two above-mentioned patches and
will likely accept them (it seems mostly reasonable to me) so in that
case please also rebase this patch to deal with the overlapping changes.

johannes

