Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60423 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753155Ab1HIPJ3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 9 Aug 2011 11:09:29 -0400
Message-ID: <4E414DA7.7020406@suse.cz> (sfid-20110809_170933_539421_1160CB2A)
Date: Tue, 09 Aug 2011 17:09:27 +0200
From: Michal Marek <mmarek@suse.cz>
MIME-Version: 1.0
To: Pavel Ivanov <paivanof@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: Cannot easily set CONFIG_WIRELESS_EXT in kernel 3.0 build
References: <CAG1a4rtHedO66ot4B7TWmKG5_mrnSS78O74_xxmgXk7UeoX_gA@mail.gmail.com>
In-Reply-To: <CAG1a4rtHedO66ot4B7TWmKG5_mrnSS78O74_xxmgXk7UeoX_gA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9.8.2011 17:04, Pavel Ivanov wrote:
> I'd think that such behavior is a bug, although I don't know on which
> side. Either on the side of wireless drivers which all have to have
> 'select WIRELESS_EXT' in their Kconfig files or on the side of kbuild
> system which doesn't allow me to set CONFIG_WIRELESS_EXT unless some
> driver requires it. Interestingly enough requiring WIRELESS_EXT works
> only with drivers, because I've tried to add CONFIG_LIBIPW (it
> requires WIRELESS_EXT too)

Both WIRELESS_EXT and LIBIPW are symbols without prompt, so they cannot
be selected by the user directly. Drivers that need CONFIG_WIRELESS_EXT
have to select it.

Michal
