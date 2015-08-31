Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f45.google.com ([209.85.213.45]:36646 "EHLO
	mail-vk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128AbbHaWM5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Aug 2015 18:12:57 -0400
Received: by vkbc123 with SMTP id c123so46105841vkb.3
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2015 15:12:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJa-X965oCpRLcq_P7Q2z2x0iVPvzeie0vZm4wExsBWGPp652w@mail.gmail.com>
References: <CAJa-X96RZTQ_=dG+PDxu8x_AeMAXhyKiTc7CrNO=hqhnmYAN-Q@mail.gmail.com>
	<2520663.ftp6yqfzU7@bentobox>
	<CAJa-X965oCpRLcq_P7Q2z2x0iVPvzeie0vZm4wExsBWGPp652w@mail.gmail.com>
Date: Mon, 31 Aug 2015 18:12:56 -0400
Message-ID: <CAJa-X965AtixEB1MNdTzsMbbjHrdRenoZ+2OCv3OS8MOC+G55g@mail.gmail.com> (sfid-20150901_001301_602973_69B8C711)
Subject: Re: CT firmware and linux kernel patches for OpenWRT( ar71xx -
 Tp-Link 1750AC )
From: s prasad <sprasad.kandregula@gmail.com>
To: Sven Eckelmann <sven@open-mesh.com>
Cc: ath10k <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sven,

Your patch worked with following changes in
compat-wireless-2015-06-22/drivers/net/wireless/ath/ath10k/mac.c
+3686:

case ATH10K_HW_TXRX_RAW:
                /* FIXME: Packet injection isn't implemented. It should be
                 * doable with firmware 10.2 on qca988x.
                 */
                //WARN_ON_ONCE(1);
                //ieee80211_free_txskb(hw, skb);
                //return;
                break;

Thanks you so much.

Regards,
S Prasad

On Mon, Aug 31, 2015 at 4:52 PM, s prasad <sprasad.kandregula@gmail.com> wrote:
> Hi Sven,
>
> Thank you for your patch.
>
> I applied that patch and tried to test by executing sending deauth
> command using aireplay-ng. However, I got following error.
>
> root@OpenWrt:/# aireplay-ng -0 1 -a 10:C3:7B:DF:EA:54 -c 9C:F3:87:49:96:7e wlan0
> [  286.183915] device wlan0 entered promiscuous mode
> 22:15:55  Waiting for beacon frame (BSSID: 10:C3:7B:DF:EA:54) on channel 36
> [  286.369861] ------------[ cut here ]------------
> [  286.374611] WARNING: CPU: 0 PID: 1150 at
> /home/openwrt/ct/openwrt/build_dir/target-mips_34kc_uClibc-0.9.33.2/linux-ar71xx_generic/compat-wireless-2015-06-22/drivers/net/wireless/ath/ath10k/mac.c:3695
> 0x87204cec()
> [  286.393771] Modules linked in: pppoe ppp_async iptable_nat ath9k
> pppox ppp_generic nf_nat_ipv4 nf_conntrack_ipv6 nf_conntrack_ipv4
> ipt_REJECT ipt_MASQUERADE ath9k_common xt_time xt_tcpudp xt_state
> xt_nat xt_multiport xt_mark xt_mac xt_limit xt_id xt_conntrack
> xt_comment xt_TCPMSS xt_REDIRECT xt_LOG xt_CT slhc nf_reject_ipv4
> nf_nat_redirect nf_nat_masquerade_ipv4 nf_nat_ftp nf_nat nf_log_ipv4
> nf_defrag_ipv6 nf_defrag_ipv4 nf_conntrack_rtcache nf_conntrack_ftp
> nf_conntrack iptable_raw iptable_mangle iptable_filter ip_tables
> crc_ccitt ath9k_hw ath10k_pci ath10k_core ath mac80211 cfg80211 compat
> ledtrig_usbdev ip6t_REJECT nf_reject_ipv6 nf_log_ipv6 nf_log_common
> ip6table_raw ip6table_mangle ip6table_filter ip6_tables x_tables ipv6
> arc4 crypto_blkcipher ohci_platform ohci_hcd ehci_platform ehci_hcd
> gpio_button_hotplug usbcore nls_base usb_common
> [  286.469918] CPU: 0 PID: 1150 Comm: aireplay-ng Not tainted 4.1.2 #6
> [  286.476273] Stack : 803c42b2 00000037 00000000 00000001 80318d80
> 80371f03 878f5ba0 0000047e
>           803c3510 00000001 00000000 00000000 871d0000 800a6564
> 00000003 8031e0f4
>           00000e6f 00000001 8031c608 86623a84 871d0000 800a4b74
> 803c42b2 000000c8
>           00000000 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000
>           00000000 00000000 00000000 00000000 00000000 00000000
> 00000000 00000000
>           ...
> [  286.512635] Call Trace:
> [  286.515127] [<80071be8>] show_stack+0x48/0x70
> [  286.519554] [<8008188c>] warn_slowpath_common+0xa0/0xd0
> [  286.524867] [<80081944>] warn_slowpath_null+0x18/0x24
> [  286.530024] [<87204cec>] 0x87204cec
> [  286.533568]
> [  286.535076] ---[ end trace d3f6cfc1171daefd ]---
>
> Please let me know if I need to do any.
>
> I need to send De-authentication command in monitor mode.
>
>
> Thanks and Regards,
> S Prasad
>
> ---------- Forwarded message ----------
> From: Sven Eckelmann <sven@open-mesh.com>
> Date: Fri, Aug 28, 2015 at 8:48 AM
> Subject: Re: CT firmware and linux kernel patches for OpenWRT( ar71xx
> - Tp-Link 1750AC )
> To: s prasad <sprasad.kandregula@gmail.com>
>
>
> [mailing lists removed - see other mail. please continue discussion
>  on mailing list]
>
> On Wednesday 26 August 2015 18:59:51 s prasad wrote:
>> Does anybody have patches for CT firmware testing using OpenWRT environment.
>> I tried to create patch, however OpenWRT patches supporting only for
>> kernel versions 3.18 and 4.1 at the same time CT Kernels supporting
>> 3.17_dev, 4.0.4 and 4.2.x. Both are miss matching.
>>
>> Can somebody help me if they have patches or to create patches.
>
> Attached is the patch with the changes for mac80211. You still have to
> select the "Firmware from Candelatech" under ath10k. Don't select
> "Firmware optimized for AP operation (v10.1 / API v2)". I know that this
> selection should be done more cleanly but I only needed it for testing :)
>
> Also an example patch for the mentioned iw hack is attached.
>
> You just have to checkout openwrt r46435 (in git
> 113f685179b34015d615530575c73e61fc913039), apply these two patches,
> select your device, enable ath10k, enable the Candelatech firmware and
> build it.
>
> Kind regards,
>         Sven
>
>
> --
> S Prasad Kandregula



-- 
S Prasad Kandregula
