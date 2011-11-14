Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35703 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752723Ab1KNJI2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Nov 2011 04:08:28 -0500
Subject: Re: [PATCH] iw : V2 fix compilation against libnl-3.x
From: Johannes Berg <johannes@sipsolutions.net>
To: Gilles Espinasse <g.esp@free.fr>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1321052678-23396-1-git-send-email-g.esp@free.fr>
References: <1321052678-23396-1-git-send-email-g.esp@free.fr>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 14 Nov 2011 10:08:25 +0100
Message-ID: <1321261705.4472.38.camel@jlt3.sipsolutions.net> (sfid-20111114_100832_980593_C66B1F4E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2011-11-12 at 00:04 +0100, Gilles Espinasse wrote:
> Add configuration to compile against 3.1 and 3.2 without breaking 3.0
> That's a bit of mess with version on .pc file and the part which belong or not to the shared lib name.
> 
> libnl-genl-3.1 is broken and can't be used
> 
> Starting from 3.2.0, I could have used libnl-genl-3.0.pc file like in patch V1 and not hardcode adding libnl-genl-3 into LIBS
> I consider this a matter of tast for now, coded like previous versions that can't use that way to code.
> 
> Added an echo to display against which libnl version iw is compiled.
> That particulary help me to test with various versions because of the mess on .pc file version as libnl>=3.2.0 has again pc file version with 3.0 number.
> 
> Removed the version_check part instead of extending blindly for the new versions.
> That was mostly dead code because prior check on NLLIBNAME not empty already care.
> The only case where that could matter would be using something stupid like
> NLLIBNAME=foo make
> 
> Compilation tested to work against
> - libnl-2.0
> - libnl-3.0
> - libnl-3.1
> - libnl-3.2.0
> - libnl-3.2.2
> 
> Tested to fail without a libnl .pc file

Great, thanks!

Applied,

> +all: $(ALL)
> +	@echo "Compilation against $(NLVERSION)"

but I removed the echo here.

johannes

