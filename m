Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2728 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750779AbYLXFwv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Dec 2008 00:52:51 -0500
Date: Wed, 24 Dec 2008 00:49:51 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	mabbaswireless@gmail.com
Subject: Re: [PATCH v2 0/3] mac80211 suspend/resume
Message-ID: <20081224054951.GA32398@hash.localnet> (sfid-20081224_065255_653595_EDAEBEB5)
References: <1229313039-5544-1-git-send-email-me@bobcopeland.com> <1229336057.4471.9.camel@johannes.berg> <1229354532.12163.24.camel@localhost.localdomain> <20081217174244.M36761@bobcopeland.com> <1230064216.31228.46.camel@johannes>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1230064216.31228.46.camel@johannes>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 23, 2008 at 09:30:16PM +0100, Johannes Berg wrote:
> > Running pm-suspend from pm-utils directly also triggers the problem, 
> > so that would seem to excuse gnome-power-manager at least.
> 
> What's the status of this? Should I look into things a bit?

Well, I guess I should have noticed this a lot earlier, but anyway the 
problem was pm-utils on Fedora 10:

/usr/lib/pm-utils/sleep.d/55NetworkManager:

    suspend_nm()
    {
        # Tell NetworkManager to shut down networking
        dbus-send --system                         \
            --dest=org.freedesktop.NetworkManager  \
            /org/freedesktop/NetworkManager        \
            org.freedesktop.NetworkManager.sleep
    }

I really don't think this is necessary (g-p-m will also do it if you 
set the proper gconf setting.)

-- 
Bob Copeland %% www.bobcopeland.com

