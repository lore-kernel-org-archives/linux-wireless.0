Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f180.google.com ([209.85.214.180]:33905 "EHLO
	mail-iw0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751718Ab0LOWbm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 17:31:42 -0500
Received: by iwn37 with SMTP id 37so2829343iwn.11
        for <linux-wireless@vger.kernel.org>; Wed, 15 Dec 2010 14:31:42 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTikJHTztqvRRQVjGL_4G8Uvg-d+Zqu4q2fJZa9_i@mail.gmail.com>
References: <4D07434F.6070006@tls-tautenburg.de> <loom.20101214T195434-788@post.gmane.org>
 <AANLkTikJHTztqvRRQVjGL_4G8Uvg-d+Zqu4q2fJZa9_i@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 15 Dec 2010 14:31:21 -0800
Message-ID: <AANLkTinHo0mAdkixy8N8K+FDC=BB9EvKgqrFM69e5bT=@mail.gmail.com>
Subject: Re: unresolved symbols due to missing iwlcore.ko
To: Tomas Winkler <tomasw@gmail.com>
Cc: Bringfried Stecklum <stecklum@tls-tautenburg.de>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 15, 2010 at 2:20 PM, Tomas Winkler <tomasw@gmail.com> wrote:
> On Tue, Dec 14, 2010 at 9:01 PM, Bringfried Stecklum
> <stecklum@tls-tautenburg.de> wrote:
>> Turns out that the error is due to a fault of the configuration script. If I
>> _don't_ select the iwlwifi driver via driver_select and build all drivers
>> instead, iwlcore.ko will be build as well and properly installed.
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> It looks like there is a mismatch between usage CONFIG_IWLWIIFI and
> CONFIG_COMPAT_IWLWIFI in select script and the Makefile. I'm not sure
> what is the intention so of COMPAT so I cannot say were it should be
> fixed.

Likely the grep'ing out is dropping one config option out of the
Makefile, fix that and you can fix the problem.

  Luis
