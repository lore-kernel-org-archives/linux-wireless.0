Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:47496 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934971Ab3FSUuo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Jun 2013 16:50:44 -0400
Received: from [192.168.100.226] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id r5JKoiIs026792
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 19 Jun 2013 13:50:44 -0700
Message-ID: <51C219A4.7030504@candelatech.com> (sfid-20130619_225048_345605_477888DE)
Date: Wed, 19 Jun 2013 13:50:44 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: regulatory splat in wireless-next (3.10.0-rc1+)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have just a few small patches in this tree, so probably not my fault :)

 From this code in reg.c:

/*
  * Restoring regulatory settings involves ingoring any
  * possibly stale country IE information and user regulatory
  * settings if so desired, this includes any beacon hints
  * learned as we could have traveled outside to another country
  * after disconnection. To restore regulatory settings we do
  * exactly what we did at bootup:
  *
  *   - send a core regulatory hint
  *   - send a user regulatory hint if applicable
  *
  * Device drivers that send a regulatory hint for a specific country
  * keep their own regulatory domain on wiphy->regd so that does does
  * not need to be remembered.
  */
static void restore_regulatory_settings(bool reset_user)
{
	char alpha2[2];
	char world_alpha2[2];
	struct reg_beacon *reg_beacon, *btmp;
	struct regulatory_request *reg_request, *tmp;
	LIST_HEAD(tmp_reg_req_list);
	struct cfg80211_registered_device *rdev;

	ASSERT_RTNL();

	reset_regdomains(true, &world_regdom);
	restore_alpha2(alpha2, reset_user);


cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
cfg80211: Updating information on frequency 2472 MHz with regulatory rule:
cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
cfg80211: Disabling freq 2484 MHz
cfg80211: Ignoring regulatory request Set by driver since the driver requires its own regulatory domain to be set first
cfg80211: Ignoring regulatory request Set by driver since the driver requires its own regulatory domain to be set first
cfg80211: Current regulatory domain intersected:
cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A, 2000 mBm)
cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (N/A, 3000 mBm)
cfg80211:   (57240000 KHz - 59400000 KHz @ 2160000 KHz), (N/A, 2800 mBm)
cfg80211:   (59400000 KHz - 63720000 KHz @ 2160000 KHz), (N/A, 4000 mBm)
EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
IPv6: ADDRCONF(NETDEV_UP): eth0: link is not ready
cfg80211: Timeout while waiting for CRDA to reply, restoring regulatory settings
RTNL: assertion failed at /home/greearb/git/linux.wireless-next/net/wireless/reg.c (1831)
CPU: 2 PID: 164 Comm: kworker/2:1 Not tainted 3.10.0-rc1+ #3
Hardware name: To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M., BIOS 4.6.3 09/05/2011
Workqueue: events reg_timeout_work [cfg80211]
  ffff88022bd13880 ffff8802178a5db8 ffffffff815d0e01 ffff8802178a5e08
  ffffffffa026d777 ffff8802178a5dc8 ffff8802178a5dc8 0000000000014000
  0000000000000080 0000000000000000 ffff880222240380 ffff88022bd13880
Call Trace:
  [<ffffffff815d0e01>] dump_stack+0x19/0x20
  [<ffffffffa026d777>] restore_regulatory_settings+0x47/0x3f7 [cfg80211]
  [<ffffffffa026db48>] reg_timeout_work+0x21/0x23 [cfg80211]
  [<ffffffff810b7dac>] process_one_work+0x23d/0x37f
  [<ffffffff810b805c>] worker_thread+0x16e/0x283
  [<ffffffff810b7eee>] ? process_one_work+0x37f/0x37f
  [<ffffffff810bde31>] kthread+0xb5/0xbd
  [<ffffffff810bdd7c>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d9c2c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810bdd7c>] ? kthread_freezable_should_stop+0x60/0x60
RTNL: assertion failed at /home/greearb/git/linux.wireless-next/net/wireless/reg.c (207)
CPU: 2 PID: 164 Comm: kworker/2:1 Not tainted 3.10.0-rc1+ #3
Hardware name: To be filled by O.E.M. To be filled by O.E.M./To be filled by O.E.M., BIOS 4.6.3 09/05/2011
Workqueue: events reg_timeout_work [cfg80211]
  ffffffffa029c140 ffff8802178a5d98 ffffffff815d0e01 ffff8802178a5db8
  ffffffffa026d55c ffff880222240301 ffff88022bd13880 ffff8802178a5e08
  ffffffffa026d788 ffff8802178a5dc8 ffff8802178a5dc8 0000000000014000
Call Trace:
  [<ffffffff815d0e01>] dump_stack+0x19/0x20
  [<ffffffffa026d55c>] reset_regdomains+0x38/0xce [cfg80211]
  [<ffffffffa026d788>] restore_regulatory_settings+0x58/0x3f7 [cfg80211]
  [<ffffffffa026db48>] reg_timeout_work+0x21/0x23 [cfg80211]
  [<ffffffff810b7dac>] process_one_work+0x23d/0x37f
  [<ffffffff810b805c>] worker_thread+0x16e/0x283
  [<ffffffff810b7eee>] ? process_one_work+0x37f/0x37f
  [<ffffffff810bde31>] kthread+0xb5/0xbd
  [<ffffffff810bdd7c>] ? kthread_freezable_should_stop+0x60/0x60
  [<ffffffff815d9c2c>] ret_from_fork+0x7c/0xb0
  [<ffffffff810bdd7c>] ? kthread_freezable_should_stop+0x60/0x60
e1000e: eth0 NIC Link is Up 1000 Mbps Full Duplex, Flow Control: Rx/Tx
IPv6: ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
cfg80211: Restoring regulatory settings including user preference
cfg80211: Kicking the queue
cfg80211: Calling CRDA to update world regulatory domain

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

