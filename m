Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 25.mail-out.ovh.net ([91.121.27.228]:58328 "HELO
	25.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759622AbZAVXmH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 18:42:07 -0500
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: iwl3945 regression: associates but no data is transfered
MIME-Version: 1.0
Date: Fri, 23 Jan 2009 00:41:59 +0100
From: <samuel@sortiz.org>
Cc: Kalle Valo <kalle.valo@iki.fi>, linux-wireless@vger.kernel.org
In-Reply-To: <20090122183448.GC3646@tuxdriver.com>
References: <87priffb95.fsf@litku.valot.fi> <20090122183448.GC3646@tuxdriver.com>
Message-ID: <d7a260e8d188b785d0d2be743c8c5461@localhost> (sfid-20090123_004222_187418_247AF699)
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 22 Jan 2009 13:34:48 -0500, "John W. Linville"

<linville@tuxdriver.com> wrote:

> On Thu, Jan 22, 2009 at 08:26:14PM +0200, Kalle Valo wrote:

>> Hello,

>> 

>> I upgraded to the latest wireless-testing and my iwl3945 is now

>> broken. It can associate but no data is transfered after that. Tried

>> with open and wep modes. With dhcp I cannot get ip and with static ip

>> ping to the gateway doesn't work.

>> 

>> Any hints?

> 

> Lots of iwlwifi stuff merged yesterday...

The bad commit seems to be e32b1b9a33759e8a83ac566c4c43f23ed5d6343b, which

is not iwlwifi related.

Even though it's an mlme commit, it doesnt seem to affect other drivers (at

least b43 and ath5k).

I'll come up soon with a proper fix, but for now iwl3945 users should

revert that commit locally.



Cheers,

Samuel.



> 

> Chatre, Reinette (1):

>       iwl3945: add debugging for wrong command queue

> 

> Helmut Schaa (2):

>       iwl3945: fix some warnings when compiled without debug

>       iwlagn: fix hw-rfkill while the interface is down

> 

> Jay Sternberg (4):

>       iwlwifi: correct Kconfig to prevent following entries from not

>       indenting

>       iwlwifi: remove static from 5000 structures

>       iwlwifi: add recognition of Intel WiFi Link 6000 and 6050 Series

>       iwlwifi: add recognition of Intel WiFi Link 100 Series

> 

> Reinette Chatre (1):

>       iwlwifi: return NETDEV_TX_OK from _tx ops

> 

> Samuel Ortiz (3):

>       iwl3945: Use iwl_txq_update_write_ptr

>       iwlwifi: Add TFD library operations

>       iwl3945: Use iwl-hcmd host command routines

> 

> Winkler, Tomas (6):

>       iwlwifi: make iwl-power.c more readable

>       iwlwifi: fix iwl_mac_set_key and iwl3945_mac_set_key

>       iwlwifi: kill iwl3945_scan_cancel and iwl3945_scan_cancel_timeout

>       iwlwifi: kill scan39

>       iwlwifi: remove unused or twice defined members in iwl_priv

>       iwlwifi: eliminate power_data_39.
