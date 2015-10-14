Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:58510 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750845AbbJNGwL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 02:52:11 -0400
Message-ID: <1444805527.3054.4.camel@sipsolutions.net> (sfid-20151014_085214_651811_7719A1D7)
Subject: Re: [PATCH] ocb: use correct "MHz" instead of "MHZ"
From: Johannes Berg <johannes@sipsolutions.net>
To: Ola Olsson <ola1olsson@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ola Olsson <ola.olsson@sonymobile.com>
Date: Wed, 14 Oct 2015 08:52:07 +0200
In-Reply-To: <CABAco3CLCtFOofHMbJSz-Okcc4BM4nnVwO5By8DeZUYJrsCt6Q@mail.gmail.com> (sfid-20151014_004234_903313_530163BE)
References: <1444635356-19975-1-git-send-email-ola1olsson@gmail.com>
	 <1444727650.1961.10.camel@sipsolutions.net>
	 <CABAco3CLCtFOofHMbJSz-Okcc4BM4nnVwO5By8DeZUYJrsCt6Q@mail.gmail.com>
	 (sfid-20151014_004234_903313_530163BE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

> May I ask if you are interested in patches that removes the compiler
> warnings on Android? I have cloned the iw git under the external
> folder in the android tree and everything compiles fine with "mm" but
> there are a lot of warnings. Most warnings are unused-parameter and
> sign-compare but also missing-field-initializers.

Hm. I think -Wunused-parameter I'd prefer not to fix, since that
usually ends up with something like

int my_callback_function(void *ignored)
{
	ignored = ignored;

	...
}

or something like that?

-Wsign-compare seems somewhat useful, I've just gone through that and
fixed it up.

I don't see anything with -Wmissing-field-initializers.


johannes
