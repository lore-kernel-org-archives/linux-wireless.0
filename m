Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from li12-156.members.linode.com ([70.85.129.156]:56386 "EHLO
	defaultvalue.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933159AbZJaSs6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Oct 2009 14:48:58 -0400
Received: from omen.defaultvalue.org (localhost [127.0.0.1])
	by defaultvalue.org (Postfix) with ESMTP id CEEFC90DA7
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2009 11:40:11 -0700 (PDT)
Received: from raven.defaultvalue.org (raven.defaultvalue.org [192.168.1.7])
	by omen.defaultvalue.org (Postfix) with ESMTP id 9AAD1507A8
	for <linux-wireless@vger.kernel.org>; Sat, 31 Oct 2009 11:40:11 -0700 (PDT)
From: Rob Browning <rlb@defaultvalue.org>
To: linux-wireless@vger.kernel.org
Subject: ath9k based AP stops responding after half a day or so
Date: Sat, 31 Oct 2009 11:40:11 -0700
Message-ID: <87my37if04.fsf@raven.defaultvalue.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I have an machine that's running a recent compat-wireless (2009-10-17),
kernel 2.6.30-2-686 (Debian), and a build of hostapd as of 2009-10-17
(08d38568).  The machine also has an AR5008 (ath9k) based PCI card.

After the machine reboots, wireless clients can connect to the AP
normally for a half day or so.  Then, at some point, all connections
fail, and clients cannot even see the network until the machine is
rebooted.  Reloading the wireless modules, and restarting hostapd
doesn't help.

Once the network has disappeared, if I restart hostapd with -dd, it gets
to this point:

  WPA: group state machine entering state GTK_INIT (VLAN-ID 0)
  GMK - hexdump(len=32): [REMOVED]
  GTK - hexdump(len=32): [REMOVED]
  WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
  nl_set_encr: ifindex=5 alg=2 addr=(nil) key_idx=1 set_tx=1 seq_len=0 key_len=32
  nl80211: Set beacon (beacon_set=0)
  wlan0: Setup of interface done.
  MGMT (TX callback) ACK

and then pauses for a long time.  Eventually it prints this:

  wlan0: WPA rekeying GTK
  WPA: group state machine entering state SETKEYS (VLAN-ID 0)
  GMK - hexdump(len=32): [REMOVED]
  GTK - hexdump(len=32): [REMOVED]
  wpa_group_setkeys: GKeyDoneStations=0
  WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
  nl_set_encr: ifindex=5 alg=2 addr=(nil) key_idx=2 set_tx=1 seq_len=0 key_len=32
  wlan0: WPA rekeying GTK

but clients still won't be able to connect until I reboot the machine.

If it helps, once the AP stopped responding, I reloaded the ath9k
modules with debugging enabled (modprobe ath9k debug=0xffffffff) and
found that while the machine in this state it prints something like this
to the log repeatedly:

  10:50:06 kernel: [230631.480019] ath: Writing ofdmbase=12582412   cckbase=12582712
  10:50:07 kernel: [230632.080018] ath: Writing ofdmbase=12582412   cckbase=12582712
  10:50:08 kernel: [230632.680020] ath: ANI parameters:
  10:50:08 kernel: [230632.680024] ath: noiseImmunityLevel=0, spurImmunityLevel=1, ofdmWeakSigDetectOff=1
  10:50:08 kernel: [230632.680029] ath: cckWeakSigThreshold=0, firstepLevel=0, listenTime=551
  10:50:08 kernel: [230632.680032] ath: cycleCount=-1758147678, ofdmPhyErrCount=99, cckPhyErrCount=1
  10:50:08 kernel: [230632.680035] 
  10:50:08 kernel: [230632.680037] ath: Writing ofdmbase=12582412   cckbase=12582712
  10:50:08 kernel: [230632.880017] ath: invalid cmd 2
  10:50:08 kernel: [230632.880023] ath: ANI parameters:
  10:50:08 kernel: [230632.880025] ath: noiseImmunityLevel=0, spurImmunityLevel=2, ofdmWeakSigDetectOff=1
  10:50:08 kernel: [230632.880029] ath: cckWeakSigThreshold=0, firstepLevel=0, listenTime=188
  10:50:08 kernel: [230632.880032] ath: cycleCount=-1749347644, ofdmPhyErrCount=107, cckPhyErrCount=0
  10:50:08 kernel: [230632.880035] 
  10:50:08 kernel: [230632.880037] ath: Writing ofdmbase=12582412   cckbase=12582712
  10:50:08 kernel: [230633.480017] ath: Writing ofdmbase=12582412   cckbase=12582712
  10:50:09 kernel: [230634.080018] ath: Writing ofdmbase=12582412   cckbase=12582712

Assuming this isn't a local configuration problem, I'd like to help fix
it if I can.  In case it matters, the machine in question is running a
firewall (shorewall).

Please let me know if I can provide further information.

Thanks
-- 
Rob Browning
rlb @defaultvalue.org and @debian.org; previously @cs.utexas.edu
GPG as of 2002-11-03 14DD 432F AE39 534D B592 F9A0 25C8 D377 8C7E 73A4
