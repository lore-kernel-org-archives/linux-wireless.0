Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56252 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbZLOBpW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2009 20:45:22 -0500
Date: Mon, 14 Dec 2009 20:42:07 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Kadianakis George <desnacked@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Function name collisions with mac80211
Message-ID: <20091215014207.GA6028@tuxdriver.com>
References: <873a3dm3j5.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <873a3dm3j5.fsf@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 15, 2009 at 03:25:50AM +0200, Kadianakis George wrote:
> Greetings,
> 
> a function name collision issue spawned off a Gentoo bug [1].
> 
> Basically, functions in the rtl8187se staging driver collide with functions in the
> mac80211 source not allowing kernel compilation with both
> CONFIG_RTL8187SE and CONFIG_MAC80211 set.
> 
> Changes that cause this issue are: 
> a) commit 103bf9f7d35849bce52ad412e4da5063b0716969: 
>    mac80211: remove ieee80211_rx namespace hack
> Where ieee80211_rx() starts getting exported instead of __ieee80211_rx() which used to get exported.
> b) commit c6e43bc83fd0f156eeb64bc2fa47323fdff16ba8
>    Staging: rtl8187se/ieee80211: remove superfluous ieee80211_* defines
> Where #define ieee80211_wake_queue ieee80211_wake_queue_rtl
> and #define ieee80211_stop_queue ieee80211_stop_queue_rtl
> get removed effectively exposing the collision with the mac80211
> functions of the same names.
> 
> The collisions are not restricted to the rtl8187se driver, like the
> following example:
> c) commit 5d9baea95f45bddcecab050de1af2ef678e85339
>    Staging: rtl8192su: make private ieee80211 stack really private
> Had the exact same effect as b) to the rtl8192su driver.
> d) A quick grep of the three functions in Gentoo bug report shows many
> instances of them in the drivers/staging directory.
> 
> [1]: http://bugs.gentoo.org/show_bug.cgi?id=296920

I suggest you change the function names in drivers/staging.

Joh
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
