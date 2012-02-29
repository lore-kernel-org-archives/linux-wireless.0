Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:9116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752486Ab2B2OjB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 09:39:01 -0500
Date: Wed, 29 Feb 2012 15:38:52 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Paul Farrow <linuxwireless@thefabfarrows.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Can't compile latest compat-wireless on Fedora 16 -
  3.2.7-1.fc16.x86_64.debug
Message-ID: <20120229143847.GA20516@redhat.com> (sfid-20120229_153906_452775_743F2EAE)
References: <fb86ee45cba7d303c361b65c072504ca@www.thefabfarrows.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fb86ee45cba7d303c361b65c072504ca@www.thefabfarrows.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Feb 28, 2012 at 02:05:24PM -0500, Paul Farrow wrote:
> I have in recent times compiled the latest compat-wireless with no
> problem but I seem to be having trouble compiling it on this kernel
> - lots of undefined warnings in the mac80211 area.
> 
> Output from make is attached.
> 
> Can any one tell me what I have done wrong?

 
> WARNING: "__tracepoint_api_stop_tx_ba_session" [/usr/local/src/compat-wireless-2012-02-27/net/mac80211/mac80211.ko] undefined!

In compat-wireless tree do:

patch -p1 -R < patches/44-deactivate-mac80211-tracing.patch

I'm not sure how proper fix should looks like. I guess removing that
patch will broke compiation on older kernels without tracing support.

BTW: this could be usefull for you
http://people.redhat.com/sgruszka/compat_wireless.html

Stanislaw
