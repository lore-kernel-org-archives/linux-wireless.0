Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aa012-1msr.fastwebnet.it ([62.101.93.132]:45737 "EHLO
	aa012-1msr.fastwebnet.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721Ab1FDPVP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jun 2011 11:21:15 -0400
Message-ID: <4DEA4D67.8000009@absence.it> (sfid-20110604_172120_298835_E95A8439)
Date: Sat, 04 Jun 2011 17:21:11 +0200
From: Marco Chiappero <marco@absence.it>
MIME-Version: 1.0
To: Mattia Dongili <malattia@linux.it>
CC: Matthew Garrett <mjg59@srcf.ucam.org>,
	platform-driver-x86@vger.kernel.org,
	linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: Re: [PATCH 12/25] sony-laptop: input core improvements improvements
References: <4DE8FC4A.9010401@absence.it> <4DE9012E.5040207@absence.it> <20110604080717.GC7194@kamineko.org>
In-Reply-To: <20110604080717.GC7194@kamineko.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Il 04/06/2011 10:07, Mattia Dongili ha scritto:
>> of Fn combos too.
>
> the additional key codes are fine though.

There is one thing (IIRC you already heard of) I'd like to discuss here.
It seems that on recent models the hotkeys layout hasn't changed for 
some time now, and it's likely to stay the same for a long time. However 
it is different from the one mapped in the driver, and some changes are 
required. For example:

- Fn-F1 (Touchpad togle enable) to KEY_TOUCHPAD_TOGGLE instead of KEY_FN_F1
- Fn-F5 (bright. down) to KEY_BRIGHTNESSDOWN instead of KEY_FN_F5
- Fn-F9 (zoom out) to KEY_ZOOMOUT instead of KEY_FN_F9
and so on.

To preserve support for older models we can use udev keymaps or a 
fallback map for any notebook not starting with the "VPC" model prefix 
(since a couple of years this is the starting model string). Is this 
solution acceptable? Having a correct mapping at the source instead of 
remapping for every model is better, is it possible?
