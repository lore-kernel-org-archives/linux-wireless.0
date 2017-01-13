Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp2-2.goneo.de ([85.220.129.34]:53505 "EHLO smtp2-2.goneo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751482AbdAMMvr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 13 Jan 2017 07:51:47 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: [PATCH] mac80211: fix documentation warnings
From: Markus Heiser <markus.heiser@darmarit.de>
In-Reply-To: <20170113101201.7352-1-johannes@sipsolutions.net>
Date: Fri, 13 Jan 2017 13:43:13 +0100
Cc: linux-wireless@vger.kernel.org, corbet@lwn.net,
        linux-doc@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>
Message-Id: <4973EEB8-5F54-451E-B939-CDA94332CEF7@darmarit.de> (sfid-20170113_135150_836953_3D7A7C87)
References: <20170113101201.7352-1-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Am 13.01.2017 um 11:12 schrieb Johannes Berg <johannes@sipsolutions.net>:

> From: Johannes Berg <johannes.berg@intel.com>
> 
> For a few restructured text warnings in mac80211, making the
> documentation warning-free (for now). Again, this required
> adding trailing whitespace to keep multiple paragraphs in a
> parameter description together.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> include/net/mac80211.h | 28 ++++++++++++++++++----------
> 1 file changed, 18 insertions(+), 10 deletions(-)
> 
> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
> index 86967b85dfd0..228c72617916 100644
> --- a/include/net/mac80211.h
> +++ b/include/net/mac80211.h
> @@ -1771,10 +1771,12 @@ struct ieee80211_sta_rates {
> * @max_amsdu_len: indicates the maximal length of an A-MSDU in bytes. This
> *	field is always valid for packets with a VHT preamble. For packets
> *	with a HT preamble, additional limits apply:
> - *		+ If the skb is transmitted as part of a BA agreement, the
> - *		  A-MSDU maximal size is min(max_amsdu_len, 4065) bytes.
> - *		+ If the skb is not part of a BA aggreement, the A-MSDU maximal
> - *		  size is min(max_amsdu_len, 7935) bytes.
> + *	
> + *	* If the skb is transmitted as part of a BA agreement, the
> + *	  A-MSDU maximal size is min(max_amsdu_len, 4065) bytes.
> + *	* If the skb is not part of a BA aggreement, the A-MSDU maximal
> + *	  size is min(max_amsdu_len, 7935) bytes.
> + *	
> *	Both additional HT limits must be enforced by the low level driver.
> *	This is defined by the spec (IEEE 802.11-2012 section 8.3.2.2 NOTE 2).
> * @support_p2p_ps: indicates whether the STA supports P2P PS mechanism or not.
> @@ -3212,14 +3214,20 @@ enum ieee80211_reconfig_type {
> *	nor send aggregates in a way that lost frames would exceed the
> *	buffer size. If just limiting the aggregate size, this would be
> *	possible with a buf_size of 8:
> - *	 - TX: 1.....7
> - *	 - RX:  2....7 (lost frame #1)
> - *	 - TX:        8..1...
> + *	
> + *	- ``TX: 1.....7``
> + *	- ``RX:  2....7`` (lost frame #1)
> + *	- ``TX:        8..1...``
> + *	

Hi Johannes!

does it make live easier when we use in-line member comments:

 https://www.kernel.org/doc/html/latest/doc-guide/kernel-doc.html#in-line-member-documentation-comments

and place the entire list in a literalblock? 

This is what I (sloppy) tested :


      void (*reset_tsf)(struct ieee80211_hw *hw, struct ieee80211_vif *vif);
       int (*tx_last_beacon)(struct ieee80211_hw *hw);

       /**
        * @ampdu_action: Perform a certain A-MPDU action
        *
        * The RA/TID combination determines the destination and TID we want
        * the ampdu action to be performed for. The action is defined through
        * ieee80211_ampdu_mlme_action.
        * When the action is set to %IEEE80211_AMPDU_TX_OPERATIONAL the driver
        * may neither send aggregates containing more subframes than @buf_size
        * nor send aggregates in a way that lost frames would exceed the
        * buffer size. If just limiting the aggregate size, this would be
        * possible with a buf_size of 8::
        *
        *   - TX: 1.....7
        *   - RX:  2....7 (lost frame #1)
        *   - TX:        8..1...
        *
        * which is invalid since #1 was now re-transmitted well past the
        * buffer size of 8. Correct ways to retransmit #1 would be::
        *
        *   - TX:       1 or 18 or 81
        *
        * Even "189" would be wrong since 1 could be lost again.
        *
        * Returns a negative error code on failure.
        * The callback can sleep.
        */

       int (*ampdu_action)(struct ieee80211_hw *hw,
                           struct ieee80211_vif *vif,
                           struct ieee80211_ampdu_params *params);

just my 2cent.

-- Markus --
