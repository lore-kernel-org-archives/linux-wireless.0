Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42271 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758273Ab3CDPtV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Mar 2013 10:49:21 -0500
Message-ID: <1362412153.21028.35.camel@jlt4.sipsolutions.net> (sfid-20130304_164924_098231_6930E414)
Subject: Re: [PATCHv3 1/3] mac80211: move mesh sync beacon handler into
 neighbour_update
From: Johannes Berg <johannes@sipsolutions.net>
To: Marco Porsch <marco@cozybit.com>
Cc: Thomas Pedersen <thomas@cozybit.com>, mcgrof@qca.qualcomm.com,
	jouni@qca.qualcomm.com, vthiagar@qca.qualcomm.com,
	senthilb@qca.qualcomm.com, sleffler@google.com,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org
Date: Mon, 04 Mar 2013 16:49:13 +0100
In-Reply-To: <512DBE77.9040902@cozybit.com> (sfid-20130227_090620_764902_9D1627C6)
References: <1361808057-17899-1-git-send-email-marco@cozybit.com>
	 <CAG6hwVOrwGTceDKK9t0QAFH9LDGuhZtJDQhQh38Mh2C+YepAtw@mail.gmail.com>
	 <512DBE77.9040902@cozybit.com> (sfid-20130227_090620_764902_9D1627C6)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2013-02-27 at 09:06 +0100, Marco Porsch wrote:

> >>   struct ieee802_11_elems;
> >>   struct ieee80211_mesh_sync_ops {
> >> -       void (*rx_bcn_presp)(struct ieee80211_sub_if_data *sdata,
> >> -                            u16 stype,
> >> -                            struct ieee80211_mgmt *mgmt,
> >> -                            struct ieee802_11_elems *elems,
> >> -                            struct ieee80211_rx_status *rx_status);
> >> +       void (*rx_bcn)(struct sta_info *sta,
> >> +                      struct ieee80211_mgmt *mgmt,
> >> +                      struct ieee802_11_elems *elems,
> >> +                      u64 t_r);
> >
> > Why not continue to sync against probe responses?
> > mesh_neighbour_update() gets these as well.
> 
> Because there was a comment about the standard mentioning only beacon 
> frames. Fooled me here =/
> Now I see that the standard explicitly mentions probe responses as well.
> Is the sync code currently ready to handle probe responses? I am not 
> perfectly sure about the sta->t_offset_setpoint stuff.

I'm going to drop these patches until you figure this out and tell me
otherwise.

johannes

