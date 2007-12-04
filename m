Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mfe1.polimi.it ([131.175.12.23]:41642 "EHLO polimi.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751661AbXLDSBn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 13:01:43 -0500
Date: Tue, 4 Dec 2007 18:57:19 +0100
From: Stefano Brivio <stefano.brivio@polimi.it>
To: Mattias Nissler <mattias.nissler@gmx.de>
Cc: Nick Kossifidis <mickflemm@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC][PATCH] mac80211: Use PID controller for TX rate control
Message-ID: <20071204185719.2eba303c@morte> (sfid-20071204_180146_478186_EE52DA27)
In-Reply-To: <1196790047.7472.5.camel@localhost>
References: <1196622331.7472.4.camel@localhost>
	<20071203041608.3af3b462@morte>
	<1196679780.7470.9.camel@localhost>
	<20071203125402.76562f26@morte>
	<1196683144.7470.14.camel@localhost>
	<20071203130602.49ab7234@morte>
	<40f31dec0712031442q51a658abwfde965dae3fb6b72@mail.gmail.com>
	<20071204024146.15689ee3@morte>
	<1196756103.7476.12.camel@localhost>
	<20071204110135.1835a57e@morte>
	<1196790047.7472.5.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 04 Dec 2007 18:40:47 +0100
Mattias Nissler <mattias.nissler@gmx.de> wrote:

> I don't think this data is useful for tuning the TX control algorithm at
> all. In the case of a noisy channel, you can improve the rate of
> successful transmission by switching to a more-robust rate. However, if
> the driver just gets the parameters wrong, a slower rate won't help at
> all, thus the feedback loop model on which the PID controller relies is
> severely flawed.

Well, I may object that here it looks like that setting a lower rate
actually yields a lower failed frames ratio. But I agree with you, this
data is suboptimal - at the very least - for helping us with tuning.

> Ah, ok, module parameters show up in sysfs. This is good for testing,
> but if we want to make some parameters available for everybody, we
> cannot rely on module parameters, i.e. when mac80211 is compiled int the
> kernel. I'd say we even want to be able to tweak the parameters on a per
> device basis, we should really add them to mac80211 sysfs.

Please see Johannes's proposal [1]. I tend to agree with that. Here comes
my plan: for testing, I'd say we can stick to those modparams I introduced
last night, setting perms to 644 and just being careful to bring down the
interface before changing them through sysfs. When we're done with testing,
we can decide which parameters need to be exported and which don't, and
then implement proper locking and exporting parameters through nl80211. Is
this OK for you?


[1] Message-Id: <1196775624.6060.52.camel@johannes.berg>, on linux-wireless.


--
Ciao
Stefano
