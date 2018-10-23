Return-Path: <SRS0=ht5v=ND=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EDD6C67863
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 20:33:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D0ED120813
	for <linux-wireless@archiver.kernel.org>; Tue, 23 Oct 2018 20:33:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D0ED120813
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=sipsolutions.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727690AbeJXE6m (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 24 Oct 2018 00:58:42 -0400
Received: from s3.sipsolutions.net ([144.76.43.62]:45118 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727667AbeJXE6l (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 24 Oct 2018 00:58:41 -0400
Received: by sipsolutions.net with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.91)
        (envelope-from <johannes@sipsolutions.net>)
        id 1gF3Mu-0005AP-FR; Tue, 23 Oct 2018 22:33:36 +0200
Message-ID: <94958073867a5bbf8161d7ea8851aaea026762b1.camel@sipsolutions.net>
Subject: Re: [PATCH v2] wireless: mark expected switch fall-throughs
From:   Johannes Berg <johannes@sipsolutions.net>
To:     "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Date:   Tue, 23 Oct 2018 22:33:17 +0200
In-Reply-To: <c2fad584-1705-a5f2-d63c-824e9b96cf50@embeddedor.com>
References: <20181023001308.GA4150@embeddedor.com>
         <0b3197a734f71bdfffaf717e63b17e2fe31720a2.camel@sipsolutions.net>
         <f0a240e2-cae7-07f4-757f-a8606199d29e@embeddedor.com>
         <c2fad584-1705-a5f2-d63c-824e9b96cf50@embeddedor.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-1.fc28) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, 2018-10-23 at 12:58 +0200, Gustavo A. R. Silva wrote:
> On 10/23/18 10:59 AM, Gustavo A. R. Silva wrote:
> > 
> > On 10/23/18 9:01 AM, Johannes Berg wrote:
> > > On Tue, 2018-10-23 at 02:13 +0200, Gustavo A. R. Silva wrote:
> > > > In preparation to enabling -Wimplicit-fallthrough, mark switch cases
> > > > where we are expecting to fall through.
> > > > 
> > > > Warning level 3 was used: -Wimplicit-fallthrough=3
> > > > 
> > > > This code was not tested and GCC 7.2.0 was used to compile it.
> > > 
> > > Look, I'm not going to make this any clearer: I'm not applying patches
> > > like that where you've invested no effort whatsoever on verifying that
> > > they're correct.
> > > 
> > 
> > How do you suggest me to verify that every part is correct in this type
> > of patches?
> > 
> 
> BTW... I'm under the impression you think that I don't even look at
> the code. Is that correct?

That's what your commit log looks like, yes. This is your full commit
log:

   In preparation to enabling -Wimplicit-fallthrough, mark switch cases
   where we are expecting to fall through.

   Warning level 3 was used: -Wimplicit-fallthrough=3

   This code was not tested and GCC 7.2.0 was used to compile it.

   For all I know, you could've run spatch to add the comments wherever
   there was no break, and then compiled it once.

   > I've been working on this for quite a while, and in every case I try to
> understand the code in terms of the context in which every warning is
> reported.

That's great.

> Here is a bug I found yesterday at drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
> 
> 5690         case WLAN_CIPHER_SUITE_CCMP:
> 5691                 key->flags |= IEEE80211_KEY_FLAG_SW_MGMT_TX;
> 5692                 break;
> 5693         case WLAN_CIPHER_SUITE_TKIP:
> 5694                 key->flags |= IEEE80211_KEY_FLAG_GENERATE_MMIC;
> 5695         default:
> 5696                 return -EOPNOTSUPP;
> 5697         }

Indeed, that looks like a bug, although kinda benign since it just means
TKIP will always use software crypto and TKIP is slow anyway ;-)

> I do this analysis for every warning.  Now, when I say I haven't tested the code
> is because I don't have any log as evidence for anything. Not that I haven't put
> any effort on trying to understand it and its context.  When I started working on
> this task there were more than 2000 of these issues, now there are around 600 left.
> 
> I have fixed many bugs on the way, so a good amount of work is being invested on
> this, and it's paying off. :)

:-)

> Now, let me ask you this question:
> 
> It would be easier for you to review this patch if I turn it into a series?
> 
> I can do that without a problem.

I'd be happy if you were to actually just mention that you've looked at
them, and found them to be expected fall throughs. I'll still review
them, but without that information I feel like I'm doing the first round
of reviews this code ever got.

johannes

