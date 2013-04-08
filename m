Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:6679 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934341Ab3DHFkZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Apr 2013 01:40:25 -0400
From: "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>
To: Jonathan McDowell <noodles@earth.li>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Intel Linux Wireless <ilw@linux.intel.com>
Subject: RE: [Ilw] Problems with Intel 2230 and AP mode
Date: Mon, 8 Apr 2013 05:39:09 +0000
Message-ID: <0BA3FCBA62E2DC44AF3030971E174FB301969F2E@HASMSX103.ger.corp.intel.com> (sfid-20130408_074032_232264_44E75A91)
References: <20130402190831.GQ31591@earth.li>
 <0BA3FCBA62E2DC44AF3030971E174FB301965EC0@HASMSX103.ger.corp.intel.com>
 <20130403182153.GT31591@earth.li>
 <0BA3FCBA62E2DC44AF3030971E174FB301969684@HASMSX103.ger.corp.intel.com>
 <20130407220314.GX31591@earth.li>
In-Reply-To: <20130407220314.GX31591@earth.li>
Content-Type: multipart/mixed;
	boundary="_002_0BA3FCBA62E2DC44AF3030971E174FB301969F2EHASMSX103gercor_"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--_002_0BA3FCBA62E2DC44AF3030971E174FB301969F2EHASMSX103gercor_
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable

> > > > >
> > > > > I'm trying to build my own wifi router, cobbling together a Debian
> > > > > (wheezy) box, hostapd (1.0) and an Intel 2230. I'm seeing various
> > > > > problems with the 2230 and I'm wondering if I'm mad for trying to=
 use
> > > > > this card in AP mode (in which case is there an alternative Intel=
 card I
> > > > > should use, or is an ath9k my best bet), or if it's worthwhile re=
porting
> > > > > the issues and trying fixes.
> > > > >
> > > > > I'm using 3.8.5 (and previously 3.8.4). I tried 3.9-rc4 briefly b=
ut it
> > > > > was unusable - as soon as there was any traffic I saw errors like:
> ...
> > Can you please try the patch attached?
> >
> > Note that I couldn't really test it so...
> >
> > Also, it seems that the best way to reproduce the issue is to have a
> > station disappear while TX AMPDU is working.
> =

> I suspect that's being caused by the cell phones appearing briefly and
> then disappearing. I've applied the patch to 3.9-rc5 (and also "iwlwifi:
> dvm: don't send HCMD in restart flow" which I saw hit stable but isn't
> in rc5) and I've had the following WARNING:
> =

> [ 8370.590990] iwlwifi 0000:04:00.0: I iwlagn_tx_agg_start Can proceed: s=
sn =3D
> next_recl =3D 2026
> [ 8370.593327] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate
> queue 11 on FIFO 4 WrPtr: 234
> [ 8372.504646] iwlwifi 0000:04:00.0: I iwlagn_tx_agg_start Can proceed: s=
sn =3D
> next_recl =3D 700
> [ 8372.526891] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate
> queue 12 on FIFO 4 WrPtr: 188
> [ 8381.218880] iwlwifi 0000:04:00.0: I iwlagn_tx_agg_stop Can proceed: ss=
n =3D
> next_recl =3D 2028
> [ 8381.218912] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_disable Deactiv=
ate
> queue 11
> [ 8385.219756] iwlwifi 0000:04:00.0: I iwlagn_tx_agg_stop Can proceed: ss=
n =3D
> next_recl =3D 708
> [ 8385.219788] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_disable Deactiv=
ate
> queue 12
> [ 8421.657189] iwlwifi 0000:04:00.0: I iwlagn_tx_agg_start Can proceed: s=
sn =3D
> next_recl =3D 196
> [ 8422.646042] iwlwifi 0000:04:00.0: I iwlagn_tx_agg_flush Flush AGG: sta=
 4 tid
