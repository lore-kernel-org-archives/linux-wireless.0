Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:60661 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021Ab2DSP5U (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 11:57:20 -0400
Message-ID: <1334851014.16897.297.camel@aeonflux> (sfid-20120419_175724_248624_8CE4E5AF)
Subject: Re: [PATCH] iwlwifi: add option to disable 5GHz band
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Date: Thu, 19 Apr 2012 17:56:54 +0200
In-Reply-To: <4F901F51.3000704@sipsolutions.net>
References: <1334830280-3019-1-git-send-email-sgruszka@redhat.com>
	 <4F901F51.3000704@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > There are various problems happened on 5GHz band not observed on
> > 2.4 GHz (microcode errors, queue stuck, etc... ) . Also roaming
> > between 5GHz AP and 2GHz does not work very well. To workaround
> > the problems add option to disable 5GHz support. This will help
> > on environments where APs are dual-band, and devices will not try
> > to associate on band where issues happen.
> 
> Would it make sense to somehow do this in cfg80211? Today, our driver 
> may be the only one having this problem (which I've never really heard 
> about?), but is it always going to be?

honestly I have seen 5GHz problems with our driver multiple times. I
always ended up disabling 5GHz support in the AP since I rarely have
time to debug this. It only happens after long time of operation for me,
but was like super annoying all the time.

And I had similar issues with N support.

I would personally be fine with a global debugfs option within cfg80211
to disable it.

Regards

Marcel


