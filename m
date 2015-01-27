Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:60014 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755745AbbA0Hjg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 02:39:36 -0500
Message-ID: <1422344369.1890.43.camel@sipsolutions.net> (sfid-20150127_083938_782977_EE84D326)
Subject: Re: cfg80211: Unknown symbol get_net_ns_by_fd (err 0)
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: Hauke Mehrtens <hauke@hauke-m.de>,
	"backports@vger.kernel.org" <backports@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Tue, 27 Jan 2015 08:39:29 +0100
In-Reply-To: <54C6A717.5050804@broadcom.com> (sfid-20150126_214412_608526_308C1470)
References: <54C6A717.5050804@broadcom.com>
	 (sfid-20150126_214412_608526_308C1470)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-01-26 at 21:44 +0100, Arend van Spriel wrote:
> Hi Hauke,
> 
> The commit below causes the error mentioned in the Subject: field. I 
> would like to fix this, but could use a bit of help here how to do this 
> type of things.
> 
> commit 4b681c82d2f9bef121c912ffcaac89a004af3f2c
> Author: Vadim Kochan <vadim4j@gmail.com>
> Date:   Mon Jan 12 16:34:05 2015 +0200
> 
>      nl80211: Allow set network namespace by fd

I don't think you can fix it in backports - it required exporting the
get_net_ns_by_fd() function, which cannot be gotten to otherwise and
cannot be backported since it internally uses a number of non-exported
symbols.

You'll probably just have to provide a backported version of
get_net_ns_by_fd() that always returns ERR_PTR(-EOPNOTSUPP) or so.

johannes

