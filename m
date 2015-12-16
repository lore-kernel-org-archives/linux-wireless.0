Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:32949 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751846AbbLPHwk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Dec 2015 02:52:40 -0500
Received: by mail-lb0-f169.google.com with SMTP id kw15so20493597lbb.0
        for <linux-wireless@vger.kernel.org>; Tue, 15 Dec 2015 23:52:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1450082912.3871.2.camel@sipsolutions.net>
References: <CAB=NE6U5sh4cneaB5CGC7fSM_fKG_tBtmZ6sAo9Jswm1RBzd-g@mail.gmail.com>
	<CAB=NE6VFo96M-ieCYPeDKncGJm+G1-_4gqKNDFen+K49-pLD4Q@mail.gmail.com>
	<1449876779.2324.16.camel@sipsolutions.net>
	<566DF964.7050904@broadcom.com>
	<0BA3FCBA62E2DC44AF3030971E174FB32E919DE2@hasmsx107.ger.corp.intel.com>
	<1450082912.3871.2.camel@sipsolutions.net>
Date: Wed, 16 Dec 2015 09:52:39 +0200
Message-ID: <CANUX_P2gtr+MgE8f67v5uj7nDmYF5ub7OxA_WpZYm4kBUAASTQ@mail.gmail.com> (sfid-20151216_085247_031248_87A63D01)
Subject: Re: iwlwifi - L1 Enabled - LTR Enabled loop
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
	linuxwifi <linuxwifi@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 14, 2015 at 10:48 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2015-12-14 at 04:00 +0000, Grumbach, Emmanuel wrote:
>>
>> This is really weird. I don't see how that could be firmware related.
>> BTW, -10.ucode is fairly old :) we have -16.ucode out there.
>
> I guess the question is how we get into this situation to start with?
>
> About the only thing I can imagine is that we fail somehow during
> initialization (without printing any other message) and higher layers
> like wpa_supplicant/network-manager/... simply try to bring up the
> device over and over again?
>

I can reproduce this now when I unload / load iwlwifi until I kill the
supplicant.
Seems like the wpa_s is indeed toggling the device.
I don't have time to play with that right now.
