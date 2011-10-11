Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:56738 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046Ab1JKLfc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 11 Oct 2011 07:35:32 -0400
Subject: Re: [PATCH] mac80211: Populate radiotap header with MCS info for
 tx'ed frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <1318332535-8815-1-git-send-email-helmut.schaa@googlemail.com> (sfid-20111011_132957_171237_937B0AE4)
References: <1318332535-8815-1-git-send-email-helmut.schaa@googlemail.com>
	 (sfid-20111011_132957_171237_937B0AE4)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 Oct 2011 13:35:27 +0200
Message-ID: <1318332927.3965.9.camel@jlt3.sipsolutions.net> (sfid-20111011_133535_811129_038B94BB)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-10-11 at 13:28 +0200, Helmut Schaa wrote:
> mac80211 already filled in the MCS rate info for rx'ed frames but tx'ed
> frames that are sent to a monitor interface during the status callback
> lack this information.
> 
> Add the radiotap fields for MCS info to ieee80211_tx_status_rtap_hdr
> and populate them when sending tx'ed frames to the monitors.
> 
> One minor flaw is that the radiotap header now includes both, the rate
> field and the mcs field. For HT frames the rate field will be zero and
> for legacy frames the mcs fields will be zero but still this could
> be improved.


> Wireshark will display the MCS rate correctly but will show the zero'd rate
> field as well with 0Mbps. For legacy frames the MCS field won't be shown
> since IEEE80211_RADIOTAP_MCS_HAVE_MCS isn't set. Only the MCS flags will be
> shown (all zero of course).
> 
> I still think it is justified to use it like this as otherwise we would have
> to build the radiotap header in a more generic fashion and we won't be able to
> easily catch build bugs like
> 
>         BUILD_BUG_ON(IEEE80211_TX_STATUS_HEADROOM !=
>                         sizeof(struct ieee80211_tx_status_rtap_hdr));

Hmm. I don't like it much, but it's a bug right now too. Too bad the
rate field doesn't just fit into the padding :-)

Actually though, the MCS field is three bytes. So using something like
this would allow us to save some space as well:

struct ieee80211_tx_status_rtap_hdr {
        struct ieee80211_radiotap_header hdr;
	union {
		struct {
			u8 rate;
			u8 padding_for_rate;
			__le16 tx_flags;
			u8 data_retries;
		} non_mcs;
		struct {
			__le16 tx_flags;
			u8 data_retries;
			u8 mcs_known, mcs_flags, mcs;
		} mcs;
	}
} __packed;

johannes

