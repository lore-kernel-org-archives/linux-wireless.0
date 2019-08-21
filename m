Return-Path: <SRS0=kz8S=WR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 000C3C3A5A0
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Aug 2019 07:59:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CAB3922D6D
	for <linux-wireless@archiver.kernel.org>; Wed, 21 Aug 2019 07:59:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbfHUH7h (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 21 Aug 2019 03:59:37 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:57108 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfHUH7h (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Aug 2019 03:59:37 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <johannes@sipsolutions.net>)
        id 1i0LWb-0005Ho-UV; Wed, 21 Aug 2019 09:59:22 +0200
Message-ID: <90445abd30536f2785e34c705e3a9ce6c817b17a.camel@sipsolutions.net>
Subject: Re: [PATCH] `iwlist scan` fails with many networks available
From:   Johannes Berg <johannes@sipsolutions.net>
To:     James Nylen <jnylen@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Wed, 21 Aug 2019 09:59:20 +0200
In-Reply-To: <CABVa4Nga1vyvyWNpTTJLa44rZo8wu4-bE=mXX1nZgvzktbSq6A@mail.gmail.com> (sfid-20190813_024304_695118_D911022B)
References: <CABVa4NgWMkJuyB1P5fwQEYHwqBRiySE+fGQpMKt8zbp+xJ8+rw@mail.gmail.com>
         <CABVa4NhutjvHPbyaxNeVpJjf-RMJdwEX-Yjk4bkqLC1DN3oXPA@mail.gmail.com>
         <f7de98001849bc98a0a084d2ffc369f4d9772d52.camel@sipsolutions.net>
         <CABVa4Nga1vyvyWNpTTJLa44rZo8wu4-bE=mXX1nZgvzktbSq6A@mail.gmail.com>
         (sfid-20190813_024304_695118_D911022B)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2019-08-13 at 00:43 +0000, James Nylen wrote:
> > I suppose we could consider applying a workaround like this if it has a
> > condition checking that the buffer passed in is the maximum possible
> > buffer (65535 bytes, due to iw_point::length being u16)
> 
> This is what the latest patch does (attached to my email from
> yesterday / https://lkml.org/lkml/2019/8/10/452 ).

Hmm, yes, you're right. I evidently missed the comparisons to 0xFFFF
there, sorry about that.

> If you'd like to apply it, I'm happy to make any needed revisions.
> Otherwise I'm going to have to keep patching my kernels for this
> issue, unfortunately I don't have the time to try to get wicd to
> migrate to a better solution.

Not sure which would be easier, but ok :-)

Can you please fix the patch to
 1) use /* */ style comments (see
    https://www.kernel.org/doc/html/latest/process/coding-style.html)

 2) remove extra braces (also per coding style)

 3) use U16_MAX instead of 0xFFFF

I'd also consider renaming "maybe_current_ev" to "next_ev" or something
shorter anyway, and would probably argue that rewriting this

> +		if (IS_ERR(maybe_current_ev)) {
> +			err = PTR_ERR(maybe_current_ev);
> +			if (err == -E2BIG) {
> +				// Last BSS failed to copy into buffer.  As
> +				// above, only report an error if `iwlist` will
> +				// retry again with a larger buffer.
> +				if (len >= 0xFFFF) {
> +					err = 0;
> +				}
> +			}
>  			break;
> +		} else {
> +			current_ev = maybe_current_ev;
>  		}


to something like

	next_ev = ...
	if (IS_ERR(next_ev)) {
		err = PTR_ERR(next_ev);
		/* mask error and truncate in case buffer cannot be
                 * increased
                 */
		if (err == -E2BIG && len < U16_MAX)
			err = 0;
		break;
	}

	current_ev = next_ev;


could be more readable, but that's just editorial really.

Thanks,
johannes

