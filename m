Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:49879 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582AbZFPTjQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Jun 2009 15:39:16 -0400
Received: by gxk10 with SMTP id 10so8121987gxk.13
        for <linux-wireless@vger.kernel.org>; Tue, 16 Jun 2009 12:39:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1245178613.21287.45.camel@johannes.local>
References: <1245177064-31861-1-git-send-email-andrey@cozybit.com>
	 <1245177307.21287.34.camel@johannes.local>
	 <45e8e6c40906161142m759e6ecdgc6765333a4cced01@mail.gmail.com>
	 <1245177946.21287.42.camel@johannes.local>
	 <45e8e6c40906161155i1e5dc5bag114dea7a8c6caa66@mail.gmail.com>
	 <1245178613.21287.45.camel@johannes.local>
Date: Tue, 16 Jun 2009 12:32:20 -0700
Message-ID: <445f43ac0906161232x743d7ab9u2f36a5893240b789@mail.gmail.com>
Subject: Re: [PATCH] cfg80211: allow adding/deleting stations on mesh
From: Javier Cardona <javier@cozybit.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>,
	devel@lists.open80211s.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes,

On Tue, Jun 16, 2009 at 11:56 AM, Johannes
Berg<johannes@sipsolutions.net> wrote:
> On Tue, 2009-06-16 at 11:55 -0700, Andrey Yurovsky wrote:
>
>> > Ok, fair enough. There are a lot of quirks in the mesh API, one of these
>> > days I'd like to make it less like wext and have you join/leave like the
>> > ibss commands instead of setting each parameter one by one...
>>
>> Thanks.  We'd like to hear about any quirks/issues as we have some
>> bandwidth to work on mesh again and we would like to address the
>> configuration/API issues.
>
> Well mostly it's the thing with configuration parameters affecting the
> interface "on the fly". But I'm not familiar enough with all of the
> parameters to actually know which ones _can_ change on the fly, and
> which ones change and thereby make you part of a different mesh.

There are some mesh parameters that you would probably want to be
uniform across the mesh network (timeouts, number of retries, etc).
But the only mesh parameter that would result in a different mesh
network is the mesh_id, and that's only settable when the mesh
interface is created.

Do you have a specific configuration parameter in mind?

Cheers,

Javier
