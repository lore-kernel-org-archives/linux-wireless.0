Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:39742 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932373AbaICMdA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2014 08:33:00 -0400
Received: by mail-qc0-f176.google.com with SMTP id m20so8343625qcx.7
        for <linux-wireless@vger.kernel.org>; Wed, 03 Sep 2014 05:32:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1409747141.911.15.camel@jlt4.sipsolutions.net>
References: <2937689.hWkxdbjQ3v@rogge-hp-probook-6470b> <1409745133.911.7.camel@jlt4.sipsolutions.net>
 <CAGnRvurXEzkekvYA2bLnObNMpxytH0G1tgXnF5c=90wBCoWmRA@mail.gmail.com> <1409747141.911.15.camel@jlt4.sipsolutions.net>
From: Henning Rogge <hrogge@gmail.com>
Date: Wed, 3 Sep 2014 14:32:39 +0200
Message-ID: <CAGnRvur4g03Ut1fiMybUy=zdA=ponAMQKbd-vc_i1RaQsThJhQ@mail.gmail.com> (sfid-20140903_150113_679102_1E0415CD)
Subject: Re: [Patch]mac80211: Add support for mesh proxy path dump
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Yeoh Chun-Yeow <yeohchunyeow@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 3, 2014 at 2:25 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
>> First patch to define the two new cfg80211_ops and the necessary
>> nl80211/tracing helper functions, second patch that implements
>> get_mpp() and dump_mpp() functions?
>
> Right. That way you have one patch that defines the API etc., and
> another that implements it, and it's easier to review and document the
> APIs in the right places etc.
>
> I don't always insist on this, but it's a pretty big patch so I'd prefer
> it this way (and it also should be almost trivial to split)

Yes, should be easy. I will come back to the list with a "v2" set of patches.

>> mpath and mpp use the same storage object (struct mesh_path), so I
>> reused the mpath_info struct. As far as I can see its just a "transfer
>> object" between for cfg80211 that temporarily stores data from the
>> cfg80211_ops for nl80211 messages.
>
> Indeed, it is.
>
>> Shall I create a new struct for the two new cfg80211_ops?
>
> No need, I just wasn't sure it really needed the same data so figured
> I'd ask.

At the moment I don't use much of the mpath_info field... but I think
the mpp operations will always use a subset of the mpath fields, so we
can reuse the nl80211 encoding function by reusing the struct. If this
changes it would be trivial to switch to a different struct, because
its not visible from userspace.

Henning
