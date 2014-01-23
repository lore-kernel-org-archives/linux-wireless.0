Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:45088 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaAWMJ1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 07:09:27 -0500
Message-ID: <1390478961.4142.12.camel@jlt4.sipsolutions.net> (sfid-20140123_130930_498582_8DF207AD)
Subject: Re: [PATCH 5/7] mac80211: improve CSA locking
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: Luca Coelho <luca@coelho.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Otcheretianski, Andrei" <andrei.otcheretianski@intel.com>
Date: Thu, 23 Jan 2014 13:09:21 +0100
In-Reply-To: <CA+BoTQn-wjQYfUVxJU+xOUoANKE=8ajmq=ytmzAqVuiqMXJj=w@mail.gmail.com> (sfid-20140123_085715_974773_1D88AF38)
References: <1390227670-19030-1-git-send-email-michal.kazior@tieto.com>
	 <1390227670-19030-6-git-send-email-michal.kazior@tieto.com>
	 <1390316761.6199.27.camel@jlt4.sipsolutions.net>
	 <CA+BoTQmsROawL=bcyiXM+zCWKfKr7KPRvDoojKfoCByV97zSUw@mail.gmail.com>
	 <1390380726.4334.4.camel@jlt4.sipsolutions.net>
	 <CA+BoTQm+DipFGQhVnGoVM4JvLgXZv1EZ0Ve4UNnFwnifsKXoCA@mail.gmail.com>
	 <1390382020.4334.17.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=iQ26EMyOS4Eroqf2G-uLtUUZHAxN6rD3Eq6CvSUj5Xg@mail.gmail.com>
	 <1390385995.4334.27.camel@jlt4.sipsolutions.net>
	 <1390394166.4189.28.camel@porter.coelho.fi>
	 <1390403432.4334.33.camel@jlt4.sipsolutions.net>
	 <1390403634.4189.39.camel@porter.coelho.fi>
	 <CA+BoTQ=+TGFo0f0z1SymiN5DkeLZUPC_p_YVZ59s=FFqpGV3vQ@mail.gmail.com>
	 <1390458664.4189.48.camel@porter.coelho.fi>
	 <CA+BoTQnyd5HQxU9n=7G8bhJTukMJqZwNmD1FgWowHm2LJ=NUsA@mail.gmail.com>
	 <1390462306.4189.56.camel@porter.coelho.fi>
	 <CA+BoTQn-wjQYfUVxJU+xOUoANKE=8ajmq=ytmzAqVuiqMXJj=w@mail.gmail.com>
	 (sfid-20140123_085715_974773_1D88AF38)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2014-01-23 at 08:57 +0100, Michal Kazior wrote:

> This is actually the tricky part. How do you automatically switch an
> AP interface? You should be able to at least generate CSA IE - true -
> but what about beacon after CSA? You need to update HT IE and VHT IE
> at least.
> 
> Perhaps we could split CSA into two parts somehow and make it more
> userspace coordinated. The first part of CSA - announcing it, is
> trivial and can actually be done entirely within mac80211 if I'm not
> mistaken. What needs userspace input is what happens after the
> announcement. This would mean that there is a possible time gap
> between announcement being completed and the actual channel switch &
> operation resuming.

I believe that even announcing it isn't necessarily possible without
userspace involvement, particularly for things like 11ac's channel
switch wrapper IE and/or operating class changes.

johannes

