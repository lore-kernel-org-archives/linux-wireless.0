Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:16766 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751395Ab3IZIRM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Sep 2013 04:17:12 -0400
Message-ID: <5243ED7C.7070203@redhat.com> (sfid-20130926_101718_847465_704AC648)
Date: Thu, 26 Sep 2013 10:17:00 +0200
From: Daniel Borkmann <dborkman@redhat.com>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: Dan Williams <dcbw@redhat.com>, linux-wireless@vger.kernel.org,
	Hauke Mehrtens <hauke@hauke-m.de>,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: bcma 3.12-rc1 scheduling while atomic
References: <1380142945.23272.42.camel@dcbw.foobar.com> <5243E72A.4040108@broadcom.com>
In-Reply-To: <5243E72A.4040108@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/26/2013 09:50 AM, Arend van Spriel wrote:
> On 09/25/2013 11:02 PM, Dan Williams wrote:
>> static int brcms_ops_start(struct ieee80211_hw *hw)
>> {
>>     ...
>>          spin_lock_bh(&wl->lock);
>>     ...
>>                          err = brcms_up(wl);
>>                          <eventually calls usleep() from bcma_pcie_mdio_set_phy()>
>>     ...
>>          spin_unlock_bh(&wl->lock);
>>     ...
>> }
>
> Hi Dan,
>
> I submitted two patches to John yesterday to address this.
>
> http://mid.gmane.org/1380103864-10447-3-git-send-email-arend@broadcom.com
> http://mid.gmane.org/1380103864-10447-4-git-send-email-arend@broadcom.com

Awesome, thanks !

