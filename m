Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f68.google.com ([209.85.215.68]:35527 "EHLO
	mail-lf0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751739AbcAWJjf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2016 04:39:35 -0500
Received: by mail-lf0-f68.google.com with SMTP id c134so5482353lfb.2
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2016 01:39:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160122203008.GA4621@localhost>
References: <1453190672-9748-1-git-send-email-henning.rogge@fkie.fraunhofer.de>
 <1453190672-9748-3-git-send-email-henning.rogge@fkie.fraunhofer.de> <20160122203008.GA4621@localhost>
From: Henning Rogge <hrogge@gmail.com>
Date: Sat, 23 Jan 2016 10:39:04 +0100
Message-ID: <CAGnRvur8eKjiwWCR69NESnMDQoA4qro1ryH=DoeMFRd1RPFKOQ@mail.gmail.com> (sfid-20160123_104019_314824_A149954B)
Subject: Re: [PATCH 2/2] mac80211: let unused MPP table entries timeout
To: Bob Copeland <me@bobcopeland.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	"David S. Miller" <davem@davemloft.net>,
	Henning Rogge <henning.rogge@fkie.fraunhofer.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jan 22, 2016 at 9:30 PM, Bob Copeland <me@bobcopeland.com> wrote:
> On Tue, Jan 19, 2016 at 09:04:32AM +0100, Henning Rogge wrote:
>> Remember the last time when a mpp table entry is used for
>> rx or tx and remove them after MESH_PATH_EXPIRE time.
>
> FYI I have a patch set I'm testing which rewrites a big chunk of
> the path table stuff.

Does it include some cleanup paths for the MPP table? At the moment
the "missing cleanup" still allows remote users to make the Linux
kernel to allocate as much memory as it wants... with no way to free
it except for shutting down the interface.

If you run a "meshed group of Access Points", any user of the AP could
run an attack on the kernel of all mesh nodes by changing its MAC
address very often.

> As I haven't posted it yet, I guess it doesn't matter if this
> goes in first or not, I can adjust -- but it will conflict as-is.
> I was hoping to post it early next week after a few fixes.
>
> Let me know if you want me to base on top.

I would like them to go in first... my experience of the kernel code
(outside some parts of the wifi stack) is not that good, so I don't
know how long I would need to adapt the patches to your new data
structures.

Most likely it is not that complicated, but I don't know.

> Shortlog looks like:
>
> Bob Copeland (6):
>       mac80211: mesh: move path tables into ieee82011_if_mesh
>       mac80211: mesh: don't hash subif data in mesh path tables
>       mac80211: mesh: factor out common mesh path allocation code
>       mac80211: mesh: embed known gates list in struct mesh_path
>       mac80211: mesh: convert path table to rhashtable
>       mac80211: mesh: get rid of write-only field mean_chain_len

Sounds useful, the 80211s data structures are really a mess.

Henning
