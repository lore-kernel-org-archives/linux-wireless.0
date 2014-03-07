Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f182.google.com ([209.85.214.182]:39314 "EHLO
	mail-ob0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013AbaCGCv1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Mar 2014 21:51:27 -0500
Received: by mail-ob0-f182.google.com with SMTP id uz6so3595236obc.27
        for <linux-wireless@vger.kernel.org>; Thu, 06 Mar 2014 18:51:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <530CD45A.8050803@wwwdotorg.org>
References: <1392900697-27577-1-git-send-email-heikki.krogerus@linux.intel.com>
	<1392900697-27577-3-git-send-email-heikki.krogerus@linux.intel.com>
	<53062F97.3050407@wwwdotorg.org>
	<CAGb2v66-tDZhrm9dnXe+PdQTaLZbw20sw3uYzLor2eXpVWmPMA@mail.gmail.com>
	<5306E599.7020605@wwwdotorg.org>
	<CACRpkdZBvKU31EDX=6=wVLXaQDAqD6VHtaE_mGnFLr1UYQAH9g@mail.gmail.com>
	<530CD45A.8050803@wwwdotorg.org>
Date: Fri, 7 Mar 2014 10:51:27 +0800
Message-ID: <CACRpkdZo1UHyCHe20LqRefCvS9BOT-2XeQXiZzLDQzUz4=Yc-w@mail.gmail.com> (sfid-20140307_035132_406527_A07CEDFC)
Subject: Re: [PATCH 2/4] net: rfkill: gpio: remove gpio names
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Alexandre Courbot <gnurou@gmail.com>,
	Grant Likely <grant.likely@linaro.org>,
	"devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
	Chen-Yu Tsai <wens@csie.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Rhyland Klein <rklein@nvidia.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	netdev <netdev@vger.kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Mark Gross <mark.gross@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 26, 2014 at 1:35 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 02/25/2014 02:13 AM, Linus Walleij wrote:

>> So it is basically there to satisfy the habit in some device
>> tree bindings to name gpio arrays instead of just passing gpios = <...>;
>> (The latter should be encouraged going forward.)
>
> Do you really want to switch from named GPIO lookups to index-based GPIO
> lookups?

I don't know what I want. I only know that ACPI and DT people
are starting to step on each others feet.

> Index-based lookups make it much harder to extend the DT
> binding in a backwards-compatible fashion, especially in the face of
> optional GPIOs (of which all of CD, WP, power are).

You're probably right. At the same time it makes the world complex
for the ambition to use the same interface for DT and ACPI alike.

Yours,
Linus Walleij
