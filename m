Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hotel311.server4you.de ([85.25.146.15]:51188 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab2KTHaM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 02:30:12 -0500
Message-ID: <50AB3182.5040505@monom.org> (sfid-20121120_083304_204610_30464E21)
Date: Tue, 20 Nov 2012 08:30:10 +0100
From: Daniel Wagner <wagi@monom.org>
MIME-Version: 1.0
To: Seth Forshee <seth.forshee@canonical.com>
CC: Arend van Spriel <arend@broadcom.com>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Brett Rudley <brudley@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Kan Yan <kanyan@broadcom.com>, brcm80211-dev-list@broadcom.com
Subject: Re: [PATCH v2 00/22] brcmsmac: Tx rework and expanded debug/trace
 support
References: <1352988492-21340-1-git-send-email-seth.forshee@canonical.com> <50AA845C.2050809@monom.org>
In-Reply-To: <50AA845C.2050809@monom.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Seth,

On 19.11.2012 20:11, Daniel Wagner wrote:
> Works perfectly fine on my machine.

Well, not really true. Though I am not sure if this what I am seeing 
related to your changes. I see following log only when I am using my 
home AP. The pattern is that when the connection stop working I see
something like this in the log:

[ 8735.159091] wlan0: moving STA 1c:c6:3c:1f:50:68 to state 4
[ 8735.197298] wlan0: Rx A-MPDU request on tid 0 result 0
[ 8735.566368] wlan0: Open BA session requested for 1c:c6:3c:1f:50:68 tid 0
[ 8735.573701] wlan0: activated addBA response timer on tid 0
[ 8735.578826] wlan0: switched off addBA timer for tid 0
[ 8735.578834] wlan0: Aggregation is on for tid 0
[ 8749.687530] wlan0: tx session timer expired on tid 0
[ 8749.687558] wlan0: Tx BA session stop requested for 1c:c6:3c:1f:50:68 tid 0
[ 8749.700550] wlan0: Stopping Tx BA session for 1c:c6:3c:1f:50:68 tid 0


This is what I do: First establishing a connection, then after a while any
traffic seems stops for a period and sometimes it recovers from that point. If
not a disconnect/connect (using ConnMan) dance fixes the problem. 

Here some more logs with the reconnect dance.

[ 8726.077111] wlan0: deauthenticating from 1c:c6:3c:1f:50:68 by local choice (reason=3)
[ 8726.077147] wlan0: Tx BA session stop requested for 1c:c6:3c:1f:50:68 tid 0
[ 8726.078819] wlan0: Rx BA session stop requested for 1c:c6:3c:1f:50:68 tid 0 recipient reason: 36
[ 8726.078824] wlan0: Stopping Tx BA session for 1c:c6:3c:1f:50:68 tid 0
[ 8726.080882] wlan0: moving STA 1c:c6:3c:1f:50:68 to state 3
[ 8726.080892] wlan0: moving STA 1c:c6:3c:1f:50:68 to state 2
[ 8726.080899] wlan0: moving STA 1c:c6:3c:1f:50:68 to state 1
[ 8726.080904] wlan0: Removed STA 1c:c6:3c:1f:50:68
[ 8726.081038] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: disassociated
[ 8726.081061] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled false, count 1 (implement)
[ 8726.081069] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: false (implement)
[ 8726.083399] cfg80211: Calling CRDA to update world regulatory domain
[ 8726.087764] wlan0: Destroyed STA 1c:c6:3c:1f:50:68
[ 8726.094448] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 8726.110106] cfg80211: World regulatory domain updated:
[ 8726.110116] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 8726.110123] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 8726.110130] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 8726.110135] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
[ 8726.110141] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 8726.110145] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
[ 8726.110192] cfg80211: Calling CRDA for country: DE
[ 8726.122480] cfg80211: Regulatory domain changed to country: DE
[ 8726.122490] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 8726.122496] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 8726.122502] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 8726.122508] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 8726.122513] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[ 8727.076039] IPv6: ADDRCONF(NETDEV_UP): wlan0: link is not ready
[ 8735.043286] wlan0: authenticate with 1c:c6:3c:1f:50:68
[ 8735.043307] wlan0: Allocated STA 1c:c6:3c:1f:50:68
[ 8735.049752] wlan0: Inserted STA 1c:c6:3c:1f:50:68
[ 8735.049761] wlan0: send auth to 1c:c6:3c:1f:50:68 (try 1/3)
[ 8735.057482] wlan0: authenticated
[ 8735.057497] wlan0: moving STA 1c:c6:3c:1f:50:68 to state 2
[ 8735.058281] wlan0: associate with 1c:c6:3c:1f:50:68 (try 1/3)
[ 8735.114690] wlan0: RX AssocResp from 1c:c6:3c:1f:50:68 (capab=0x431 status=0 aid=3)
[ 8735.114709] wlan0: moving STA 1c:c6:3c:1f:50:68 to state 3
[ 8735.114717] wlan0: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023 txop=0 uapsd=0
[ 8735.114844] wlan0: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023 txop=0 uapsd=0
[ 8735.114965] wlan0: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15 txop=94 uapsd=0
[ 8735.115087] wlan0: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47 uapsd=0
[ 8735.115301] brcmsmac bcma0:0: brcmsmac: brcms_ops_bss_info_changed: associated
[ 8735.115321] brcmsmac bcma0:0: brcms_ops_bss_info_changed: arp filtering: enabled true, count 0 (implement)
[ 8735.115334] brcmsmac bcma0:0: brcms_ops_bss_info_changed: qos enabled: true (implement)
[ 8735.115361] wlan0: associated
[ 8735.116132] cfg80211: Calling CRDA for country: DE
[ 8735.116218] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[ 8735.118204] wlan0: dropped frame to 1c:c6:3c:1f:50:68 (unauthorized port)
[ 8735.120665] cfg80211: Regulatory domain changed to country: DE
[ 8735.120672] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
[ 8735.120678] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 8735.120682] cfg80211:   (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 8735.120687] cfg80211:   (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
[ 8735.120692] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
[ 8735.159091] wlan0: moving STA 1c:c6:3c:1f:50:68 to state 4
[ 8735.197298] wlan0: Rx A-MPDU request on tid 0 result 0
[ 8735.566368] wlan0: Open BA session requested for 1c:c6:3c:1f:50:68 tid 0
[ 8735.573701] wlan0: activated addBA response timer on tid 0
[ 8735.578826] wlan0: switched off addBA timer for tid 0
[ 8735.578834] wlan0: Aggregation is on for tid 0
[ 8749.687530] wlan0: tx session timer expired on tid 0
[ 8749.687558] wlan0: Tx BA session stop requested for 1c:c6:3c:1f:50:68 tid 0
[ 8749.700550] wlan0: Stopping Tx BA session for 1c:c6:3c:1f:50:68 tid 0


cheers,
daniel
