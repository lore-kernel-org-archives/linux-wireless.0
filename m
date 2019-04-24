Return-Path: <SRS0=48GF=S2=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B507C10F11
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 21:01:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 527C820835
	for <linux-wireless@archiver.kernel.org>; Wed, 24 Apr 2019 21:01:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387985AbfDXVBa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Apr 2019 17:01:30 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:42252 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728550AbfDXVBa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Apr 2019 17:01:30 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1hJP1E-0007Ny-6j; Wed, 24 Apr 2019 23:01:28 +0200
Message-ID: <2b232d3cd7af0e6ab6e787d94ffad392813d4da0.camel@sipsolutions.net>
Subject: Re: [PATCH] mac80211: Set CAN_REPLACE_PTK0 for SW crypto only
 drivers
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Alexander Wetzel <alexander@wetzel-home.de>
Cc:     linux-wireless@vger.kernel.org
Date:   Wed, 24 Apr 2019 23:01:26 +0200
In-Reply-To: <0e1d8f51-ca1b-a55e-73a1-d4b95fe3f0b5@wetzel-home.de>
References: <20190424173246.26421-1-alexander@wetzel-home.de>
         <45ef6418002ddb01bc99a06a5c52e0dcd30afd4b.camel@sipsolutions.net>
         <0e1d8f51-ca1b-a55e-73a1-d4b95fe3f0b5@wetzel-home.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-04-24 at 22:58 +0200, Alexander Wetzel wrote:
> 
> > Now I wonder - shouldn't the same A-MPDU issue apply here? After all, if
> > you replace the PTK 0 surely you shouldn't use different ones for the
> > same frame in an A-MPDU?
> 
> Not from what I found in IEEE 802.11. It's only forbidden to mix keyIDs, 
> not MPDUs using different keys. And without Extended Key ID the keyID 
> can only be zero. So from a standard point of view we are ok, no keyID 
> mixing possible.

Yeah, well, the standard probably didn't consider this. From an
implementation POV, having two subframes with different keys will not
really be possible, *especially* if they have the same key ID.

I think this basically was not considered in spec writing.

> From a practical point of view cards like mvm cards will for sure 
> corrupt MPDUs aggregated in a A-MPDU when different key were used for 
> them. But we still don't care:-)
> 
> We'll corrupt the MPDU's encoded with either the old or the new key 
> anyhow and we don't care which ones. After all the card will only have 
> one key active for key ID 0 at any time won't have the second key 
> installed at all.

Yeah, ok, fair point.

johannes

