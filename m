Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:53595 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767367AbXCIQa0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Mar 2007 11:30:26 -0500
Received: by nf-out-0910.google.com with SMTP id o25so1132061nfa
        for <linux-wireless@vger.kernel.org>; Fri, 09 Mar 2007 08:30:25 -0800 (PST)
To: Michael Buesch <mb@bu3sch.de>
Subject: Re: [PATCH] mac80211: Prevent unregistering of unregistered hw
Date: Fri, 9 Mar 2007 17:30:06 +0100
Cc: "John Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200703091614.04526.IvDoorn@gmail.com> <200703091646.05292.mb@bu3sch.de>
In-Reply-To: <200703091646.05292.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200703091730.06796.IvDoorn@gmail.com>
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 09 March 2007 16:46, Michael Buesch wrote:
> On Friday 09 March 2007 16:14, Ivo van Doorn wrote:
> > At the moment it is possible to call ieee80211_unregister_hw()
> > for an unregistered hw structure. This will cause a big panic.
> > This patch will add a check to check if IEEE80211_DEV_REGISTERED
> > has been set before attempting to unregister hw.
> 
> For which reason would a driver call unregister, but not register before?

Well it occurred in rt2x00 during errors during initialization,
instead of using goto's to step by step free all allocated memory and unregistration
the main free_dev() was called. And there isn't a way for the driver to check
if the hw has been registered or not without creating new flags for it.
But since mac80211 already is using such a flag internally, it would sound like
more sense to make the check in there.

> I smell design problems in the driver ;)

True, there are different approaches to take care of this inside the driver,
but I think this check is sane enough as well. ;)

Ivo
