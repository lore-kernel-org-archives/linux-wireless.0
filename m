Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:39916 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202AbbCFKrx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 05:47:53 -0500
Received: by wiwl15 with SMTP id l15so2548604wiw.4
        for <linux-wireless@vger.kernel.org>; Fri, 06 Mar 2015 02:47:51 -0800 (PST)
From: Sven Eckelmann <sven@open-mesh.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
	Johannes Berg <johannes.berg@intel.com>
Subject: Re: [RFC v2] [RFC] mac80211: lock rate control
Date: Fri, 06 Mar 2015 11:47:48 +0100
Message-ID: <2736671.Y6Lt54SxyK@bentobox> (sfid-20150306_114805_768318_A1BF2BD0)
In-Reply-To: <1425575237-5556-1-git-send-email-johannes@sipsolutions.net>
References: <1425575237-5556-1-git-send-email-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="nextPart3837925.eL4c4tZl1O"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.

--nextPart3837925.eL4c4tZl1O
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Thursday 05 March 2015 18:07:17 Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Both minstrel (reported by Sven Eckelmann) and the iwlwifi rate
> control aren't properly taking concurrency into account. It's
> likely that the same is true for other rate control algorithms.
> 
> In the case of minstrel this manifests itself in crashes when an
> update and other data access are run concurrently, for example
> when the stations change bandwidth or similar. In iwlwifi, this
> can cause firmware crashes.
> 
> Since fixing all rate control algorithms will be very difficult,
> just provide locking for invocations. This protects the internal
> data structures the algorithms maintain.
> 
> I've manipulated hostapd to test this, by having it change its
> advertised bandwidth roughly ever 150ms. At the same time, I'm
> running a flood ping between the client and the AP, which causes
> this race of update vs. get_rate/status to easily happen on the
> client. With this change, the system survives this test.
> 
> Change-Id: I77383401a67a1ec380cec65b34802ab879357e80
> Reported-by: Sven Eckelmann <sven@open-mesh.com>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---

Thanks for the second patch. I got a message today that the patched wifi 
driver was tested at least on one network and it still crashes. You can see 
the attached logs but they are mostly the same as before - just with some 
addresses changed due to the patch.

I've looked through the code and didn't find a situation where the tx_status 
function pointer is called without the lock. Same for the rate_update. But 
there is something in minstrel_ht which you most likely don't have in the 
iwlwifi code:

 minstrel_ht_update_caps is called by rate_update and rate_init

My hypothesis would be that rate_init is called for a sta during tx_status and 
this causes one of the crashes. This sounds a little bit weird but at least 
one thing that can be checked. I am not sure in which state the device is but 
it is most likely running AP vifs and one IBSS vif.

The function rate_control_rate_init is called by the IBSS code (in my OpenWrt 
compat-wireless 2014-11-04 snapshot) in ieee80211_ibss_finish_sta and 
ieee80211_rx_bss_info after an rates_updated. At least the latter one sounds 
suspicious.

I will just add following modification to your patch and ask for a new test. 
But feel free to point out any problem in my hypothesis.


@@ -69,8 +71,10 @@ static inline void rate_control_rate_ini
 
 	sband = local->hw.wiphy->bands[chanctx_conf->def.chan->band];
 
+	spin_lock_bh(&sta->rate_ctrl_lock);
 	ref->ops->rate_init(ref->priv, sband, &chanctx_conf->def, ista,
 			    priv_sta);
+	spin_unlock_bh(&sta->rate_ctrl_lock);
 	rcu_read_unlock();
 	set_sta_flag(sta, WLAN_STA_RATE_CONTROL);
 }

Kind regards,
	Sven
--nextPart3837925.eL4c4tZl1O
Content-Disposition: attachment; filename="minstel_crash.txt"
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; name="minstel_crash.txt"

Before applying the patch


