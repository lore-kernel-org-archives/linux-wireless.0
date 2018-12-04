Return-Path: <SRS0=aqaD=ON=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CDE0C04EB8
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 15:53:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3AF7C2082B
	for <linux-wireless@archiver.kernel.org>; Tue,  4 Dec 2018 15:53:51 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3AF7C2082B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=v3.sk
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726475AbeLDPxu (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 4 Dec 2018 10:53:50 -0500
Received: from shell.v3.sk ([90.176.6.54]:44210 "EHLO shell.v3.sk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726042AbeLDPxu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Dec 2018 10:53:50 -0500
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 9808DC82B0;
        Tue,  4 Dec 2018 16:53:47 +0100 (CET)
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id dxKkG3tu8ode; Tue,  4 Dec 2018 16:53:44 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by zimbra.v3.sk (Postfix) with ESMTP id 28A47C8350;
        Tue,  4 Dec 2018 16:53:44 +0100 (CET)
X-Virus-Scanned: amavisd-new at zimbra.v3.sk
Received: from shell.v3.sk ([127.0.0.1])
        by localhost (zimbra.v3.sk [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id JAITSqBMj87U; Tue,  4 Dec 2018 16:53:43 +0100 (CET)
Received: from belphegor (nat-pool-brq-t.redhat.com [213.175.37.10])
        by zimbra.v3.sk (Postfix) with ESMTPSA id 6B4B6C834E;
        Tue,  4 Dec 2018 16:53:43 +0100 (CET)
Message-ID: <7bc580805b3db47f70f42957f6c5ed53c9991b03.camel@v3.sk>
Subject: Re: [PATCH] mac80211: rewrite Kconfig text for mesh
From:   Lubomir Rintel <lkundrak@v3.sk>
To:     Bob Copeland <me@bobcopeland.com>,
        Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, Bob Copeland <bobcopeland@fb.com>
Date:   Tue, 04 Dec 2018 16:53:42 +0100
In-Reply-To: <20181204152200.2252-1-me@bobcopeland.com>
References: <20181204152200.2252-1-me@bobcopeland.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.2 (3.30.2-2.fc29) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-12-04 at 10:22 -0500, Bob Copeland wrote:
> Lubomir Rintel recently pointed out a dead link for o11s.org, and
> repointed it to a still live, but also stale website.  As far as I
> know, no one is updating the content at open80211s.org.
> 
> Since this Kconfig text was originally written, though, the 802.11s
> mesh drafts were approved and ultimately rolled into 802.11 proper.
> Meanwhile, the implementation has converged on the final standard,
> so we can lose all of the text here and provide something that's a
> little more helpful and accurate.
> 
> Signed-off-by: Bob Copeland <bobcopeland@fb.com>

Thanks. The old text indeed fooled me into thinking that only some pre-
release version of the spec is implemented. It looks better now.

Reviewed-by: Lubomir Rintel <lkundrak@v3.sk>

> ---
>  net/mac80211/Kconfig | 11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
> 
> diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
> index f869e35d0974..6b09355dfc90 100644
> --- a/net/mac80211/Kconfig
> +++ b/net/mac80211/Kconfig
> @@ -57,14 +57,13 @@ comment "Some wireless drivers require a rate control algorithm"
>  	depends on MAC80211 && MAC80211_HAS_RC=n
>  
>  config MAC80211_MESH
> -	bool "Enable mac80211 mesh networking (pre-802.11s) support"
> +	bool "Enable mac80211 mesh networking support"
>  	depends on MAC80211
>  	---help---
> -	 This options enables support of Draft 802.11s mesh networking.
> -	 The implementation is based on Draft 2.08 of the Mesh Networking
> -	 amendment.  However, no compliance with that draft is claimed or even
> -	 possible, as drafts leave a number of identifiers to be defined after
> -	 ratification.  For more information visit http://o11s.org/.
> +	  Select this option to enable 802.11 mesh operation in mac80211
> +	  drivers that support it.  802.11 mesh connects multiple stations
> +	  over (possibly multi-hop) wireless links to form a single logical
> +	  LAN.
>  
>  config MAC80211_LEDS
>  	bool "Enable LED triggers"

