Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34898 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbbJNHgF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 Oct 2015 03:36:05 -0400
Received: by wicge5 with SMTP id ge5so223305816wic.0
        for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2015 00:36:03 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1444805527.3054.4.camel@sipsolutions.net>
References: <1444635356-19975-1-git-send-email-ola1olsson@gmail.com>
	<1444727650.1961.10.camel@sipsolutions.net>
	<CABAco3CLCtFOofHMbJSz-Okcc4BM4nnVwO5By8DeZUYJrsCt6Q@mail.gmail.com>
	<1444805527.3054.4.camel@sipsolutions.net>
Date: Wed, 14 Oct 2015 09:36:03 +0200
Message-ID: <CABAco3BpY-hU=9MGzovyUfyRgXMynikNbUD3cScievczq2qsKg@mail.gmail.com> (sfid-20151014_093610_029345_ADBDAF56)
Subject: Re: [PATCH] ocb: use correct "MHz" instead of "MHZ"
From: Ola Olsson <ola1olsson@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ola Olsson <ola.olsson@sonymobile.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Hm. I think -Wunused-parameter I'd prefer not to fix, since that
> usually ends up with something like
>
> int my_callback_function(void *ignored)
> {
>         ignored = ignored;
>
>         ...
> }
>
> or something like that?

Correct. I have done a macro to utilize the gcc "__attribute__
((unused))" and I fully understand that it is not an elegant solution.
I don't want to convince you about merging it since I wouldn't do it
myself. :)

> I don't see anything with -Wmissing-field-initializers.

Hmm. I'll try to find out why I get these warnings. Mostly, it is
about changing "{}" -> "{0}" on stack allocated objects.
This is what I get when compiling at 0ee571d57b8b631658d1a35ad9a906610d6145d3

$ mm -B -j8 2>&1 | grep -i missing-field
external/iw/scan.c:1863:3: warning: missing initializer for field
'type' of 'struct nla_policy' [-Wmissing-field-initializers]
external/iw/scan.c:1866:3: warning: missing initializer for field
'type' of 'struct nla_policy' [-Wmissing-field-initializers]
external/iw/scan.c:1871:3: warning: missing initializer for field
'type' of 'struct nla_policy' [-Wmissing-field-initializers]
external/iw/connect.c:80:9: warning: missing initializer for field
'ts' of 'struct print_event_args' [-Wmissing-field-initializers]
external/iw/link.c:32:3: warning: missing initializer for field 'type'
of 'struct nla_policy' [-Wmissing-field-initializers]
external/iw/link.c:35:3: warning: missing initializer for field 'type'
of 'struct nla_policy' [-Wmissing-field-initializers]
external/iw/bitrate.c:95:9: warning: missing initializer for field
'mcs' of 'struct nl80211_txrate_vht' [-Wmissing-field-initializers]
external/iw/bitrate.c:96:9: warning: missing initializer for field
'mcs' of 'struct nl80211_txrate_vht' [-Wmissing-field-initializers]
external/iw/wowlan.c:110:11: warning: missing initializer for field
'start' of 'struct nl80211_wowlan_tcp_data_seq'
[-Wmissing-field-initializers]