> 0 q 11 state 0
> [ 8422.646301] ------------[ cut here ]------------
> [ 8422.647227] WARNING: at drivers/net/wireless/iwlwifi/pcie/tx.c:1120
> iwl_trans_pcie_txq_disable+0x45/0xb9 [iwlwifi]()
> [ 8422.648165] Hardware name: To be filled by O.E.M.
> [ 8422.649125] queue 11 not used
> [ 8422.649150] Modules linked in: sit tunnel4 ip6t_REJECT xt_LOG xt_limit
> nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filter ip6_tables 8021q garp st=
p llc
> ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat xt_tcpudp nf_conntrack_ipv4
> nf_defrag_ipv4 xt_state nf_conntrack iptable_filter ip_tables x_tables du=
mmy
> nls_utf8 nls_cp437 vfat fat loop rt2800usb rt2800lib rt2x00usb rt2x00lib
> crc_ccitt tda18271 lgdt3305 hid_generic em28xx_dvb dvb_core btusb bluetoo=
th
> em28xx videobuf2_vmalloc videobuf2_memops videobuf2_core tveeprom
> v4l2_common videodev media joydev hid_aureal usbhid hid
> snd_hda_codec_hdmi snd_hda_codec_realtek snd_hda_intel snd_hda_codec
> snd_hwdep snd_pcm arc4 snd_page_alloc kvm_intel iwldvm mac80211 iwlwifi
> kvm snd_seq crc32_pclmul crc32c_intel ghash_clmulni_intel snd_seq_device
> snd_timer xhci_hcd snd cfg80211 rfkill iTCO_wdt iTCO_vendor_support cryptd
> soundcore i2c_i801 lpc_ich mfd_core mei ehci_pci ehci_hcd usbcore
> usb_common acpi_cpufreq mperf processor evdev microcode fan thermal
> [ 8422.657942] Pid: 2038, comm: hostapd Not tainted 3.9.0-rc5 #2
> [ 8422.659702] Call Trace:
> [ 8422.661460]  [<ffffffff8102c007>] ? warn_slowpath_common+0x76/0x8c
> [ 8422.663291]  [<ffffffff8102c0b5>] ? warn_slowpath_fmt+0x45/0x4a
> [ 8422.665130]  [<ffffffffa024396f>] ? iwlagn_txfifo_flush+0x9d/0xa3 [iwl=
dvm]
> [ 8422.667003]  [<ffffffffa032d92d>] ? iwl_trans_pcie_txq_disable+0x45/0x=
b9
> [iwlwifi]
> [ 8422.668911]  [<ffffffffa0241913>] ? iwlagn_tx_agg_flush+0xc4/0xd9
> [iwldvm]
> [ 8422.670820]  [<ffffffffa023e82d>] ?
> iwlagn_mac_ampdu_action+0x1cb/0x2db [iwldvm]
> [ 8422.672754]  [<ffffffffa01be4ae>] ? drv_ampdu_action+0xf2/0x148
> [mac80211]
> [ 8422.674706]  [<ffffffff8107ede1>] ? try_stop_cpus+0x42/0x53
> [ 8422.676671]  [<ffffffff8104f680>] ? should_resched+0x5/0x23
> [ 8422.678687]  [<ffffffffa01bef01>] ?
> ___ieee80211_stop_tx_ba_session+0x1b3/0x1db [mac80211]
> [ 8422.680739]  [<ffffffff8104f680>] ? should_resched+0x5/0x23
> [ 8422.682822]  [<ffffffffa01bf30a>] ?
> __ieee80211_stop_tx_ba_session+0x31/0x4a [mac80211]
> [ 8422.684964]  [<ffffffffa01bdf68>] ?
> ieee80211_sta_tear_down_BA_sessions+0x2d/0x58 [mac80211]
> [ 8422.687157]  [<ffffffffa01ba1d3>] ? __sta_info_destroy+0x41/0x1e2
> [mac80211]
> [ 8422.689368]  [<ffffffffa01ba4de>] ? sta_info_destroy_addr_bss+0x35/0x56
> [mac80211]
> [ 8422.691633]  [<ffffffffa00baa8b>] ? nl80211_del_station+0x6c/0xc2
> [cfg80211]
> [ 8422.693915]  [<ffffffff81386476>] ? genl_rcv_msg+0x1b6/0x1ff
> [ 8422.696219]  [<ffffffff813862c0>] ? genl_rcv+0x28/0x28
> [ 8422.698532]  [<ffffffff81385f83>] ? netlink_rcv_skb+0x36/0x7c
> [ 8422.700808]  [<ffffffff813862b7>] ? genl_rcv+0x1f/0x28
> [ 8422.703115]  [<ffffffff81385aa5>] ? netlink_unicast+0xde/0x15e
> [ 8422.705447]  [<ffffffff810f6f5f>] ? set_restore_sigmask+0x2d/0x2d
> [ 8422.707796]  [<ffffffff81385db2>] ? netlink_sendmsg+0x28d/0x2b4
> [ 8422.710111]  [<ffffffff8104f680>] ? should_resched+0x5/0x23
> [ 8422.712466]  [<ffffffff81354616>] ? sock_sendmsg+0x4f/0x6c
> [ 8422.714770]  [<ffffffff814044ab>] ? packet_recvmsg+0x469/0x47c
> [ 8422.717095]  [<ffffffff810f6f5f>] ? set_restore_sigmask+0x2d/0x2d
> [ 8422.719447]  [<ffffffff81354825>] ? __sys_sendmsg+0x1f2/0x284
> [ 8422.721801]  [<ffffffff8104f680>] ? should_resched+0x5/0x23
> [ 8422.724180]  [<ffffffff8141dc07>] ? _cond_resched+0x6/0x1a
> [ 8422.726589]  [<ffffffff810468cc>] ? autoremove_wake_function+0x2a/0x2a
> [ 8422.729015]  [<ffffffff810f93cc>] ? dentry_kill+0x121/0x12d
> [ 8422.731459]  [<ffffffff810f981d>] ? dput+0xe6/0xf3
> [ 8422.733909]  [<ffffffff810ea73f>] ? __fput+0x192/0x1b9
> [ 8422.736418]  [<ffffffff810fdac0>] ? fget_light+0x2c/0x74
> [ 8422.739611]  [<ffffffff8135584c>] ? sys_sendmsg+0x39/0x57
> [ 8422.742841]  [<ffffffff81423852>] ? system_call_fastpath+0x16/0x1b
> [ 8422.746075] ---[ end trace dc0022bd7c6404b6 ]---
> [ 8427.736757] iwlwifi 0000:04:00.0: I iwlagn_tx_agg_start Can proceed: s=
sn =3D
> next_recl =3D 734
> [ 8427.744108] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate
> queue 11 on FIFO 4 WrPtr: 222
> [ 8457.809811] iwlwifi 0000:04:00.0: I iwlagn_tx_agg_stop Can proceed: ss=
n =3D
> next_recl =3D 1595
> [ 8457.809843] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_disable Deactiv=
ate
> queue 11
> [ 8487.759858] iwlwifi 0000:04:00.0: I iwlagn_tx_agg_start Can't proceed:=
 ssn
