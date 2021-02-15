Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 609F4C433DB
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Feb 2021 16:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 27F756024A
	for <linux-wireless@archiver.kernel.org>; Mon, 15 Feb 2021 16:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232168AbhBOQQv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 15 Feb 2021 11:16:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbhBOQL2 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Feb 2021 11:11:28 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51A1AC061756;
        Mon, 15 Feb 2021 08:10:47 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1lBgSF-003Kql-5a; Mon, 15 Feb 2021 17:10:31 +0100
Message-ID: <eb819e72fb2d897e603654d44aeda8c6f337453f.camel@sipsolutions.net>
Subject: Re: [PATCH 1/2] lockdep: add lockdep_assert_not_held()
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Shuah Khan <skhan@linuxfoundation.org>, mingo@redhat.com,
        will@kernel.org, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 15 Feb 2021 17:10:14 +0100
In-Reply-To: <YCqbehyyeUoL0pPT@hirez.programming.kicks-ass.net>
References: <cover.1613171185.git.skhan@linuxfoundation.org>
         <37a29c383bff2fb1605241ee6c7c9be3784fb3c6.1613171185.git.skhan@linuxfoundation.org>
         <YCljfeNr4m5mZa4N@hirez.programming.kicks-ass.net>
         <20210215104402.GC4507@worktop.programming.kicks-ass.net>
         <79aeb83a288051bd3a2a3f15e5ac42e06f154d48.camel@sipsolutions.net>
         <YCqbehyyeUoL0pPT@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-2.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, 2021-02-15 at 17:04 +0100, Peter Zijlstra wrote:
> On Mon, Feb 15, 2021 at 02:12:30PM +0100, Johannes Berg wrote:
> > On Mon, 2021-02-15 at 11:44 +0100, Peter Zijlstra wrote:
> > > I think something like so will work, but please double check.
> > 
> > Yeah, that looks better.
> > 
> > > +++ b/include/linux/lockdep.h
> > > @@ -294,11 +294,15 @@ extern void lock_unpin_lock(struct lockdep_map *lock, struct pin_cookie);
> > >  
> > >  #define lockdep_depth(tsk)	(debug_locks ? (tsk)->lockdep_depth : 0)
> > >  
> > > -#define lockdep_assert_held(l)	do {				\
> > > -		WARN_ON(debug_locks && !lockdep_is_held(l));	\
> > > +#define lockdep_assert_held(l)	do {					\
> > > +		WARN_ON(debug_locks && lockdep_is_held(l) == 0));	\
> > >  	} while (0)
> > 
> > That doesn't really need to change? It's the same.
> 
> Correct, but I found it more symmetric vs the not implementation below.

Fair enough. One might argue that you should have an

enum lockdep_lock_state {
	LOCK_STATE_NOT_HELD, /* 0 now */
	LOCK_STATE_HELD, /* 1 now */
	LOCK_STATE_UNKNOWN, /* -1 with your patch but might as well be 2 */
};

:)

johannes

