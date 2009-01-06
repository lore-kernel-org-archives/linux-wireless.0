Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:1933 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844AbZAFRJs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Jan 2009 12:09:48 -0500
From: "Bob Copeland" <me@bobcopeland.com>
To: Dan Williams <dcbw@redhat.com>,
	Marcel Holtmann <marcel@holtmann.org>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org, mabbaswireless@gmail.com
Subject: Re: [PATCH v2 0/3] mac80211 suspend/resume
Date: Tue, 6 Jan 2009 12:07:36 -0500
Message-Id: <20090106165434.M2397@bobcopeland.com> (sfid-20090106_180953_085437_C8423EDA)
In-Reply-To: <1231260306.14565.21.camel@localhost.localdomain>
References: <1229313039-5544-1-git-send-email-me@bobcopeland.com> <1229336057.4471.9.camel@johannes.berg> <1229354532.12163.24.camel@localhost.localdomain> <20081217174244.M36761@bobcopeland.com> <1230064216.31228.46.camel@johannes> <20081224054951.GA32398@hash.localnet> <1230102989.16960.14.camel@californication> <1231260306.14565.21.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 06 Jan 2009 11:45:06 -0500, Dan Williams wrote
> You still want to tell NM to go to sleep so it doesn't see the
> disconnection from the supplicant (triggered by the driver because it
> was going to sleep), and thus try to reconnect, or try a different AP.

Well, I tried it without the hack and it works (connection stays up 
over a short suspend period).  This is with the new mac80211 suspend
patches, where suspend/resume looks like this:

suspend:
  suspend userspace (freezes NM)
  save bssid, keys etc
  if wlan0 up
     ifdown wlan0 (note NM is already frozen)
  power down hw

resume:
  power up hw
  if wlan0 was up
     ifup wlan0
  reload config, bssid, ...
  resume userspace

However, _with_ the current procedure of telling NM to go to sleep, it
tries to reconnect after resume because NM takes care of downing the
interfaces.  As a result mac80211 never gets the chance to save the
state of the running interfaces.

-- 
Bob Copeland %% www.bobcopeland.com


