Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2805 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751569AbZAFSDI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 13:03:08 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-wireless@vger.kernel.org, mabbaswireless@gmail.com
Subject: Re: [PATCH v2 0/3] mac80211 suspend/resume
Date: Tue, 6 Jan 2009 13:01:00 -0500
Message-Id: <20090106174830.M95524@bobcopeland.com> (sfid-20090106_190313_967720_5D5E0C7C)
In-Reply-To: <1231263802.3654.8.camel@johannes>
References: <1229313039-5544-1-git-send-email-me@bobcopeland.com> <1229336057.4471.9.camel@johannes.berg> <1229354532.12163.24.camel@localhost.localdomain> <20081217174244.M36761@bobcopeland.com> <1230064216.31228.46.camel@johannes> <20081224054951.GA32398@hash.localnet> <1230102989.16960.14.camel@californication> <1231260306.14565.21.camel@localhost.localdomain> <20090106165434.M2397@bobcopeland.com> <1231262082.3654.5.camel@johannes> <20090106172758.M47578@bobcopeland.com> <1231263802.3654.8.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 06 Jan 2009 18:43:22 +0100, Johannes Berg wrote
> We should probably take the rtnl anyway though to be prepared for when
> userspace is not suspended.. Need to think about that more though, and
> possibly add a new "suspended" flag that makes it block all
> configuration attempts.

Well, luckily we do take the rtnl already, wiphy_suspend() and _resume()
do that around the cfg ops.

IMHO a suspended flag would be extra complexity that we should just
hold off on until the freezer really is getting removed.

For now is there anything besides driver support we need to do for this
patchset?  I guess that the drivers will actually be OK as-is too unless
there are any that do release_firmware in ->stop(), but it will be nice
to clean them up.

-- 
Bob Copeland %% www.bobcopeland.com


