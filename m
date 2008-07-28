Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:33015 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750790AbYG1NpA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Jul 2008 09:45:00 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 1/6] mac80211: allow no mac address until firmware load
Date: Mon, 28 Jul 2008 15:44:33 +0200
Cc: Dan Williams <dcbw@redhat.com>,
	Luis Carlos Cobo <luisca@cozybit.com>,
	linux-wireless@vger.kernel.org
References: <48763814.27052c0a.1794.2095@mx.google.com> <1217172136.2700.21.camel@localhost.localdomain> <1217251433.12662.5.camel@johannes.berg>
In-Reply-To: <1217251433.12662.5.camel@johannes.berg>
MIME-Version: 1.0
Message-Id: <200807281544.33509.mb@bu3sch.de> (sfid-20080728_154505_121256_3A3A779A)
Content-Type: text/plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 28 July 2008 15:23:53 Johannes Berg wrote:
> On Sun, 2008-07-27 at 11:22 -0400, Dan Williams wrote:
> > On Thu, 2008-07-10 at 16:57 +0200, Luis Carlos Cobo wrote:
> > > Originally by Johannes Berg. This patch adds support for devices that do not
> > > report their MAC address until the firmware is loaded. While the address is not
> > > known, a multicast on is used.
> > 
> > Johannes, thoughts on this?  Is there a better way to do it for devices
> > that don't know their MAC address until firmware load?
> 
> I actually wrote this patch, but largely I don't care. It seemed that
> having unique MAC addresses would screw up less with udev, but maybe we
> can just leave it zeroed until we know?

Well, I think that really is pretty weird and it is confusing to the
user to see that pseudo random MAC that changes suddenly when the device is
initialized. For the human user (so everybody but me), it would be better
to have the MAC all-zeros until the firmware loaded. So it would be obvious
that the MAC is not set, yet. I think userspace
tools should just be fixed, if they have problems with that.
(What are the udev problems, btw?)

-- 
Greetings Michael.
