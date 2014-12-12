Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33207 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967475AbaLLMl5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2014 07:41:57 -0500
Message-ID: <1418388114.2470.34.camel@sipsolutions.net> (sfid-20141212_134159_670033_B23B733A)
Subject: Re: [PATCH] cfg80211: avoid intersection when applying custom reg
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Date: Fri, 12 Dec 2014 13:41:54 +0100
In-Reply-To: <1417968225-17518-1-git-send-email-arik@wizery.com> (sfid-20141207_170350_677767_29EEFA25)
References: <1417968225-17518-1-git-send-email-arik@wizery.com>
	 (sfid-20141207_170350_677767_29EEFA25)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-12-07 at 18:03 +0200, Arik Nemtsov wrote:
> The custom-reg handling function can currently only add flags to a given
> channel. This results in stale flags being left applied. In some cases
> a channel was disabled and even the orig_flags were changed to reflect
> this.
> 
> Previously the API was designed for a single invocation before wiphy
> registration, so this didn't matter. The previous approach doesn't scale
> well to self-managed regulatory devices, particularly when a more
> permissive regdom is applied after a restrictive one.

This description (not the patch) only makes sense after the other series
with self-managed, please resend it in the self-managed patchset.

johannes