> 1843, next_reclaimed =3D 1803
> [ 8487.786678] iwlwifi 0000:04:00.0: I iwlagn_check_ratid_empty Can conti=
nue
> ADDBA flow ssn =3D next_recl =3D 1843
> [ 8487.802696] iwlwifi 0000:04:00.0: U iwl_trans_pcie_txq_enable Activate
> queue 11 on FIFO 4 WrPtr: 51
> =


Stupid me - can you please try with this one?
Thanks
---------------------------------------------------------------------
A member of the Intel Corporation group of companies

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

--_002_0BA3FCBA62E2DC44AF3030971E174FB301969F2EHASMSX103gercor_
Content-Type: application/octet-stream;
	name="0001-iwlwifi-dvm-handle-FLUSH-ampdu-actions-from-mac80211.patch"
Content-Description: 0001-iwlwifi-dvm-handle-FLUSH-ampdu-actions-from-mac80211.patch
Content-Disposition: attachment;
	filename="0001-iwlwifi-dvm-handle-FLUSH-ampdu-actions-from-mac80211.patch";
	size=6732; creation-date="Mon, 08 Apr 2013 05:36:32 GMT";
	modification-date="Mon, 08 Apr 2013 05:38:27 GMT"
Content-Transfer-Encoding: base64

RnJvbSA0MzVhZmRmMTE4NjdlYWVmOWJiZWY0OTMwNmNhMTQ1MDJjNTgwYzgxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBFbW1hbnVlbCBHcnVtYmFjaCA8ZW1tYW51ZWwuZ3J1bWJhY2hA
aW50ZWwuY29tPgpEYXRlOiBTdW4sIDcgQXByIDIwMTMgMTA6MTM6NDQgKzAzMDAKU3ViamVjdDog
W1BBVENIXSBpd2x3aWZpOiBkdm06IGhhbmRsZSBGTFVTSCBhbXBkdSBhY3Rpb25zIGZyb20gbWFj
ODAyMTEKClVudGlsIG5vdyB3ZSBkaWRuJ3QgaGFuZGxlIHByb3Blcmx5IHRoZSBGTFVTSCBhbXBk
dSBhY3Rpb24KY29taW5nIGZyb20gbWFjODAyMTEuIFRoaXMgY291bGQgcmVzdWx0IGluIFNDRCBx
dWV1ZSBsZWFrOgptYWM4MDIxMSB3b3VsZCBTVE9QX0ZMVVNIIGFuIEFNUERVIFR4IHNlc3Npb24g
YW5kIHJlbW92ZQp0aGUgc3RhdGlvbi4gSWYgd2UgaGFkIHN0aWxsIHBhY2tldHMgb24gdGhlIHJp
bmcsIHdlCndvdWxkbid0IGRlYWxsb2NhdGUgdGhlIFNDRCBxdWV1ZSBhbmQgd2FpdCBmb3IgaXQg
dG8gYmUKZW1wdHkuClRoZSBpbmRpY2F0aW9uIG9mIHRoZSBxdWV1ZSBiZWluZyBlbXB0eSBjb21l
cyBmcm9tIHRoZSBUeApyZXNwb25zZSBmbG93IHdoaWNoIHJlbGllcyBvbiB0aGUgdGlkX2RhdGEg
c3RydWN0dXJlLiBUaGUKcHJvYmxlbSBpcyB0aGF0IHRoaXMgc3RydWN0dXJlIGhhcyBiZWVuIGNs
ZWFyZWQgd2hlbiB0aGUKc3RhdGlvbiBoYXMgYmVlbiByZW1vdmVkLgpJbiBvcmRlciB0byBzb2x2
ZSB0aGlzIGlzc3VlLCBibG9jayBpbiB0aGUgU1RPUF9GTFVTSAphbXBkdV9hY3Rpb24gdW50aWwg
dGhlIFNDRCBxdWV1ZSBpcyBmbHVzaGVkLCBhbmQgb25seSB0aGVuLApsZXQgbWFjODAyMTEgbW92
ZSBmb3J3YXJkIHRvIHJlbW92ZSB0aGUgc3RhdGlvbi4KaXdsYWduX3R4Zmlmb19mbHVzaCBoYWQg
dG8gYmUgZW5oYW5jZWQgdG8gYWxsb3cgdGhpcy4KClRoZSBidWcgZml4ZWQgaGVyZSBjYXVzZWQg
dGhlICJ0eHFfaWQgbWlzbWF0Y2g6IDEyIDAiIHByaW50LgoKQ2hhbmdlLUlkOiBJYTdhYjA4ZDgz
NDZmZjgzNmIyNWYyMmEwOTQwOWM2NzZmOWQ1NTk5NApTaWduZWQtb2ZmLWJ5OiBFbW1hbnVlbCBH
cnVtYmFjaCA8ZW1tYW51ZWwuZ3J1bWJhY2hAaW50ZWwuY29tPgotLS0KIGRyaXZlcnMvbmV0L3dp
cmVsZXNzL2l3bHdpZmkvZHZtL2Fnbi5oICAgICAgfCAgNCArKy0KIGRyaXZlcnMvbmV0L3dpcmVs
ZXNzL2l3bHdpZmkvZHZtL2xpYi5jICAgICAgfCAgNyArKystLQogZHJpdmVycy9uZXQvd2lyZWxl
c3MvaXdsd2lmaS9kdm0vbWFjODAyMTEuYyB8ICA3ICsrKy0tCiBkcml2ZXJzL25ldC93aXJlbGVz
cy9pd2x3aWZpL2R2bS90eC5jICAgICAgIHwgNDQgKysrKysrKysrKysrKysrKysrKysrKysrKysr
KysKIDQgZmlsZXMgY2hhbmdlZCwgNTcgaW5zZXJ0aW9ucygrKSwgNSBkZWxldGlvbnMoLSkKCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2R2bS9hZ24uaCBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvZHZtL2Fnbi5oCmluZGV4IGViMjgwMzIuLjUzZTdhNDMg
MTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvZHZtL2Fnbi5oCisrKyBi
L2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvZHZtL2Fnbi5oCkBAIC0xNzgsNyArMTc4LDcg
QEAgaW50IGl3bGFnbl9od192YWxpZF9ydGNfZGF0YV9hZGRyKHUzMiBhZGRyKTsKIC8qIGxpYiAq
LwogaW50IGl3bGFnbl9zZW5kX3R4X3Bvd2VyKHN0cnVjdCBpd2xfcHJpdiAqcHJpdik7CiB2b2lk
IGl3bGFnbl90ZW1wZXJhdHVyZShzdHJ1Y3QgaXdsX3ByaXYgKnByaXYpOwotaW50IGl3bGFnbl90
eGZpZm9fZmx1c2goc3RydWN0IGl3bF9wcml2ICpwcml2KTsKK2ludCBpd2xhZ25fdHhmaWZvX2Zs
dXNoKHN0cnVjdCBpd2xfcHJpdiAqcHJpdiwgdTMyIHNjZF9xX21zayk7CiB2b2lkIGl3bGFnbl9k
ZXZfdHhmaWZvX2ZsdXNoKHN0cnVjdCBpd2xfcHJpdiAqcHJpdik7CiBpbnQgaXdsYWduX3NlbmRf
YmVhY29uX2NtZChzdHJ1Y3QgaXdsX3ByaXYgKnByaXYpOwogaW50IGl3bF9zZW5kX3N0YXRpc3Rp
Y3NfcmVxdWVzdChzdHJ1Y3QgaXdsX3ByaXYgKnByaXYsCkBAIC0yMTIsNiArMjEyLDggQEAgaW50
IGl3bGFnbl90eF9hZ2dfb3BlcihzdHJ1Y3QgaXdsX3ByaXYgKnByaXYsIHN0cnVjdCBpZWVlODAy
MTFfdmlmICp2aWYsCiAJCQlzdHJ1Y3QgaWVlZTgwMjExX3N0YSAqc3RhLCB1MTYgdGlkLCB1OCBi
dWZfc2l6ZSk7CiBpbnQgaXdsYWduX3R4X2FnZ19zdG9wKHN0cnVjdCBpd2xfcHJpdiAqcHJpdiwg
c3RydWN0IGllZWU4MDIxMV92aWYgKnZpZiwKIAkJICAgICAgIHN0cnVjdCBpZWVlODAyMTFfc3Rh
ICpzdGEsIHUxNiB0aWQpOworaW50IGl3bGFnbl90eF9hZ2dfZmx1c2goc3RydWN0IGl3bF9wcml2
ICpwcml2LCBzdHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLAorCQkJc3RydWN0IGllZWU4MDIxMV9z
dGEgKnN0YSwgdTE2IHRpZCk7CiBpbnQgaXdsYWduX3J4X3JlcGx5X2NvbXByZXNzZWRfYmEoc3Ry
dWN0IGl3bF9wcml2ICpwcml2LAogCQkJCSAgIHN0cnVjdCBpd2xfcnhfY21kX2J1ZmZlciAqcnhi
LAogCQkJCSAgIHN0cnVjdCBpd2xfZGV2aWNlX2NtZCAqY21kKTsKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvZHZtL2xpYi5jIGIvZHJpdmVycy9uZXQvd2lyZWxlc3Mv
aXdsd2lmaS9kdm0vbGliLmMKaW5kZXggZDI5NGUwZS4uNTRmNTUzMyAxMDA2NDQKLS0tIGEvZHJp
dmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9kdm0vbGliLmMKKysrIGIvZHJpdmVycy9uZXQvd2ly
ZWxlc3MvaXdsd2lmaS9kdm0vbGliLmMKQEAgLTEzNiw3ICsxMzYsNyBAQCBpbnQgaXdsYWduX21h
bmFnZV9pYnNzX3N0YXRpb24oc3RydWN0IGl3bF9wcml2ICpwcml2LAogICogIDEuIGFjcXVpcmUg
bXV0ZXggYmVmb3JlIGNhbGxpbmcKICAqICAyLiBtYWtlIHN1cmUgcmYgaXMgb24gYW5kIG5vdCBp
biBleGl0IHN0YXRlCiAgKi8KLWludCBpd2xhZ25fdHhmaWZvX2ZsdXNoKHN0cnVjdCBpd2xfcHJp
diAqcHJpdikKK2ludCBpd2xhZ25fdHhmaWZvX2ZsdXNoKHN0cnVjdCBpd2xfcHJpdiAqcHJpdiwg
dTMyIHNjZF9xX21zaykKIHsKIAlzdHJ1Y3QgaXdsX3R4Zmlmb19mbHVzaF9jbWQgZmx1c2hfY21k
OwogCXN0cnVjdCBpd2xfaG9zdF9jbWQgY21kID0gewpAQCAtMTYyLDYgKzE2Miw5IEBAIGludCBp
d2xhZ25fdHhmaWZvX2ZsdXNoKHN0cnVjdCBpd2xfcHJpdiAqcHJpdikKIAlpZiAocHJpdi0+bnZt
X2RhdGEtPnNrdV9jYXBfMTFuX2VuYWJsZSkKIAkJZmx1c2hfY21kLnF1ZXVlX2NvbnRyb2wgfD0g
SVdMX0FHR19UWF9RVUVVRV9NU0s7CiAKKwlpZiAoc2NkX3FfbXNrKQorCQlmbHVzaF9jbWQucXVl
dWVfY29udHJvbCA9IGNwdV90b19sZTMyKHNjZF9xX21zayk7CisKIAlJV0xfREVCVUdfSU5GTyhw
cml2LCAicXVldWUgY29udHJvbDogMHgleFxuIiwKIAkJICAgICAgIGZsdXNoX2NtZC5xdWV1ZV9j
b250cm9sKTsKIAlmbHVzaF9jbWQuZmx1c2hfY29udHJvbCA9IGNwdV90b19sZTE2KElXTF9EUk9Q
X0FMTCk7CkBAIC0xNzMsNyArMTc2LDcgQEAgdm9pZCBpd2xhZ25fZGV2X3R4Zmlmb19mbHVzaChz
dHJ1Y3QgaXdsX3ByaXYgKnByaXYpCiB7CiAJbXV0ZXhfbG9jaygmcHJpdi0+bXV0ZXgpOwogCWll
ZWU4MDIxMV9zdG9wX3F1ZXVlcyhwcml2LT5odyk7Ci0JaWYgKGl3bGFnbl90eGZpZm9fZmx1c2go
cHJpdikpIHsKKwlpZiAoaXdsYWduX3R4Zmlmb19mbHVzaChwcml2LCAwKSkgewogCQlJV0xfRVJS
KHByaXYsICJmbHVzaCByZXF1ZXN0IGZhaWxcbiIpOwogCQlnb3RvIGRvbmU7CiAJfQpkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9kdm0vbWFjODAyMTEuYyBiL2RyaXZl
cnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvZHZtL21hYzgwMjExLmMKaW5kZXggYTk0ZTc5OC4uODIw
YzVmZiAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9kdm0vbWFjODAy
MTEuYworKysgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2R2bS9tYWM4MDIxMS5jCkBA
IC03ODEsOSArNzgxLDEyIEBAIHN0YXRpYyBpbnQgaXdsYWduX21hY19hbXBkdV9hY3Rpb24oc3Ry
dWN0IGllZWU4MDIxMV9odyAqaHcsCiAJCUlXTF9ERUJVR19IVChwcml2LCAic3RhcnQgVHhcbiIp
OwogCQlyZXQgPSBpd2xhZ25fdHhfYWdnX3N0YXJ0KHByaXYsIHZpZiwgc3RhLCB0aWQsIHNzbik7
CiAJCWJyZWFrOwotCWNhc2UgSUVFRTgwMjExX0FNUERVX1RYX1NUT1BfQ09OVDoKIAljYXNlIElF
RUU4MDIxMV9BTVBEVV9UWF9TVE9QX0ZMVVNIOgogCWNhc2UgSUVFRTgwMjExX0FNUERVX1RYX1NU
T1BfRkxVU0hfQ09OVDoKKwkJSVdMX0RFQlVHX0hUKHByaXYsICJGbHVzaCBUeFxuIik7CisJCXJl
dCA9IGl3bGFnbl90eF9hZ2dfZmx1c2gocHJpdiwgdmlmLCBzdGEsIHRpZCk7CisJCWJyZWFrOwor
CWNhc2UgSUVFRTgwMjExX0FNUERVX1RYX1NUT1BfQ09OVDoKIAkJSVdMX0RFQlVHX0hUKHByaXYs
ICJzdG9wIFR4XG4iKTsKIAkJcmV0ID0gaXdsYWduX3R4X2FnZ19zdG9wKHByaXYsIHZpZiwgc3Rh
LCB0aWQpOwogCQlpZiAoKHJldCA9PSAwKSAmJiAocHJpdi0+YWdnX3RpZHNfY291bnQgPiAwKSkg
ewpAQCAtMTEyNiw3ICsxMTI5LDcgQEAgc3RhdGljIHZvaWQgaXdsYWduX21hY19mbHVzaChzdHJ1
Y3QgaWVlZTgwMjExX2h3ICpodywgdTMyIHF1ZXVlcywgYm9vbCBkcm9wKQogCSAqLwogCWlmIChk
cm9wKSB7CiAJCUlXTF9ERUJVR19NQUM4MDIxMShwcml2LCAic2VuZCBmbHVzaCBjb21tYW5kXG4i
KTsKLQkJaWYgKGl3bGFnbl90eGZpZm9fZmx1c2gocHJpdikpIHsKKwkJaWYgKGl3bGFnbl90eGZp
Zm9fZmx1c2gocHJpdiwgMCkpIHsKIAkJCUlXTF9FUlIocHJpdiwgImZsdXNoIHJlcXVlc3QgZmFp
bFxuIik7CiAJCQlnb3RvIGRvbmU7CiAJCX0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL2l3bHdpZmkvZHZtL3R4LmMgYi9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2R2bS90
eC5jCmluZGV4IDI0OGE2NGMuLjg1ODFmODQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbmV0L3dpcmVs
ZXNzL2l3bHdpZmkvZHZtL3R4LmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9k
dm0vdHguYwpAQCAtNjc0LDYgKzY3NCw1MCBAQCBpbnQgaXdsYWduX3R4X2FnZ19zdGFydChzdHJ1
Y3QgaXdsX3ByaXYgKnByaXYsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYsCiAJcmV0dXJuIHJl
dDsKIH0KIAoraW50IGl3bGFnbl90eF9hZ2dfZmx1c2goc3RydWN0IGl3bF9wcml2ICpwcml2LCBz
dHJ1Y3QgaWVlZTgwMjExX3ZpZiAqdmlmLAorCQkJc3RydWN0IGllZWU4MDIxMV9zdGEgKnN0YSwg
dTE2IHRpZCkKK3sKKwlzdHJ1Y3QgaXdsX3RpZF9kYXRhICp0aWRfZGF0YTsKKwllbnVtIGl3bF9h
Z2dfc3RhdGUgYWdnX3N0YXRlOworCWludCBzdGFfaWQsIHR4cV9pZDsKKwlzdGFfaWQgPSBpd2xf
c3RhX2lkKHN0YSk7CisKKwkvKgorCSAqIEZpcnN0IHNldCB0aGUgYWdnIHN0YXRlIHRvIE9GRiB0
byBhdm9pZCBjYWxsaW5nCisJICogaWVlZTgwMjExX3N0b3BfdHhfYmFfY2IgaW4gaXdsYWduX2No
ZWNrX3JhdGlkX2VtcHR5LgorCSAqLworCXNwaW5fbG9ja19iaCgmcHJpdi0+c3RhX2xvY2spOwor
CUlXTF9ERUJVR19UWF9RVUVVRVMocHJpdiwgIkZsdXNoIEFHRzogc3RhICVkIHRpZCAlZCBxICVk
IHN0YXRlICVkXG4iLAorCQkJICAgIHN0YV9pZCwgdGlkLCB0eHFfaWQsIHRpZF9kYXRhLT5hZ2cu
c3RhdGUpOworCisJdGlkX2RhdGEgPSAmcHJpdi0+dGlkX2RhdGFbc3RhX2lkXVt0aWRdOworCXR4
cV9pZCA9IHRpZF9kYXRhLT5hZ2cudHhxX2lkOworCWFnZ19zdGF0ZSA9IHRpZF9kYXRhLT5hZ2cu
c3RhdGU7CisJdGlkX2RhdGEtPmFnZy5zdGF0ZSA9IElXTF9BR0dfT0ZGOworCisJc3Bpbl91bmxv
Y2tfYmgoJnByaXYtPnN0YV9sb2NrKTsKKworCWlmIChpd2xhZ25fdHhmaWZvX2ZsdXNoKHByaXYs
IEJJVCh0eHFfaWQpKSkKKwkJSVdMX0VSUihwcml2LCAiQ291bGRuJ3QgZmx1c2ggdGhlIEFHRyBx
dWV1ZVxuIik7CisKKwlpZiAodGVzdF9iaXQodHhxX2lkLCBwcml2LT5hZ2dfcV9hbGxvYykpIHsK
KwkJLyoKKwkJICogSWYgdGhlIHRyYW5zcG9ydCBkaWRuJ3Qga25vdyB0aGF0IHdlIHdhbnRlZCB0
byBzdGFydAorCQkgKiBhZ3JlZ2dhdGlvbiwgZG9uJ3QgdGVsbCBpdCB0aGF0IHdlIHdhbnQgdG8g
c3RvcCB0aGVtLgorCQkgKiBUaGlzIGNhbiBoYXBwZW4gd2hlbiB3ZSBkb24ndCBnZXQgdGhlIGFk
ZEJBIHJlc3BvbnNlIG9uCisJCSAqIHRpbWUsIG9yIHdlIGhhZG4ndCB0aW1lIHRvIGRyYWluIHRo
ZSBBQyBxdWV1ZXMuCisJCSAqLworCQlpZiAoYWdnX3N0YXRlID09IElXTF9BR0dfT04pCisJCQlp
d2xfdHJhbnNfdHhxX2Rpc2FibGUocHJpdi0+dHJhbnMsIHR4cV9pZCk7CisJCWVsc2UKKwkJCUlX
TF9ERUJVR19UWF9RVUVVRVMocHJpdiwgIkRvbid0IGRpc2FibGUgdHggYWdnOiAlZFxuIiwKKwkJ
CQkJICAgIGFnZ19zdGF0ZSk7CisJCWl3bGFnbl9kZWFsbG9jX2FnZ190eHEocHJpdiwgdHhxX2lk
KTsKKwl9CisKKwlyZXR1cm4gMDsKK30KKwogaW50IGl3bGFnbl90eF9hZ2dfb3BlcihzdHJ1Y3Qg
aXdsX3ByaXYgKnByaXYsIHN0cnVjdCBpZWVlODAyMTFfdmlmICp2aWYsCiAJCQlzdHJ1Y3QgaWVl
ZTgwMjExX3N0YSAqc3RhLCB1MTYgdGlkLCB1OCBidWZfc2l6ZSkKIHsKLS0gCjEuOC4xLm1zeXNn
aXQuMQoK

--_002_0BA3FCBA62E2DC44AF3030971E174FB301969F2EHASMSX103gercor_--

