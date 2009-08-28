Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f227.google.com ([209.85.219.227]:38564 "EHLO
	mail-ew0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750766AbZH1NGu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Aug 2009 09:06:50 -0400
Received: by ewy27 with SMTP id 27so2236071ewy.40
        for <linux-wireless@vger.kernel.org>; Fri, 28 Aug 2009 06:06:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <43e72e890908272221s39df68abq8e146c2d3566b415@mail.gmail.com>
References: <20090827023000.21926.90867.stgit@mj.roinet.com>
	 <40f31dec0908270558y2a3a565bvcc7e470b7f2644c6@mail.gmail.com>
	 <b6c5339f0908271117q3a893d4dma9df0ac441091dbf@mail.gmail.com>
	 <43e72e890908271125x378da3abw41e7f73dd8fbfe81@mail.gmail.com>
	 <40f31dec0908272001u1a67cbf3ycc5d9588dd48915d@mail.gmail.com>
	 <43e72e890908272057s28ee11c6x624e8a08c6bd17e9@mail.gmail.com>
	 <40f31dec0908272117s27b3a59ep5f18c85aa179793d@mail.gmail.com>
	 <43e72e890908272221s39df68abq8e146c2d3566b415@mail.gmail.com>
Date: Fri, 28 Aug 2009 16:06:50 +0300
Message-ID: <40f31dec0908280606g7ce50ea7n8c727825f9b98c33@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH 1/2] ath5k: fix uninitialized value use in
	ath5k_eeprom_read_turbo_modes()
From: Nick Kossifidis <mickflemm@gmail.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Bob Copeland <bcopeland@gmail.com>, Pavel Roskin <proski@gnu.org>,
	ath5k-devel@lists.ath5k.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/8/28 Luis R. Rodriguez <mcgrof@gmail.com>:
> On Thu, Aug 27, 2009 at 9:17 PM, Nick Kossifidis<mickflemm@gmail.com> wrote:
>
>> Many people use turbo mode and it's not an ugly proprietary extension, static
>> turbo mode is close to just having 40MHz channels,
>
> Its not following any spec and I suspect it will create pretty noise
> on existing wireless networks. 11n has at least some precautions to
> try to be friendly, such as trying using primary and extension
> channels to match nearby APs. I don't believe Atheros Turbo has such
> things.
>

With 16dB attenuation it's gone (check out the spectrum analyzer graph), it's
no big deal + it only operates on channels we want (on channels with no "edges"
eg as the whitepaper mentions)
http://www.super-g.com/collateral/atheros_superg_whitepaper.pdf

Trust me, many people are using turbo mode and it's no big deal to
support it, code is there
and everyone else supports it (MadWiFi, ath, atheros windows driver
etc). Dynamic turbo
is even better since it can operate on 40MHz on-demand only. If hw
supports it then why shouldn't
we add support on ath5k ?

>
> MadWifi is dead.
>

Well if people want turbo and other fancy stuff then they 'll keep it alive...


-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
