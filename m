Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:46329 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754349Ab2LLVIf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Dec 2012 16:08:35 -0500
Received: by mail-ie0-f171.google.com with SMTP id 17so2873358iea.30
        for <linux-wireless@vger.kernel.org>; Wed, 12 Dec 2012 13:08:35 -0800 (PST)
MIME-Version: 1.0
Date: Wed, 12 Dec 2012 13:08:35 -0800
Message-ID: <CAMcMvshyr6p2dqv-4YKW3=ZqLXskqvOtR9E4+UGOM4pzzJumgg@mail.gmail.com> (sfid-20121212_220839_643820_505C0A07)
Subject: Question about "authorized state" test in tx.c
From: Paul Stewart <pstew@chromium.org>
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: "Berg, Johannes" <johannes.berg@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The "unauthorized port" test in ieee80211_subif_start_xmit reads as follows:

        /*
         * Drop unicast frames to unauthorised stations unless they are
         * EAPOL frames from the local station.
         */
        if (unlikely(!ieee80211_vif_is_mesh(&sdata->vif) &&
                     !is_multicast_ether_addr(hdr.addr1) && !authorized &&
                     (cpu_to_be16(ethertype) != sdata->control_port_protocol ||
                      !ether_addr_equal(sdata->vif.addr, skb->data + ETH_ALEN)))
) {
#ifdef CONFIG_MAC80211_VERBOSE_DEBUG
                net_info_ratelimited("%s: dropped frame to %pM (unauthorized por
t)\n",
                                    dev->name, hdr.addr1);
#endif

  [...]

Was it explicitly meant to allow multicast/broadcast frames while not
authorized?  I'm starting to see isolated cases in packet traces where
APs deauth clients due to errant broadcasts being sent during/before
the 4-way handshake, after association.  Are there situations where
these broadcasts / multicasts should be allowed, or would it be
acceptable to drop the multicast check?  The change which introduced
it is
7d185b8bb17eac9e9d673eb483ded0fbf0b28b97, but I don't quite understand
it since if we're not authenticated to the AP, should we still be
allowed to send (non-authentication) traffic to it?

--
Paul
