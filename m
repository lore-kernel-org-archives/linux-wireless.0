Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.173]:4714 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401AbXB1Qyz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 11:54:55 -0500
Received: by ug-out-1314.google.com with SMTP id 44so169608uga
        for <linux-wireless@vger.kernel.org>; Wed, 28 Feb 2007 08:54:54 -0800 (PST)
Message-ID: <43e72e890702280854m763b401dmcb5e37599a42bb57@mail.gmail.com>
Date: Wed, 28 Feb 2007 11:54:50 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: Patch to allow specification of interface name prefix
Cc: "Jouni Malinen" <jkm@devicescape.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Jiri Benc" <jbenc@suse.cz>,
	"Stephen Hemminger" <shemminger@linux-foundation.org>,
	"Larry Finger" <larry.finger@lwfinger.net>,
	"Pavel Roskin" <proski@gnu.org>,
	"Alex Davis" <alex14641@yahoo.com>, linux-wireless@vger.kernel.org
In-Reply-To: <1172681452.5015.41.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
References: <510326.55988.qm@web50211.mail.yahoo.com>
	 <20070224233001.3ok4k0c00ksos4sw@webmail.spamcop.net>
	 <45E112F7.9090908@lwfinger.net> <20070226150241.1b5b63b2@freekitty>
	 <20070227111644.784600be@logostar.upir.cz>
	 <43e72e890702271055sc1525ecy54870626125a7fae@mail.gmail.com>
	 <20070228012500.GB4072@tuxdriver.com>
	 <20070228164437.GA31074@devicescape.com>
	 <1172681452.5015.41.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2/28/07, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Wed, 2007-02-28 at 08:44 -0800, Jouni Malinen wrote:
>
> > What's wrong with wlan#?
>
> Some people are anal about changing user-visible properties when one
> driver replaces another.

Nothing is wrong with it, that's perfectly fine. This is just a matter
of adopting a default convention for all wireless devices and sticking
to it. Old drivers used eth%d as the drivers mangled ethernet frames
and not wireless frames. With mac80211 wmaster handles wireless frames
directly but wlan%d handles ethernet frames. If we care more about
announcing a device is a wireless device is WLAN then lets go with
wlan%d, if we care more about implying what type of frames are being
passed to the device then eth%d seems more appropriate.

  Luis
