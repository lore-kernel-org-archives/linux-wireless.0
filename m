Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:47269 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384AbbJRFHJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Oct 2015 01:07:09 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Helmut Heubel <heubelmail@gmail.com>,
	linuxwifi <linuxwifi@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [linuxwifi] Wireless card not working
Date: Sun, 18 Oct 2015 05:07:03 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB32E8A3742@hasmsx107.ger.corp.intel.com> (sfid-20151018_070714_325090_10A173C0)
References: <20151017193826.4a266ae3@UX305FA>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 10/18/2015 01:38 AM, Helmut Heubel wrote:
> 
> Hi, I have an Asus UX305FA notebook and I am facing some problems with
> the Intel 7265 wireless card, sometimes it works and sometimes not
> (lately it is more frequent that it does not work at all what forces
> me to always use the ethernet USB adaptor and cable).
> 

please share  your dmesg output as a start.
> ==================================================
> # sudo lshw -C network
> 
>   *-network               
>        description: Wireless interface
>        product: Wireless 7265
>        vendor: Intel Corporation
>        physical id: 0
>        bus info: pci@0000:02:00.0
>        logical name: wlan0
>        version: 59
>        serial: 34:02:86:60:cd:3b
>        width: 64 bits
>        clock: 33MHz
>        capabilities: pm msi pciexpress bus_master cap_list ethernet
>   physical wireless configuration: broadcast=yes driver=iwlwifi
>   driverversion=3.19.0-30-generic firmware=25.17.12.0 ip=192.168.101.20
>   latency=0 link=yes multicast=yes wireless=IEEE 802.11abgn resources:
>   irq:50 memory:f7000000-f7001fff
> ==================================================

> ==================================================
> # cat /etc/modprobe.d/iwlwifi.conf
> 
> # /etc/modprobe.d/iwlwifi.conf
> # iwlwifi will dyamically load either iwldvm or iwlmvm depending on the
> # microcode file installed on the system.  When removing iwlwifi, first
> # remove the iwl?vm module and then iwlwifi.
> remove iwlwifi (/sbin/lsmod | grep -o -e ^iwlmvm -e ^iwldvm -e ^iwlwifi
> | xargs /sbin/rmmod) && /sbin/modprobe -r mac80211
> options iwlwifi 11n_disable=1
> options iwlwifi 11n_disable=8
> options iwlwifi wd_disable=1
> ==================================================
> 

Please remove all these options.

> My latest attempt was to download this firmware but I don't know how to
> load it correctly:
> 
> https://wireless.wiki.kernel.org/_media/en/users/drivers/iwlwifi-7265-ucode-25.17.12.0.tgz
> 

You already have the correct firmware for this kernel. No need to update
anything.
