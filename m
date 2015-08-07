Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:40151 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1945911AbbHGSJn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Aug 2015 14:09:43 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
	by mailout.nyi.internal (Postfix) with ESMTP id 0A3C320928
	for <linux-wireless@vger.kernel.org>; Fri,  7 Aug 2015 14:09:40 -0400 (EDT)
Date: Fri, 7 Aug 2015 11:09:38 -0700
From: Greg KH <greg@kroah.com>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Cathy Luo <cluo@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	"stable@vger.kernel.org" <stable@vger.kernel.org>,
	Reyad Attiyat <reyad.attiyat@gmail.com>
Subject: Re: [PATCH 4.2 1/3] mwifiex: usb: Fix double add error when
 submitting rx urb
Message-ID: <20150807180938.GC11113@kroah.com> (sfid-20150807_200950_673174_7FDB232C)
References: <1438856775-3666-1-git-send-email-akarwar@marvell.com>
 <877fp7zeqt.fsf@kamboji.qca.qualcomm.com>
 <72f6efd46e4949599ded42f97ac19449@SC-EXCH04.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <72f6efd46e4949599ded42f97ac19449@SC-EXCH04.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Aug 07, 2015 at 08:33:57AM +0000, Amitkumar Karwar wrote:
> Hi Kalle,
> 
> > From: Kalle Valo [mailto:kvalo@codeaurora.org]
> > Sent: Friday, August 07, 2015 1:56 PM
> > To: Amitkumar Karwar
> > Cc: linux-wireless@vger.kernel.org; Cathy Luo; Nishant Sarmukadam;
> > stable@vger.kernel.org; Reyad Attiyat
> > Subject: Re: [PATCH 4.2 1/3] mwifiex: usb: Fix double add error when
> > submitting rx urb
> > 
> > Amitkumar Karwar <akarwar@marvell.com> writes:
> > 
> > > From: Reyad Attiyat <reyad.attiyat@gmail.com>
> > >
> > > There is an error that can occur where the driver adds the same URB to
> > USB submission list twice.
> > > This happens since mwifiex_usb_submit_rem_rx can submit packets at
> > same time as an rx urb complete callback.
> > > This causes list corruption and is fixed by not setting the skb to
> > NULL when submitting an rx packet.
> > >
> > > [   84.461242] WARNING: CPU: 1 PID: 748 at lib/list_debug.c:36
> > __list_add+0xcb/0xd0()
> > > [   84.461245] list_add double add: new=ffff8800c92b0c50,
> > prev=ffff8800c92b0c50, next=ffff8800ced6c430.
> > > [   84.461247] Modules linked in: rfcomm fuse cmac
> > nf_conntrack_netbios_ns nf_conntrack_broadcast ip6t_rpfilter ip6t_REJECT
> > nf_reject_ipv6 xt_conntrack ebtable_nat ebtable_broute bridge stp llc
> > ebtable_filter ebtables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6
> > nf_nat_ipv6 ip6table_mangle ip6table_security ip6table_raw
> > ip6table_filter ip6_tables iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4
> > nf_nat_ipv4 nf_nat nf_conntrack bnep iptable_mangle iptable_security
> > iptable_raw btusb btintel bluetooth mwifiex_usb mwifiex
> > x86_pkg_temp_thermal cfg80211 coretemp r8712u(C) kvm_intel kvm
> > hid_sensor_als hid_sensor_incl_3d hid_sensor_rotation hid_sensor_magn_3d
> > hid_sensor_accel_3d hid_sensor_gyro_3d hid_sensor_trigger
> > hid_sensor_iio_common industrialio_triggered_buffer kfifo_buf rfkill
> > iTCO_wdt industrialio iTCO_vendor_support
> > > [   84.461316]  crc32_pclmul crc32c_intel ghash_clmulni_intel
> > microcode snd_hda_codec_realtek vfat snd_hda_codec_generic fat
> > snd_hda_codec_hdmi snd_hda_intel snd_hda_controller uvcvideo
> > snd_hda_codec videobuf2_vmalloc videobuf2_memops snd_hwdep
> > videobuf2_core snd_hda_core joydev v4l2_common videodev hid_sensor_hub
> > snd_seq hid_multitouch media snd_seq_device snd_pcm snd_timer mei_me snd
> > i2c_i801 lpc_ich mei soundcore tpm_infineon tpm_tis tpm i2c_hid
> > i2c_designware_platform i2c_designware_core nfsd auth_rpcgss nfs_acl
> > lockd grace sunrpc sch_fq_codel i915 i2c_algo_bit drm_kms_helper drm
> > xhci_pci xhci_hcd ehci_pci sd_mod ehci_hcd video
> > > [   84.461383] CPU: 1 PID: 748 Comm: kworker/u9:0 Tainted: G         C
> > 4.1.0-rc5+ #163
> > > [   84.461386] Hardware name: Microsoft Corporation Surface Pro
> > 2/Surface Pro 2, BIOS 2.05.0250 04/10/2015
> > > [   84.461396] Workqueue: MWIFIEX_RX_WORK_QUEUE mwifiex_rx_work_queue
> > [mwifiex]
> > > [   84.461399]  ffffffff81a8150e ffff8801174cf8e8 ffffffff817df830
> > 0000000000000000
> > > [   84.461405]  ffff8801174cf938 ffff8801174cf928 ffffffff810a54ba
> > ffff8800c86bd750
> > > [   84.461410]  ffff8800c92b0c50 ffff8800c92b0c50 ffff8800ced6c430
> > ffff88010c057178
> > > [   84.461416] Call Trace:
> > > [   84.461421]  [<ffffffff817df830>] dump_stack+0x4f/0x7b
> > > [   84.461428]  [<ffffffff810a54ba>] warn_slowpath_common+0x8a/0xc0
> > > [   84.461432]  [<ffffffff810a5536>] warn_slowpath_fmt+0x46/0x50
> > > [   84.461436]  [<ffffffff814109fb>] __list_add+0xcb/0xd0
> > > [   84.461442]  [<ffffffff815c551a>] ?
> > usb_hcd_link_urb_to_ep+0x2a/0xa0
> > > [   84.461446]  [<ffffffff815c5570>] usb_hcd_link_urb_to_ep+0x80/0xa0
> > > [   84.461459]  [<ffffffffa004318a>] prepare_transfer+0xaa/0x130
> > [xhci_hcd]
> > > [   84.461470]  [<ffffffffa0044cf7>] xhci_queue_bulk_tx+0xb7/0x7a0
> > [xhci_hcd]
> > > [   84.461480]  [<ffffffffa003b67f>] ? xhci_urb_enqueue+0x50f/0x660
> > [xhci_hcd]
> > > [   84.461489]  [<ffffffffa003b67f>] ? xhci_urb_enqueue+0x50f/0x660
> > [xhci_hcd]
> > > [   84.461498]  [<ffffffffa003b735>] xhci_urb_enqueue+0x5c5/0x660
> > [xhci_hcd]
> > > [   84.461503]  [<ffffffff815c7ad3>] usb_hcd_submit_urb+0x93/0xa70
> > > [   84.461507]  [<ffffffff8168dde8>] ? __alloc_skb+0x78/0x1f0
> > > [   84.461511]  [<ffffffff8168d301>] ?
> > __kmalloc_reserve.isra.26+0x31/0x90
> > > [   84.461515]  [<ffffffff8168ddbc>] ? __alloc_skb+0x4c/0x1f0
> > > [   84.461519]  [<ffffffff8168ddfc>] ? __alloc_skb+0x8c/0x1f0
> > > [   84.461523]  [<ffffffff8168badd>] ? skb_dequeue+0x5d/0x80
> > > [   84.461527]  [<ffffffff815c987e>] usb_submit_urb+0x42e/0x5f0
> > > [   84.461531]  [<ffffffff816931d9>] ? __alloc_rx_skb+0x39/0x100
> > > [   84.461536]  [<ffffffffa05aa372>]
> > mwifiex_usb_submit_rx_urb+0xb2/0x170 [mwifiex_usb]
> > > [   84.461542]  [<ffffffffa05aa5f5>]
> > mwifiex_usb_submit_rem_rx_urbs+0x45/0x50 [mwifiex_usb]
> > > [   84.461550]  [<ffffffffa07094be>] mwifiex_rx_work_queue+0x10e/0x140
> > [mwifiex]
> > > [   84.461556]  [<ffffffff810c4429>] process_one_work+0x229/0x890
> > > [   84.461559]  [<ffffffff810c438c>] ? process_one_work+0x18c/0x890
> > > [   84.461565]  [<ffffffff810c4ae3>] worker_thread+0x53/0x470
> > > [   84.461569]  [<ffffffff810c4a90>] ? process_one_work+0x890/0x890
> > > [   84.461572]  [<ffffffff810cb162>] kthread+0xf2/0x110
> > > [   84.461577]  [<ffffffff811031ad>] ? trace_hardirqs_on+0xd/0x10
> > > [   84.461581]  [<ffffffff810cb070>] ?
> > kthread_create_on_node+0x230/0x230
> > > [   84.461586]  [<ffffffff817e9662>] ret_from_fork+0x42/0x70
> > > [   84.461590]  [<ffffffff810cb070>] ?
> > kthread_create_on_node+0x230/0x230
> > > [   84.461593] ---[ end trace 65103af5e6fb3444 ]---
> > >
> > > Cc: stable@vger.kernel.org # 3.19+
> > > Signed-off-by: Reyad Attiyat <reyad.attiyat@gmail.com>
> > > Acked-by: Amitkumar Karwar <akarwar@marvell.com>
> > > Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> > 
> > What do you want to do with these patches exactly? These three are
> > already in wireless-drivers-next so I cannot apply to wireless-drivers
> > anymore (and that's why I cannot push them to 4.2).
> > 
> 
> These are some critical stability fixes. I want them to be merged to 3.19 onwards stable kernel releases.
> I have CCed stable@vger.kernel.org here. Let me know if I missed anything.

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
