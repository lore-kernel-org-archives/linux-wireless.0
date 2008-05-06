Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:1181 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755467AbYEFJHp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 May 2008 05:07:45 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: libertas-dev@lists.infradead.org
Subject: BUG: sleeping function called from invalid context
Date: Tue, 6 May 2008 11:04:43 +0200
Cc: "Linux Wireless" <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200805061104.43050.hs4233@mail.mn-solutions.de> (sfid-20080506_110701_857800_237FA3DD)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Here is something I haven't yet debugged and where I am a little 
bit clueless.

Situation: libertas has associated to an AP successfully and I 
run "iwconfig eth1 essid BLAHLABER". Everything is o.k. when I 
run the same command while not associated.

What I don't know is why something is calling 
get_wireless_stats() when setting the essid. This happens way 
before a call into lbs_set_essid() (the WEXT handler), as can be 
seen from the log below.


libertas enter: lbs_ret_80211_associate()
libertas assoc: associated to 00:13:19:80:da:30
##HS iwconfig eth1 essid BLAHLABER
libertas enter: lbs_get_wireless_stats()
libertas wext: signal level 0xd2
libertas wext: noise 0xa8
BUG: sleeping function called from invalid context at 
drivers/net/wireless/libertas/cmd.c:2013
in_atomic():1, irqs_disabled():0
2 locks held by iwconfig/16494:
 #0:  (&p->lock){--..}, at: [<c016d856>] seq_read+0x25/0x267
 #1:  (dev_base_lock){-.--}, at: [<c02bf6f6>] 
dev_seq_start+0x1d/0x7f
Pid: 16494, comm: iwconfig Not tainted 2.6.25-wl #33
 [<c0114e77>] __might_sleep+0xb3/0xb8
 [<f8837d9f>] __lbs_cmd+0x8b/0x175 [libertas]
 [<c0119477>] ? printk+0x15/0x17
 [<f883452a>] lbs_get_wireless_stats+0x17e/0x2d4 [libertas]
 [<f88392a7>] ? lbs_cmd_copyback+0x0/0x2d [libertas]
 [<c030464a>] get_wireless_stats+0x16/0x1c
 [<c03050ff>] wireless_seq_show+0x2f/0xcf
 [<c016d880>] ? seq_read+0x4f/0x267
 [<c016d9c1>] seq_read+0x190/0x267
 [<c016d831>] ? seq_read+0x0/0x267
 [<c0181376>] proc_reg_read+0x60/0x74
 [<c0181316>] ? proc_reg_read+0x0/0x74
 [<c01580ed>] vfs_read+0x8a/0x106
 [<c015845b>] sys_read+0x3b/0x60
 [<c010384a>] sysenter_past_esp+0x5f/0xa5
 =======================
BUG: scheduling while atomic: iwconfig/16494/0x00000002
2 locks held by iwconfig/16494:
 #0:  (&p->lock){--..}, at: [<c016d856>] seq_read+0x25/0x267
 #1:  (dev_base_lock){-.--}, at: [<c02bf6f6>] 
dev_seq_start+0x1d/0x7f
Pid: 16494, comm: iwconfig Not tainted 2.6.25-wl #33
 [<c0115d6b>] __schedule_bug+0x58/0x5f
 [<c032a863>] schedule+0x5b/0x2d1
 [<c0127d82>] ? prepare_to_wait+0x4d/0x53
 [<f8837df5>] __lbs_cmd+0xe1/0x175 [libertas]
 [<c0127c25>] ? autoremove_wake_function+0x0/0x33
 [<f883452a>] lbs_get_wireless_stats+0x17e/0x2d4 [libertas]
 [<f88392a7>] ? lbs_cmd_copyback+0x0/0x2d [libertas]
 [<c030464a>] get_wireless_stats+0x16/0x1c
 [<c03050ff>] wireless_seq_show+0x2f/0xcf
 [<c016d880>] ? seq_read+0x4f/0x267
 [<c016d9c1>] seq_read+0x190/0x267
 [<c016d831>] ? seq_read+0x0/0x267
 [<c0181376>] proc_reg_read+0x60/0x74
 [<c0181316>] ? proc_reg_read+0x0/0x74
 [<c01580ed>] vfs_read+0x8a/0x106
 [<c015845b>] sys_read+0x3b/0x60
 [<c010384a>] sysenter_past_esp+0x5f/0xa5
 =======================
BUG: scheduling while atomic: iwconfig/16494/0x00000002
2 locks held by iwconfig/16494:
 #0:  (&p->lock){--..}, at: [<c016d856>] seq_read+0x25/0x267
 #1:  (dev_base_lock){-.--}, at: [<c02bf6f6>] 
dev_seq_start+0x1d/0x7f
Pid: 16494, comm: iwconfig Not tainted 2.6.25-wl #33
 [<c0115d6b>] __schedule_bug+0x58/0x5f
 [<c032a863>] schedule+0x5b/0x2d1
 [<c0127d82>] ? prepare_to_wait+0x4d/0x53
 [<f8837df5>] __lbs_cmd+0xe1/0x175 [libertas]
 [<c0127c25>] ? autoremove_wake_function+0x0/0x33
 [<f883452a>] lbs_get_wireless_stats+0x17e/0x2d4 [libertas]
 [<f88392a7>] ? lbs_cmd_copyback+0x0/0x2d [libertas]
 [<c030464a>] get_wireless_stats+0x16/0x1c
 [<c03050ff>] wireless_seq_show+0x2f/0xcf
 [<c016d880>] ? seq_read+0x4f/0x267
 [<c016d9c1>] seq_read+0x190/0x267
 [<c016d831>] ? seq_read+0x0/0x267
 [<c0181376>] proc_reg_read+0x60/0x74
 [<c0181316>] ? proc_reg_read+0x0/0x74
 [<c01580ed>] vfs_read+0x8a/0x106
 [<c015845b>] sys_read+0x3b/0x60
 [<c010384a>] sysenter_past_esp+0x5f/0xa5
 =======================
libertas enter: lbs_set_essid()
libertas wext: requested SSID 'MNHS'

This happens with libertas from wireless-testing 
v2.6.25-6933-g0bacadf.

