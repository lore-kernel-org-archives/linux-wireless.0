Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:51865 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756532Ab3BFQsA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Feb 2013 11:48:00 -0500
Message-ID: <1360169290.7910.29.camel@jlt4.sipsolutions.net> (sfid-20130206_174804_832793_E70DDAB9)
Subject: Re: [PATCH 5/7] mac80211: Expand powersave configuration flag to be
 two bits
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	Christian Lamparter <chunkeey@googlemail.com>,
	Ivo van Doorn <IvDoorn@gmail.com>,
	Gertjan van Wingerde <gwingerde@gmail.com>,
	Helmut Schaa <helmut.schaa@googlemail.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Arend van Spriel <arend@broadcom.com>,
	Luciano Coelho <coelho@ti.com>, ath9k-devel@venema.h4ckr.net,
	brcm80211-dev-list@broadcom.com, users@rt2x00.serialmonkey.com
Date: Wed, 06 Feb 2013 17:48:10 +0100
In-Reply-To: <20130205225101.GB29557@thinkpad-t410>
References: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
	 <1359503255-18270-6-git-send-email-seth.forshee@canonical.com>
	 <1359645648.8415.77.camel@jlt4.sipsolutions.net>
	 <20130131163355.GE28799@thinkpad-t410>
	 <1359651229.8415.99.camel@jlt4.sipsolutions.net>
	 <20130131171826.GG28799@thinkpad-t410>
	 <1359654634.8415.101.camel@jlt4.sipsolutions.net>
	 <20130205225101.GB29557@thinkpad-t410>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Seth,

> I've been thinking about and playing around with these ideas. I've
> implemented the CONF_PM idea, and it does end up with fewer changes, but
> I just don't think separating powersave from setting PM makes much
> sense. In the end it just seems like a kludge to fix a problem with
> Broadcom chips, and if I want a kludge I can do it entirely within the
> driver.
> 
> So what I'm planning to do know is implement the awake/doze/offchannel
> powersave modes like I had mentioned, but taking things a bit further.
> I'd change IEEE80211_HW_SUPPORTS_PS to SUPPORTS_PS_DOZE, indicating
> support for a low-power powersave state rather than support for
> powersave in general.

Hm, I'm not sure I fully understand this. What does PS_DOZE mean then? I
think in the spec doze is a specific term for mesh?

Does it just mean "I support actually turning off the radio"? But then
what's the difference to supporting powersave? Can we maybe just
disregard wl1251, which has the stupidest powersave implementation on
the planet, and solve the "normal" problems first? :)

> All hardware will be reconfigured for
> awake<->offchannel transitions (though most drivers can simply ignore
> these transitions), but hardware will only be put in the doze state if
> it indicates PS_DOZE support.
> 
> This will make it compulsory for all drivers to indicate whether or not
> they require IEEE802111_HW_PS_NULLFUNC_STACK. I'll simply set this flag
> for any drivers not currently supporting powersave.

That seems odd, why would they advertise they want null-data packets for
powersave, when they don't have powersave? Just for the interaction with
scan/offchannel?

> In practice the changes shouldn't end up much different than what I have
> in these patches, but I think it's conceptually cleaner (and less
> confusing!). Does this sound reasonable to you?

Not really sure I understand it enough to comment :)

johannes

