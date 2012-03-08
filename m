Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39040 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754104Ab2CHSxd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 8 Mar 2012 13:53:33 -0500
Received: by mail-iy0-f174.google.com with SMTP id z16so1053560iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 08 Mar 2012 10:53:33 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20120308174101.GB28133@ubuntu-macmini>
References: <20120307194001.GA2506@ubuntu-macmini> <20120308174101.GB28133@ubuntu-macmini>
From: "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>
Date: Thu, 8 Mar 2012 10:53:13 -0800
Message-ID: <CAB=NE6VapPfLjAh5Y+sCA4qA82s9HrQk_Mxr8FpKoCfjudMDig@mail.gmail.com> (sfid-20120308_195341_224366_30E32676)
Subject: Re: Problems with regulatory domain support and BCM43224
To: Seth Forshee <seth.forshee@canonical.com>,
	David Quan <dquan@qca.qualcomm.com>,
	Michael Green <green@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

David, Michael,

below is a thread on world regulatory domains and DFS. This is a
public thread so replying to this is public. The question is simple:
why not add DFS channels to the world regulatory domain provided that
1) we only passive scan on them 2) STA does support DFS support. It
seems logical to me now that this should be enabled, but I can't
recall if perhaps I am forgetting something.

The beacon hint code we have, which enables radiation upon finding a
beacon from an AP on a 5 GHz channel only does beacon hints for
non-DFS channels, so a device using the world regulatory domain is
guaranteed to not initiate radiation on these channels.

Seth, my response to you below.

On Thu, Mar 8, 2012 at 9:41 AM, Seth Forshee <seth.forshee@canonical.com> wrote:
> As I understand it, the DFS channels aren't included in the world domain
> because Linux does not yet fully support DFS.

A STA device can connect to a DFS AP when the STA device does have
those DFS channels as part of its world regulatory domain, but the STA
will passively scan on those channels given that sending a probe
request is active radiation and active radiation requires a bit of
code which is not yet complete and only used as a AP. You are right
though that the Linux regulatory code though does not include any DFS
channels in the world regulatory domain. The world regulatory domain
is the mathematical intersection of all the regulatory domains in the
world (see intersect.c on CRDA) but a few set of channels were added
as well which are not DFS with the condition that we do passive scans.
We did remove the DFS channels completely.

> But I can then specify a
> domain that's known to require DFS on these channels, and they are
> enabled. This seems illogical. If passive scanning is okay when we know
> DFS is required, why can't it be enabled in the world domain when we
> simply don't know if it's required?

Its a fair point and given the way we handle beacon hints and not
enabling them for DFS channels at all, and if we only passively scan
for DFS channels I think this should be good.

  Luis
