Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:1272 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752205AbZFPSzF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 14:55:05 -0400
Received: by yw-out-2324.google.com with SMTP id 5so3077067ywb.1
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2009 11:55:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1245177946.21287.42.camel@johannes.local>
References: <1245177064-31861-1-git-send-email-andrey@cozybit.com>
	 <1245177307.21287.34.camel@johannes.local>
	 <45e8e6c40906161142m759e6ecdgc6765333a4cced01@mail.gmail.com>
	 <1245177946.21287.42.camel@johannes.local>
Date: Tue, 16 Jun 2009 11:55:07 -0700
Message-ID: <45e8e6c40906161155i1e5dc5bag114dea7a8c6caa66@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: allow adding/deleting stations on mesh
From: Andrey Yurovsky <andrey@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 16, 2009 at 11:45 AM, Johannes
Berg<johannes@sipsolutions.net> wrote:
> On Tue, 2009-06-16 at 11:42 -0700, Andrey Yurovsky wrote:
>> On Tue, Jun 16, 2009 at 11:35 AM, Johannes
>> Berg<johannes@sipsolutions.net> wrote:
>> > On Tue, 2009-06-16 at 11:31 -0700, Andrey Yurovsky wrote:
>> >> Commit b2a151a288 added a check that prevents adding or deleting
>> >> stations on non-AP interfaces.  Adding and deleting stations is
>> >> supported for Mesh Point interfaces, so add Mesh Point to that check as
>> >> well.
>> >
>> > Why? Aren't those automatically discovered like IBSS peers?
>>
>> Yes, they normally are, however it's possible to turn that off from
>> user space (via iw).
>>
>> The reason for this is that it's useful to manually create mesh
>> topologies.  This is mostly for testing, verification, and
>> experimentation.  For example, you can manually create a topology
>> where you have two paths and you know one path is better than another
>> and then run a test script that verifies that the right path was
>> taken.  It could presumably also be used by some user-space "mesh
>> manager" similar to hostapd for APs.
>
> Ok, fair enough. There are a lot of quirks in the mesh API, one of these
> days I'd like to make it less like wext and have you join/leave like the
> ibss commands instead of setting each parameter one by one...

Thanks.  We'd like to hear about any quirks/issues as we have some
bandwidth to work on mesh again and we would like to address the
configuration/API issues.

  -Andrey
