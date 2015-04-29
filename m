Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lb1-smtp-cloud6.xs4all.net ([194.109.24.24]:57159 "EHLO
	lb1-smtp-cloud6.xs4all.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1422711AbbD2I6z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Apr 2015 04:58:55 -0400
Message-ID: <1430297931.2411.110.camel@x220> (sfid-20150429_110720_204547_1DA77728)
Subject: Re: [PATCH] drivers/nfc: remove obsolete setting of DEBUG
From: Paul Bolle <pebolle@tiscali.nl>
To: Valentin Rothberg <valentinrothberg@gmail.com>
Cc: Joe Perches <joe@perches.com>, lauro.venancio@openbossa.org,
	aloisio.almeida@openbossa.org, sameo@linux.intel.com,
	clement.perrochaud@effinnov.com, charles.gorand@effinnov.com,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
	Andreas Ruprecht <rupran@einserver.de>,
	hengelein Stefan <stefan.hengelein@fau.de>
Date: Wed, 29 Apr 2015 10:58:51 +0200
In-Reply-To: <CAD3Xx4KtKfh+RwicZ1P1acYAMgvGALMuoTWZTKMks2qQrRrc4Q@mail.gmail.com>
References: <1430212127-5841-1-git-send-email-valentinrothberg@gmail.com>
	 <1430296046.2411.100.camel@x220>
	 <CAD3Xx4KtKfh+RwicZ1P1acYAMgvGALMuoTWZTKMks2qQrRrc4Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-04-29 at 10:45 +0200, Valentin Rothberg wrote:
> Thanks, I was not aware of it at all.  I read the code and it seems
> that if neither DYNAMIC_DEBUG nor DEBUG is defined, pr_debug() does
> nothing more than to return 0.
> 
> I am not sure what to do in this case.  Somehow it seems reasonable to
> me to add NFC_DEBUG to Kconfig since a considerable amount of code in
> nfc seems to depend on DEBUG.

A few greps tell me the first pointless reference to CONFIG_NFC_DEBUG
was added in v3.1. So clearly the people actually building and using the
nfc code don't need the DEBUG flag. Apparently using pr_debug() by
setting CONFIG_DYNAMIC_DEBUG works for them. (I trust Joe will shout
when that statement is incorrect.)

So, as I said, the patch should be fine, and only the commit explanation
needs work.


Paul Bolle

