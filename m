Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:33946 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbXK0Be3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Nov 2007 20:34:29 -0500
Received: by py-out-1112.google.com with SMTP id u77so1839630pyb
        for <linux-wireless@vger.kernel.org>; Mon, 26 Nov 2007 17:34:28 -0800 (PST)
Message-ID: <43e72e890711261734s17621900yc9ee5946bc30482e@mail.gmail.com> (sfid-20071127_013433_124271_C36D7736)
Date: Mon, 26 Nov 2007 20:34:28 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Ron Rindjunsky" <ron.rindjunsky@intel.com>
Subject: Re: [PATCH 0/15] mac80211/iwlwifi (#everything): integrate IEEE802.11n support
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, flamingice@sourmilk.net,
	tomas.winkler@intel.com
In-Reply-To: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <11960864823402-git-send-email-ron.rindjunsky@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Nov 26, 2007 9:14 AM, Ron Rindjunsky <ron.rindjunsky@intel.com> wrote:
> This series of patches contains all 802.11n code + fixes of comments to
> the first two cycles of 802.11n patches.
>
> Fixed list:
> ===========
>  - removing MAC80211_HT from config and all *.[ch] files
>  - removing IWL4965 config dependency on MAC80211_HT
>  - adding MAC80211_HT_DEBUG to config file and to relevant places
>  - refine TODO remark in ieee80211_sta_process_addba_request
>  - net_ratelimit() added to relevant prints
>  - renaming ieee80211_rx_h_data_agg to ieee80211_rx_h_amsdu
>  - removing parentheses from IEEE80211_CONF_SUPPORT_HT_MODE use
>  - changing amsdu_frame type from u16 to u8
>  - adding define SUPP_MCS_SET_LEN 16 to indicate MCS set length
>  - fixes to some typos
>  - Changes to Rx handlers PAE and drop unencrypted (for EAPOL frames in amsdu)
>
> If this series is accepted then next series will contain the follow:
>
> TODO list (planned for next series of patches)
> ==============================================
>  - Full A-MPDU aggregation capability.
>  - AP flows
>  - Examine config flows in mac80211 (RFC is prepered)
>
> Notes to this series:
> ======================
> This series of patches splits into two parts:
>  - patches 1-7 add 802.11n support to mac80211.
>  - patches 8-15 demonstrates the use of the above mac80211's 802.11n framework through iwl4965 low level driver
>
> In order to be compatible with the 802.11n requirements for an HT station,
> patches 1-7 should not be treated as stand alone patches, but as a complete framework,
> although separation to patches by subjects was made for ease of handling.
> This applies to patches 8-15 as well.
>
> The patches do _not_ break any existing driver.
>
> patches were made (and tested to work) with wireless branch 2.6.24-rc3 (#everything)
>
> The framework includes the following:
> - HT probing.
> - HT association.
> - Support in Rx A-MSDU.
> - Support in A-MPDU addBA request.
> - HT information and configuration delivery to both low-level driver and rate scaling.

Ron I haven't been able to review your 802.11n patches yet due to time
but I do remember seeing some "channel" variable in a struct somewhere
at a quick glance on your 802.11n patch series. It was determined a
little while ago that we'd move from static channels to frequency
instead. One reason for this is to stick to 'one' thing later for
regulatory purposes. Another reason that came up later is that
frequency be relied upon even on 5GHz reliably contrary to channel
number -- in 5GHz the channel numbers can be mapped arbitrarily
depending on the regulatory agency your country falls under. Would it
be too much if you used frequency instead of channel or does the the
802.11n draft specs say you have to use channel somewhere?

Sorry I couldn't pin point the specific patch yet.

  Luis
