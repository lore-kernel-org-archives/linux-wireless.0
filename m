Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:46561 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751599AbcCIJ3P (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Mar 2016 04:29:15 -0500
Message-ID: <1457515749.2042.0.camel@sipsolutions.net> (sfid-20160309_102919_228139_CC215082)
Subject: Re: [PATCH] mac80211: Allow probe response frame rx to user space
 in AP mode
From: Johannes Berg <johannes@sipsolutions.net>
To: "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 09 Mar 2016 10:29:09 +0100
In-Reply-To: <56DFB02A.5070207@qti.qualcomm.com>
References: <1457334731-6456-1-git-send-email-vthiagar@qti.qualcomm.com>
	 <1457456123.24270.11.camel@sipsolutions.net>
	 <56DFB02A.5070207@qti.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-03-09 at 05:10 +0000, Thiagarajan, Vasanthakumar wrote:

> When an user space wants to have control over the duration of off-
> channel (single channel) scan it could use remain-on-channel
> interface instead of trigger_scan to perform off-channel scan. I dont
> think BSS cache will be updated with the BSS information received
> during remain-on-channel. In this case, user space could use probe
> response frames to build BSS list.
> 
That's not a use case, that's an implementation?

FWIW, we have patches pending to add some dwell time control for
scanning since it's required for some radio resource measurement
things. It seems like that would address your use case.

johannes
