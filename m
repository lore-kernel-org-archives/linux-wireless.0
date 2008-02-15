Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail30f.wh2.ocn.ne.jp ([220.111.41.203]:14569 "HELO
	mail30f.wh2.ocn.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750999AbYBOBko (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Feb 2008 20:40:44 -0500
From: bruno randolf <bruno@thinktube.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Subject: Re: [PATCH] mac80211: enable IBSS merging
Date: Fri, 15 Feb 2008 10:40:34 +0900
Cc: "Jouni Malinen" <j@w1.fi>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Johannes Berg" <johannes@sipsolutions.net>, jirislaby@gmail.com,
	mickflemm@gmail.com, linux-wireless@vger.kernel.org,
	"Ivo van Doorn" <ivdoorn@gmail.com>,
	"Kishore Ramachandran" <kishore@winlab.rutgers.edu>,
	"Ivan Seskar" <Seskar@winlab.rutgers.edu>
References: <20080118125252.6455.41047.stgit@one> <200802121100.02259.bruno@thinktube.com> <43e72e890802141706v528489f5y8a46f13d87bebb62@mail.gmail.com>
In-Reply-To: <43e72e890802141706v528489f5y8a46f13d87bebb62@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200802151040.35031.bruno@thinktube.com> (sfid-20080215_014050_670685_27628306)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 15 February 2008 10:06:37 Luis R. Rodriguez wrote:
> >  i think the point here is that we still need to be prepared to merge
> > IBSS (i.e. switch to another BSSID when we receive a beacon with an older
> > TSF) no matter how we generate our own BSSID in the first place.
>
> Well that is still possible.
>
> >  using a hash of the BSSID and channel would reduce the necessity to
> > merge IBSS for mac80211 drivers but we still need to be able to join
> > older IBSS from other drivers.
>
> Sure, how is it that this prevents that?

it wouldn't :)

i agree to johannes approach to set the BSSID from userspace, so people can 
use all sorts of hashing algorithms to set the bssid. we could implement a 
default hashing algorithm in "iw" maybe, and introduce a flag "dont merge 
ibss" to prevent ibss merge for situations where we know we don't want 
that...

"iwconfig wlan0 ap xx:xx:xx:xx:xx:xx" doesn't work for ibss right now (i'll 
try to look into that today).

bruno


