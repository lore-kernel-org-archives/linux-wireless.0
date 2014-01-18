Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:7287 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751065AbaARSUn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 18 Jan 2014 13:20:43 -0500
From: "Peer, Ilan" <ilan.peer@intel.com>
To: David Herrmann <dh.herrmann@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: RE: iwlwifi: P2P group-formation timeout
Date: Sat, 18 Jan 2014 18:20:37 +0000
Message-ID: <CB3B3D4774441E42AA3EA0E1BA8230A03335A169@HASMSX106.ger.corp.intel.com> (sfid-20140118_192046_850965_BF2E9456)
References: <CANq1E4Rhja6XZPq9sXfycK_wWNB3nsjpQFr2XnzOXLHUnm__mw@mail.gmail.com>
	<CANq1E4STKqci55ZbGP9Siorf3ABptHHTAuOg_4-bbbEiw93w+A@mail.gmail.com>
	<CB3B3D4774441E42AA3EA0E1BA8230A0333565A8@HASMSX106.ger.corp.intel.com>
 <CANq1E4QmdmMsvXFonAmMYQ5X-r-GQDrPAsU9rYk49GgWMbF2bQ@mail.gmail.com>
In-Reply-To: <CANq1E4QmdmMsvXFonAmMYQ5X-r-GQDrPAsU9rYk49GgWMbF2bQ@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi David,

Sorry for the late response. Hope the below can help :)

Regards,

Ilan.
 
> I tried again and masked the 5ghz channels (via "p2p_set", not "set" I
> guess?), however, still almost exactly the same log but on a 2.4ghz
> channel. I attached the full log to the email, I cut down all the
> "p2p-scan" log messages and inlined most parts of the log below.
> 
> Another thing that I noticed is that I don't get any "P2P-XY" status
> messages to wpa_cli. I need to run "tail -f wpa.log | grep ^P2P-" in a
> separate session to actually see messages like P2P-DEVICE-FOUND,
> P2P-GO-NEG-SUCCESS, .. I only got "P2P-GROUP-" related messages
> directly forwarded to my wpa_cli. I really think this is all somehow
> related to the bunch of errors I get during p2p-dev-wlan0 setup, which
> you said you cannot reproduce.
>

>From the logs it looks like the wpa_supplicant tries to use the P2P Device interface for the GO instantiation (which is impossible since this is not a netdev but a P2P Device interface). Can you please try to invoke the wpa_supplicant with a global control interface and issue the P2P commands over the global control interface? Something like:

wpa_supplicant -i wlan0 -c <conf> -p allow_p2p_device=1 -t -s -d -T -B -g /tmp/wpa_global -G <group>
wpa_cli -g /tmp/wpa_global -G <group>

See the following commit from Jouni: 78f79fe5fc251e3ababa2970956cc9a84f29f209

    P2P: Do not add ctrl interface for P2P_DEVICE (p2p-dev-*)

    Adding a new wpa_supplicant control interface for the dedicated
    P2P_DEVICE would be quite confusing for programs that manage P2P
    operations. Remove this control interface and require the global control
    interface to be used since it will provide consistent interface for both
    the new dedicated P2P_DEVICE (non-netdev) and old style P2P management
    through a netdev.






