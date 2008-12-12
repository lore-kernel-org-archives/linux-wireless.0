Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:62572 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182AbYLLWcb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 17:32:31 -0500
Received: by rv-out-0506.google.com with SMTP id k40so1578824rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Dec 2008 14:32:30 -0800 (PST)
Message-ID: <69e28c910812121432k1e8732bcma77e489d247ecdf4@mail.gmail.com> (sfid-20081212_233239_864570_76D3B7E9)
Date: Fri, 12 Dec 2008 23:32:30 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: [RFC 0/3] cfg80211, mac80211: Introduce radiotap flags for finer userspace control of injection
Cc: "Johannes Berg" <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Userspace packet injector applications might want to transmit packets
that are, by design, not supposed to be acked. In other cases, an
injector application may need to control the sequence number of the
packets it transmits. Introduce 2 new flags in the "TX flags" Radiotap
fields, controlling these 2 behaviors.

The new fields are as follows:

 * IEEE80211_RADIOTAP_TX_FLAGS

   IEEE80211_RADIOTAP_F_TX_NO_ACK: Transmit the packet once with no wai=
ting for
				   an ACK and no retrying if no ACK received
   IEEE80211_RADIOTAP_F_TX_NO_SEQ: Use the sequence number already pres=
ent in
				   the 802.11 header, do not generate a new one
				   in the driver/stack. Useful when injecting
				   fragments with the same sequence number.

Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
