Return-Path: <SRS0=LENq=3F=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E181FC33CB3
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 17:56:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BD3FD2073A
	for <linux-wireless@archiver.kernel.org>; Thu, 16 Jan 2020 17:56:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394014AbgAPR4m (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 16 Jan 2020 12:56:42 -0500
Received: from s3.sipsolutions.net ([144.76.43.62]:34816 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406059AbgAPR43 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Jan 2020 12:56:29 -0500
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1is9Nb-00Ck5J-8p; Thu, 16 Jan 2020 18:56:27 +0100
Message-ID: <b9a0380428ed580bdc7a9299585943dd77e83c4d.camel@sipsolutions.net>
Subject: Re: [PATCH v2 0/3] fix a STA PS bug and add PS support to
 mac80211_hwsim
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Thomas Pedersen <thomas@adapt-ip.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Date:   Thu, 16 Jan 2020 18:56:26 +0100
In-Reply-To: <bd9d68d2-114d-7e7a-000b-d2bf40658e74@adapt-ip.com>
References: <2b07e86b-9be7-4fc3-ae92-a4f831e585ef@email.android.com>
         <4c2d7cc81e83238512360903f38e12be16c16ed5.camel@sipsolutions.net>
         <bd9d68d2-114d-7e7a-000b-d2bf40658e74@adapt-ip.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.2 (3.34.2-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2020-01-16 at 09:54 -0800, Thomas Pedersen wrote:
> On 1/15/20 11:54 PM, Johannes Berg wrote:
> > On Wed, 2020-01-15 at 23:53 -0800, thomas@adapt-ip.com wrote:
> > > > FWIW, I applied your patches yesterday. There was one issue remaining 
> > > > uncovered by them, but it wasn't actually related to your patches, just 
> > > > related to the test sending too many frames. I sent a workaround to the 
> > > > hostap list and also the "mac80211: use more bits for ack_frame_id" to 
> > > > the kernel to fix that. 
> > > > 
> > > 
> > > But in the v3, no frames should actually be buffered unless power save
> > > is explicitly enabled on the STA side. Or is this some rrm specific
> > > behavior?
> > 
> > I didn't check whether or not powersave got enabled by default now, I
> > sort of assumed it did? But that isn't really bad, almost all real
> > devices will have it enabled by default too.
> 
> In v2 powersave was enabled by default, but that broke some test
> assumptions (and p2p stuff I don't really understand), so v3 disables it
> by default: https://lore.kernel.org/linux-wireless/20200114055940.18502-2-thomas@adapt-ip.com/T/#u

Right.

Not sure. I bisected the failure to the *next* patch actually, before
actually debugging it ...

johannes

