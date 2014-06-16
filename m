Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:21172 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751478AbaFPMde convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Jun 2014 08:33:34 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Johannes Stezenbach <js@sig21.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: RE: iwlwifi AC 7260 fails to connect
Date: Mon, 16 Jun 2014 12:33:25 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB303E22CCC@HASMSX103.ger.corp.intel.com> (sfid-20140616_143338_108607_61DA6D9B)
References: <20140613105412.GA25048@sig21.net>
 <20140616094001.GB15116@sig21.net>
In-Reply-To: <20140616094001.GB15116@sig21.net>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> 
> Hi,
> 
> On Fri, Jun 13, 2014 at 12:54:13PM +0200, Johannes Stezenbach wrote:
> > a new Thinkpad Yoga 20CD00AMGE with Intel(R) Dual Band Wireless AC
> > 7260 fails to connect to the AP in the office, while it works on my
> > home AP.  WPA2 is used in both cases.  I tried with kernel 3.14.7 and
> > 3.15.  There is a high density of APs and clients and lots of traffic
> > in the office environment.
> 
> I have confirmation someone on the other side of the globe with a similar
> machine sees the same issue.
> 
> > [   31.890168] wlp4s0: authenticate with f8:d1:11:39:1a:8c
> > [   31.892972] wlp4s0: send auth to f8:d1:11:39:1a:8c (try 1/3)
> > [   31.903458] wlp4s0: authenticated
> > [   31.927239] wlp4s0: associate with f8:d1:11:39:1a:8c (try 1/3)
> > [   31.963374] wlp4s0: RX AssocResp from f8:d1:11:39:1a:8c (capab=0x431
> status=0 aid=5)
> > [   31.968857] wlp4s0: associated
> > [   32.200142] iwlwifi 0000:04:00.0: No association and the time event is over
> already...
> > [   32.200154] wlp4s0: Connection to AP f8:d1:11:39:1a:8c lost
> 

What is the beacon interval on these access point?
Please open a bugzilla on kernel.org and CC ilw@linux.intel.com
This issue is not something I can fix on the spot through mailing list, and I'd like to be able to track it.
Thanks.

> Some more detail from dmesg:
> 
> [    1.161462] iwlwifi 0000:04:00.0: irq 61 for MSI/MSI-X
> [    1.164277] iwlwifi 0000:04:00.0: loaded firmware version 22.24.8.0
> op_mode iwlmvm
> [    1.180348] iwlwifi 0000:04:00.0: Detected Intel(R) Dual Band Wireless AC
> 7260, REV=0x144
> [    1.180651] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> [    1.180885] iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
> 
> lspci -vn:
> 
> 04:00.0 0280: 8086:08b2 (rev 83)
> 	Subsystem: 8086:4270
> 
> Full lspci -vvv output attached.
> 
> 
> I also tried "iw dev wlp4s0 set power_save off", it did not help.
> 
> 
> > drivers/net/wireless/iwlwifi/mvm/time-
> event.c:iwl_mvm_te_handle_notif(
> > )
> >
> >                 iwl_mvm_te_check_disconnect(mvm, te_data->vif,
> >                         "No association and the time event is over
> > already...");
> >
> > And lo and behold, it can connect.
> >
> > Let me know if you need more information to produce a proper fix.
> 
> 
> TIA,
> Johannes
