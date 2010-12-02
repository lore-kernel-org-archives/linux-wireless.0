Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:44588 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab0LBAy2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Dec 2010 19:54:28 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id oB20sRND001086
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 1 Dec 2010 16:54:28 -0800
Message-ID: <4CF6EE43.2020905@candelatech.com>
Date: Wed, 01 Dec 2010 16:54:27 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath5k:  invalid hw_rix with 64 stations.
References: <4CF6ED18.5010704@candelatech.com>
In-Reply-To: <4CF6ED18.5010704@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/01/2010 04:49 PM, Ben Greear wrote:
> We were testing with 64 virtual stations running WPA, with
> a single instance of supplicant controlling all interfaces and
> the scan-sharing enabled. It was running clean w/out encryption
> (and w/out supplicant).
>
> We see a large number of these types of warnings. We had a proprietary
> module loaded, but it was not in active use. We're going to reproduce
> without it, but in the meantime, here is a representative trace:

Here's another one from a non-tainted kernel.  Seems this is trivial
to reproduce.

------------[ cut here ]------------
WARNING: at /home/greearb/git/linux.wireless-testing-ct/drivers/net/wireless/ath/ath5k/base.c:620 ath5k_hw_to_driver_rix+0x5b/0x5f [ath5k]()
Hardware name:
invalid hw_rix: 1b
Modules linked in: 8021q garp stp llc fuse michael_mic macvlan pktgen w83627hf hwmon_vid hwmon nfs lockd fscache nfs_acl auth_rpcgss sunrpc ipv6 dm_multipath 
uinput arc4 ecb ath5k ath mac80211 cfg80211 e1000e i2c_i801 e100 i2c_core output serio_raw pcspkr mii iTCO_wdt iTCO_vendor_support ata_generic pata_acpi [last 
unloaded: ipt_addrtype]
Pid: 1225, comm: rsyslogd Tainted: G        W   2.6.37-rc4-wl+ #9
Call Trace:
  [<8043144d>] warn_slowpath_common+0x77/0x8c
  [<f8663994>] ? ath5k_hw_to_driver_rix+0x5b/0x5f [ath5k]
  [<f8663994>] ? ath5k_hw_to_driver_rix+0x5b/0x5f [ath5k]
  [<804314de>] warn_slowpath_fmt+0x2e/0x30
  [<f8663994>] ath5k_hw_to_driver_rix+0x5b/0x5f [ath5k]
  [<f8663ba5>] ath5k_tasklet_tx+0x1ab/0x2f0 [ath5k]
  [<80435948>] tasklet_action+0x78/0xc1
  [<80436034>] __do_softirq+0x75/0x121
  [<80435fbf>] ? __do_softirq+0x0/0x121
  <IRQ>  [<80435f0c>] ? irq_exit+0x29/0x5d
  [<804042c9>] ? do_IRQ+0x8e/0xa2
  [<80403729>] ? common_interrupt+0x29/0x30
  [<8044007b>] ? __queue_work+0x138/0x1af
  [<804b8e53>] ? mntput+0x0/0x15
  [<804b8fb1>] ? path_put+0x15/0x18
  [<8046b551>] ? audit_free_names+0x40/0x59
  [<8046b6fe>] ? audit_syscall_exit+0x91/0x10f
  [<804031d0>] ? sysexit_audit+0x24/0x44
---[ end trace e87e98eb2549568d ]---

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

