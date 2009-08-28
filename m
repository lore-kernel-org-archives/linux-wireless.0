Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f204.google.com ([209.85.223.204]:63078 "EHLO
	mail-iw0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750993AbZH1FVk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 01:21:40 -0400
Received: by iwn42 with SMTP id 42so841029iwn.33
        for <linux-wireless@vger.kernel.org>; Thu, 27 Aug 2009 22:21:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <40f31dec0908272117s27b3a59ep5f18c85aa179793d@mail.gmail.com>
References: <20090827023000.21926.90867.stgit@mj.roinet.com>
	<40f31dec0908270558y2a3a565bvcc7e470b7f2644c6@mail.gmail.com>
	<b6c5339f0908271117q3a893d4dma9df0ac441091dbf@mail.gmail.com>
	<43e72e890908271125x378da3abw41e7f73dd8fbfe81@mail.gmail.com>
	<40f31dec0908272001u1a67cbf3ycc5d9588dd48915d@mail.gmail.com>
	<43e72e890908272057s28ee11c6x624e8a08c6bd17e9@mail.gmail.com>
	<40f31dec0908272117s27b3a59ep5f18c85aa179793d@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 27 Aug 2009 22:21:22 -0700
Message-ID: <43e72e890908272221s39df68abq8e146c2d3566b415@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/2] ath5k: fix uninitialized value use in
	ath5k_eeprom_read_turbo_modes()
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: Bob Copeland <bcopeland@gmail.com>, Pavel Roskin <proski@gnu.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Aug 27, 2009 at 9:17 PM, Nick Kossifidis<mickflemm@gmail.com> wrote:

> Many people use turbo mode and it's not an ugly proprietary extension, static
> turbo mode is close to just having 40MHz channels,

Its not following any spec and I suspect it will create pretty noise
on existing wireless networks. 11n has at least some precautions to
try to be friendly, such as trying using primary and extension
channels to match nearby APs. I don't believe Atheros Turbo has such
things.

> we can use the same way to
> switch to it as with 5 and 10MHz channels.

5 and 10 MHz seem to be defined and used as per 802.11 and those seem
reasonable to support.

> Most code is there, we are ready to support 5/10/40MHz channels on the
> driver part

Great.

> as soon as we are done with cfg80211/mac80211 compatibility so why drop it ?

We can drop Turbo, but it seems reasonable to keep 5 MHz and 10 MHz support.

> Having multiple drivers won't help users, i thought that MadWiFi was "dead"
> and we were working on a complete alternative.

MadWifi is dead.

  Luis
