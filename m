Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:56524 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750905AbaK0HM2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Nov 2014 02:12:28 -0500
Received: by mail-wi0-f178.google.com with SMTP id hi2so7290613wib.5
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2014 23:12:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAB=NE6VXWdjE=ZJvjJ4K56vXMZvi15j2WLi7Vj6cOkA=X2ArOA@mail.gmail.com>
References: <1417035388-2511-1-git-send-email-arik@wizery.com>
 <1417035388-2511-3-git-send-email-arik@wizery.com> <20141126213531.GT25677@wotan.suse.de>
 <CAB=NE6VXWdjE=ZJvjJ4K56vXMZvi15j2WLi7Vj6cOkA=X2ArOA@mail.gmail.com>
From: Arik Nemtsov <arik@wizery.com>
Date: Thu, 27 Nov 2014 09:12:11 +0200
Message-ID: <CA+XVXff=pj-etCQ=p7wHUBPPJPCQTvf2wsGiS9eXrrGCf661sA@mail.gmail.com> (sfid-20141127_081231_507213_D49ABB0A)
Subject: Re: [PATCH v4 3/4] cfg80211: allow usermode to query wiphy specific regdom
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Nov 26, 2014 at 11:43 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Wed, Nov 26, 2014 at 4:35 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
>> We're not checking here if this was a managed wiphy or not, we
>> want userspace to be able to tell if a wiphy was managed or not.
>
> Ah I see what you did, yes that is what I wanted but since you allowed
> for self managed regdomains *first* the placement of this patch in
> terms of order would mean we are not giving userspace information it
> should have needed right after this commit. After your 4th patch we do
> though. We want commits to work well linearly in history so can you
> move this patch to number 2 in the series and bump number 2 to be
> patch number 3? That way right after commit 2 we are not lying to
> userspace.
>
> The question about having userspace specify the wiphy still stands as
> I'd expect userspace asking only for a regd for a wiphy would want
> only that one, not all, or the central one.

In general, we want to return only the regdom of the wiphy the user
asked for. And yea, I'll fix it.

But there's a tricky part here. In the not-self-managed case, if a
user specifies a wiphy-idx, and there's no wiphy->regd, we'll return
the global one.
This is fine, since in effect, the global regd is the one used by this
wiphy anyway.
Essentially we want this part to just be able to add the wiphy-idx to
wpa_s code for GET_REG, and remain backward compatible. But like I
said above, it's the right thing to do.

Arik
