Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2196 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753751AbaCCN3z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Mar 2014 08:29:55 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "mcgrof@do-not-panic.com" <mcgrof@do-not-panic.com>
Subject: RE: [PATCH v6 0/5] Enable additional channels for use
Date: Mon, 3 Mar 2014 13:29:16 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A033390751@HASMSX106.ger.corp.intel.com> (sfid-20140303_142959_110472_EA23B63C)
References: <1393139583-7249-1-git-send-email-ilan.peer@intel.com>
In-Reply-To: <1393139583-7249-1-git-send-email-ilan.peer@intel.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Any comments on the last series?

Thanks in advance,

Ilan.

> -----Original Message-----
> From: Peer, Ilan
> Sent: Sunday, February 23, 2014 09:13
> To: linux-wireless@vger.kernel.org
> Cc: mcgrof@do-not-panic.com; Peer, Ilan
> Subject: [PATCH v6 0/5] Enable additional channels for use
> 
> Some additional documentation fixes.
> 
> ------
> 
> As before, this series addresses the option of enabling additional channels
> for use based on the following relaxations:
> 
> 1. Indoor operation, where a device can use channels requiring indoor
>    operation, subject to that it can guarantee indoor operation.
> 2. Concurrent GO operation, where devices may instantiate a P2P GO
>    while they are under the guidance of an authorized master.
> 
> The series includes:
> 
> * Some clarification (mainly in documentation) about the intended usage of
>   channels marked as INDOOR_ONLY and CONCURRENT GO.
> * Mapping of NL80211_RFF_NO_OUTDOOR to
> NL80211_CHAN_INDOOR_ONLY
> * Support for a user hint that the platform is operating in an indoor
>   environment, i.e., channel marked as INDOOR_ONLY can be used.
> * Allow initiating radiation on channel marked with INDOOR_ONLY also
>   for scanning an frame injection in monitor mode.
> * Some additional fixes for comments I got.
> 
> Following is an example of a possible channel map that can be used to allow
> the INDOOR_ONLY and CONCURRENT_GO relaxations. Note that:
> 
> * Channels 12,13 are marked as Concurrent GO, so even in the lack of exact
>   information about the current regulatory domain, these channels can be
> used
>   for GO instantiation based on the concurrent GO relaxation.
> * The above is also true for channels 149-165 (a.k.a U-NII 3).
> * Channels 36-48 (a.k.a thee U-NII 1), are marked both with Concurrent GO
> and
>   indoor only. While the Concurrent GO can be used as described above, the
>   indoor only setting allows to use these channels given the platform is
>   identified as an indoor one, i.e., media server.
> 
>  2412 MHz [1] (16.0 dBm)
>  2417 MHz [2] (16.0 dBm)
>  2422 MHz [3] (16.0 dBm)
>  2427 MHz [4] (16.0 dBm)
>  2432 MHz [5] (16.0 dBm)
>  2437 MHz [6] (16.0 dBm)
>  2442 MHz [7] (16.0 dBm)
>  2447 MHz [8] (16.0 dBm)
>  2452 MHz [9] (16.0 dBm)
>  2457 MHz [10] (16.0 dBm)
>  2462 MHz [11] (16.0 dBm)
>  2467 MHz [12] (16.0 dBm) (no IR, Concurrent GO)
>  2472 MHz [13] (16.0 dBm) (no IR, Concurrent GO)
>  5180 MHz [36] (16.0 dBm) (no IR, Indoor Only, Concurrent GO)
>  5200 MHz [40] (16.0 dBm) (no IR, Indoor Only, Concurrent GO)
>  5220 MHz [44] (16.0 dBm) (no IR, Indoor Only, Concurrent GO)
>  5240 MHz [48] (16.0 dBm) (no IR, Indoor Only, Concurrent GO)
>  5260 MHz [52] (16.0 dBm) (no IR, radar detection)
>  5280 MHz [56] (16.0 dBm) (no IR, radar detection)
>  5300 MHz [60] (16.0 dBm) (no IR, radar detection)
>  5320 MHz [64] (16.0 dBm) (no IR, radar detection)
>  5500 MHz [100] (16.0 dBm) (no IR, radar detection)
>  5520 MHz [104] (16.0 dBm) (no IR, radar detection)
>  5540 MHz [108] (16.0 dBm) (no IR, radar detection)
>  5560 MHz [112] (16.0 dBm) (no IR, radar detection)
>  5580 MHz [116] (16.0 dBm) (no IR, radar detection)
>  5600 MHz [120] (16.0 dBm) (no IR, radar detection)
>  5620 MHz [124] (16.0 dBm) (no IR, radar detection)
>  5640 MHz [128] (16.0 dBm) (no IR, radar detection)
>  5660 MHz [132] (16.0 dBm) (no IR, radar detection)
>  5680 MHz [136] (16.0 dBm) (no IR, radar detection)
>  5700 MHz [140] (16.0 dBm) (no IR, radar detection)
>  5720 MHz [144] (16.0 dBm) (no IR, radar detection)
>  5745 MHz [149] (16.0 dBm) (no IR, Concurrent GO)
>  5765 MHz [153] (16.0 dBm) (no IR, Concurrent GO)
>  5785 MHz [157] (16.0 dBm) (no IR, Concurrent GO)
>  5805 MHz [161] (16.0 dBm) (no IR, Concurrent GO)
>  5825 MHz [165] (16.0 dBm) (no IR, Concurrent GO)
> 
> Thanks in advance,
> 
> Ilan.
> 
> David Spinadel (1):
>   cfg80211: Add indoor only and GO concurrent channel attributes
> 
> Ilan Peer (4):
>   cfg80211: Add Kconfig option for cellular BS hints
>   cfg80211: Enable GO operation on additional channels
>   cfg80211: Add an option to hint indoor operation
>   cfg80211: Enable GO operation on indoor channels
> 
>  include/net/cfg80211.h       |   14 +++++-
>  include/net/regulatory.h     |    6 +++
>  include/uapi/linux/nl80211.h |   26 ++++++++++++
>  net/mac80211/ibss.c          |    9 ++--
>  net/wireless/Kconfig         |   37 ++++++++++++++++
>  net/wireless/chan.c          |   84 ++++++++++++++++++++++++++++++++++--
>  net/wireless/mesh.c          |    3 +-
>  net/wireless/nl80211.c       |   35 ++++++++-------
>  net/wireless/reg.c           |   96
> +++++++++++++++++++++++++++++++++++++++++-
>  net/wireless/reg.h           |   13 ++++++
>  net/wireless/trace.h         |   11 +++--
>  11 files changed, 305 insertions(+), 29 deletions(-)
> 
> --
> 1.7.10.4

