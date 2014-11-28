Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f182.google.com ([209.85.212.182]:37521 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750957AbaK1Hbb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 28 Nov 2014 02:31:31 -0500
Received: by mail-wi0-f182.google.com with SMTP id h11so10276215wiw.15
        for <linux-wireless@vger.kernel.org>; Thu, 27 Nov 2014 23:31:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20141127153529.GU25677@wotan.suse.de>
References: <1417035388-2511-1-git-send-email-arik@wizery.com>
 <1417035388-2511-3-git-send-email-arik@wizery.com> <20141126213531.GT25677@wotan.suse.de>
 <CAB=NE6VXWdjE=ZJvjJ4K56vXMZvi15j2WLi7Vj6cOkA=X2ArOA@mail.gmail.com>
 <CA+XVXff=pj-etCQ=p7wHUBPPJPCQTvf2wsGiS9eXrrGCf661sA@mail.gmail.com> <20141127153529.GU25677@wotan.suse.de>
From: Arik Nemtsov <arik@wizery.com>
Date: Fri, 28 Nov 2014 09:31:15 +0200
Message-ID: <CA+XVXffjVgoWv+msaDWkh58q7mo-PSO4FxwFFbEHuhR2rC6tAg@mail.gmail.com> (sfid-20141128_083135_109658_33F7F48C)
Subject: Re: [PATCH v4 3/4] cfg80211: allow usermode to query wiphy specific regdom
To: "Luis R. Rodriguez" <mcgrof@suse.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 27, 2014 at 5:35 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
> On Thu, Nov 27, 2014 at 09:12:11AM +0200, Arik Nemtsov wrote:
>> On Wed, Nov 26, 2014 at 11:43 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
>> > On Wed, Nov 26, 2014 at 4:35 PM, Luis R. Rodriguez <mcgrof@suse.com> wrote:
>> >> We're not checking here if this was a managed wiphy or not, we
>> >> want userspace to be able to tell if a wiphy was managed or not.
>> >
>> > Ah I see what you did, yes that is what I wanted but since you allowed
>> > for self managed regdomains *first* the placement of this patch in
>> > terms of order would mean we are not giving userspace information it
>> > should have needed right after this commit. After your 4th patch we do
>> > though. We want commits to work well linearly in history so can you
>> > move this patch to number 2 in the series and bump number 2 to be
>> > patch number 3? That way right after commit 2 we are not lying to
>> > userspace.
>> >
>> > The question about having userspace specify the wiphy still stands as
>> > I'd expect userspace asking only for a regd for a wiphy would want
>> > only that one, not all, or the central one.
>>
>> In general, we want to return only the regdom of the wiphy the user
>> asked for. And yea, I'll fix it.
>>
>> But there's a tricky part here. In the not-self-managed case, if a
>> user specifies a wiphy-idx, and there's no wiphy->regd, we'll return
>> the global one.
>
> Hm, that's fine if its well understood by userspace that even if
> a wiphy has a specific regd (priv one) that the central one is the one that is
> used for it anyway, the wiphy regd would just be informational. It may be
> a bit odd to give the central one if the wiphy-idx has no regd in this
> case then, so just think about this a bit, wihch is why I am a bit
> inclined to just have cfg80211 not return any regd if the wiphy has
> no priv or self-manged regd.
>
>> This is fine, since in effect, the global regd is the one used by this
>> wiphy anyway.
>> Essentially we want this part to just be able to add the wiphy-idx to
>> wpa_s code for GET_REG, and remain backward compatible. But like I
>> said above, it's the right thing to do
>
> Sure, you have a handle of what is needed, so just make the API very
> clear to users so they don't think that if cfg80211 returns a regd
> for a wiphy if its a priv regd that its not the one that applies
> but rather informational for what it started with.

Do you see a problem with v5 of the patches?

Arik
