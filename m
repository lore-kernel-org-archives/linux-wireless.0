Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38096 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750936AbaLNK2s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Dec 2014 05:28:48 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so6277480wiv.11
        for <linux-wireless@vger.kernel.org>; Sun, 14 Dec 2014 02:28:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1418388114.2470.34.camel@sipsolutions.net>
References: <1417968225-17518-1-git-send-email-arik@wizery.com> <1418388114.2470.34.camel@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 14 Dec 2014 12:28:32 +0200
Message-ID: <CA+XVXfc=1mm5cUaFqb5zbg7ZO9Hnyq9ofXvFzy=fZkaCnguQ8g@mail.gmail.com> (sfid-20141214_113239_514034_CD208F88)
Subject: Re: [PATCH] cfg80211: avoid intersection when applying custom reg
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 12, 2014 at 2:41 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> On Sun, 2014-12-07 at 18:03 +0200, Arik Nemtsov wrote:
> > The custom-reg handling function can currently only add flags to a given
> > channel. This results in stale flags being left applied. In some cases
> > a channel was disabled and even the orig_flags were changed to reflect
> > this.
> >
> > Previously the API was designed for a single invocation before wiphy
> > registration, so this didn't matter. The previous approach doesn't scale
> > well to self-managed regulatory devices, particularly when a more
> > permissive regdom is applied after a restrictive one.
>
> This description (not the patch) only makes sense after the other series
> with self-managed, please resend it in the self-managed patchset.

Sure. I'll also make it self-managed only, so avoid possible
regressions, as Luis commented.

Arik
