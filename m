Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f51.google.com ([209.85.210.51]:48440 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753945Ab2CSEgt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Mar 2012 00:36:49 -0400
MIME-Version: 1.0
In-Reply-To: <b157e2d1a746733d1814b9726f326d52d36da2fc.1332116921.git.joe@perches.com>
References: <cover.1332116921.git.joe@perches.com>
	<b157e2d1a746733d1814b9726f326d52d36da2fc.1332116921.git.joe@perches.com>
Date: Sun, 18 Mar 2012 21:36:49 -0700
Message-ID: <CAJ-Vmo=ceSV38vQGfs8cKJScWjYF4kbQdK3+JJvQLCmnURaEwA@mail.gmail.com> (sfid-20120319_053714_181063_BB8B5E65)
Subject: Re: [PATCH wireless-next 2/3] ath5k: Introduce _ath5k_printk to
 reduce code/text
From: Adrian Chadd <adrian@freebsd.org>
To: Joe Perches <joe@perches.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
	Nick Kossifidis <mickflemm@gmail.com>,
	"Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
	Bob Copeland <me@bobcopeland.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

So the reason this is a macro in the FreeBSD HAL is so that the args
aren't evaluated unless the level (or debug bitmap in my case) fires
off.

Otherwise compiling in debugging will cause a _lot_ of spurious
register reads to occur that are then tossed. This was one of the big
reasons for instability and slow performance when AH_DEBUG was
enabled.



Adrian
