Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:7378 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754244Ab1FTTqg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Jun 2011 15:46:36 -0400
Subject: Re: [3.0 regression] DMAR faults in iwlagn
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Andrew Lutomirski <luto@mit.edu>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <BANLkTi=LySY+Wyjj-uw2Zu73Lnh4MvCArw@mail.gmail.com>
References: <BANLkTikKia-UXL8LJ60sLDV1uZBFEP8Kwg@mail.gmail.com>
	 <1308596817.21011.8.camel@wwguy-ubuntu>
	 <BANLkTi=LySY+Wyjj-uw2Zu73Lnh4MvCArw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 20 Jun 2011 12:15:24 -0700
Message-ID: <1308597325.13397.251.camel@wwguy-huron> (sfid-20110620_214641_799459_A75B246F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-06-20 at 12:21 -0700, Andrew Lutomirski wrote:
> On Mon, Jun 20, 2011 at 3:06 PM, wwguy <wey-yi.w.guy@intel.com> wrote:
> > On Mon, 2011-06-20 at 11:44 -0700, Andrew Lutomirski wrote:
> >> On 3.0-git today, I get:
> >>
> >> [   40.142872] DRHD: handling fault status reg 2
> >> [   40.142892] DMAR:[DMA Write] Request device [03:00.0] fault addr ffe38000
> >> [   40.142896] DMAR:[fault reason 05] PTE Write access is not set
> >>
> >> lspci says:
> >>
> >> 03:00.0 Network controller: Intel Corporation Centrino Ultimate-N 6300 (rev 35)
> >>
> >> This seems to be triggered by interface state changes.  The driver
> >> still works.  I don't see this on 2.6.39.1.
> >>
> > can I got more information. which repo you are using?
> > git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-testing.git
> 
> This is de505e709ffb09a7382ca8e0d8c7dbb171ba5830 from Linus' tree.
> 
> >
> > Can you provide full log?
> 
> dmesg attached.
> 
> /var/log/messages says:
> 
> NetworkManager[804]: <info> (wlan0): bringing up device.
> kernel: [   85.153160] DRHD: handling fault status reg 2
> kernel: [   85.153175] DMAR:[DMA Write] Request device [03:00.0] fault
> addr ffe0e000
> kernel: [   85.153178] DMAR:[fault reason 05] PTE Write access is not set
> kernel: [   85.207502] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> NetworkManager[804]: <info> Activation (wlan0/wireless): access point
> 'xxxx' has security, but secrets are required.
> NetworkManager[804]: <info> (wlan0): device state change: config ->
> need-auth (reason 'none') [50 60 0]
> NetworkManager[804]: <info> Activation (wlan0) Stage 2 of 5 (Device
> Configure) complete.
> NetworkManager[804]: <info> Activation (wlan0) Stage 1 of 5 (Device
> Prepare) scheduled...
> NetworkManager[804]: <info> Activation (wlan0) Stage 1 of 5 (Device
> Prepare) started...
> NetworkManager[804]: <info> (wlan0): device state change: need-auth ->
> prepare (reason 'none') [60 40 0]
> NetworkManager[804]: <info> Activation (wlan0) Stage 2 of 5 (Device
> Configure) scheduled...
> NetworkManager[804]: <info> Activation (wlan0) Stage 1 of 5 (Device
> Prepare) complete.
> NetworkManager[804]: <info> Activation (wlan0) Stage 2 of 5 (Device
> Configure) starting...
> NetworkManager[804]: <info> (wlan0): device state change: prepare ->
> config (reason 'none') [40 50 0]
> NetworkManager[804]: <info> Activation (wlan0/wireless): connection
> 'Auto Aether Wind' has security, and secrets exist.  No new secrets
> needed.
> NetworkManager[804]: <info> Config: added 'ssid' value 'xxxx'
> NetworkManager[804]: <info> Config: added 'scan_ssid' value '1'
> NetworkManager[804]: <info> Config: added 'key_mgmt' value 'WPA-PSK'
> NetworkManager[804]: <info> Config: added 'psk' value '<omitted>'
> NetworkManager[804]: <info> Config: added 'proto' value 'WPA RSN'
> NetworkManager[804]: <info> Activation (wlan0) Stage 2 of 5 (Device
> Configure) complete.
> NetworkManager[804]: <info> Config: set interface ap_scan to 1
> kernel: [   85.228522] DRHD: handling fault status reg 2
> kernel: [   85.228526] DMAR:[DMA Write] Request device [03:00.0] fault
> addr ffeb8000
> kernel: [   85.228527] DMAR:[fault reason 05] PTE Write access is not set
> NetworkManager[804]: <info> (wlan0): supplicant interface state:
> inactive -> scanning
> kernel: [   85.471825] DRHD: handling fault status reg 2
> kernel: [   85.471840] DMAR:[DMA Write] Request device [03:00.0] fault
> addr ffe54000
> kernel: [   85.471843] DMAR:[fault reason 05] PTE Write access is not set
> NetworkManager[804]: <info> (wlan0): supplicant interface state:
> scanning -> authenticating
> 
> 
Are you seeing the same problem if pull from wireless-testing? I did not
see any iwlagn related log in the log file. But I am pulling from Linus
tree and check it out.

Thanks
Wey



