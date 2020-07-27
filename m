Return-Path: <SRS0=zMWk=BG=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDD44C433EB
	for <linux-wireless@archiver.kernel.org>; Mon, 27 Jul 2020 19:44:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A31C720738
	for <linux-wireless@archiver.kernel.org>; Mon, 27 Jul 2020 19:44:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgG0Toa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 27 Jul 2020 15:44:30 -0400
Received: from smtprelay0118.hostedemail.com ([216.40.44.118]:60546 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726196AbgG0Toa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Jul 2020 15:44:30 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay07.hostedemail.com (Postfix) with ESMTP id 56185181D3025;
        Mon, 27 Jul 2020 19:44:29 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: table68_3617a8e26f63
X-Filterd-Recvd-Size: 1563
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf07.hostedemail.com (Postfix) with ESMTPA;
        Mon, 27 Jul 2020 19:44:27 +0000 (UTC)
Message-ID: <70ed74d65b5909615c7a9430f3479695465d3b1d.camel@perches.com>
Subject: Re: [PATCH][next] ath11k: Use fallthrough pseudo-keyword
From:   Joe Perches <joe@perches.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Mon, 27 Jul 2020 12:44:26 -0700
In-Reply-To: <20200727194415.GA1275@embeddedor>
References: <20200727194415.GA1275@embeddedor>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.3-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2020-07-27 at 14:44 -0500, Gustavo A. R. Silva wrote:
> Replace the existing /* fall through */ comments and its variants with
> the new pseudo-keyword macro fallthrough[1]. Also, remove unnecessary
> fall-through markings when it is the case.
[]
> diff --git a/drivers/net/wireless/ath/ath11k/dp.c b/drivers/net/wireless/ath/ath11k/dp.c
[]
> @@ -159,7 +159,7 @@ int ath11k_dp_srng_setup(struct ath11k_base *ab, struct dp_srng *ring,
>  			break;
>  		}
>  		/* follow through when ring_num >= 3 */
> -		/* fall through */
> +		fallthrough;

Likely the /* follow through ... */ comment can be deleted too


