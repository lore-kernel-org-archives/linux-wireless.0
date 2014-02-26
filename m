Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:57910 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751418AbaBZJiA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Feb 2014 04:38:00 -0500
Message-ID: <1393407473.4133.5.camel@jlt4.sipsolutions.net> (sfid-20140226_103806_577303_39CFB42B)
Subject: Re: [PATCH 01/14] brcmfmac: add delay before unregistering the
 network device
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 26 Feb 2014 10:37:53 +0100
In-Reply-To: <530DB3BA.20106@broadcom.com>
References: <1393356639-19169-1-git-send-email-arend@broadcom.com>
			 <1393356639-19169-2-git-send-email-arend@broadcom.com>
			 (sfid-20140225_203048_842452_A39499B6) <1393358376.4170.22.camel@jlt4.sipsolutions.net>
		 <530DAECD.8010405@broadcom.com>
	 <1393406278.4133.4.camel@jlt4.sipsolutions.net>
	 <530DB3BA.20106@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-02-26 at 10:28 +0100, Arend van Spriel wrote:

> > Yes. Can't we just flush the work at some strategic place?
> > 
> > Actually you're not talking about the "disconnect_work" (which is
> > related to regulatory) but the "event_work" so I was confused here for a
> > second.
> > 
> > What was the warning? cfg80211 already calls
> > cfg80211_process_wdev_events() from within the REMOVE netdev notifier,
> > so that *shouldn't* have happened.
> 
> I guess that means some wdev event is missing? It was the
> WARN_ON(current->bss) that fired.

Hmm, that's odd, the process_wdev_events() call is right before that, so
I don't see how that could have happened?

johannes

