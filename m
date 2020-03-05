Return-Path: <SRS0=q56x=4W=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71759C3F2CD
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Mar 2020 14:04:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4F15020848
	for <linux-wireless@archiver.kernel.org>; Thu,  5 Mar 2020 14:04:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726191AbgCEOEG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 5 Mar 2020 09:04:06 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:34708 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbgCEOEG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Mar 2020 09:04:06 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1j9r6V-001D9F-Rk; Thu, 05 Mar 2020 15:03:59 +0100
Message-ID: <c5319f6630be431c8680051fd4c33d59524683a2.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211_hwsim: add frame transmission support over
 virtio
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Marcel Holtmann <marcel@holtmann.org>
Cc:     linux-wireless@vger.kernel.org
Date:   Thu, 05 Mar 2020 15:03:57 +0100
In-Reply-To: <2F7ADB4C-8C2C-4DEC-80AF-9E2D6B55CA88@holtmann.org>
References: <20200305143212.c6e4c87d225b.I7ce60bf143e863dcdf0fb8040aab7168ba549b99@changeid>
         <2F7ADB4C-8C2C-4DEC-80AF-9E2D6B55CA88@holtmann.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Marcel,
> 
> > This allows communication with external entities.
> > 
> > It also required fixing up the netlink policy, since NLA_UNSPEC
> > attributes are no longer accepted.
> > 
> > Signed-off-by: Erel Geron <erelx.geron@intel.com>
> > [port to backports, inline the ID, use 29 as the ID as requested,
> > drop != NULL checks, reduce ifdefs]
> > Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
> since the module now can auto-load, don’t you want to change radios = 2 to radio = 0?

Hmm. I didn't really want to change the behaviour there, and the auto-
loading is *highly* unlikely, you need to specifically set up a vhost-
user wmediumd (which I'm in the process of publishing).

And even then, you still need to have the radios, they just don't
communicate directly with each other but will go into wmediumd over the
virtio when you actually have virtio.

I'm not principally opposed to changing the default, but I'm not
convinced it'd be related to this patch in any way.

johannes

