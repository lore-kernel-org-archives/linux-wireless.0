Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:36220 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab0I2RYK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Sep 2010 13:24:10 -0400
Subject: Re: [PATCH] mac80211: fix rate_control_send_low warnings for delbas
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Vasanthakumar Thiagarajan <vasanth@atheros.com>,
	Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>,
	Jouni Malinen <j@w1.fi>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"stable@kernel.org" <stable@kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Paul Stewart <pstew@google.com>,
	Amod Bodas <Amod.Bodas@atheros.com>
In-Reply-To: <AANLkTikUAchrjeMraauLaUggtq7bYZoki=kz2o8XQ2yh@mail.gmail.com>
References: <20100928222945.GB10932@tux> <20100928230211.GA9844@jm.kir.nu>
	 <AANLkTimGPPUW6=QYpZz7q96vt1GOd5kJ-tvYEKxZZT2B@mail.gmail.com>
	 <20100929052006.GC18450@vasanth-laptop>
	 <AANLkTinKkTgUUGPxY82G1B6taToKeAMOmrJ+tYvzLY52@mail.gmail.com>
	 <20100929085657.GD18450@vasanth-laptop>
	 <AANLkTikUAchrjeMraauLaUggtq7bYZoki=kz2o8XQ2yh@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 19:24:03 +0200
Message-ID: <1285781043.3756.28.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-09-29 at 10:16 -0700, Luis R. Rodriguez wrote:

> > 2. NL80211_CMD_ASSOCIATE to newly authenticated AP from user space
> >
> >        - Clean up any existing BA session with an AP, if any.
> >        Here the assumption is, ieee80211_work_work() has already
> >        configured the device back to it's operating channel (the
> >        old one) after the authentication is complete with the new
> >        AP. This should have happened part of 1.
> >        - Start the association process with the new AP.
> 
> No see, I believe we actually get the association response and *then*
> we teardown the BA agreements. Let me review this some more today.

No, Vasanth's right, but there's a race:

 * we go off-channel
 * we send auth
 * we get auth
 * we notify wpa_s
 * wpa_s asks for assoc         | these aren't ordered
 * we disassoc                  | quite right but it's
 * we return from off-channel   | hard to avoid ...
 * we assoc to new AP

johannes

