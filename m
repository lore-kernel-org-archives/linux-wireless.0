Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:60755 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053AbaHSHi2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Aug 2014 03:38:28 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
CC: <ath6kl@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: ath6kl DT support and multiple instances.
References: <53F2FB31.3090802@linaro.org>
Date: Tue, 19 Aug 2014 10:38:19 +0300
In-Reply-To: <53F2FB31.3090802@linaro.org> (Srinivas Kandagatla's message of
	"Tue, 19 Aug 2014 08:22:25 +0100")
Message-ID: <87oavhapzo.fsf@kamboji.qca.qualcomm.com> (sfid-20140819_093853_542833_A3FD38CA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Srinivas,

Srinivas Kandagatla <srinivas.kandagatla@linaro.org> writes:

> I noticed that ath6kl partially supports Device trees, via
> check_device_tree() function in init.c.

That's really old code. Sam Leffler wrote that back in 2011 and IIRC
nobody has touched it since.

> I have a use case for adding reset line and pinctrl properties to this
> dt bindings, but soon realized that this function would not work for
> multiple instances of the driver, as there is no direct
> association/binding of dt node and driver instance.
>
> Just wondering if this is a know limitation and there will be no
> possible multiple instances of this driver?
>
> is check_device_tree function obsolete?

I'm not familiar with the device tree at all so I can't really comment
much, except that I'm happy to take patches :)

> should I care about multiple instances?

Yes, I think you should.

> Other than adding static code in the board file, are there any other
> options to pass platform data like reset gpio lines and pinctrl
> properties to the driver?

Few years back we talked about adding function pointers to the board
files for that, but there never were any patches.

-- 
Kalle Valo