> Regards,
> Arend
>
>> [    7.607842] BUG: scheduling while atomic: NetworkManager/523/0x00000200
>> [    7.607846] Modules linked in: arc4 brcmsmac cordic brcmutil b43 mac80211 nls_utf8 hfsplus snd_hda_codec_hdmi snd_hda_codec_cirrus cfg80211 i915 snd_hda_intel snd_hda_codec snd_hwdep ssb snd_seq snd_seq_device mmc_core snd_pcm joydev iTCO_wdt snd_page_alloc iTCO_vendor_support snd_timer uvcvideo x86_pkg_temp_thermal videobuf2_vmalloc videobuf2_memops videobuf2_core videodev snd coretemp kvm_intel kvm btusb bluetooth applesmc input_polldev crc32_pclmul crc32c_intel i2c_algo_bit media drm_kms_helper ghash_clmulni_intel soundcore drm rfkill microcode pcspkr bcm5974 lpc_ich mfd_core bcma i2c_i801 mei_me shpchp mei video apple_bl i2c_core
>> [    7.607889] CPU: 0 PID: 523 Comm: NetworkManager Not tainted 3.12.0-rc1+ #3
>> [    7.607891] Hardware name: Apple Inc. MacBookAir5,1/Mac-66F35F19FE2A0D05, BIOS MBA51.88Z.00EF.B02.1211271028 11/27/2012
>> [    7.607893]  ffff88026f214280 ffff880257751498 ffffffff81659c85 ffff8802577515d0
>> [    7.607896]  ffff8802577514a8 ffffffff81655f39 ffff880257751508 ffffffff8165e8a6
>> [    7.607899]  ffff880257751fd8 0000000000014280 ffff880257751fd8 0000000000014280
>> [    7.607902] Call Trace:
>> [    7.607910]  [<ffffffff81659c85>] dump_stack+0x45/0x56
>> [    7.607914]  [<ffffffff81655f39>] __schedule_bug+0x4d/0x5b
>> [    7.607918]  [<ffffffff8165e8a6>] __schedule+0x746/0x750
>> [    7.607922]  [<ffffffff8165e8d9>] schedule+0x29/0x70
>> [    7.607926]  [<ffffffff8165dd0c>] schedule_hrtimeout_range_clock+0x12c/0x170
>> [    7.607930]  [<ffffffff8108cb00>] ? hrtimer_get_res+0x50/0x50
>> [    7.607933]  [<ffffffff8165dc8c>] ? schedule_hrtimeout_range_clock+0xac/0x170
>> [    7.607936]  [<ffffffff8165dd63>] schedule_hrtimeout_range+0x13/0x20
>> [    7.607941]  [<ffffffff81073bf0>] usleep_range+0x40/0x50
>> [    7.607948]  [<ffffffffa00603df>] bcma_pcie_mdio_set_phy.isra.3+0x4f/0x80 [bcma]
>> [    7.607954]  [<ffffffffa00605c7>] bcma_pcie_mdio_write.isra.5+0xc7/0xd0 [bcma]
>> [    7.607960]  [<ffffffffa00606aa>] bcma_pcie_mdio_writeread.isra.6.constprop.13+0x1a/0x30 [bcma]
>> [    7.607965]  [<ffffffffa00606fa>] bcma_core_pci_power_save+0x3a/0x70 [bcma]
>> [    7.607971]  [<ffffffffa0060869>] bcma_core_pci_up+0x29/0x60 [bcma]
>> [    7.607981]  [<ffffffffa05b55df>] brcms_c_up+0xff/0x440 [brcmsmac]
>> [    7.607987]  [<ffffffffa05ab242>] brcms_ops_start+0xf2/0x360 [brcmsmac]
>> [    7.607999]  [<ffffffffa042be3a>] ? cfg80211_netdev_notifier_call+0x40a/0x600 [cfg80211]
>> [    7.608005]  [<ffffffff815c9f48>] ? inetdev_event+0x38/0x510
>> [    7.608019]  [<ffffffffa04cda71>] ieee80211_do_open+0x2e1/0xd80 [mac80211]
>> [    7.608022]  [<ffffffff8166466c>] ? notifier_call_chain+0x4c/0x70
>> [    7.608032]  [<ffffffffa04ce579>] ieee80211_open+0x69/0x70 [mac80211]
>> [    7.608036]  [<ffffffff8155f14f>] __dev_open+0xbf/0x140
>> [    7.608040]  [<ffffffff8155f412>] __dev_change_flags+0x92/0x170
>> [    7.608043]  [<ffffffff8155f59d>] dev_change_flags+0x1d/0x60
>> [    7.608047]  [<ffffffff8156ca69>] do_setlink+0x339/0xa00
>> [    7.608051]  [<ffffffff8131f020>] ? __nla_put+0x20/0x30
>> [    7.608063]  [<ffffffffa044544c>] ? nl80211_send_wiphy+0x3fc/0x2470 [cfg80211]
>> [    7.608066]  [<ffffffff8131edd2>] ? nla_parse+0x32/0xe0
>> [    7.608070]  [<ffffffff8156dd94>] rtnl_newlink+0x394/0x5e0
>> [    7.608075]  [<ffffffff8129e63e>] ? selinux_capable+0x2e/0x40
>> [    7.608079]  [<ffffffff8156a769>] rtnetlink_rcv_msg+0x99/0x260
>> [    7.608082]  [<ffffffff8129b8c5>] ? sock_has_perm+0x75/0x90
>> [    7.608085]  [<ffffffff8156a6d0>] ? rtnetlink_rcv+0x30/0x30
>> [    7.608089]  [<ffffffff81589709>] netlink_rcv_skb+0xa9/0xc0
>> [    7.608093]  [<ffffffff8156a6c8>] rtnetlink_rcv+0x28/0x30
>> [    7.608097]  [<ffffffff81588d5d>] netlink_unicast+0xdd/0x190
>> [    7.608100]  [<ffffffff8158910f>] netlink_sendmsg+0x2ff/0x740
>> [    7.608104]  [<ffffffff81585d02>] ? netlink_seq_next+0x142/0x150
>> [    7.608107]  [<ffffffff8158707c>] ? netlink_recvmsg+0x1ec/0x390
>> [    7.608112]  [<ffffffff81544b9b>] sock_sendmsg+0x8b/0xc0
>> [    7.608116]  [<ffffffff8154488e>] ? move_addr_to_kernel.part.16+0x1e/0x60
>> [    7.608120]  [<ffffffff81545401>] ? move_addr_to_kernel+0x21/0x30
>> [    7.608123]  [<ffffffff815453cc>] ___sys_sendmsg+0x36c/0x380
>> [    7.608127]  [<ffffffff81544d95>] ? SYSC_sendto+0x175/0x1c0
>> [    7.608131]  [<ffffffff81545ad2>] __sys_sendmsg+0x42/0x80
>> [    7.608134]  [<ffffffff81545b22>] SyS_sendmsg+0x12/0x20
>> [    7.608138]  [<ffffffff81668c29>] system_call_fastpath+0x16/0x1b
>>
>>
>
>
