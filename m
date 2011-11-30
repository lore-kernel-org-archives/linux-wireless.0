Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:57233 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756062Ab1K3IcX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 03:32:23 -0500
Subject: Re: [PATCH] mac80211: reset addba retries after timeout
From: Johannes Berg <johannes@sipsolutions.net>
To: Nikolay Martynov <mar.kolya@gmail.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
In-Reply-To: <CALGY4fu7DExMn6BCrwTMCEav1VEe81NAvJapiLXoi_DSf50ctg@mail.gmail.com> (sfid-20111129_234719_623158_EFE47BCC)
References: <1322533625-24641-1-git-send-email-mar.kolya@gmail.com>
	 <1322555084.4110.2.camel@jlt3.sipsolutions.net>
	 <CALGY4fvLSKBY93M9Bhb-F8Sm=Uw5nU+OvTtAmk_BXQX8WX6V8A@mail.gmail.com>
	 <1322579973.4110.22.camel@jlt3.sipsolutions.net>
	 <CALGY4fvSOdKtZbPSdvYkY3XXaGXNo-Ft8ir4LikmnTLqSkVCGA@mail.gmail.com>
	 <1322604877.11282.1.camel@jlt3.sipsolutions.net>
	 <CALGY4ftCLvwUuRZbH30PyUxAd6U7-p9hGwu8SjzLmqV4=XryZg@mail.gmail.com>
	 <1322606159.11282.2.camel@jlt3.sipsolutions.net>
	 <CALGY4fu7DExMn6BCrwTMCEav1VEe81NAvJapiLXoi_DSf50ctg@mail.gmail.com>
	 (sfid-20111129_234719_623158_EFE47BCC)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Nov 2011 09:32:18 +0100
Message-ID: <1322641938.3982.0.camel@jlt3.sipsolutions.net> (sfid-20111130_093226_883039_FCB736D2)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-29 at 17:46 -0500, Nikolay Martynov wrote:

> > Maybe the better approach would be to bump it up, but also only allow an
> > attempt once every say 15 seconds or so? It seems kinda useless to try 3
> > (or 10/15) times in quick succession and then give up, vs. just trying
> > more spaced out?
> 
>   Makes sense to me. Although I would left first 2-3 go quickly in
> case first was lost due to random glitch there is no reason to wait 15
> seconds. But if first 2-3 fail - it make sense split next apart, I
> think.

Seems ok to me, want to implement it? :)

johannes

