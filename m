Return-Path: <SRS0=opxm=CS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4BC6C43461
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Sep 2020 11:02:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6401A21D7A
	for <linux-wireless@archiver.kernel.org>; Wed,  9 Sep 2020 11:02:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729161AbgIILCY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 9 Sep 2020 07:02:24 -0400
Received: from smtprelay0003.hostedemail.com ([216.40.44.3]:35116 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729692AbgIILBb (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 Sep 2020 07:01:31 -0400
Received: from filter.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay01.hostedemail.com (Postfix) with ESMTP id 479AC100E7B45;
        Wed,  9 Sep 2020 11:00:19 +0000 (UTC)
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-HE-Tag: horn54_50064b2270dc
X-Filterd-Recvd-Size: 1987
Received: from XPS-9350.home (unknown [47.151.133.149])
        (Authenticated sender: joe@perches.com)
        by omf04.hostedemail.com (Postfix) with ESMTPA;
        Wed,  9 Sep 2020 11:00:17 +0000 (UTC)
Message-ID: <e2dfa0e0c279cd39a0b7ab725a634831e1f188cc.camel@perches.com>
Subject: Re: [PATCH][next] mt7601u: Use fallthrough pseudo-keyword
From:   Joe Perches <joe@perches.com>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jakub Kicinski <kubakici@wp.pl>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Date:   Wed, 09 Sep 2020 04:00:16 -0700
In-Reply-To: <20200901173603.GA2701@embeddedor>
References: <20200901173603.GA2701@embeddedor>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2020-09-01 at 12:36 -0500, Gustavo A. R. Silva wrote:
> Replace the existing /* fall through */ comments and its variants with
> the new pseudo-keyword macro fallthrough[1]. Also, remove unnecessary
> fall-through markings when it is the case.
[]
> diff --git a/drivers/net/wireless/mediatek/mt7601u/dma.c b/drivers/net/wireless/mediatek/mt7601u/dma.c
[]
> @@ -196,7 +196,7 @@ static void mt7601u_complete_rx(struct urb *urb)
>  	default:
>  		dev_err_ratelimited(dev->dev, "rx urb failed: %d\n",
>  				    urb->status);
> -		/* fall through */
> +		fallthrough;
		
		fallthrough to break is odd.
		break would probably be better.

>  	case 0:
>  		break;
>  	}
> @@ -241,7 +241,7 @@ static void mt7601u_complete_tx(struct urb *urb)
>  	default:
>  		dev_err_ratelimited(dev->dev, "tx urb failed: %d\n",
>  				    urb->status);
> -		/* fall through */
> +		fallthrough;

here too...

>  	case 0:
>  		break;
>  	}
> 

