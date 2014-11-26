Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:50770 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaKZVnz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2014 16:43:55 -0500
Received: by mail-la0-f47.google.com with SMTP id hz20so3125869lab.20
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2014 13:43:54 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141126213531.GT25677@wotan.suse.de>
References: <1417035388-2511-1-git-send-email-arik@wizery.com>
 <1417035388-2511-3-git-send-email-arik@wizery.com> <20141126213531.GT25677@wotan.suse.de>
From: "Luis R. Rodriguez" <mcgrof@suse.com>
Date: Wed, 26 Nov 2014 16:43:33 -0500
Message-ID: <CAB=NE6VXWdjE=ZJvjJ4K56vXMZvi15j2WLi7Vj6cOkA=X2ArOA@mail.gmail.com> (sfid-20141126_224359_126164_E5106AD7)
Subject: Re: [PATCH v4 3/4] cfg80211: allow usermode to query wiphy specific regdom
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 26, 2014 at 4:35 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> We're not checking here if this was a managed wiphy or not, we
> want userspace to be able to tell if a wiphy was managed or not.

Ah I see what you did, yes that is what I wanted but since you allowed
for self managed regdomains *first* the placement of this patch in
terms of order would mean we are not giving userspace information it
should have needed right after this commit. After your 4th patch we do
though. We want commits to work well linearly in history so can you
move this patch to number 2 in the series and bump number 2 to be
patch number 3? That way right after commit 2 we are not lying to
userspace.

The question about having userspace specify the wiphy still stands as
I'd expect userspace asking only for a regd for a wiphy would want
only that one, not all, or the central one.

 Luis
