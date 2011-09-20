Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qy0-f181.google.com ([209.85.216.181]:52286 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242Ab1ITSMz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Sep 2011 14:12:55 -0400
Received: by qyk7 with SMTP id 7so826343qyk.19
        for <linux-wireless@vger.kernel.org>; Tue, 20 Sep 2011 11:12:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1316521312.3953.27.camel@jlt3.sipsolutions.net>
References: <35635039ce7d4a79dc62b19d51ccf0d5d4838112.1316297595.git.an.alexsimon@googlemail.com>
 <loom.20110918T004437-426@post.gmane.org> <1316437459.5995.29.camel@jlt3.sipsolutions.net>
 <36569806.Rgjanm0GiI@alex-1> <1316521312.3953.27.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Tue, 20 Sep 2011 11:12:34 -0700
Message-ID: <CAB=NE6VDSTAKK0pmyBOz6hw1pbxo7U6dxbrvg_F-y6CDB0paKw@mail.gmail.com> (sfid-20110920_201258_559868_CBD50368)
Subject: Re: [PATCH v3 3/3] mac80211: Add HT operation modes for IBSS
To: Johannes Berg <johannes@sipsolutions.net>,
	Javier Cardona <javier@cozybit.com>
Cc: Alexander Simon <an.alexsimon@googlemail.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 20, 2011 at 5:21 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2011-09-19 at 17:46 +0200, Alexander Simon wrote:
> That seems pretty complex too ...
>
> I don't really know. As I said, I think I'd be happy with an
> implementation that maybe doesn't fully implement everything as long as
> it considers the trade-offs.

The same questions come up with HT support and 802.11s, as per Javier
this is not really well spelled out in the spec. My recommendation is
to just support for now the most simple case and let us not entangle
ourselves with the complexities of handling trying to merge different
setups. So only enable peering up for adhoc or mesh if and only if the
observed IE matches our own supported HT caps or target configuration.
If a legacy STA tries to peer up with an HT IBSS, this would simply be
rejected. We can leave off handling the change in configuration later
for userspace, but do not see this as being a requirement for
supporting HT for IBSS or Mesh. The simpler the better, so long as we
simply respect the spec.

  Luis
