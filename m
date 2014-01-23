Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lan.nucleusys.com ([92.247.61.126]:58272 "EHLO
	zztop.nucleusys.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751791AbaAWUTd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 15:19:33 -0500
Date: Thu, 23 Jan 2014 22:19:22 +0200
From: Petko Manolov <petkan@nucleusys.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>
Cc: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ilw@linux.intel.com" <ilw@linux.intel.com>,
	"Berg, Johannes" <johannes.berg@intel.com>
Subject: Re: iwlwifi crash with 3.13
Message-ID: <20140123201922.GB4064@localhost> (sfid-20140123_211937_018324_4D65E949)
References: <20140123091659.GE9077@localhost>
 <0BA3FCBA62E2DC44AF3030971E174FB303D56D70@HASMSX103.ger.corp.intel.com>
 <20140123123125.GA3424@localhost>
 <0BA3FCBA62E2DC44AF3030971E174FB303D57045@HASMSX103.ger.corp.intel.com>
 <52E16978.3040602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52E16978.3040602@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 14-01-23 21:11:52, Emmanuel Grumbach wrote:
> Ok -  I put the pieces together:
> 
> > iwlwifi 0000:01:00.0: loaded firmware version 22.15.8.0 op_mode iwlmvm
> > iwlwifi 0000:01:00.0: Detected Intel(R) Wireless N 7260, REV=0x144
> 
> This means that your NIC is 2.4GHz only. Dual band NICs print something
> else.

This isn't correct.  My NIC happily connects to my crappy Linksys WRT610Nv1 at 5GHz.  After a while the router's (5GHz) radio dies, but before 
that i am able to easily do more than 100Mbps.

iwconfig output:

wlan0     IEEE 802.11abgn  ESSID:"xxxxxxx"
          Mode:Managed  Frequency:5.745 GHz  Access Point: xx:xx:xx:xx:xx:xx
          Bit Rate=135 Mb/s   Tx-Power=16 dBm
          Retry  long limit:7   RTS thr:off   Fragment thr:off
          Encryption key:off
          Power Management:on
          Link Quality=64/70  Signal level=-46 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:9  Invalid misc:3   Missed beacon:0
 
> Now here come the catch. You seem to have an "old" NIC in a way that the
> NVM (EEPROM like) is old. In that NVM, there was a bug that advertised
> the A band channels but disabled the A band in SKU cap.

iwlwifi-7260-7 ucode works fine for both bands.  iwlwifi-7260-8.ucode seems unable to connect at 5GHz.

> Can you please try the patch attached?

Do you still think it is a good idea to apply and test the patch?


		Petko
