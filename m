Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:33708 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751396AbeCUJxz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 21 Mar 2018 05:53:55 -0400
Message-ID: <1521626030.2645.24.camel@sipsolutions.net> (sfid-20180321_105358_741568_B2268DCC)
Subject: Re: [PATCH] mac80211: add ieee80211_hw flag for QoS NDP support
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Caradoc-Davies <ben@transient.nz>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 21 Mar 2018 10:53:50 +0100
In-Reply-To: <20180318235744.3527-1-ben@transient.nz>
References: <20180318235744.3527-1-ben@transient.nz>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2018-03-19 at 12:57 +1300, Ben Caradoc-Davies wrote:
> Commit 7b6ddeaf27ec ("mac80211: use QoS NDP for AP probing") adds an
> argument qos_ok to ieee80211_nullfunc_get to support QoS NDP. Despite
> the claim in the commit log "Change all the drivers to *not* allow
> QoS NDP for now, even though it looks like most of them should be OK
> with that", this commit enables QoS NDP in response to beacons (see
> change to mlme.c:ieee80211_send_nullfunc), causing ath9k_htc to lose
> IP connectivity. See:
> https://patchwork.kernel.org/patch/10241109/
> https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=891060
> 
> This patch replaces the argument qos_ok of ieee80211_nullfunc_get
> with an ieee80211_hw flag that drivers can use to declare support for
> QoS NDP, allowing consistent behaviour between mlme.c and drivers.

A version identifier (as in "[PATCH v3]" in the subject) would help :-)

I've applied a modified version of this patch - it will also require
setting the new "broken" flag in the driver.

johannes
