Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:36315 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161190Ab2JXVzZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Oct 2012 17:55:25 -0400
Received: by mail-oa0-f46.google.com with SMTP id h16so968090oag.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Oct 2012 14:55:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1350912590.10166.9.camel@jlt4.sipsolutions.net>
References: <1350654441-6761-1-git-send-email-johannes@sipsolutions.net>
	<CAB3XZEc0PbzcCFfkabEg9UfwnCizKGvKEhZ_iYfMA6QC=xcxFw@mail.gmail.com>
	<1350912590.10166.9.camel@jlt4.sipsolutions.net>
Date: Wed, 24 Oct 2012 23:55:25 +0200
Message-ID: <CAB3XZEfh9+S_PfYfVTYToJ-G46s6r8ZtnKDbgtJOnvbGDFue9g@mail.gmail.com> (sfid-20121025_000044_922933_02F4E393)
Subject: Re: [RFC] mac80211: add explicit AP/GO driver operations
From: Eliad Peller <eliad@wizery.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, ilan.peer@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 22, 2012 at 3:29 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>> what about other direct notification of BSS_CHANGED_BEACON_ENABLED
>> (like in offchannel and ieee80211_do_stop)? should we call
>> start_ap/stop_ap there as well?
>
> The one in do_stop() should probably just be cleaned up, cfg80211 will
> now stop the AP operation while the interface goes down ... so that
> won't actually do anything, but could be a concern for the old API
> because it might cause an off/off transition.
>
cool.

> For offchannel, I'm not sure. Does it really make sense to call it
> there? I can do it, I suppose, but ... hmm. The software-offchannel
> hopefully won't actually be needed much longer given channel
> contexts ;-)
:)
i guess skipping these calls on software-offchannel transitions is
reasonable, but it's worth documenting it (as it's different from
BSS_CHANGED_BEACON_ENABLED notifications).

Eliad.
