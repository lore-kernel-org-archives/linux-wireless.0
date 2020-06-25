Return-Path: <SRS0=3AJD=AG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E2F6EC433DF
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Jun 2020 08:49:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1DBE2072E
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Jun 2020 08:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390431AbgFYIte (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Jun 2020 04:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390216AbgFYItd (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Jun 2020 04:49:33 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79990C061573
        for <linux-wireless@vger.kernel.org>; Thu, 25 Jun 2020 01:49:33 -0700 (PDT)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.93)
        (envelope-from <johannes@sipsolutions.net>)
        id 1joNZb-00Bmcf-Id; Thu, 25 Jun 2020 10:49:31 +0200
Message-ID: <caca45b225b3b5cc17c494d9c5d67a18c593c3ce.camel@sipsolutions.net>
Subject: Re: [PATCH v4] mac80211: fix control port tx status check
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Markus Theil <markus.theil@tu-ilmenau.de>
Cc:     linux-wireless@vger.kernel.org, j@w1.fi,
        kernel test robot <lkp@intel.com>
Date:   Thu, 25 Jun 2020 10:49:26 +0200
In-Reply-To: <20200625084831.5094-1-markus.theil@tu-ilmenau.de>
References: <20200625084831.5094-1-markus.theil@tu-ilmenau.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.3 (3.36.3-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Thu, 2020-06-25 at 10:48 +0200, Markus Theil wrote:
> The initial control port tx status patch assumed, that
> we have IEEE 802.11 frames, but actually ethernet frames
> are stored in the ack skb. Fix this by checking for the
> correct ethertype and skb protocol 802.3.
> 
> Also allow tx status reports for ETH_P_PREAUTH, as preauth
> frames can also be send over the nl80211 control port.
> 
> Fixes: a7528198add8 ("mac80211: support control port TX status reporting")
> Reported-by: kernel test robot <lkp@intel.com>
> Reported-by: Jouni Malinen <j@w1.fi>
> Signed-off-by: Markus Theil <markus.theil@tu-ilmenau.de>
> ---
> v4: add cast, reported by Intel kernel test robot
> v3: also check for ETH_P_PREAUTH
> v2: use __be16, as suggested by Johannes Berg
>  net/mac80211/status.c | 22 +++++++++++++++-------
>  1 file changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
> index 7b1bacac39c6..d6edd3acda0a 100644
> --- a/net/mac80211/status.c
> +++ b/net/mac80211/status.c
> @@ -639,11 +639,23 @@ static void ieee80211_report_ack_skb(struct ieee80211_local *local,
>  		u64 cookie = IEEE80211_SKB_CB(skb)->ack.cookie;
>  		struct ieee80211_sub_if_data *sdata;
>  		struct ieee80211_hdr *hdr = (void *)skb->data;
> +		__be16 ethertype = (__be16)0xffff;

If anything, that should've been "cpu_to_be16(0xffff)" but I was just
applying this and changing it to 0 instead (which sparse knows about).

johannes

