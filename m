Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:44256 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753401AbYDRDDY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Apr 2008 23:03:24 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1Jmgsj-0003G7-By
	for linux-wireless@vger.kernel.org; Fri, 18 Apr 2008 03:03:21 +0000
Received: from 84-203-37-37.mysmart.ie ([84.203.37.37])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 18 Apr 2008 03:03:21 +0000
Received: from furlongm by 84-203-37-37.mysmart.ie with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Fri, 18 Apr 2008 03:03:21 +0000
To: linux-wireless@vger.kernel.org
From: Marcus Furlong <furlongm@hotmail.com>
Subject: RE:  RE: iwl3945 problem with 2.6.25-rc9
Date: Fri, 18 Apr 2008 04:03:32 +0100
Message-ID: <fu931e$k1b$1@ger.gmane.org> (sfid-20080418_040330_103902_25CDDD32)
References: <D936D925018D154694D8A362EEB08920043535A1@orsmsx416.amr.corp.intel.com> <fu5iel$c45$1@ger.gmane.org> <fu5l5r$pm8$1@ger.gmane.org> <1208376292.27708.3.camel@localhost.localdomain> <D936D925018D154694D8A362EEB0892004353826@orsmsx416.amr.corp.intel.com> <D936D925018D154694D8A362EEB08920043539AE@orsmsx416.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 16 April 2008 23:55 in
<D936D925018D154694D8A362EEB08920043539AE@orsmsx416.amr.corp.intel.com>,
Chatre, Reinette wrote:

> There seems to be a lot going on through initialization scripts of your
> distribution. Could you disable all that and try to get up and running
> with as little variables as possible? It may be that the interface is
> automatically brought up when the module is loaded - this script should
> be among your network init scripts. Can you disable that? You can load
> the driver with debugging and see through the logs if anything is trying
> to use it. The first goal is to load the driver and not have it do any
> work after initial load.

Ok, I did this now. iwl3945 is now only loaded manually by modprobe, and the
initscript is disabled for wlan0.

> After this follow the following steps (I am assuming you are not using
> security):
> $ /sbin/ip link set dev wlan0 up
> $ iwlist wlan0 scan
> Search for your AP in the above output - should match with your
> wpa_supplicant conf file.
> $ iwconfig wlan0 channel <channel of your AP> ap <MAC of your AP> essid
> <essid of your AP>
> $ iwconfig
> check above output to see if you are associated
> next use your usual net app to get an IP (dhclient?)
> 
> Can you associate with the above steps? What do the logs look like?

The dmesg output is here:

https://www.cs.tcd.ie/~furlongm/iwlwifi/2.6.25-dmesg-wirelesstools-only

iwconfig wlan0 said it was associated (connecting to the AP with no security
now):

wlan0     IEEE 802.11g  ESSID:"testing"
          Mode:Managed  Frequency:2.417 GHz  Access Point: 00:0F:CC:5E:86:00
          Bit Rate=54 Mb/s   Tx-Power=15 dBm
          Retry min limit:7   RTS thr:off   Fragment thr=2352 B
          Encryption key:off
          Link Quality=84/100  Signal level=-49 dBm  Noise level=-88 dBm
          Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
          Tx excessive retries:0  Invalid misc:0   Missed beacon:0


but it never got an IP address, no matter what timeout I set for the dhcp
client.

iwlist wlan0 scan showed the AP a few times, but mostly found nothing at
all. When it did find APs, it found at most 2-3 APs, whereas the ipw driver
finds 10 or more APs on the same machine.

Marcus.

