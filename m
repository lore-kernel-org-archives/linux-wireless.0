Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:54382 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752772AbaKDQFN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Nov 2014 11:05:13 -0500
Message-ID: <1415117110.2064.21.camel@sipsolutions.net> (sfid-20141104_170619_774246_6E3F7379)
Subject: Re: [PATCH] cfg80211: fix nl80211 cmd id in nl80211_send_mpath()
From: Johannes Berg <johannes@sipsolutions.net>
To: Henning Rogge <hrogge@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Date: Tue, 04 Nov 2014 17:05:10 +0100
In-Reply-To: <CAGnRvuo4TzrwSfQF5SUKUKptvFxEeqVTx9zg3KfGnEU=aokyQA@mail.gmail.com> (sfid-20141104_165716_359630_3B8E329C)
References: <1415114098-25517-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
	 <1415115463.2064.20.camel@sipsolutions.net>
	 <CAGnRvuo4TzrwSfQF5SUKUKptvFxEeqVTx9zg3KfGnEU=aokyQA@mail.gmail.com>
	 (sfid-20141104_165716_359630_3B8E329C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-11-04 at 16:56 +0100, Henning Rogge wrote:
> Hi,
> 
> the only reason why nobody noticed is that the "iw" tool does not even
> check the cmd field of the kernel replies it process. I wonder if "iw"
> should check the value, just to make sure bugs like this are easier to
> detect.

It doesn't really have to since it's not processing events on the same
socket ... but maybe we should just add some sanity checks.

johannes

