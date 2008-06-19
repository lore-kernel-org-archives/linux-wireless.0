Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.176]:3123 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754253AbYFSJU2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jun 2008 05:20:28 -0400
Received: by wa-out-1112.google.com with SMTP id j37so513146waf.23
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jun 2008 02:20:24 -0700 (PDT)
Message-ID: <1ba2fa240806190220l18fe5dcdsf44fe81412a5f35d@mail.gmail.com> (sfid-20080619_112044_515836_00BBE652)
Date: Thu, 19 Jun 2008 12:20:24 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Broken fragmentation
Cc: "Linux Wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes
Your patch bellow has broken the fragmentation. Can you please have a
look at this.

commit 49cfd9a35cd593e3b575b89c2dca148bdd4fbb57
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Thu May 15 12:55:28 2008 +0200

    mac80211: reorder some transmit handlers



static ieee80211_tx_handler ieee80211_tx_handlers[] =
{
	ieee80211_tx_h_check_assoc,
	ieee80211_tx_h_sequence,
	ieee80211_tx_h_ps_buf,
	ieee80211_tx_h_select_key,
	ieee80211_tx_h_michael_mic_add,
	ieee80211_tx_h_rate_ctrl,
	ieee80211_tx_h_misc,                                         -- this
one already assume fragmetation
	ieee80211_tx_h_fragment,
	/* handlers after fragment must be aware of tx info fragmentation! */
	ieee80211_tx_h_encrypt,
	ieee80211_tx_h_stats,
	NULL
};


static ieee80211_tx_result
ieee80211_tx_h_misc(struct ieee80211_tx_data *tx)
{


          /* Setup duration field for the first fragment of the frame. Duration
	 * for remaining fragments will be updated when they are being sent
	 * to low-level driver in ieee80211_tx(). */
	dur = ieee80211_duration(tx, is_multicast_ether_addr(hdr->addr1),
				 (tx->flags & IEEE80211_TX_FRAGMENTED) ?
				 tx->extra_frag[0]->len : 0);                                 --
NULL pointer


}


Thanks
Tomas
