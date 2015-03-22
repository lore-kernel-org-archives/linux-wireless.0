Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f43.google.com ([209.85.215.43]:34742 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbbCVHhp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Mar 2015 03:37:45 -0400
Received: by lagg8 with SMTP id g8so113640546lag.1
        for <linux-wireless@vger.kernel.org>; Sun, 22 Mar 2015 00:37:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1426865064-17707-2-git-send-email-johannes@sipsolutions.net>
References: <1426865064-17707-1-git-send-email-johannes@sipsolutions.net> <1426865064-17707-2-git-send-email-johannes@sipsolutions.net>
From: Arik Nemtsov <arik@wizery.com>
Date: Sun, 22 Mar 2015 09:37:29 +0200
Message-ID: <CA+XVXfesez3UaeR+h5-8VEy8Mn7fJjZYgBuQZHiL+0PPGwynig@mail.gmail.com> (sfid-20150322_083835_233855_2BCC03D7)
Subject: Re: [PATCH 1/4] mac80211: don't look up destination station twice
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes.berg@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 20, 2015 at 5:24 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> From: Johannes Berg <johannes.berg@intel.com>
>
> There's no need to look up the destination station twice while
> building the 802.11 header for a given frame if the frame will
> actually be transmitted to the station we initially looked up.
>
> This happens for 4-addr VLAN interfaces and TDLS connections, which
> both directly send the frame to the station they looked up, though
> in the case of TDLS some station conditions need to be checked.
>
> To avoid that, add a variable indicating that we've looked up the
> station that the frame is going to be transmitted to, and avoid the
> lookup/flag checking if it already has been done.
>
> In the TDLS case, also move the authorized/wme_sta flag assignment
> to the correct place, i.e. only when that station is really used.
> Before this change, the new lookup should always have succeeded so
> that the potentially erroneous data would be overwritten.
>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>

The TDLS parts look good.

Arik
