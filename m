Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37262 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab0KXQ6r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Nov 2010 11:58:47 -0500
Received: by gyb11 with SMTP id 11so2895135gyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 24 Nov 2010 08:58:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTinM5JKjW7qTm-iCUcXB2-eiWDxPe1SGiUUd8zpu@mail.gmail.com>
References: <AANLkTinM5JKjW7qTm-iCUcXB2-eiWDxPe1SGiUUd8zpu@mail.gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Wed, 24 Nov 2010 08:58:25 -0800
Message-ID: <AANLkTinDrNhiOZ+oXHTbuqbNJa+5TcvirhQHQgAQhc_B@mail.gmail.com>
Subject: Re: bug report for compat-wireless-2010-11-22
To: Matthew Morgan <willdeed@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Nov 23, 2010 at 11:39 PM, Matthew Morgan <willdeed@gmail.com> wrote:
> I was having trouble with my wireless connection dropping constantly
> on a fresh install of Fedora 14 x86_64 on an Alienware M15x with Intel
> Corporation Ultimate N WiFi Link 5300  wireless device. I used the
> compat-wireless-2010-11-22 source, built it and installed iwlagn and
> unloaded my wireless and bluetooth systems.  I rebooted and now I
> receive the errors in the attached trace and my system will not boot.
>
> Please let me know if you need further information or if you have some
> advice on how I can get my system back to booting.  I'm able to boot
> into a live cd, mount the partition and chroot in, but make uninstall
> errors out.

To uninstall just rm -rf /lib/modules/$(uname -r)/updates/


Nov 23 17:22:04 machine-name kernel: [  457.453851] ------------[ cut
here ]------------
Nov 23 17:22:04 machine-name kernel: [  457.453854] kernel BUG at
/home/user/downloads/compat-wireless-201
0-11-22/net/mac80211/main.c:540!
Nov 23 17:22:04 machine-name kernel: [  457.453857] invalid opcode:
0000 [#1] SMP
Nov 23 17:22:04 machine-name kernel: [  457.453860] last sysfs file:
/sys/devices/platform/regulatory.0/uevent
Nov 23 17:22:04 machine-name kernel: [  457.453862] CPU 2
Nov 23 17:22:04 machine-name kernel: [  457.453863] Modules linked in:
iwlagn(+) iwlcore mac80211 cfg80211 rfk
ill compat sit tunnel4 vmnet ppdev parport_pc parport vmblock vsock
vmci vmmon sunrpc cpufreq_ondemand acpi_cpu
freq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 ip6table_filter
ip6_tables ipv6 uinput nvidia(P) snd_hda_co
dec_idt snd_hda_intel snd_hda_codec snd_hwdep snd_seq snd_seq_device
arc4 ecb snd_pcm snd_timer snd r852 sm_com
mon nand uvcvideo nand_ids nand_ecc soundcore videodev mtd e1000e
v4l1_compat v4l2_compat_ioctl32 snd_page_allo
c dell_wmi iTCO_wdt i7core_edac i2c_i801 edac_core iTCO_vendor_support
i2c_core wmi microcode serio_raw joydev
cryptd aes_x86_64 aes_generic xts gf128mul dm_crypt mmc_block
sdhci_pci firewire_ohci sdhci firewire_core mmc_c
ore crc_itu_t video output [last unloaded: rfkill]
Nov 23 17:22:04 machine-name kernel: [  457.453914]
Nov 23 17:22:04 machine-name kernel: [  457.453917] Pid: 5214, comm:
modprobe Tainted: P            2.6.35.6-4
8.fc14.x86_64 #1       /M15x
Nov 23 17:22:04 machine-name kernel: [  457.453920] RIP:
0010:[<ffffffffa0c56225>]  [<ffffffffa0c56225>] ieee8
0211_alloc_hw+0xa9/0x3b1 [mac80211]

Should be:

        BUG_ON(!ops->configure_filter);

can you check your net/mac80211/main.c on line 540 to confirm?

This should be set on iwlagn:

#ifdef CONFIG_IWL5000
struct ieee80211_ops iwlagn_hw_ops = {
        .tx = iwlagn_mac_tx,
        .start = iwlagn_mac_start,
        .stop = iwlagn_mac_stop,
        .add_interface = iwl_mac_add_interface,
        .remove_interface = iwl_mac_remove_interface,
        .change_interface = iwl_mac_change_interface,
        .config = iwlagn_mac_config,
        .configure_filter = iwlagn_configure_filter,
        .set_key = iwlagn_mac_set_key,
        .update_tkip_key = iwlagn_mac_update_tkip_key,
        .conf_tx = iwl_mac_conf_tx,
        .bss_info_changed = iwlagn_bss_info_changed,
        .ampdu_action = iwlagn_mac_ampdu_action,
        .hw_scan = iwl_mac_hw_scan,
        .sta_notify = iwlagn_mac_sta_notify,
        .sta_add = iwlagn_mac_sta_add,
        .sta_remove = iwl_mac_sta_remove,
        .channel_switch = iwlagn_mac_channel_switch,
        .flush = iwlagn_mac_flush,
        .tx_last_beacon = iwl_mac_tx_last_beacon,
};
#endif

And we do define CONFIG_IWL5000 on config.mk, so not sure yet.

  Luis
