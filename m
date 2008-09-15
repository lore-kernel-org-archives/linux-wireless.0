Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:56429 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753703AbYIOPLI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Sep 2008 11:11:08 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: linux-wireless@vger.kernel.org
Subject: Re: [RFC] mac80211: notify the user space about low signal quality
Date: Mon, 15 Sep 2008 17:10:43 +0200
Cc: Dan Williams <dcbw@redhat.com>, Helmut Schaa <hschaa@suse.de>
References: <200809151416.07552.hschaa@suse.de> <200809151435.28933.hschaa@suse.de> <1221487652.10177.23.camel@localhost.localdomain>
In-Reply-To: <1221487652.10177.23.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200809151710.43827.hs4233@mail.mn-solutions.de> (sfid-20080915_171111_190479_91FC3591)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> So why does this need a new event?  Can't wpa_supplicant
> monitor the signal quality (or level/noise if the driver
> doesn't provide "quality") and do what it needs to do without
> any changes to the kernel at all?

It could, but to do this, wpa_supplicant (or whatever) would have 
to periodically get awake, send the query command to mac80211 
and get the result.

With an event, it just sits sleeping until some interesting event 
arrives. Nicer programming idiom, AFAIK.
