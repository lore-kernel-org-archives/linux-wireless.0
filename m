Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp-out.google.com ([74.125.121.67]:47864 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab1CVOd5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Mar 2011 10:33:57 -0400
Received: from hpaq14.eem.corp.google.com (hpaq14.eem.corp.google.com [172.25.149.14])
	by smtp-out.google.com with ESMTP id p2MEXuGl020280
	for <linux-wireless@vger.kernel.org>; Tue, 22 Mar 2011 07:33:56 -0700
Received: from gwb17 (gwb17.prod.google.com [10.200.2.17])
	by hpaq14.eem.corp.google.com with ESMTP id p2MEWwBJ019198
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Tue, 22 Mar 2011 07:33:55 -0700
Received: by gwb17 with SMTP id 17so4374936gwb.1
        for <linux-wireless@vger.kernel.org>; Tue, 22 Mar 2011 07:33:55 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1300800933.3746.5.camel@jlt3.sipsolutions.net>
References: <20110321213812.76CD420891@glenhelen.mtv.corp.google.com>
	<1300800933.3746.5.camel@jlt3.sipsolutions.net>
Date: Tue, 22 Mar 2011 07:33:54 -0700
Message-ID: <AANLkTi=4QLfpeAKCiAxDYcL8dGNbWdaxE3OVic7obe_B@mail.gmail.com>
Subject: Re: [PATCH 0/4] Add station BSS parameters to station
From: Paul Stewart <pstew@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 22, 2011 at 6:35 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2011-03-21 at 14:32 -0700, Paul Stewart wrote:
>> This allows user-space monitoring of BSS parameters for the associated
>> station.  This is useful for debugging and verifying that the paramaters
>> are as expected.
>
> Nice set of patches, but I'm wondering if the station info really is the
> best place to put this information? It's not really strictly information
> about the station, but rather about the BSS that it created. OTOH, I'm
> not sure if we need to distinguish?

I think it makes sense in a way.  This is the station's view of the
BSS once it is associated.  In fact, the primary use intended for this
is to verify that the station's view of the BSS parameters matches
that of the AP.  After looking a little closer, it looks more for iw,
it should show up in the output of "iw link", as part of the output of
the hidden "iw link get_sta" command, but from the kernel perspective,
the API would be the same.

--
Paul
