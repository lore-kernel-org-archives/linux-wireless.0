Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:43493 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752097AbbEZOag (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2015 10:30:36 -0400
Message-ID: <1432650631.5169.11.camel@sipsolutions.net> (sfid-20150526_163047_004951_A9B83CFC)
Subject: Re: [PATCH 5/6] mwifiex: use generic name 'device dump'
From: Johannes Berg <johannes@sipsolutions.net>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
	Avinash Patil <patila@marvell.com>
Date: Tue, 26 May 2015 16:30:31 +0200
In-Reply-To: <1432647272-5734-6-git-send-email-akarwar@marvell.com> (sfid-20150526_153538_730660_141E53A3)
References: <1432647272-5734-1-git-send-email-akarwar@marvell.com>
	 <1432647272-5734-6-git-send-email-akarwar@marvell.com>
	 (sfid-20150526_153538_730660_141E53A3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-05-26 at 06:34 -0700, Amitkumar Karwar wrote:
> Currently we are dumping driver information also inside
> firmware dump API. We will call it as device dump and
> dump driver and firmware data separately.

Honestly, I don't think this matters. I called it 'devcoredump' or
'device' because there were people saying it might be used to dump
hardware state, rather than firmware state (my original thought was to
call the framework 'fwcoredump')

In your driver, it's really only dumping firmware state (as far as I can
tell), so I don't think the name matters.

If you prefer "device dump" that's surely fine, but changing all the
debugfs file names etc. just because I called the framework
"devcoredump" isn't really needed I think :)

Note that the framework is really also built to support "spontaneous"
data collection, e.g. when the driver noticed the firmware doing
something strange. You seem to support "user-triggered" only, which is
perfectly reasonable again if you want it, but not necessary.

johannes


