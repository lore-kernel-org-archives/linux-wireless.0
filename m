Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.190]:18013 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbXLWWKP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 23 Dec 2007 17:10:15 -0500
Received: by mu-out-0910.google.com with SMTP id i10so1143223mue.5
        for <linux-wireless@vger.kernel.org>; Sun, 23 Dec 2007 14:10:13 -0800 (PST)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] mac80211: add unified BSS configuration
Date: Sun, 23 Dec 2007 23:10:36 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Ron Rindjunsky <ron.rindjunsky@intel.com>,
	Michael Wu <flamingice@sourmilk.net>,
	Tomas Winkler <tomasw@gmail.com>
References: <1198109817.16241.7.camel@johannes.berg>
In-Reply-To: <1198109817.16241.7.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200712232310.36974.IvDoorn@gmail.com> (sfid-20071223_221026_659169_9F9DCB95)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 20 December 2007, Johannes Berg wrote:
> This patch (based on Ron Rindjunsky's) creates a framework for
> a unified way to pass BSS configuration to drivers that require
> the information, e.g. for implementing power save mode.
> 
> A new ieee80211_bss_conf structure is embedded into each virtual
> interface structure to allow the driver to access the BSS
> configuration at any time, changes in the structure are passed
> to the driver via the new bss_info_changed() callback.
> 
> This new BSS configuration infrastructure adds the following
> new features:
>  * drivers are notified of their association AID
>  * drivers are notified of association status
> 
> and replaces the erp_ie_changed() callback. The patch also does
> the relevant driver updates for the latter change.
> 
> Signed-off-by: Ron Rindjunsky <ron.rindjunsky@intel.com>
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> ---
> Ivo, can you see if you can address the FIXME item in the rt2x00 driver?
> It is probably very easy but I don't know how you'd want to handle it.

Sure, I'll look into it. I also have to lookup what parts of the rt2x00 can
now be optimized because the assocation state is known as well. :)
Patch will follow soon. :)

Ivo
