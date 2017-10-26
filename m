Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:46925 "EHLO
        mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751457AbdJZVNS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 26 Oct 2017 17:13:18 -0400
Received: by mail-io0-f181.google.com with SMTP id 101so8424729ioj.3
        for <linux-wireless@vger.kernel.org>; Thu, 26 Oct 2017 14:13:17 -0700 (PDT)
Date: Thu, 26 Oct 2017 14:13:14 -0700
From: Brian Norris <briannorris@chromium.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jesse Sung <jesse.sung@canonical.com>,
        Amitkumar Karwar <akarwar@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ilan Peer <ilan.peer@intel.com>,
        Anthony Wong <anthony.wong@canonical.com>,
        Jason Yen <jason.yen@canonical.com>, Terry.Wey@dell.com,
        linux-wireless@vger.kernel.org, Ganapathi Bhat <gbhat@marvell.com>
Subject: Re: Commit 0711d638 breaks mwifiex
Message-ID: <20171026211313.GA46251@google.com> (sfid-20171026_231334_358549_F9DB8AFC)
References: <CAH10aOifYo=g8oLC3D=QcmVw28EqNotxuNRsprJGNP5ceEYLag@mail.gmail.com>
 <1508233890.10607.70.camel@sipsolutions.net>
 <CAH10aOj8xTPDyEufGS47hytnT8RSL+qSbiRVmePrMpaaUu7gPQ@mail.gmail.com>
 <1508237298.10607.76.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1508237298.10607.76.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I'm not sure I've followed all the problems here, but I wanted to point
some things out:

On Tue, Oct 17, 2017 at 12:48:18PM +0200, Johannes Berg wrote:
> On Tue, 2017-10-17 at 18:18 +0800, Jesse Sung wrote:
> 
> > > Does mwifiex treat this -EALREADY as *keeping* an old connection,
> > > or tearing it down entirely?
> > 
> > From the call trace:
> 
> Well, the call trace can't really answer that :-)
> Does mwifiex firmware stay connected?

IIUC, mwifiex hasn't told the firmware to do anything at this point --
the -EALREADY check is practically the first thing it does within
connect(). So it just quits the connect() request and tries to carry on
as usual. It will only do something different if the upper layers tell
it to do so afterward (e.g., calling disconnect()).

> > 139.451318: nl80211_get_valid_chan <-nl80211_connect
> > 139.451321: cfg80211_connect <-nl80211_connect
> > 139.451322: cfg80211_oper_and_ht_capa <-cfg80211_connect
> > 139.451323: mwifiex_cfg80211_connect <-cfg80211_connect
> > 139.451337: nl80211_post_doit <-genl_family_rcv_msg
> > 139.451423: nl80211_pre_doit <-genl_family_rcv_msg
> > 139.451425: nl80211_disconnect <-genl_family_rcv_msg
> > 139.451426: cfg80211_disconnect <-nl80211_disconnect
> > 139.451430: mwifiex_cfg80211_disconnect <-cfg80211_disconnect
> > 
> > mwifiex_cfg80211_disconnect() would be called after
> > mwifiex_cfg80211_connect(), though I'm not sure if it's triggered by
> > the error returned.
> 
> I think so - it's probably wpa_supplicant trying to get back to a well-
> known state (of being disconnected).

Yes, that's definitely what's happening. And it's explicitly called out
in the supplicant's nl80211 driver that this is intentional:

static int wpa_driver_nl80211_connect(
	struct wpa_driver_nl80211_data *drv,
	struct wpa_driver_associate_params *params)
{
...
	ret = wpa_driver_nl80211_try_connect(drv, params);
	if (ret == -EALREADY) {
		/*
		 * cfg80211 does not currently accept new connections if
		 * we are already connected. As a workaround, force
		 * disconnection and try again.
		 */
		wpa_printf(MSG_DEBUG, "nl80211: Explicitly "
			   "disconnecting before reassociation "
			   "attempt");
		if (wpa_driver_nl80211_disconnect(
			    drv, WLAN_REASON_PREV_AUTH_NOT_VALID))
			return -1;
		ret = wpa_driver_nl80211_try_connect(drv, params);
	}
	return ret;
}

This is the main code path for supplicant commands like "Reattach",
which boil down to (for non SME drivers):

wpas_request_connection()
  ...
 -> wpa_supplicant_connect()
   -> wpa_supplicant_associate()
     -> wpas_start_assoc_cb()
       -> wpa_drv_associate()
         -> wpa_driver_nl80211_associate()
           -> wpa_driver_nl80211_connect()

Now for the part I'm not so familiar with: is this really the *expected*
flow for full-MAC drivers in reattach, reassociate, and roaming flows?
All of those seem to boil down to this same connect() (and fallback to
disconnect()+connect() if -EALREADY) flow.

But it doesn't seem like all full-MAC drivers do the same thing. Some
seem to just blaze ahead with a connect attempt (maybe some firmwares
automatically interpret this for us?) and never return -EALREADY at all.

Sorry if this is slightly off-topic, but I'm trying to understand what
the general expectations are here, based on my relatively narrow
experience with a few drivers.

Brian