[ 4161.700000] CPU 0 Unable to handle kernel paging request at virtual =
address 00000048, epc =3D=3D 83b93c24, ra =3D=3D 83b81fa8
[ 4161.710000] Oops[#1]:
[ 4161.710000] Cpu 0
[ 4161.710000] $ 0   : 00000000 00000000 ffffffff 00000012
[ 4161.710000] $ 4   : 83b5cac0 00000000 82eff580 82eff592
[ 4161.710000] $ 8   : 00000000 83bcda00 00000008 0000000f
[ 4161.710000] $12   : 00004000 00000001 00000000 00000001
[ 4161.710000] $16   : 83248000 83b5cac0 83394840 8212b030
[ 4161.710000] $20   : 00000001 00000001 00000800 83394843
[ 4161.710000] $24   : 00000000 00000000                 =20
[ 4161.710000] $28   : 82d5c000 82d5d920 04208060 83b81fa8
[ 4161.710000] Hi    : 00000000
[ 4161.710000] Lo    : 00000000
[ 4161.710000] epc   : 83b93c24 rate_control_set_rates+0x8/0x120 [mac80=
211]
[ 4161.710000]     Tainted: P           O
[ 4161.710000] ra    : 83b81fa8 ieee80211_tx_status+0x400/0xde8 [mac802=
11]
[ 4161.710000] Status: 1100f403    KERNEL EXL IE=20
[ 4161.710000] Cause : 00802008
[ 4161.710000] BadVA : 00000048
[ 4161.710000] PrId  : 0001974c (MIPS 74Kc)
[ 4161.710000] Modules linked in: sch_teql sch_tbf sch_sfq sch_red sch_=
prio sch_netem sch_htb sch_gred sch_dsmark em_text em_nbyte em_meta em_=
cmp cls_basic act_police act_ipt act_skbedit act_mirred em_u32 cls_u32 =
cls_tcindex cls_flow cls_route cls_fw sch_hfsc sch_fq_codel sch_codel s=
ch_ingress tmp421 ath10k_pci(O) ath10k_core(O) UDSMARK(O) udsmac(O) i2c=
_dev tc_classid_mapper(PO) filter_group(O) ledtrig_netdev classifier_du=
mper(PO) classifier_dns(PO) classifier_netblock(PO) classifier_bittorre=
nt(PO) classifier_rtmp(PO) classifier_ssl(PO) classifier_content(PO) cl=
assifier_skype(PO) kernel_classifier(O) batman_adv(O) ip6t_REJECT ip6t_=
rt ip6t_hbh ip6t_mh ip6t_ipv6header ip6t_frag ip6t_eui64 ip6t_ah ip6t_N=
PT ip6t_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_raw ip6table_mangl=
e ip6table_filter ip6_tables nf_conntrack_ipv6 nf_defrag_ipv6 xt_IMQ im=
q nf_nat_tftp nf_conntrack_tftp nf_nat_snmp_basic nf_conntrack_snmp nf_=
nat_sip nf_conntrack_sip nf_nat_pptp nf_conntrack_pptp nf_nat_h323 nf_c=
onntrack_h323 nf_nat_proto_gre nf_conntrack_proto_gre nf_nat_amanda nf_=
conntrack_amanda nf_conntrack_broadcast nf_nat_irc nf_nat_ftp nf_conntr=
ack_irc nf_conntrack_ftp xt_HL xt_hl xt_ecn ipt_ECN xt_CLASSIFY xt_time=
 xt_tcpmss xt_statistic xt_mark xt_length xt_DSCP xt_dscp xt_string xt_=
layer7 xt_quota xt_pkttype xt_physdev xt_owner xt_addrtype xt_REDIRECT =
xt_NETMAP ipt_MASQUERADE iptable_nat xt_nat nf_nat_ipv4 nf_nat xt_recen=
t xt_helper xt_connmark xt_connbytes xt_conntrack xt_CT iptable_raw xt_=
state nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack ipt_REJECT xt_TCPMS=
S xt_LOG xt_comment xt_multiport xt_mac xt_limit iptable_mangle iptable=
_filter ip_tables xt_tcpudp x_tables hwmon ifb tun button_hotplug(O) at=
h9k(O) ath9k_common(O) ath9k_hw(O) ath(O) mac80211(O) ts_fsm ts_bm ts_k=
mp libcrc32c crc16 crc_ccitt input_polldev cfg80211(O) compat(O) input_=
core ag71xx arc4 crc32c crypto_blkcipher aead crypto_hash ledtrig_timer=
 ledtrig_default_on leds_gpio gpio_button_hotplug(O)
[ 4161.710000] Process kworker/u:2 (pid: 15261, threadinfo=3D82d5c000, =
task=3D822ba140, tls=3D00000000)
[ 4161.710000] Stack : 83248000 83248000 83b5cac0 83394840 8212b030 83b=
81fa8 00000001 80000000
        82d5da08 00000001 83394840 82d5d964 8029ee8c 80000000 8032b714 =
83394480
        8032beb8 00000000 00000000 00000001 8388212c 83093042 8392b800 =
82d5da20
        803b0000 80340000 83b5d6a0 82d5d9c0 83b7ef30 83b5d6a0 83882010 =
00100100
        00200200 803a0000 04208060 83b48728 00000000 00000000 83b5e0a8 =
83b5e068
        ...
[ 4161.710000] Call Trace:
[ 4161.710000] [<83b93c24>] rate_control_set_rates+0x8/0x120 [mac80211]=

[ 4161.710000] [<83b81fa8>] ieee80211_tx_status+0x400/0xde8 [mac80211]
[ 4161.710000] [<83b48728>] ath_txq_unlock_complete+0xa8/0xc0 [ath9k]
[ 4161.710000] [<83b4baec>] ath_tx_edma_tasklet+0x288/0x2b8 [ath9k]
[ 4161.710000] [<83b447f0>] ath9k_tasklet+0x264/0x2c8 [ath9k]
[ 4161.710000] [<8007e31c>] tasklet_action+0x78/0xc8
[ 4161.710000] [<8007db6c>] __do_softirq+0xb0/0x184
[ 4161.710000] [<8007dcf0>] do_softirq+0x48/0x68
[ 4161.710000] [<8007df0c>] irq_exit+0x4c/0x80
[ 4161.710000] [<8006082c>] ret_from_irq+0x0/0x4
[ 4161.710000] [<80064800>] __bzero+0x44/0x164
[ 4161.710000] [<83bc8208>] minstrel_remove_sta_debugfs+0x11ec/0x1aa0 [=
mac80211]
[ 4161.710000]=20
[ 4161.710000]=20
Code: 27bd0020  27bdffe8  afbf0014 <8ca40048> 10800003  aca60048  0c02c=
21a  00002821  8fbf0014=20
[ 4162.100000] ---[ end trace 0873425f4a654b6a ]---



-----------------------------------------------------------------------=
---------

After applying the patch

CPU 0 Unable to handle kernel paging request at virtual address 0000004=
8, epc =3D=3D 83b93c84, ra =3D=3D 83b81fb4
[  846.030000] Oops[#1]:
[  846.030000] Cpu 0
[  846.030000] $ 0   : 00000000 00000000 ffffffff 00000012
[  846.030000] $ 4   : 83b68ac0 00000000 81d99200 81d99212
[  846.030000] $ 8   : 00000000 83bcdb20 00000008 0000000f
[  846.030000] $12   : 00004000 00000001 00000000 00000000
[  846.030000] $16   : 83a66000 83b68ac0 83b3f9c0 82e50040
[  846.030000] $20   : 00000000 00000001 0000b000 83b3f9c0
[  846.030000] $24   : 00000000 00000000                 =20
[  846.030000] $28   : 83838000 83839920 83bdb000 83b81fb4
[  846.030000] Hi    : 00000000
[  846.030000] Lo    : 00000000
[  846.030000] epc   : 83b93c84 rate_control_set_rates+0x8/0x120 [mac80=
211]
[  846.030000]     Tainted: P           O
[  846.030000] ra    : 83b81fb4 ieee80211_tx_status+0x40c/0xe00 [mac802=
11]
[  846.030000] Status: 1100f403    KERNEL EXL IE=20
[  846.030000] Cause : 00800008
[  846.030000] BadVA : 00000048
[  846.030000] PrId  : 0001974c (MIPS 74Kc)
[  846.030000] Modules linked in: sch_teql sch_tbf sch_sfq sch_red sch_=
prio sch_netem sch_htb sch_gred sch_dsmark em_text em_nbyte em_meta em_=
cmp cls_basic act_police act_ipt act_skbedit act_mirred em_u32 cls_u32 =
cls_tcindex cls_flow cls_route cls_fw sch_hfsc sch_fq_codel sch_codel s=
ch_ingress tmp421 ath10k_pci(O) ath10k_core(O) UDSMARK(O) udsmac(O) i2c=
_dev tc_classid_mapper(PO) filter_group(O) ledtrig_netdev classifier_du=
mper(PO) classifier_dns(PO) classifier_netblock(PO) classifier_bittorre=
nt(PO) classifier_rtmp(PO) classifier_ssl(PO) classifier_content(PO) cl=
assifier_skype(PO) kernel_classifier(O) batman_adv(O) ip6t_REJECT ip6t_=
rt ip6t_hbh ip6t_mh ip6t_ipv6header ip6t_frag ip6t_eui64 ip6t_ah ip6t_N=
PT ip6t_MASQUERADE ip6table_nat nf_nat_ipv6 ip6table_raw ip6table_mangl=
e ip6table_filter ip6_tables nf_conntrack_ipv6 nf_defrag_ipv6 xt_IMQ im=
q nf_nat_tftp nf_conntrack_tftp nf_nat_snmp_basic nf_conntrack_snmp nf_=
nat_sip nf_conntrack_sip nf_nat_pptp nf_conntrack_pptp nf_nat_h323 nf_c=
onntrack_h323 nf_nat_proto_gre nf_conntrack_proto_gre nf_nat_amanda nf_=
conntrack_amanda nf_conntrack_broadcast nf_nat_irc nf_nat_ftp nf_conntr=
ack_irc nf_conntrack_ftp xt_HL xt_hl xt_ecn ipt_ECN xt_CLASSIFY xt_time=
 xt_tcpmss xt_statistic xt_mark xt_length xt_DSCP xt_dscp xt_string xt_=
layer7 xt_quota xt_pkttype xt_physdev xt_owner xt_addrtype xt_REDIRECT =
xt_NETMAP ipt_MASQUERADE iptable_nat xt_nat nf_nat_ipv4 nf_nat xt_recen=
t xt_helper xt_connmark xt_connbytes xt_conntrack xt_CT iptable_raw xt_=
state nf_conntrack_ipv4 nf_defrag_ipv4 nf_conntrack ipt_REJECT xt_TCPMS=
S xt_LOG xt_comment xt_multiport xt_mac xt_limit iptable_mangle iptable=
_filter ip_tables xt_tcpudp x_tables hwmon ifb tun button_hotplug(O) at=
h9k(O) ath9k_common(O) ath9k_hw(O) ath(O) mac80211(O) ts_fsm ts_bm ts_k=
mp libcrc32c crc16 crc_ccitt input_polldev cfg80211(O) compat(O) input_=
core ag71xx arc4 crc32c crypto_blkcipher aead crypto_hash ledtrig_timer=
 ledtrig_default_on leds_gpio gpio_button_hotplug(O)
[  846.030000] Process kworker/u:0 (pid: 6, threadinfo=3D83838000, task=
=3D8381d4c8, tls=3D00000000)
[  846.030000] Stack : 83a66000 83a66000 83b68ac0 83b3f9c0 82e50040 83b=
81fb4 822d62c0 801e947c
        83839a08 00000001 83b3f9c0 00000000 838399a0 83b947a0 822d62c0 =
00000000
        83886000 00000000 00000000 00000000 8388212c 00000000 00000089 =
00001002
        022d630e 00000000 83b696a0 838399c0 83b65250 83b696a0 83882010 =
00100100
        00200200 803a0000 04208060 83b48728 00000000 00000000 83b6a170 =
83b6a150
        ...
[  846.030000] Call Trace:
[  846.030000] [<83b93c84>] rate_control_set_rates+0x8/0x120 [mac80211]=

[  846.030000] [<83b81fb4>] ieee80211_tx_status+0x40c/0xe00 [mac80211]
[  846.030000] [<83b48728>] ath_txq_unlock_complete+0xa8/0xc0 [ath9k]
[  846.030000] [<83b4baec>] ath_tx_edma_tasklet+0x288/0x2b8 [ath9k]
[  846.030000] [<83b447f0>] ath9k_tasklet+0x264/0x2c8 [ath9k]
[  846.030000] [<8007e31c>] tasklet_action+0x78/0xc8
[  846.030000] [<8007db6c>] __do_softirq+0xb0/0x184
[  846.030000] [<8007dcf0>] do_softirq+0x48/0x68
[  846.030000] [<8007df0c>] irq_exit+0x4c/0x80
[  846.030000] [<8006082c>] ret_from_irq+0x0/0x4
[  846.030000] [<80064804>] __bzero+0x48/0x164
[  846.030000] [<83bc8328>] minstrel_remove_sta_debugfs+0x11ec/0x1aa0 [=
mac80211]
[  846.030000]=20
[  846.030000]=20
Code: 27bd0020  27bdffe8  afbf0014 <8ca40048> 10800003  aca60048  0c02c=
21a  00002821  8fbf0014=20
[  846.410000] ---[ end trace 36e2ac14823a5880 ]---
--nextPart3837925.eL4c4tZl1O--

