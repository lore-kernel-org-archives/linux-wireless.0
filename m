Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f171.google.com ([209.85.128.171]:41347 "EHLO
        mail-wr0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753841AbeDQN5K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 17 Apr 2018 09:57:10 -0400
Received: by mail-wr0-f171.google.com with SMTP id v24so18767518wra.8
        for <linux-wireless@vger.kernel.org>; Tue, 17 Apr 2018 06:57:09 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 11.2 \(3445.5.20\))
Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - Dropping
 frame due to full tx queue...?
From: Jamie Stuart <jamie@onebillion.org>
In-Reply-To: <alpine.LNX.2.21.99.1804171554290.11111@mStation.localdomain>
Date: Tue, 17 Apr 2018 16:56:58 +0300
Cc: Kofi Agor <nenekofi@gmail.com>,
        Craig Matsuura <cmatsuura@vivint.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Stanislaw Gruszka <sgruszka@redhat.com>,
        Mathias Kresin <dev@kresin.me>,
        Tom Psyborg <pozega.tomislav@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, John Crispin <john@phrozen.org>,
        Felix Fietkau <nbd@nbd.name>
Message-Id: <03E1F6D7-86AE-4C11-846A-7334A5D37CC9@onebillion.org> (sfid-20180417_155730_335823_88F3982A)
References: <20180123132234.GC2520@redhat.com>
 <alpine.LNX.2.21.99.1801240917001.13679@mStation.localdomain>
 <20180124100316.GB3101@redhat.com> <20180301153006.GJ1233@makrotopia.org>
 <20180307122701.GA10584@redhat.com> <20180307122935.GB10584@redhat.com>
 <d462681a-6a85-f76c-85a0-4e51b8529606@kresin.me>
 <20180326103551.GA2069@redhat.com>
 <24f8f4a2-b355-a1b3-d07a-940fc1e50fcc@kresin.me>
 <20180327171815.GA31338@redhat.com> <20180327174302.GB1206@makrotopia.org>
 <alpine.LNX.2.21.99.1803280605580.2911@mStation.localdomain>
 <CAOt++SeSQ2j1KuVkbqt77LfznXN7JV0Lx5O8d7-m2VBrz8=85g@mail.gmail.com>
 <alpine.LNX.2.21.99.1803301642110.31428@mStation.localdomain>
 <MWHPR02MB3326233159B021143D7278F5D4A10@MWHPR02MB3326.namprd02.prod.outlook.com>
 <alpine.LNX.2.21.99.1803301931300.5692@mStation.localdomain>
 <CAOt++SeLh_NxcmM=YEMQSv4y9PabS_dT7k4yTxUiqXbac-=iUQ@mail.gmail.com>
 <alpine.LNX.2.21.99.1804171554290.11111@mStation.localdomain>
To: Enrico Mioso <mrkiko.rs@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Should this just be applied on top of trunk - and is current thinking =
that it supersedes earlier attempts at fixing this issue?

> On 17 Apr 2018, at 16:55, Enrico Mioso <mrkiko.rs@gmail.com> wrote:
>=20
> thank you very vry much for your work guys.
> I at the moment don't have at ready disposal the hw to test this out, =
sorry.
> But your work is no matter precious and valuable. Thank you very much =
again for it, and all the effort.
> Can someone help us, and test this out?
> Sorry to all of you.
>=20
> Enrico
>=20
>=20
> On Tue, 17 Apr 2018, Kofi Agor wrote:
>=20
>> Date: Tue, 17 Apr 2018 15:32:57
>> From: Kofi Agor <nenekofi@gmail.com>
>> To: Enrico Mioso <mrkiko.rs@gmail.com>
>> Cc: Craig Matsuura <cmatsuura@vivint.com>,
>>    Daniel Golle <daniel@makrotopia.org>,
>>    Stanislaw Gruszka <sgruszka@redhat.com>, Mathias Kresin =
<dev@kresin.me>,
>>    Tom Psyborg <pozega.tomislav@gmail.com>,
>>    linux-wireless <linux-wireless@vger.kernel.org>,
>>    Johannes Berg <johannes.berg@intel.com>, Arnd Bergmann =
<arnd@arndb.de>,
>>    John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>,
>>    Jamie Stuart <jamie@onebillion.org>
>> Subject: Re: ieee80211 phy0: rt2x00queue_write_tx_frame: Error - =
Dropping
>>    frame due to full tx queue...?
>> Hi Enrico,
>> Some minor changes to our patch:
>> 1. We (Craig Matsuura) found that disabling/enable the txtasklet =
worked better than tearing down and recreating the txtasklet each time. =
It also resolved a kernel oops we were experiencing.
>> 2. Cleaned up the patch a bit and gave credit to the developers
>> 3. There's a companion patch along with the txqueue patch that I =
forgot to add when I submitted the txqueue patch the first time. It =
resolves an rtnl deadlock during device unregistration. This should =
resolve the ifdown issue you were
>>    experiencing.
>>  -Thanks, Kofi A.
>> On Fri, Mar 30, 2018 at 11:33 AM, Enrico Mioso <mrkiko.rs@gmail.com> =
wrote:
>>      To turn it off and on I use the OpenWrt wifi command:
>>      wifi down
>>=20
>>      turns it off.
>>=20
>>      wifi up
>>=20
>>      turns it back on.
>>=20
>>      thank you very much for your help.
>>=20
>>      I suspect you're using something nearer to mt7620A, while the =
Asus WL-330n3G is based on rt305X I guess.
>>=20
>>      Enrico
>>=20
>>      See attached .config:
>>=20
>>      #
>>      # Automatically generated file; DO NOT EDIT.
>>      # OpenWrt Configuration
>>      #
>>      CONFIG_MODULES=3Dy
>>      CONFIG_HAVE_DOT_CONFIG=3Dy
>>      # CONFIG_TARGET_sunxi is not set
>>      # CONFIG_TARGET_apm821xx is not set
>>      # CONFIG_TARGET_ath25 is not set
>>      # CONFIG_TARGET_ar71xx is not set
>>      # CONFIG_TARGET_brcm2708 is not set
>>      # CONFIG_TARGET_bcm53xx is not set
>>      # CONFIG_TARGET_brcm47xx is not set
>>      # CONFIG_TARGET_brcm63xx is not set
>>      # CONFIG_TARGET_cns3xxx is not set
>>      # CONFIG_TARGET_octeon is not set
>>      # CONFIG_TARGET_gemini is not set
>>      # CONFIG_TARGET_mpc85xx is not set
>>      # CONFIG_TARGET_imx6 is not set
>>      # CONFIG_TARGET_mxs is not set
>>      # CONFIG_TARGET_adm8668 is not set
>>      # CONFIG_TARGET_adm5120 is not set
>>      # CONFIG_TARGET_xburst is not set
>>      # CONFIG_TARGET_ixp4xx is not set
>>      # CONFIG_TARGET_lantiq is not set
>>      # CONFIG_TARGET_malta is not set
>>      # CONFIG_TARGET_pistachio is not set
>>      # CONFIG_TARGET_mvebu is not set
>>      # CONFIG_TARGET_kirkwood is not set
>>      # CONFIG_TARGET_mediatek is not set
>>      CONFIG_TARGET_ramips=3Dy
>>      # CONFIG_TARGET_at91 is not set
>>      # CONFIG_TARGET_rb532 is not set
>>      # CONFIG_TARGET_mcs814x is not set
>>      # CONFIG_TARGET_layerscape is not set
>>      # CONFIG_TARGET_octeontx is not set
>>      # CONFIG_TARGET_oxnas is not set
>>      # CONFIG_TARGET_armvirt is not set
>>      # CONFIG_TARGET_ipq40xx is not set
>>      # CONFIG_TARGET_ipq806x is not set
>>      # CONFIG_TARGET_au1000 is not set
>>      # CONFIG_TARGET_arc770 is not set
>>      # CONFIG_TARGET_archs38 is not set
>>      # CONFIG_TARGET_ar7 is not set
>>      # CONFIG_TARGET_omap is not set
>>      # CONFIG_TARGET_uml is not set
>>      # CONFIG_TARGET_zynq is not set
>>      # CONFIG_TARGET_x86 is not set
>>      # CONFIG_TARGET_ramips_mt7620 is not set
>>      # CONFIG_TARGET_ramips_mt7621 is not set
>>      # CONFIG_TARGET_ramips_mt76x8 is not set
>>      # CONFIG_TARGET_ramips_rt288x is not set
>>      CONFIG_TARGET_ramips_rt305x=3Dy
>>      # CONFIG_TARGET_ramips_rt3883 is not set
>>      # CONFIG_TARGET_MULTI_PROFILE is not set
>>      # CONFIG_TARGET_ramips_rt305x_Default is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_px-4885-4M is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_px-4885-8M is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_carambola is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_a5-v11 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_w502u is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_freestation5 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_wr6202 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_mr-102n is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_air3gii is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_ALL02393G is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_all0256n-4M is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_all0256n-8M is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_all5002 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_all5003 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_asl26555-8M is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_asl26555-16M is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_atp-52b is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_awapn2403 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_awm002-evb-4M is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_awm002-evb-8M is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_rt-g32-b1 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_rt-n10-plus is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_rt-n13u is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_wl-330n is not set
>>      CONFIG_TARGET_ramips_rt305x_DEVICE_wl-330n3g=3Dy
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_hw550-3g is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_f5d8235-v2 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_f7c027 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_whr-g300n is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_dap-1350 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_DCS930 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_DCS930LB1 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_dir-300-b1 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_dir-300-b7 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_dir-320-b1 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_dir-600-b1 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_dir-610-a1 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_dir-615-d is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_dir-615-h1 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_dir-620-a1 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_dir-620-d1 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_dwr-512-b is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_wizard8800 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_3g-6200n is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_3g-6200nl is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_esr-9753 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_fonera20n is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_mpr-a1 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_mpr-a2 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_broadway is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_hlk-rm04 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_ht-tm02 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_hg255d is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_d105 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_m2m is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_jhr-n805r is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_jhr-n825r is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_jhr-n926r is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_mofi3500-3gn is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_nw718 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_wnce2001 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_bc2 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_wt1520-4M is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_wt1520-8M is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_nixcore-x1-16M is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_nixcore-x1-8M is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_miniembplug is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_miniembwifi is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_psr-680w is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_mzk-dp150n is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_mzk-w300nh2 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_mzk-wdpr is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_ip2202 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_m3 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_m4-4M is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_m4-8M is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_x5 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_x8 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_pwh2004 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_rt5350f-olinuxino is not =
set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_rt5350f-olinuxino-evb is =
not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_v22rw-2x2 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_WL-341V3 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_wl-351 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_sl-r7205 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_wcr-150gn is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_tew-638apb-v2 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_tew-714tru is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_rut5xx is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_3g150b is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_3g300m is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_w150m is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_w306r-v20 is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_ur-326n4g is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_ur-336un is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_vocore-16M is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_vocore-8M is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_wizfi630a is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_wr512-3gn-4M is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_wr512-3gn-8M is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_ncs601w is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_xdxrn502j is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_kn is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_nbg-419n is not set
>>      # CONFIG_TARGET_ramips_rt305x_DEVICE_nbg-419n2 is not set
>>      CONFIG_HAS_SUBTARGETS=3Dy
>>      CONFIG_HAS_DEVICES=3Dy
>>      CONFIG_TARGET_BOARD=3D"ramips"
>>      CONFIG_TARGET_SUBTARGET=3D"rt305x"
>>      CONFIG_TARGET_PROFILE=3D"DEVICE_wl-330n3g"
>>      CONFIG_TARGET_ARCH_PACKAGES=3D"mipsel_24kc"
>>      CONFIG_DEFAULT_TARGET_OPTIMIZATION=3D"-Os -pipe =
-mno-branch-likely -mips32r2 -mtune=3D24kc"
>>      CONFIG_CPU_TYPE=3D"24kc"
>>      CONFIG_LINUX_4_9=3Dy
>>      CONFIG_DEFAULT_base-files=3Dy
>>      CONFIG_DEFAULT_busybox=3Dy
>>      CONFIG_DEFAULT_dnsmasq=3Dy
>>      CONFIG_DEFAULT_dropbear=3Dy
>>      CONFIG_DEFAULT_firewall=3Dy
>>      CONFIG_DEFAULT_fstools=3Dy
>>      CONFIG_DEFAULT_ip6tables=3Dy
>>      CONFIG_DEFAULT_iptables=3Dy
>>      CONFIG_DEFAULT_iwinfo=3Dy
>>      CONFIG_DEFAULT_kmod-gpio-button-hotplug=3Dy
>>      CONFIG_DEFAULT_kmod-ipt-offload=3Dy
>>      CONFIG_DEFAULT_kmod-leds-gpio=3Dy
>>      CONFIG_DEFAULT_kmod-rt2800-soc=3Dy
>>      CONFIG_DEFAULT_libc=3Dy
>>      CONFIG_DEFAULT_libgcc=3Dy
>>      CONFIG_DEFAULT_logd=3Dy
>>      CONFIG_DEFAULT_mtd=3Dy
>>      CONFIG_DEFAULT_netifd=3Dy
>>      CONFIG_DEFAULT_odhcp6c=3Dy
>>      CONFIG_DEFAULT_odhcpd-ipv6only=3Dy
>>      CONFIG_DEFAULT_opkg=3Dy
>>      CONFIG_DEFAULT_ppp=3Dy
>>      CONFIG_DEFAULT_ppp-mod-pppoe=3Dy
>>      CONFIG_DEFAULT_swconfig=3Dy
>>      CONFIG_DEFAULT_uci=3Dy
>>      CONFIG_DEFAULT_uclient-fetch=3Dy
>>      CONFIG_DEFAULT_wpad-mini=3Dy
>>      CONFIG_AUDIO_SUPPORT=3Dy
>>      CONFIG_GPIO_SUPPORT=3Dy
>>      CONFIG_USB_SUPPORT=3Dy
>>      CONFIG_USES_DEVICETREE=3Dy
>>      CONFIG_USES_INITRAMFS=3Dy
>>      CONFIG_USES_SQUASHFS=3Dy
>>      CONFIG_HAS_MIPS16=3Dy
>>      CONFIG_mipsel=3Dy
>>      CONFIG_ARCH=3D"mipsel"
>>=20
>>      #
>>      # Target Images
>>      #
>>      # CONFIG_TARGET_ROOTFS_INITRAMFS is not set
>>      CONFIG_EXTERNAL_CPIO=3D""
>>=20
>>      #
>>      # Root filesystem archives
>>      #
>>      # CONFIG_TARGET_ROOTFS_CPIOGZ is not set
>>      # CONFIG_TARGET_ROOTFS_TARGZ is not set
>>=20
>>      #
>>      # Root filesystem images
>>      #
>>      # CONFIG_TARGET_ROOTFS_EXT4FS is not set
>>      CONFIG_TARGET_ROOTFS_SQUASHFS=3Dy
>>      CONFIG_TARGET_SQUASHFS_BLOCK_SIZE=3D256
>>      CONFIG_TARGET_UBIFS_FREE_SPACE_FIXUP=3Dy
>>      CONFIG_TARGET_UBIFS_JOURNAL_SIZE=3D""
>>=20
>>      #
>>      # Image Options
>>      #
>>=20
>>      #
>>      # Global build settings
>>      #
>>      # CONFIG_ALL_NONSHARED is not set
>>      # CONFIG_ALL_KMODS is not set
>>      # CONFIG_ALL is not set
>>      # CONFIG_BUILDBOT is not set
>>      CONFIG_SIGNED_PACKAGES=3Dy
>>=20
>>      #
>>      # General build options
>>      #
>>      # CONFIG_DISPLAY_SUPPORT is not set
>>      CONFIG_BUILD_PATENTED=3Dy
>>      # CONFIG_BUILD_NLS is not set
>>      CONFIG_SHADOW_PASSWORDS=3Dy
>>      # CONFIG_CLEAN_IPKG is not set
>>      # CONFIG_INCLUDE_CONFIG is not set
>>      # CONFIG_COLLECT_KERNEL_DEBUG is not set
>>=20
>>      #
>>      # Kernel build options
>>      #
>>      CONFIG_KERNEL_BUILD_USER=3D""
>>      CONFIG_KERNEL_BUILD_DOMAIN=3D""
>>      CONFIG_KERNEL_PRINTK=3Dy
>>      # CONFIG_KERNEL_CRASHLOG is not set
>>      # CONFIG_KERNEL_SWAP is not set
>>      CONFIG_KERNEL_DEBUG_FS=3Dy
>>      CONFIG_KERNEL_MIPS_FPU_EMULATOR=3Dy
>>      # CONFIG_KERNEL_PERF_EVENTS is not set
>>      # CONFIG_KERNEL_PROFILING is not set
>>      # CONFIG_KERNEL_KALLSYMS is not set
>>      # CONFIG_KERNEL_FTRACE is not set
>>      # CONFIG_KERNEL_DEBUG_KERNEL is not set
>>      # CONFIG_KERNEL_DEBUG_INFO is not set
>>      # CONFIG_KERNEL_DYNAMIC_DEBUG is not set
>>      # CONFIG_KERNEL_KPROBES is not set
>>      # CONFIG_KERNEL_AIO is not set
>>      # CONFIG_KERNEL_FHANDLE is not set
>>      # CONFIG_KERNEL_FANOTIFY is not set
>>      # CONFIG_KERNEL_BLK_DEV_BSG is not set
>>      CONFIG_KERNEL_MAGIC_SYSRQ=3Dy
>>      # CONFIG_KERNEL_DEBUG_PINCTRL is not set
>>      # CONFIG_KERNEL_DEBUG_GPIO is not set
>>      # CONFIG_KERNEL_ELF_CORE is not set
>>      # CONFIG_KERNEL_PROVE_LOCKING is not set
>>      # CONFIG_KERNEL_PRINTK_TIME is not set
>>      # CONFIG_KERNEL_SLABINFO is not set
>>      # CONFIG_KERNEL_PROC_PAGE_MONITOR is not set
>>      # CONFIG_KERNEL_KEXEC is not set
>>      # CONFIG_USE_RFKILL is not set
>>      # CONFIG_USE_SPARSE is not set
>>      # CONFIG_KERNEL_DEVTMPFS is not set
>>      # CONFIG_KERNEL_KEYS is not set
>>      # CONFIG_KERNEL_CGROUPS is not set
>>      # CONFIG_KERNEL_NAMESPACES is not set
>>      # CONFIG_KERNEL_LXC_MISC is not set
>>      # CONFIG_KERNEL_SECCOMP_FILTER is not set
>>      # CONFIG_KERNEL_SECCOMP is not set
>>      # CONFIG_KERNEL_IP_MROUTE is not set
>>      CONFIG_KERNEL_IPV6=3Dy
>>      CONFIG_KERNEL_IPV6_MULTIPLE_TABLES=3Dy
>>      CONFIG_KERNEL_IPV6_SUBTREES=3Dy
>>      CONFIG_KERNEL_IPV6_MROUTE=3Dy
>>      # CONFIG_KERNEL_IPV6_PIMSM_V2 is not set
>>      # CONFIG_KERNEL_IP_PNP is not set
>>=20
>>      #
>>      # Filesystem ACL and attr support options
>>      #
>>      # CONFIG_USE_FS_ACL_ATTR is not set
>>      # CONFIG_KERNEL_FS_POSIX_ACL is not set
>>      # CONFIG_KERNEL_BTRFS_FS_POSIX_ACL is not set
>>      # CONFIG_KERNEL_EXT4_FS_POSIX_ACL is not set
>>      # CONFIG_KERNEL_F2FS_FS_POSIX_ACL is not set
>>      # CONFIG_KERNEL_JFFS2_FS_POSIX_ACL is not set
>>      # CONFIG_KERNEL_TMPFS_POSIX_ACL is not set
>>      # CONFIG_KERNEL_CIFS_ACL is not set
>>      # CONFIG_KERNEL_HFS_FS_POSIX_ACL is not set
>>      # CONFIG_KERNEL_HFSPLUG_FS_POSIX_ACL is not set
>>      # CONFIG_KERNEL_NFS_ACL_SUPPORT is not set
>>      # CONFIG_KERNEL_NFS_V3_ACL_SUPPORT is not set
>>      # CONFIG_KERNEL_NFSD_V2_ACL_SUPPORT is not set
>>      # CONFIG_KERNEL_NFSD_V3_ACL_SUPPORT is not set
>>      # CONFIG_KERNEL_REISER_FS_POSIX_ACL is not set
>>      # CONFIG_KERNEL_XFS_POSIX_ACL is not set
>>      # CONFIG_KERNEL_JFS_POSIX_ACL is not set
>>      # CONFIG_KERNEL_DEVMEM is not set
>>      # CONFIG_KERNEL_DEVKMEM is not set
>>=20
>>      #
>>      # Package build options
>>      #
>>      # CONFIG_DEBUG is not set
>>      CONFIG_IPV6=3Dy
>>=20
>>      #
>>      # Stripping options
>>      #
>>      # CONFIG_NO_STRIP is not set
>>      # CONFIG_USE_STRIP is not set
>>      CONFIG_USE_SSTRIP=3Dy
>>      # CONFIG_STRIP_KERNEL_EXPORTS is not set
>>      # CONFIG_USE_MKLIBS is not set
>>      CONFIG_USE_UCLIBCXX=3Dy
>>      # CONFIG_USE_LIBSTDCXX is not set
>>=20
>>      #
>>      # Hardening build options
>>      #
>>      CONFIG_PKG_CHECK_FORMAT_SECURITY=3Dy
>>      CONFIG_PKG_ASLR_PIE=3Dy
>>      CONFIG_PKG_CC_STACKPROTECTOR_NONE=3Dy
>>      # CONFIG_PKG_CC_STACKPROTECTOR_STRONG is not set
>>      # CONFIG_KERNEL_CC_STACKPROTECTOR_NONE is not set
>>      # CONFIG_KERNEL_CC_STACKPROTECTOR_REGULAR is not set
>>      CONFIG_KERNEL_CC_STACKPROTECTOR_STRONG=3Dy
>>      # CONFIG_PKG_FORTIFY_SOURCE_NONE is not set
>>      CONFIG_PKG_FORTIFY_SOURCE_1=3Dy
>>      # CONFIG_PKG_FORTIFY_SOURCE_2 is not set
>>      # CONFIG_PKG_RELRO_NONE is not set
>>      # CONFIG_PKG_RELRO_PARTIAL is not set
>>      CONFIG_PKG_RELRO_FULL=3Dy
>>      # CONFIG_DEVEL is not set
>>      # CONFIG_BROKEN is not set
>>      CONFIG_BINARY_FOLDER=3D""
>>      CONFIG_DOWNLOAD_FOLDER=3D""
>>      CONFIG_LOCALMIRROR=3D""
>>      CONFIG_AUTOREBUILD=3Dy
>>      # CONFIG_AUTOREMOVE is not set
>>      CONFIG_BUILD_SUFFIX=3D""
>>      CONFIG_TARGET_ROOTFS_DIR=3D""
>>      # CONFIG_CCACHE is not set
>>      CONFIG_EXTERNAL_KERNEL_TREE=3D""
>>      CONFIG_KERNEL_GIT_CLONE_URI=3D""
>>      CONFIG_EXTRA_OPTIMIZATION=3D"-fno-caller-saves -fno-plt"
>>      CONFIG_TARGET_OPTIMIZATION=3D"-Os -pipe -mno-branch-likely =
-mips32r2 -mtune=3D24kc"
>>      CONFIG_SOFT_FLOAT=3Dy
>>      CONFIG_USE_MIPS16=3Dy
>>      # CONFIG_EXTRA_TARGET_ARCH is not set
>>      CONFIG_EXTRA_BINUTILS_CONFIG_OPTIONS=3D""
>>      CONFIG_EXTRA_GCC_CONFIG_OPTIONS=3D""
>>      # CONFIG_GCC_DEFAULT_PIE is not set
>>      # CONFIG_GCC_DEFAULT_SSP is not set
>>      # CONFIG_SJLJ_EXCEPTIONS is not set
>>      # CONFIG_INSTALL_GFORTRAN is not set
>>      CONFIG_GDB=3Dy
>>      CONFIG_USE_MUSL=3Dy
>>      CONFIG_SSP_SUPPORT=3Dy
>>      CONFIG_BINUTILS_VERSION_2_29_1=3Dy
>>      CONFIG_BINUTILS_VERSION=3D"2.29.1"
>>      CONFIG_GCC_VERSION=3D"7.3.0"
>>      CONFIG_LIBC=3D"musl"
>>      CONFIG_TARGET_SUFFIX=3D"musl"
>>      # CONFIG_IB is not set
>>      # CONFIG_SDK is not set
>>      # CONFIG_MAKE_TOOLCHAIN is not set
>>      # CONFIG_IMAGEOPT is not set
>>      # CONFIG_PREINITOPT is not set
>>      CONFIG_TARGET_PREINIT_SUPPRESS_STDERR=3Dy
>>      # CONFIG_TARGET_PREINIT_DISABLE_FAILSAFE is not set
>>      CONFIG_TARGET_PREINIT_TIMEOUT=3D2
>>      # CONFIG_TARGET_PREINIT_SHOW_NETMSG is not set
>>      # CONFIG_TARGET_PREINIT_SUPPRESS_FAILSAFE_NETMSG is not set
>>      CONFIG_TARGET_PREINIT_IFNAME=3D""
>>      CONFIG_TARGET_PREINIT_IP=3D"192.168.1.1"
>>      CONFIG_TARGET_PREINIT_NETMASK=3D"255.255.255.0"
>>      CONFIG_TARGET_PREINIT_BROADCAST=3D"192.168.1.255"
>>      # CONFIG_INITOPT is not set
>>      CONFIG_TARGET_INIT_PATH=3D"/usr/sbin:/usr/bin:/sbin:/bin"
>>      CONFIG_TARGET_INIT_ENV=3D""
>>      CONFIG_TARGET_INIT_CMD=3D"/sbin/init"
>>      CONFIG_TARGET_INIT_SUPPRESS_STDERR=3Dy
>>      # CONFIG_VERSIONOPT is not set
>>      CONFIG_PER_FEED_REPO=3Dy
>>      CONFIG_PER_FEED_REPO_ADD_DISABLED=3Dy
>>      CONFIG_PER_FEED_REPO_ADD_COMMENTED=3Dy
>>      # CONFIG_FEED_packages is not set
>>      # CONFIG_FEED_luci is not set
>>      # CONFIG_FEED_routing is not set
>>      # CONFIG_FEED_telephony is not set
>>=20
>>      #
>>      # Base system
>>      #
>>      CONFIG_PACKAGE_base-files=3Dy
>>      # CONFIG_PACKAGE_block-mount is not set
>>      # CONFIG_PACKAGE_blockd is not set
>>      CONFIG_PACKAGE_busybox=3Dy
>>      # CONFIG_BUSYBOX_CUSTOM is not set
>>      CONFIG_BUSYBOX_DEFAULT_HAVE_DOT_CONFIG=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_DESKTOP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_EXTRA_COMPAT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEDORA_COMPAT is not set
>>      CONFIG_BUSYBOX_DEFAULT_INCLUDE_SUSv2=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_USE_PORTABLE_CODE is not set
>>      CONFIG_BUSYBOX_DEFAULT_PLATFORM_LINUX=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_SHOW_USAGE=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_VERBOSE_USAGE=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_COMPRESS_USAGE=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_BUSYBOX is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_INSTALLER is not set
>>      # CONFIG_BUSYBOX_DEFAULT_INSTALL_NO_USR is not set
>>      # CONFIG_BUSYBOX_DEFAULT_PAM is not set
>>      CONFIG_BUSYBOX_DEFAULT_LONG_OPTS=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_DEVPTS=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_CLEAN_UP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_UTMP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_WTMP is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_PIDFILE=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_PID_FILE_PATH=3D"/var/run"
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_SUID=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SUID_CONFIG is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SUID_CONFIG_QUIET is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SELINUX is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_PREFER_APPLETS=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_BUSYBOX_EXEC_PATH=3D"/proc/self/exe"
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_SYSLOG=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_HAVE_RPC is not set
>>      # CONFIG_BUSYBOX_DEFAULT_STATIC is not set
>>      CONFIG_BUSYBOX_DEFAULT_PIE=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_NOMMU is not set
>>      # CONFIG_BUSYBOX_DEFAULT_BUILD_LIBBUSYBOX is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_INDIVIDUAL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SHARED_BUSYBOX is not set
>>      CONFIG_BUSYBOX_DEFAULT_LFS=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_CROSS_COMPILER_PREFIX=3D""
>>      CONFIG_BUSYBOX_DEFAULT_SYSROOT=3D""
>>      CONFIG_BUSYBOX_DEFAULT_EXTRA_CFLAGS=3D""
>>      CONFIG_BUSYBOX_DEFAULT_EXTRA_LDFLAGS=3D""
>>      CONFIG_BUSYBOX_DEFAULT_EXTRA_LDLIBS=3D""
>>      CONFIG_BUSYBOX_DEFAULT_INSTALL_APPLET_SYMLINKS=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_INSTALL_APPLET_HARDLINKS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_INSTALL_APPLET_SCRIPT_WRAPPERS is not =
set
>>      # CONFIG_BUSYBOX_DEFAULT_INSTALL_APPLET_DONT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_INSTALL_SH_APPLET_SYMLINK is not set
>>      # CONFIG_BUSYBOX_DEFAULT_INSTALL_SH_APPLET_HARDLINK is not set
>>      # CONFIG_BUSYBOX_DEFAULT_INSTALL_SH_APPLET_SCRIPT_WRAPPER is not =
set
>>      CONFIG_BUSYBOX_DEFAULT_PREFIX=3D"./_install"
>>      # CONFIG_BUSYBOX_DEFAULT_DEBUG is not set
>>      # CONFIG_BUSYBOX_DEFAULT_DEBUG_PESSIMIZE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_DEBUG_SANITIZE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_UNIT_TEST is not set
>>      # CONFIG_BUSYBOX_DEFAULT_WERROR is not set
>>      CONFIG_BUSYBOX_DEFAULT_NO_DEBUG_LIB=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_DMALLOC is not set
>>      # CONFIG_BUSYBOX_DEFAULT_EFENCE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_USE_BSS_TAIL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_RTMINMAX is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_BUFFERS_USE_MALLOC is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_BUFFERS_GO_ON_STACK=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_BUFFERS_GO_IN_BSS is not set
>>      CONFIG_BUSYBOX_DEFAULT_PASSWORD_MINLEN=3D6
>>      CONFIG_BUSYBOX_DEFAULT_MD5_SMALL=3D1
>>      CONFIG_BUSYBOX_DEFAULT_SHA3_SMALL=3D1
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_FAST_TOP=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_ETC_NETWORKS is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_EDITING=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_EDITING_MAX_LEN=3D512
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_EDITING_VI is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_EDITING_HISTORY=3D256
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_EDITING_SAVEHISTORY is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_EDITING_SAVE_ON_EXIT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_REVERSE_SEARCH is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_TAB_COMPLETION=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_USERNAME_COMPLETION is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_EDITING_FANCY_PROMPT=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_EDITING_ASK_TERMINAL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_LOCALE_SUPPORT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_UNICODE_SUPPORT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_UNICODE_USING_LOCALE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_CHECK_UNICODE_IN_ENV is not set
>>      CONFIG_BUSYBOX_DEFAULT_SUBST_WCHAR=3D0
>>      CONFIG_BUSYBOX_DEFAULT_LAST_SUPPORTED_WCHAR=3D0
>>      # CONFIG_BUSYBOX_DEFAULT_UNICODE_COMBINING_WCHARS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_UNICODE_WIDE_WCHARS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_UNICODE_BIDI_SUPPORT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_UNICODE_NEUTRAL_TABLE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_UNICODE_PRESERVE_BROKEN is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_NON_POSIX_CP=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VERBOSE_CP_MESSAGE is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_USE_SENDFILE=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_COPYBUF_KB=3D4
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SKIP_ROOTFS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_MONOTONIC_SYSCALL is not set
>>      CONFIG_BUSYBOX_DEFAULT_IOCTL_HEX2STR_ERROR=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_HWIB is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SEAMLESS_XZ is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SEAMLESS_LZMA is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SEAMLESS_BZ2 is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_SEAMLESS_GZ=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SEAMLESS_Z is not set
>>      # CONFIG_BUSYBOX_DEFAULT_AR is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_AR_LONG_FILENAMES is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_AR_CREATE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_UNCOMPRESS is not set
>>      CONFIG_BUSYBOX_DEFAULT_GUNZIP=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_ZCAT=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_GUNZIP_LONG_OPTIONS is not set
>>      CONFIG_BUSYBOX_DEFAULT_BUNZIP2=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_BZCAT=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_UNLZMA is not set
>>      # CONFIG_BUSYBOX_DEFAULT_LZCAT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_LZMA is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_LZMA_FAST is not set
>>      # CONFIG_BUSYBOX_DEFAULT_UNXZ is not set
>>      # CONFIG_BUSYBOX_DEFAULT_XZCAT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_XZ is not set
>>      # CONFIG_BUSYBOX_DEFAULT_BZIP2 is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_BZIP2_DECOMPRESS=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_CPIO is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_CPIO_O is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_CPIO_P is not set
>>      # CONFIG_BUSYBOX_DEFAULT_DPKG is not set
>>      # CONFIG_BUSYBOX_DEFAULT_DPKG_DEB is not set
>>      CONFIG_BUSYBOX_DEFAULT_GZIP=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_GZIP_LONG_OPTIONS is not set
>>      CONFIG_BUSYBOX_DEFAULT_GZIP_FAST=3D0
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_GZIP_LEVELS is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_GZIP_DECOMPRESS=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_LZOP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_UNLZOP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_LZOPCAT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_LZOP_COMPR_HIGH is not set
>>      # CONFIG_BUSYBOX_DEFAULT_RPM is not set
>>      # CONFIG_BUSYBOX_DEFAULT_RPM2CPIO is not set
>>      CONFIG_BUSYBOX_DEFAULT_TAR=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_TAR_CREATE=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TAR_AUTODETECT is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_TAR_FROM=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TAR_OLDGNU_COMPATIBILITY is not =
set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TAR_OLDSUN_COMPATIBILITY is not =
set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_TAR_GNU_EXTENSIONS=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TAR_LONG_OPTIONS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TAR_TO_COMMAND is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TAR_UNAME_GNAME is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TAR_NOPRESERVE_TIME is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TAR_SELINUX is not set
>>      # CONFIG_BUSYBOX_DEFAULT_UNZIP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_UNZIP_CDF is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_UNZIP_BZIP2 is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_UNZIP_LZMA is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_UNZIP_XZ is not set
>>      CONFIG_BUSYBOX_DEFAULT_BASENAME=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_CAT=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_CATV is not set
>>      CONFIG_BUSYBOX_DEFAULT_CHGRP=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_CHMOD=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_CHOWN=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_CHOWN_LONG_OPTIONS is not set
>>      CONFIG_BUSYBOX_DEFAULT_CHROOT=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_CKSUM is not set
>>      # CONFIG_BUSYBOX_DEFAULT_COMM is not set
>>      CONFIG_BUSYBOX_DEFAULT_CP=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_CP_LONG_OPTIONS is not set
>>      CONFIG_BUSYBOX_DEFAULT_CUT=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_DATE=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_DATE_ISOFMT=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_DATE_NANO is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_DATE_COMPAT is not set
>>      CONFIG_BUSYBOX_DEFAULT_DD=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_DD_SIGNAL_HANDLING=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_DD_THIRD_STATUS_LINE is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_DD_IBS_OBS=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_DD_STATUS is not set
>>      CONFIG_BUSYBOX_DEFAULT_DF=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_DF_FANCY is not set
>>      CONFIG_BUSYBOX_DEFAULT_DIRNAME=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_DOS2UNIX is not set
>>      # CONFIG_BUSYBOX_DEFAULT_UNIX2DOS is not set
>>      CONFIG_BUSYBOX_DEFAULT_DU=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_DU_DEFAULT_BLOCKSIZE_1K=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_ECHO=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_FANCY_ECHO=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_ENV=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_ENV_LONG_OPTIONS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_EXPAND is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_EXPAND_LONG_OPTIONS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_UNEXPAND is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_UNEXPAND_LONG_OPTIONS is not =
set
>>      CONFIG_BUSYBOX_DEFAULT_EXPR=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_EXPR_MATH_SUPPORT_64=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FACTOR is not set
>>      CONFIG_BUSYBOX_DEFAULT_FALSE=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FOLD is not set
>>      CONFIG_BUSYBOX_DEFAULT_FSYNC=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_HEAD=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_FANCY_HEAD=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_HOSTID is not set
>>      CONFIG_BUSYBOX_DEFAULT_ID=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_GROUPS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_INSTALL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_INSTALL_LONG_OPTIONS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_LINK is not set
>>      CONFIG_BUSYBOX_DEFAULT_LN=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_LOGNAME is not set
>>      CONFIG_BUSYBOX_DEFAULT_LS=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_LS_FILETYPES=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_LS_FOLLOWLINKS=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_LS_RECURSIVE=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_LS_WIDTH=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_LS_SORTFILES=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_LS_TIMESTAMPS=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_LS_USERNAME=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_LS_COLOR=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_LS_COLOR_IS_DEFAULT=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_MD5SUM=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_SHA1SUM is not set
>>      CONFIG_BUSYBOX_DEFAULT_SHA256SUM=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_SHA512SUM is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SHA3SUM is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_MD5_SHA1_SUM_CHECK=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_MKDIR=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_MKDIR_LONG_OPTIONS is not set
>>      CONFIG_BUSYBOX_DEFAULT_MKFIFO=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_MKNOD=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_MV=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_MV_LONG_OPTIONS is not set
>>      CONFIG_BUSYBOX_DEFAULT_NICE=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_NL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_NOHUP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_NPROC is not set
>>      # CONFIG_BUSYBOX_DEFAULT_OD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_PASTE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_PRINTENV is not set
>>      CONFIG_BUSYBOX_DEFAULT_PRINTF=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_PWD=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_READLINK=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_READLINK_FOLLOW=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_REALPATH is not set
>>      CONFIG_BUSYBOX_DEFAULT_RM=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_RMDIR=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_RMDIR_LONG_OPTIONS is not set
>>      CONFIG_BUSYBOX_DEFAULT_SEQ=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_SHRED is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SHUF is not set
>>      CONFIG_BUSYBOX_DEFAULT_SLEEP=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_FANCY_SLEEP=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_FLOAT_SLEEP is not set
>>      CONFIG_BUSYBOX_DEFAULT_SORT=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SORT_BIG is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SPLIT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SPLIT_FANCY is not set
>>      # CONFIG_BUSYBOX_DEFAULT_STAT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_STAT_FORMAT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_STAT_FILESYSTEM is not set
>>      # CONFIG_BUSYBOX_DEFAULT_STTY is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SUM is not set
>>      CONFIG_BUSYBOX_DEFAULT_SYNC=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SYNC_FANCY is not set
>>      # CONFIG_BUSYBOX_DEFAULT_TAC is not set
>>      CONFIG_BUSYBOX_DEFAULT_TAIL=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_FANCY_TAIL=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_TEE=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_TEE_USE_BLOCK_IO=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_TEST=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_TEST1=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_TEST2=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_TEST_64=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_TOUCH=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TOUCH_NODEREF is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_TOUCH_SUSV3=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_TR=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TR_CLASSES is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TR_EQUIV is not set
>>      CONFIG_BUSYBOX_DEFAULT_TRUE=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_TRUNCATE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_TTY is not set
>>      CONFIG_BUSYBOX_DEFAULT_UNAME=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_UNAME_OSNAME=3D"GNU/Linux"
>>      CONFIG_BUSYBOX_DEFAULT_UNIQ=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_UNLINK is not set
>>      # CONFIG_BUSYBOX_DEFAULT_USLEEP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_UUDECODE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_BASE64 is not set
>>      # CONFIG_BUSYBOX_DEFAULT_UUENCODE is not set
>>      CONFIG_BUSYBOX_DEFAULT_WC=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_WC_LARGE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_WHO is not set
>>      # CONFIG_BUSYBOX_DEFAULT_W is not set
>>      # CONFIG_BUSYBOX_DEFAULT_USERS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_WHOAMI is not set
>>      CONFIG_BUSYBOX_DEFAULT_YES=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VERBOSE is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_PRESERVE_HARDLINKS=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_HUMAN_READABLE=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_CHVT is not set
>>      CONFIG_BUSYBOX_DEFAULT_CLEAR=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_DEALLOCVT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_DUMPKMAP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FGCONSOLE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_KBD_MODE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_LOADFONT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SETFONT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SETFONT_TEXTUAL_MAP is not set
>>      CONFIG_BUSYBOX_DEFAULT_DEFAULT_SETFONT_DIR=3D""
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_LOADFONT_PSF2 is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_LOADFONT_RAW is not set
>>      # CONFIG_BUSYBOX_DEFAULT_LOADKMAP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_OPENVT is not set
>>      CONFIG_BUSYBOX_DEFAULT_RESET=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_RESIZE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_RESIZE_PRINT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SETCONSOLE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SETCONSOLE_LONG_OPTIONS is not =
set
>>      # CONFIG_BUSYBOX_DEFAULT_SETKEYCODES is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SETLOGCONS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SHOWKEY is not set
>>      CONFIG_BUSYBOX_DEFAULT_MKTEMP=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_PIPE_PROGRESS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_RUN_PARTS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_RUN_PARTS_LONG_OPTIONS is not =
set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_RUN_PARTS_FANCY is not set
>>      CONFIG_BUSYBOX_DEFAULT_START_STOP_DAEMON=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_START_STOP_DAEMON_FANCY is not =
set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_START_STOP_DAEMON_LONG_OPTIONS =
is not set
>>      CONFIG_BUSYBOX_DEFAULT_WHICH=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_AWK=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_AWK_LIBM=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_AWK_GNU_EXTENSIONS=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_CMP=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_DIFF is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_DIFF_LONG_OPTIONS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_DIFF_DIR is not set
>>      # CONFIG_BUSYBOX_DEFAULT_ED is not set
>>      # CONFIG_BUSYBOX_DEFAULT_PATCH is not set
>>      CONFIG_BUSYBOX_DEFAULT_SED=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_VI=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_MAX_LEN=3D1024
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_8BIT is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_COLON=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_YANKMARK=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_SEARCH=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_REGEX_SEARCH is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_USE_SIGNALS=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_DOT_CMD=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_READONLY=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_SETOPTS=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_SET=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_WIN_RESIZE=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_ASK_TERMINAL=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_UNDO is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_UNDO_QUEUE is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_VI_UNDO_QUEUE_MAX=3D0
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_ALLOW_EXEC=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FIND=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_PRINT0=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_MTIME=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_MMIN is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_PERM=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_TYPE=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_XDEV=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_MAXDEPTH=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_NEWER=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_INUM is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_EXEC=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_EXEC_PLUS is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_USER=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_GROUP=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_NOT=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_DEPTH=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_PAREN=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_SIZE=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_PRUNE=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_DELETE is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_PATH=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_REGEX=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_CONTEXT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_FIND_LINKS is not set
>>      CONFIG_BUSYBOX_DEFAULT_GREP=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_EGREP=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FGREP=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_GREP_CONTEXT=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_XARGS=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_XARGS_SUPPORT_CONFIRMATION=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_XARGS_SUPPORT_QUOTES=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_XARGS_SUPPORT_TERMOPT=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_XARGS_SUPPORT_ZERO_TERM=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_XARGS_SUPPORT_REPL_STR is not =
set
>>      # CONFIG_BUSYBOX_DEFAULT_BOOTCHARTD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_BOOTCHARTD_BLOATED_HEADER is =
not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_BOOTCHARTD_CONFIG_FILE is not =
set
>>      CONFIG_BUSYBOX_DEFAULT_HALT=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_POWEROFF=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_REBOOT=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_CALL_TELINIT is not set
>>      CONFIG_BUSYBOX_DEFAULT_TELINIT_PATH=3D""
>>      # CONFIG_BUSYBOX_DEFAULT_INIT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_LINUXRC is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_USE_INITTAB is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_KILL_REMOVED is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_KILL_DELAY=3D0
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_INIT_SCTTY is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_INIT_SYSLOG is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_INIT_QUIET is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_INIT_COREDUMPS is not set
>>      CONFIG_BUSYBOX_DEFAULT_INIT_TERMINAL_TYPE=3D""
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_INIT_MODIFY_CMDLINE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_MESG is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_MESG_ENABLE_ONLY_GROUP is not =
set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_SHADOWPASSWDS=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_USE_BB_PWD_GRP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_USE_BB_SHADOW is not set
>>      # CONFIG_BUSYBOX_DEFAULT_USE_BB_CRYPT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_USE_BB_CRYPT_SHA is not set
>>      # CONFIG_BUSYBOX_DEFAULT_ADD_SHELL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_REMOVE_SHELL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_ADDGROUP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_ADDGROUP_LONG_OPTIONS is not =
set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_ADDUSER_TO_GROUP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_ADDUSER is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_ADDUSER_LONG_OPTIONS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_CHECK_NAMES is not set
>>      CONFIG_BUSYBOX_DEFAULT_LAST_ID=3D0
>>      CONFIG_BUSYBOX_DEFAULT_FIRST_SYSTEM_ID=3D0
>>      CONFIG_BUSYBOX_DEFAULT_LAST_SYSTEM_ID=3D0
>>      # CONFIG_BUSYBOX_DEFAULT_CHPASSWD is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_DEFAULT_PASSWD_ALGO=3D"md5"
>>      # CONFIG_BUSYBOX_DEFAULT_CRYPTPW is not set
>>      # CONFIG_BUSYBOX_DEFAULT_MKPASSWD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_DELUSER is not set
>>      # CONFIG_BUSYBOX_DEFAULT_DELGROUP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_DEL_USER_FROM_GROUP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_GETTY is not set
>>      CONFIG_BUSYBOX_DEFAULT_LOGIN=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_LOGIN_SESSION_AS_CHILD=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_LOGIN_SCRIPTS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_NOLOGIN is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SECURETTY is not set
>>      CONFIG_BUSYBOX_DEFAULT_PASSWD=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_PASSWD_WEAK_CHECK=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_SU is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SU_SYSLOG is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SU_CHECKS_SHELLS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SU_BLANK_PW_NEEDS_SECURE_TTY is =
not set
>>      # CONFIG_BUSYBOX_DEFAULT_SULOGIN is not set
>>      # CONFIG_BUSYBOX_DEFAULT_VLOCK is not set
>>      # CONFIG_BUSYBOX_DEFAULT_CHATTR is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FSCK is not set
>>      # CONFIG_BUSYBOX_DEFAULT_LSATTR is not set
>>      # CONFIG_BUSYBOX_DEFAULT_TUNE2FS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_MODPROBE_SMALL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_DEPMOD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_INSMOD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_LSMOD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_LSMOD_PRETTY_2_6_OUTPUT is not =
set
>>      # CONFIG_BUSYBOX_DEFAULT_MODINFO is not set
>>      # CONFIG_BUSYBOX_DEFAULT_MODPROBE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_MODPROBE_BLACKLIST is not set
>>      # CONFIG_BUSYBOX_DEFAULT_RMMOD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_CMDLINE_MODULE_OPTIONS is not =
set
>>      # =
CONFIG_BUSYBOX_DEFAULT_FEATURE_MODPROBE_SMALL_CHECK_ALREADY_LOADED is =
not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_2_4_MODULES is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_INSMOD_VERSION_CHECKING is not =
set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_INSMOD_KSYMOOPS_SYMBOLS is not =
set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_INSMOD_LOADINKMEM is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_INSMOD_LOAD_MAP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_INSMOD_LOAD_MAP_FULL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_CHECK_TAINTED_MODULE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_INSMOD_TRY_MMAP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_MODUTILS_ALIAS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_MODUTILS_SYMBOLS is not set
>>      CONFIG_BUSYBOX_DEFAULT_DEFAULT_MODULES_DIR=3D""
>>      CONFIG_BUSYBOX_DEFAULT_DEFAULT_DEPMOD_FILE=3D""
>>      # CONFIG_BUSYBOX_DEFAULT_ACPID is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_ACPID_COMPAT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_BLKDISCARD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_BLKID is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_BLKID_TYPE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_BLOCKDEV is not set
>>      # CONFIG_BUSYBOX_DEFAULT_CAL is not set
>>      CONFIG_BUSYBOX_DEFAULT_DMESG=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_DMESG_PRETTY=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FALLOCATE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FATATTR is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FBSET is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_FBSET_FANCY is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_FBSET_READMODE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FDFORMAT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FDISK is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FDISK_SUPPORT_LARGE_DISKS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_FDISK_WRITABLE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_AIX_LABEL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SGI_LABEL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SUN_LABEL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_OSF_LABEL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_GPT_LABEL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_FDISK_ADVANCED is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FINDFS is not set
>>      CONFIG_BUSYBOX_DEFAULT_FLOCK=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FDFLUSH is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FREERAMDISK is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FSCK_MINIX is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FSFREEZE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FSTRIM is not set
>>      # CONFIG_BUSYBOX_DEFAULT_GETOPT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_GETOPT_LONG is not set
>>      CONFIG_BUSYBOX_DEFAULT_HEXDUMP=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_HEXDUMP_REVERSE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_XXD is not set
>>      CONFIG_BUSYBOX_DEFAULT_HWCLOCK=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_HWCLOCK_LONG_OPTIONS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_HWCLOCK_ADJTIME_FHS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_IPCRM is not set
>>      # CONFIG_BUSYBOX_DEFAULT_IPCS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_LOSETUP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_LSPCI is not set
>>      # CONFIG_BUSYBOX_DEFAULT_LSUSB is not set
>>      # CONFIG_BUSYBOX_DEFAULT_MDEV is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_MDEV_CONF is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_MDEV_RENAME is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_MDEV_RENAME_REGEXP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_MDEV_EXEC is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_MDEV_LOAD_FIRMWARE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_MKE2FS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_MKFS_EXT2 is not set
>>      # CONFIG_BUSYBOX_DEFAULT_MKFS_MINIX is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_MINIX2 is not set
>>      # CONFIG_BUSYBOX_DEFAULT_MKFS_REISER is not set
>>      # CONFIG_BUSYBOX_DEFAULT_MKDOSFS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_MKFS_VFAT is not set
>>      CONFIG_BUSYBOX_DEFAULT_MKSWAP=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_MKSWAP_UUID is not set
>>      # CONFIG_BUSYBOX_DEFAULT_MORE is not set
>>      CONFIG_BUSYBOX_DEFAULT_MOUNT=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_MOUNT_FAKE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_MOUNT_VERBOSE is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_MOUNT_HELPERS=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_MOUNT_LABEL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_MOUNT_NFS is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_MOUNT_CIFS=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_MOUNT_FLAGS=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_MOUNT_FSTAB=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_MOUNT_OTHERTAB is not set
>>      # CONFIG_BUSYBOX_DEFAULT_NSENTER is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_NSENTER_LONG_OPTS is not set
>>      CONFIG_BUSYBOX_DEFAULT_PIVOT_ROOT=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_RDATE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_RDEV is not set
>>      # CONFIG_BUSYBOX_DEFAULT_READPROFILE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_REV is not set
>>      # CONFIG_BUSYBOX_DEFAULT_RTCWAKE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SCRIPT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SCRIPTREPLAY is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SETARCH is not set
>>      # CONFIG_BUSYBOX_DEFAULT_LINUX32 is not set
>>      # CONFIG_BUSYBOX_DEFAULT_LINUX64 is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SETPRIV is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SWAPON is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SWAPON_DISCARD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SWAPON_PRI is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SWAPOFF is not set
>>      CONFIG_BUSYBOX_DEFAULT_SWITCH_ROOT=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_UEVENT is not set
>>      CONFIG_BUSYBOX_DEFAULT_UMOUNT=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_UMOUNT_ALL=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_UNSHARE is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_MOUNT_LOOP=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_MOUNT_LOOP_CREATE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_MTAB_SUPPORT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_VOLUMEID is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VOLUMEID_BCACHE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VOLUMEID_BTRFS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VOLUMEID_CRAMFS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VOLUMEID_EXFAT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VOLUMEID_EXT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VOLUMEID_F2FS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VOLUMEID_FAT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VOLUMEID_HFS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VOLUMEID_ISO9660 is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VOLUMEID_JFS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VOLUMEID_LINUXRAID is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VOLUMEID_LINUXSWAP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VOLUMEID_LUKS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VOLUMEID_NILFS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VOLUMEID_NTFS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VOLUMEID_OCFS2 is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VOLUMEID_REISERFS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VOLUMEID_ROMFS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VOLUMEID_SQUASHFS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VOLUMEID_SYSV is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VOLUMEID_UBIFS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VOLUMEID_UDF is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_VOLUMEID_XFS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_ADJTIMEX is not set
>>      # CONFIG_BUSYBOX_DEFAULT_BBCONFIG is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_COMPRESS_BBCONFIG is not set
>>      # CONFIG_BUSYBOX_DEFAULT_BEEP is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_BEEP_FREQ=3D0
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_BEEP_LENGTH_MS=3D0
>>      # CONFIG_BUSYBOX_DEFAULT_CHAT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_CHAT_NOFAIL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_CHAT_TTY_HIFI is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_CHAT_IMPLICIT_CR is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_CHAT_SWALLOW_OPTS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_CHAT_SEND_ESCAPES is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_CHAT_VAR_ABORT_LEN is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_CHAT_CLR_ABORT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_CHRT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_CONSPY is not set
>>      CONFIG_BUSYBOX_DEFAULT_CROND=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_CROND_D is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_CROND_CALL_SENDMAIL is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_CROND_DIR=3D"/etc"
>>      CONFIG_BUSYBOX_DEFAULT_CRONTAB=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_DC is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_DC_LIBM is not set
>>      # CONFIG_BUSYBOX_DEFAULT_DEVFSD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_DEVFSD_MODLOAD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_DEVFSD_FG_NP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_DEVFSD_VERBOSE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_DEVFS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_DEVMEM is not set
>>      # CONFIG_BUSYBOX_DEFAULT_EJECT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_EJECT_SCSI is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FBSPLASH is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FLASH_ERASEALL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FLASH_LOCK is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FLASH_UNLOCK is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FLASHCP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HDPARM is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_HDPARM_GET_IDENTITY is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_HDPARM_HDIO_SCAN_HWIF is not =
set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_HDPARM_HDIO_UNREGISTER_HWIF is =
not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_HDPARM_HDIO_DRIVE_RESET is not =
set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_HDPARM_HDIO_TRISTATE_HWIF is =
not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_HDPARM_HDIO_GETSET_DMA is not =
set
>>      # CONFIG_BUSYBOX_DEFAULT_I2CGET is not set
>>      # CONFIG_BUSYBOX_DEFAULT_I2CSET is not set
>>      # CONFIG_BUSYBOX_DEFAULT_I2CDUMP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_I2CDETECT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_INOTIFYD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_IONICE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_LAST is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_LAST_FANCY is not set
>>      CONFIG_BUSYBOX_DEFAULT_LESS=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_LESS_MAXLINES=3D9999999
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_LESS_BRACKETS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_LESS_FLAGS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_LESS_TRUNCATE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_LESS_MARKS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_LESS_REGEXP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_LESS_WINCH is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_LESS_ASK_TERMINAL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_LESS_DASHCMD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_LESS_LINENUMS is not set
>>      CONFIG_BUSYBOX_DEFAULT_LOCK=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_LSSCSI is not set
>>      # CONFIG_BUSYBOX_DEFAULT_MAKEDEVS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_MAKEDEVS_LEAF is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_MAKEDEVS_TABLE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_MAN is not set
>>      # CONFIG_BUSYBOX_DEFAULT_MICROCOM is not set
>>      # CONFIG_BUSYBOX_DEFAULT_MOUNTPOINT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_MT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_NANDWRITE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_NANDDUMP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_PARTPROBE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_RAIDAUTORUN is not set
>>      # CONFIG_BUSYBOX_DEFAULT_READAHEAD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_RFKILL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_RUNLEVEL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_RX is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SETSERIAL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SETSID is not set
>>      CONFIG_BUSYBOX_DEFAULT_STRINGS=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_TASKSET is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TASKSET_FANCY is not set
>>      CONFIG_BUSYBOX_DEFAULT_TIME=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_TIMEOUT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_TTYSIZE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_UBIATTACH is not set
>>      # CONFIG_BUSYBOX_DEFAULT_UBIDETACH is not set
>>      # CONFIG_BUSYBOX_DEFAULT_UBIMKVOL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_UBIRMVOL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_UBIRSVOL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_UBIUPDATEVOL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_UBIRENAME is not set
>>      # CONFIG_BUSYBOX_DEFAULT_VOLNAME is not set
>>      # CONFIG_BUSYBOX_DEFAULT_WALL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_WATCHDOG is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_IPV6=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_UNIX_LOCAL is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_PREFER_IPV4_ADDRESS=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_VERBOSE_RESOLUTION_ERRORS=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_ARP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_ARPING is not set
>>      CONFIG_BUSYBOX_DEFAULT_BRCTL=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_BRCTL_FANCY=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_BRCTL_SHOW=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_DNSD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_ETHER_WAKE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FTPD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_FTPD_WRITE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_FTPD_ACCEPT_BROKEN_LIST is not =
set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_FTPD_AUTHENTICATION is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FTPGET is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FTPPUT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_FTPGETPUT_LONG_OPTIONS is not =
set
>>      # CONFIG_BUSYBOX_DEFAULT_HOSTNAME is not set
>>      # CONFIG_BUSYBOX_DEFAULT_DNSDOMAINNAME is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HTTPD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_HTTPD_RANGES is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_HTTPD_SETUID is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_HTTPD_BASIC_AUTH is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_HTTPD_AUTH_MD5 is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_HTTPD_CGI is not set
>>      # =
CONFIG_BUSYBOX_DEFAULT_FEATURE_HTTPD_CONFIG_WITH_SCRIPT_INTERPR is not =
set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_HTTPD_SET_REMOTE_PORT_TO_ENV is =
not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_HTTPD_ENCODE_URL_STR is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_HTTPD_ERROR_PAGES is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_HTTPD_PROXY is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_HTTPD_GZIP is not set
>>      CONFIG_BUSYBOX_DEFAULT_IFCONFIG=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_IFCONFIG_STATUS=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_IFCONFIG_SLIP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_IFCONFIG_MEMSTART_IOADDR_IRQ is =
not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_IFCONFIG_HW=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_IFCONFIG_BROADCAST_PLUS=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_IFENSLAVE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_IFPLUGD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_IFUP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_IFDOWN is not set
>>      CONFIG_BUSYBOX_DEFAULT_IFUPDOWN_IFSTATE_PATH=3D""
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_IFUPDOWN_IP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_IFUPDOWN_IPV4 is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_IFUPDOWN_IPV6 is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_IFUPDOWN_MAPPING is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_IFUPDOWN_EXTERNAL_DHCP is not =
set
>>      # CONFIG_BUSYBOX_DEFAULT_INETD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_INETD_SUPPORT_BUILTIN_ECHO is =
not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_INETD_SUPPORT_BUILTIN_DISCARD =
is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_INETD_SUPPORT_BUILTIN_TIME is =
not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_INETD_SUPPORT_BUILTIN_DAYTIME =
is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_INETD_SUPPORT_BUILTIN_CHARGEN =
is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_INETD_RPC is not set
>>      CONFIG_BUSYBOX_DEFAULT_IP=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_IPADDR is not set
>>      # CONFIG_BUSYBOX_DEFAULT_IPLINK is not set
>>      # CONFIG_BUSYBOX_DEFAULT_IPROUTE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_IPTUNNEL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_IPRULE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_IPNEIGH is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_IP_ADDRESS=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_IP_LINK=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_IP_ROUTE=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_IP_ROUTE_DIR=3D"/etc/iproute2"
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_IP_TUNNEL is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_IP_RULE=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_IP_NEIGH=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_IP_RARE_PROTOCOLS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_IPCALC is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_IPCALC_FANCY is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_IPCALC_LONG_OPTIONS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FAKEIDENTD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_NAMEIF is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_NAMEIF_EXTENDED is not set
>>      # CONFIG_BUSYBOX_DEFAULT_NBDCLIENT is not set
>>      CONFIG_BUSYBOX_DEFAULT_NC=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_NC_SERVER is not set
>>      # CONFIG_BUSYBOX_DEFAULT_NC_EXTRA is not set
>>      # CONFIG_BUSYBOX_DEFAULT_NC_110_COMPAT is not set
>>      CONFIG_BUSYBOX_DEFAULT_NETMSG=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_NETSTAT=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_NETSTAT_WIDE=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_NETSTAT_PRG=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_NSLOOKUP is not set
>>      CONFIG_BUSYBOX_DEFAULT_NSLOOKUP_OPENWRT=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_NSLOOKUP_OPENWRT_LONG_OPTIONS =
is not set
>>      CONFIG_BUSYBOX_DEFAULT_NTPD=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_NTPD_SERVER=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_NTPD_CONF is not set
>>      CONFIG_BUSYBOX_DEFAULT_PING=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_PING6=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_FANCY_PING=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_PSCAN is not set
>>      CONFIG_BUSYBOX_DEFAULT_ROUTE=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_SLATTACH is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SSL_CLIENT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_TCPSVD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_UDPSVD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_TELNET is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TELNET_TTYPE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TELNET_AUTOLOGIN is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TELNET_WIDTH is not set
>>      # CONFIG_BUSYBOX_DEFAULT_TELNETD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TELNETD_STANDALONE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TELNETD_INETD_WAIT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_TFTP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_TFTPD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TFTP_GET is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TFTP_PUT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TFTP_BLOCKSIZE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TFTP_PROGRESS_BAR is not set
>>      # CONFIG_BUSYBOX_DEFAULT_TFTP_DEBUG is not set
>>      # CONFIG_BUSYBOX_DEFAULT_TLS is not set
>>      CONFIG_BUSYBOX_DEFAULT_TRACEROUTE=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_TRACEROUTE6=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_TRACEROUTE_VERBOSE=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TRACEROUTE_USE_ICMP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_TUNCTL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TUNCTL_UG is not set
>>      # CONFIG_BUSYBOX_DEFAULT_VCONFIG is not set
>>      # CONFIG_BUSYBOX_DEFAULT_WGET is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_WGET_STATUSBAR is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_WGET_AUTHENTICATION is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_WGET_LONG_OPTIONS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_WGET_TIMEOUT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_WGET_HTTPS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_WGET_OPENSSL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_WHOIS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_ZCIP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_UDHCPC6 is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_UDHCPC6_RFC3646 is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_UDHCPC6_RFC4704 is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_UDHCPC6_RFC4833 is not set
>>      # CONFIG_BUSYBOX_DEFAULT_UDHCPD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_UDHCPD_WRITE_LEASES_EARLY is =
not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_UDHCPD_BASE_IP_ON_MAC is not =
set
>>      CONFIG_BUSYBOX_DEFAULT_DHCPD_LEASES_FILE=3D""
>>      # CONFIG_BUSYBOX_DEFAULT_DUMPLEASES is not set
>>      # CONFIG_BUSYBOX_DEFAULT_DHCPRELAY is not set
>>      CONFIG_BUSYBOX_DEFAULT_UDHCPC=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_UDHCPC_ARPING is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_UDHCPC_SANITIZEOPT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_UDHCP_PORT is not set
>>      CONFIG_BUSYBOX_DEFAULT_UDHCP_DEBUG=3D0
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_UDHCP_RFC3397=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_UDHCP_8021Q is not set
>>      =
CONFIG_BUSYBOX_DEFAULT_UDHCPC_DEFAULT_SCRIPT=3D"/usr/share/udhcpc/default.=
script"
>>      CONFIG_BUSYBOX_DEFAULT_UDHCPC_SLACK_FOR_BUGGY_SERVERS=3D80
>>      CONFIG_BUSYBOX_DEFAULT_IFUPDOWN_UDHCPC_CMD_OPTIONS=3D""
>>      # CONFIG_BUSYBOX_DEFAULT_LPD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_LPR is not set
>>      # CONFIG_BUSYBOX_DEFAULT_LPQ is not set
>>      # CONFIG_BUSYBOX_DEFAULT_MAKEMIME is not set
>>      # CONFIG_BUSYBOX_DEFAULT_POPMAILDIR is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_POPMAILDIR_DELIVERY is not set
>>      # CONFIG_BUSYBOX_DEFAULT_REFORMIME is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_REFORMIME_COMPAT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SENDMAIL is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_MIME_CHARSET=3D""
>>      CONFIG_BUSYBOX_DEFAULT_FREE=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FUSER is not set
>>      # CONFIG_BUSYBOX_DEFAULT_IOSTAT is not set
>>      CONFIG_BUSYBOX_DEFAULT_KILL=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_KILLALL=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_KILLALL5 is not set
>>      # CONFIG_BUSYBOX_DEFAULT_LSOF is not set
>>      # CONFIG_BUSYBOX_DEFAULT_MPSTAT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_NMETER is not set
>>      CONFIG_BUSYBOX_DEFAULT_PGREP=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_PKILL is not set
>>      CONFIG_BUSYBOX_DEFAULT_PIDOF=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_PIDOF_SINGLE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_PIDOF_OMIT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_PMAP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_POWERTOP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_POWERTOP_INTERACTIVE is not set
>>      CONFIG_BUSYBOX_DEFAULT_PS=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_PS_WIDE=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_PS_LONG is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_PS_TIME is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_PS_ADDITIONAL_COLUMNS is not =
set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_PS_UNUSUAL_SYSTEMS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_PSTREE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_PWDX is not set
>>      # CONFIG_BUSYBOX_DEFAULT_RENICE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SMEMCAP is not set
>>      CONFIG_BUSYBOX_DEFAULT_BB_SYSCTL=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_TOP=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TOP_INTERACTIVE is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_TOP_CPU_USAGE_PERCENTAGE=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_TOP_CPU_GLOBAL_PERCENTS=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TOP_SMP_CPU is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TOP_DECIMALS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TOP_SMP_PROCESS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_TOPMEM is not set
>>      CONFIG_BUSYBOX_DEFAULT_UPTIME=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_UPTIME_UTMP_SUPPORT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_WATCH is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SHOW_THREADS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_CHPST is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SETUIDGID is not set
>>      # CONFIG_BUSYBOX_DEFAULT_ENVUIDGID is not set
>>      # CONFIG_BUSYBOX_DEFAULT_ENVDIR is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SOFTLIMIT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_RUNSV is not set
>>      # CONFIG_BUSYBOX_DEFAULT_RUNSVDIR is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_RUNSVDIR_LOG is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SV is not set
>>      CONFIG_BUSYBOX_DEFAULT_SV_DEFAULT_SERVICE_DIR=3D""
>>      # CONFIG_BUSYBOX_DEFAULT_SVC is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SVLOGD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_CHCON is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_CHCON_LONG_OPTIONS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_GETENFORCE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_GETSEBOOL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_LOAD_POLICY is not set
>>      # CONFIG_BUSYBOX_DEFAULT_MATCHPATHCON is not set
>>      # CONFIG_BUSYBOX_DEFAULT_RUNCON is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_RUNCON_LONG_OPTIONS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SELINUXENABLED is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SESTATUS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SETENFORCE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SETFILES is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SETFILES_CHECK_OPTION is not =
set
>>      # CONFIG_BUSYBOX_DEFAULT_RESTORECON is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SETSEBOOL is not set
>>      CONFIG_BUSYBOX_DEFAULT_SH_IS_ASH=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_SH_IS_HUSH is not set
>>      # CONFIG_BUSYBOX_DEFAULT_SH_IS_NONE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_BASH_IS_ASH is not set
>>      # CONFIG_BUSYBOX_DEFAULT_BASH_IS_HUSH is not set
>>      CONFIG_BUSYBOX_DEFAULT_BASH_IS_NONE=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_ASH=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_ASH_OPTIMIZE_FOR_SIZE is not set
>>      CONFIG_BUSYBOX_DEFAULT_ASH_INTERNAL_GLOB=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_ASH_BASH_COMPAT=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_ASH_JOB_CONTROL=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_ASH_ALIAS=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_ASH_RANDOM_SUPPORT is not set
>>      CONFIG_BUSYBOX_DEFAULT_ASH_EXPAND_PRMT=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_ASH_IDLE_TIMEOUT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_ASH_MAIL is not set
>>      CONFIG_BUSYBOX_DEFAULT_ASH_ECHO=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_ASH_PRINTF=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_ASH_TEST=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_ASH_HELP is not set
>>      CONFIG_BUSYBOX_DEFAULT_ASH_GETOPTS=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_ASH_CMDCMD=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_CTTYHACK is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_BASH_COMPAT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_BRACE_EXPANSION is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_HELP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_INTERACTIVE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_SAVEHISTORY is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_JOB is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_TICK is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_IF is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_LOOPS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_CASE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_FUNCTIONS is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_LOCAL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_RANDOM_SUPPORT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_MODE_X is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_ECHO is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_PRINTF is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_TEST is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_EXPORT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_EXPORT_N is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_KILL is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_WAIT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_TRAP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_TYPE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_READ is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_SET is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_UNSET is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_ULIMIT is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_UMASK is not set
>>      # CONFIG_BUSYBOX_DEFAULT_HUSH_MEMLEAK is not set
>>      # CONFIG_BUSYBOX_DEFAULT_MSH is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_SH_MATH=3Dy
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_SH_MATH_64=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SH_EXTRA_QUIET is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SH_STANDALONE is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_SH_NOFORK=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SH_HISTFILESIZE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_KLOGD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_KLOGD_KLOGCTL is not set
>>      CONFIG_BUSYBOX_DEFAULT_LOGGER=3Dy
>>      # CONFIG_BUSYBOX_DEFAULT_LOGREAD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_LOGREAD_REDUCED_LOCKING is not =
set
>>      # CONFIG_BUSYBOX_DEFAULT_SYSLOGD is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_ROTATE_LOGFILE is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_REMOTE_LOG is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SYSLOGD_DUP is not set
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_SYSLOGD_CFG is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_SYSLOGD_READ_BUFFER_SIZE=3D0
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_IPC_SYSLOG is not set
>>      CONFIG_BUSYBOX_DEFAULT_FEATURE_IPC_SYSLOG_BUFFER_SIZE=3D0
>>      # CONFIG_BUSYBOX_DEFAULT_FEATURE_KMSG_SYSLOG is not set
>>      # CONFIG_PACKAGE_ca-bundle is not set
>>      # CONFIG_PACKAGE_ca-certificates is not set
>>      CONFIG_PACKAGE_dnsmasq=3Dy
>>      # CONFIG_PACKAGE_dnsmasq-dhcpv6 is not set
>>      # CONFIG_PACKAGE_dnsmasq-full is not set
>>      CONFIG_PACKAGE_dropbear=3Dy
>>=20
>>      #
>>      # Configuration
>>      #
>>      CONFIG_DROPBEAR_CURVE25519=3Dy
>>      CONFIG_DROPBEAR_ECC=3Dy
>>      CONFIG_DROPBEAR_ZLIB=3Dy
>>      # CONFIG_PACKAGE_ead is not set
>>      CONFIG_PACKAGE_firewall=3Dy
>>      CONFIG_PACKAGE_fstools=3Dy
>>      CONFIG_PACKAGE_fwtool=3Dy
>>      CONFIG_PACKAGE_jsonfilter=3Dy
>>      CONFIG_PACKAGE_lede-keyring=3Dy
>>      # CONFIG_PACKAGE_libatomic is not set
>>      CONFIG_PACKAGE_libc=3Dy
>>      CONFIG_PACKAGE_libgcc=3Dy
>>      # CONFIG_PACKAGE_libgomp is not set
>>      CONFIG_PACKAGE_libpthread=3Dy
>>      # CONFIG_PACKAGE_librt is not set
>>      # CONFIG_PACKAGE_libstdcpp is not set
>>      CONFIG_PACKAGE_logd=3Dy
>>      CONFIG_PACKAGE_mtd=3Dy
>>      CONFIG_PACKAGE_netifd=3Dy
>>      # CONFIG_PACKAGE_om-watchdog is not set
>>      CONFIG_PACKAGE_opkg=3Dy
>>      CONFIG_PACKAGE_procd=3Dy
>>=20
>>      #
>>      # Configuration
>>      #
>>      # CONFIG_PROCD_SHOW_BOOT is not set
>>      # CONFIG_PROCD_ZRAM_TMPFS is not set
>>      # CONFIG_PACKAGE_qos-scripts is not set
>>      # CONFIG_PACKAGE_resolveip is not set
>>      # CONFIG_PACKAGE_rpcd is not set
>>      # CONFIG_PACKAGE_snapshot-tool is not set
>>      CONFIG_PACKAGE_swconfig=3Dy
>>      CONFIG_PACKAGE_ubox=3Dy
>>      CONFIG_PACKAGE_ubus=3Dy
>>      CONFIG_PACKAGE_ubusd=3Dy
>>      CONFIG_PACKAGE_uci=3Dy
>>      CONFIG_PACKAGE_usign=3Dy
>>      # CONFIG_PACKAGE_wireless-tools is not set
>>      # CONFIG_PACKAGE_zram-swap is not set
>>=20
>>      #
>>      # Boot Loaders
>>      #
>>=20
>>      #
>>      # Development
>>      #
>>=20
>>      #
>>      # Libraries
>>      #
>>      # CONFIG_PACKAGE_libncurses-dev is not set
>>      # CONFIG_PACKAGE_zlib-dev is not set
>>      # CONFIG_PACKAGE_ar is not set
>>      # CONFIG_PACKAGE_binutils is not set
>>      # CONFIG_PACKAGE_gdb is not set
>>      # CONFIG_PACKAGE_gdbserver is not set
>>      # CONFIG_PACKAGE_objdump is not set
>>      # CONFIG_PACKAGE_trace-cmd is not set
>>      # CONFIG_PACKAGE_trace-cmd-extra is not set
>>      # CONFIG_PACKAGE_valgrind is not set
>>=20
>>      #
>>      # Firmware
>>      #
>>=20
>>      #
>>      # ath10k IPQ4019 Boarddata
>>      #
>>      # CONFIG_PACKAGE_aircard-pcmcia-firmware is not set
>>      # CONFIG_PACKAGE_ar3k-firmware is not set
>>      # CONFIG_PACKAGE_ath10k-firmware-qca4019 is not set
>>      # CONFIG_PACKAGE_ath10k-firmware-qca4019-ct is not set
>>      # CONFIG_PACKAGE_ath10k-firmware-qca4019-ct-htt is not set
>>      # CONFIG_PACKAGE_ath10k-firmware-qca6174 is not set
>>      # CONFIG_PACKAGE_ath10k-firmware-qca9887 is not set
>>      # CONFIG_PACKAGE_ath10k-firmware-qca9887-ct is not set
>>      # CONFIG_PACKAGE_ath10k-firmware-qca9887-ct-htt is not set
>>      # CONFIG_PACKAGE_ath10k-firmware-qca9888 is not set
>>      # CONFIG_PACKAGE_ath10k-firmware-qca9888-ct is not set
>>      # CONFIG_PACKAGE_ath10k-firmware-qca9888-ct-htt is not set
>>      # CONFIG_PACKAGE_ath10k-firmware-qca988x is not set
>>      # CONFIG_PACKAGE_ath10k-firmware-qca988x-ct is not set
>>      # CONFIG_PACKAGE_ath10k-firmware-qca988x-ct-htt is not set
>>      # CONFIG_PACKAGE_ath10k-firmware-qca9984 is not set
>>      # CONFIG_PACKAGE_ath10k-firmware-qca9984-ct is not set
>>      # CONFIG_PACKAGE_ath10k-firmware-qca9984-ct-htt is not set
>>      # CONFIG_PACKAGE_ath10k-firmware-qca99x0 is not set
>>      # CONFIG_PACKAGE_ath10k-firmware-qca99x0-ct is not set
>>      # CONFIG_PACKAGE_ath10k-firmware-qca99x0-ct-htt is not set
>>      # CONFIG_PACKAGE_ath6k-firmware is not set
>>      # CONFIG_PACKAGE_ath9k-htc-firmware is not set
>>      # CONFIG_PACKAGE_b43legacy-firmware is not set
>>      # CONFIG_PACKAGE_bnx2-firmware is not set
>>      # CONFIG_PACKAGE_brcmfmac-firmware-4329-sdio is not set
>>      # CONFIG_PACKAGE_brcmfmac-firmware-43362-sdio is not set
>>      # CONFIG_PACKAGE_brcmfmac-firmware-43430-sdio is not set
>>      # CONFIG_PACKAGE_brcmfmac-firmware-43602a1-pcie is not set
>>      # CONFIG_PACKAGE_brcmfmac-firmware-4366b1-pcie is not set
>>      # CONFIG_PACKAGE_brcmfmac-firmware-usb is not set
>>      # CONFIG_PACKAGE_brcmsmac-firmware is not set
>>      # CONFIG_PACKAGE_carl9170-firmware is not set
>>      # CONFIG_PACKAGE_e100-firmware is not set
>>      # CONFIG_PACKAGE_edgeport-firmware is not set
>>      # CONFIG_PACKAGE_ibt-firmware is not set
>>      # CONFIG_PACKAGE_iwl3945-firmware is not set
>>      # CONFIG_PACKAGE_iwl4965-firmware is not set
>>      # CONFIG_PACKAGE_iwlwifi-firmware-iwl100 is not set
>>      # CONFIG_PACKAGE_iwlwifi-firmware-iwl1000 is not set
>>      # CONFIG_PACKAGE_iwlwifi-firmware-iwl105 is not set
>>      # CONFIG_PACKAGE_iwlwifi-firmware-iwl135 is not set
>>      # CONFIG_PACKAGE_iwlwifi-firmware-iwl2000 is not set
>>      # CONFIG_PACKAGE_iwlwifi-firmware-iwl2030 is not set
>>      # CONFIG_PACKAGE_iwlwifi-firmware-iwl3160 is not set
>>      # CONFIG_PACKAGE_iwlwifi-firmware-iwl3168 is not set
>>      # CONFIG_PACKAGE_iwlwifi-firmware-iwl5000 is not set
>>      # CONFIG_PACKAGE_iwlwifi-firmware-iwl5150 is not set
>>      # CONFIG_PACKAGE_iwlwifi-firmware-iwl6000g2 is not set
>>      # CONFIG_PACKAGE_iwlwifi-firmware-iwl6000g2a is not set
>>      # CONFIG_PACKAGE_iwlwifi-firmware-iwl6000g2b is not set
>>      # CONFIG_PACKAGE_iwlwifi-firmware-iwl6050 is not set
>>      # CONFIG_PACKAGE_iwlwifi-firmware-iwl7260 is not set
>>      # CONFIG_PACKAGE_iwlwifi-firmware-iwl7265 is not set
>>      # CONFIG_PACKAGE_iwlwifi-firmware-iwl7265d is not set
>>      # CONFIG_PACKAGE_iwlwifi-firmware-iwl8260c is not set
>>      # CONFIG_PACKAGE_iwlwifi-firmware-iwl8265 is not set
>>      # CONFIG_PACKAGE_jboot-tools is not set
>>      # CONFIG_PACKAGE_libertas-sdio-firmware is not set
>>      # CONFIG_PACKAGE_libertas-spi-firmware is not set
>>      # CONFIG_PACKAGE_libertas-usb-firmware is not set
>>      # CONFIG_PACKAGE_mt7601u-firmware is not set
>>      # CONFIG_PACKAGE_mwifiex-pcie-firmware is not set
>>      # CONFIG_PACKAGE_mwifiex-sdio-firmware is not set
>>      # CONFIG_PACKAGE_mwl8k-firmware is not set
>>      # CONFIG_PACKAGE_p54-pci-firmware is not set
>>      # CONFIG_PACKAGE_p54-spi-firmware is not set
>>      # CONFIG_PACKAGE_p54-usb-firmware is not set
>>      # CONFIG_PACKAGE_prism54-firmware is not set
>>      # CONFIG_PACKAGE_r8169-firmware is not set
>>      # CONFIG_PACKAGE_rt2800-pci-firmware is not set
>>      # CONFIG_PACKAGE_rt2800-usb-firmware is not set
>>      # CONFIG_PACKAGE_rt61-pci-firmware is not set
>>      # CONFIG_PACKAGE_rt73-usb-firmware is not set
>>      # CONFIG_PACKAGE_rtl8188eu-firmware is not set
>>      # CONFIG_PACKAGE_rtl8192ce-firmware is not set
>>      # CONFIG_PACKAGE_rtl8192cu-firmware is not set
>>      # CONFIG_PACKAGE_rtl8192de-firmware is not set
>>      # CONFIG_PACKAGE_rtl8192se-firmware is not set
>>      # CONFIG_PACKAGE_rtl8192su-firmware is not set
>>      # CONFIG_PACKAGE_rtl8821ae-firmware is not set
>>      CONFIG_PACKAGE_wireless-regdb=3Dy
>>      # CONFIG_PACKAGE_wl12xx-firmware is not set
>>      # CONFIG_PACKAGE_wl18xx-firmware is not set
>>=20
>>      #
>>      # Kernel modules
>>      #
>>=20
>>      #
>>      # Block Devices
>>      #
>>      # CONFIG_PACKAGE_kmod-aoe is not set
>>      # CONFIG_PACKAGE_kmod-block2mtd is not set
>>      # CONFIG_PACKAGE_kmod-dm is not set
>>      # CONFIG_PACKAGE_kmod-loop is not set
>>      # CONFIG_PACKAGE_kmod-md-mod is not set
>>      # CONFIG_PACKAGE_kmod-nbd is not set
>>      # CONFIG_PACKAGE_kmod-scsi-cdrom is not set
>>      # CONFIG_PACKAGE_kmod-scsi-core is not set
>>      # CONFIG_PACKAGE_kmod-scsi-generic is not set
>>      # CONFIG_PACKAGE_kmod-scsi-tape is not set
>>=20
>>      #
>>      # CAN Support
>>      #
>>      # CONFIG_PACKAGE_kmod-can is not set
>>=20
>>      #
>>      # Cryptographic API modules
>>      #
>>      # CONFIG_PACKAGE_kmod-crypto-aead is not set
>>      # CONFIG_PACKAGE_kmod-crypto-authenc is not set
>>      # CONFIG_PACKAGE_kmod-crypto-cbc is not set
>>      # CONFIG_PACKAGE_kmod-crypto-ccm is not set
>>      # CONFIG_PACKAGE_kmod-crypto-cmac is not set
>>      # CONFIG_PACKAGE_kmod-crypto-crc32c is not set
>>      # CONFIG_PACKAGE_kmod-crypto-ctr is not set
>>      # CONFIG_PACKAGE_kmod-crypto-cts is not set
>>      # CONFIG_PACKAGE_kmod-crypto-deflate is not set
>>      # CONFIG_PACKAGE_kmod-crypto-des is not set
>>      # CONFIG_PACKAGE_kmod-crypto-ecb is not set
>>      # CONFIG_PACKAGE_kmod-crypto-ecdh is not set
>>      # CONFIG_PACKAGE_kmod-crypto-echainiv is not set
>>      # CONFIG_PACKAGE_kmod-crypto-fcrypt is not set
>>      # CONFIG_PACKAGE_kmod-crypto-gcm is not set
>>      # CONFIG_PACKAGE_kmod-crypto-gf128 is not set
>>      # CONFIG_PACKAGE_kmod-crypto-ghash is not set
>>      # CONFIG_PACKAGE_kmod-crypto-hash is not set
>>      # CONFIG_PACKAGE_kmod-crypto-hmac is not set
>>      # CONFIG_PACKAGE_kmod-crypto-hw-ccp is not set
>>      # CONFIG_PACKAGE_kmod-crypto-hw-geode is not set
>>      # CONFIG_PACKAGE_kmod-crypto-hw-hifn-795x is not set
>>      # CONFIG_PACKAGE_kmod-crypto-hw-padlock is not set
>>      # CONFIG_PACKAGE_kmod-crypto-hw-talitos is not set
>>      # CONFIG_PACKAGE_kmod-crypto-manager is not set
>>      # CONFIG_PACKAGE_kmod-crypto-md4 is not set
>>      # CONFIG_PACKAGE_kmod-crypto-md5 is not set
>>      # CONFIG_PACKAGE_kmod-crypto-michael-mic is not set
>>      # CONFIG_PACKAGE_kmod-crypto-misc is not set
>>      # CONFIG_PACKAGE_kmod-crypto-null is not set
>>      # CONFIG_PACKAGE_kmod-crypto-pcbc is not set
>>      # CONFIG_PACKAGE_kmod-crypto-pcompress is not set
>>      # CONFIG_PACKAGE_kmod-crypto-rng is not set
>>      # CONFIG_PACKAGE_kmod-crypto-seqiv is not set
>>      # CONFIG_PACKAGE_kmod-crypto-sha1 is not set
>>      # CONFIG_PACKAGE_kmod-crypto-sha256 is not set
>>      # CONFIG_PACKAGE_kmod-crypto-sha512 is not set
>>      # CONFIG_PACKAGE_kmod-crypto-test is not set
>>      # CONFIG_PACKAGE_kmod-crypto-user is not set
>>      # CONFIG_PACKAGE_kmod-crypto-wq is not set
>>      # CONFIG_PACKAGE_kmod-crypto-xts is not set
>>=20
>>      #
>>      # Filesystems
>>      #
>>      # CONFIG_PACKAGE_kmod-fs-afs is not set
>>      # CONFIG_PACKAGE_kmod-fs-autofs4 is not set
>>      # CONFIG_PACKAGE_kmod-fs-btrfs is not set
>>      # CONFIG_PACKAGE_kmod-fs-cifs is not set
>>      # CONFIG_PACKAGE_kmod-fs-configfs is not set
>>      # CONFIG_PACKAGE_kmod-fs-cramfs is not set
>>      # CONFIG_PACKAGE_kmod-fs-exportfs is not set
>>      # CONFIG_PACKAGE_kmod-fs-ext4 is not set
>>      # CONFIG_PACKAGE_kmod-fs-f2fs is not set
>>      # CONFIG_PACKAGE_kmod-fs-fscache is not set
>>      # CONFIG_PACKAGE_kmod-fs-hfs is not set
>>      # CONFIG_PACKAGE_kmod-fs-hfsplus is not set
>>      # CONFIG_PACKAGE_kmod-fs-isofs is not set
>>      # CONFIG_PACKAGE_kmod-fs-jfs is not set
>>      # CONFIG_PACKAGE_kmod-fs-minix is not set
>>      # CONFIG_PACKAGE_kmod-fs-msdos is not set
>>      # CONFIG_PACKAGE_kmod-fs-nfs is not set
>>      # CONFIG_PACKAGE_kmod-fs-nfs-common is not set
>>      # CONFIG_PACKAGE_kmod-fs-nfs-common-rpcsec is not set
>>      # CONFIG_PACKAGE_kmod-fs-nfs-v3 is not set
>>      # CONFIG_PACKAGE_kmod-fs-nfs-v4 is not set
>>      # CONFIG_PACKAGE_kmod-fs-nfsd is not set
>>      # CONFIG_PACKAGE_kmod-fs-ntfs is not set
>>      # CONFIG_PACKAGE_kmod-fs-reiserfs is not set
>>      # CONFIG_PACKAGE_kmod-fs-squashfs is not set
>>      # CONFIG_PACKAGE_kmod-fs-udf is not set
>>      # CONFIG_PACKAGE_kmod-fs-vfat is not set
>>      # CONFIG_PACKAGE_kmod-fs-xfs is not set
>>      # CONFIG_PACKAGE_kmod-fuse is not set
>>=20
>>      #
>>      # FireWire support
>>      #
>>=20
>>      #
>>      # Hardware Monitoring Support
>>      #
>>      # CONFIG_PACKAGE_kmod-hwmon-core is not set
>>=20
>>      #
>>      # I2C support
>>      #
>>      # CONFIG_PACKAGE_kmod-i2c-core is not set
>>      # CONFIG_PACKAGE_kmod-i2c-gpio-custom is not set
>>=20
>>      #
>>      # Industrial I/O Modules
>>      #
>>      # CONFIG_PACKAGE_kmod-iio-ad799x is not set
>>      # CONFIG_PACKAGE_kmod-iio-bmp280 is not set
>>      # CONFIG_PACKAGE_kmod-iio-bmp280-i2c is not set
>>      # CONFIG_PACKAGE_kmod-iio-bmp280-spi is not set
>>      # CONFIG_PACKAGE_kmod-iio-core is not set
>>      # CONFIG_PACKAGE_kmod-iio-dht11 is not set
>>=20
>>      #
>>      # Input modules
>>      #
>>      # CONFIG_PACKAGE_kmod-hid is not set
>>      # CONFIG_PACKAGE_kmod-hid-generic is not set
>>      # CONFIG_PACKAGE_kmod-input-core is not set
>>      # CONFIG_PACKAGE_kmod-input-evdev is not set
>>      # CONFIG_PACKAGE_kmod-input-gpio-encoder is not set
>>      # CONFIG_PACKAGE_kmod-input-gpio-keys is not set
>>      # CONFIG_PACKAGE_kmod-input-gpio-keys-polled is not set
>>      # CONFIG_PACKAGE_kmod-input-joydev is not set
>>      # CONFIG_PACKAGE_kmod-input-matrixkmap is not set
>>      # CONFIG_PACKAGE_kmod-input-polldev is not set
>>      # CONFIG_PACKAGE_kmod-input-uinput is not set
>>=20
>>      #
>>      # LED modules
>>      #
>>      CONFIG_PACKAGE_kmod-leds-gpio=3Dy
>>      # CONFIG_PACKAGE_kmod-leds-pca963x is not set
>>      # CONFIG_PACKAGE_kmod-ledtrig-default-on is not set
>>      # CONFIG_PACKAGE_kmod-ledtrig-gpio is not set
>>      # CONFIG_PACKAGE_kmod-ledtrig-heartbeat is not set
>>      # CONFIG_PACKAGE_kmod-ledtrig-netdev is not set
>>      # CONFIG_PACKAGE_kmod-ledtrig-oneshot is not set
>>      # CONFIG_PACKAGE_kmod-ledtrig-timer is not set
>>      # CONFIG_PACKAGE_kmod-ledtrig-transient is not set
>>=20
>>      #
>>      # Libraries
>>      #
>>      # CONFIG_PACKAGE_kmod-lib-cordic is not set
>>      CONFIG_PACKAGE_kmod-lib-crc-ccitt=3Dy
>>      CONFIG_PACKAGE_kmod-lib-crc-itu-t=3Dy
>>      # CONFIG_PACKAGE_kmod-lib-crc16 is not set
>>      # CONFIG_PACKAGE_kmod-lib-crc32c is not set
>>      # CONFIG_PACKAGE_kmod-lib-crc7 is not set
>>      # CONFIG_PACKAGE_kmod-lib-crc8 is not set
>>      # CONFIG_PACKAGE_kmod-lib-textsearch is not set
>>=20
>>      #
>>      # Native Language Support
>>      #
>>      CONFIG_PACKAGE_kmod-nls-base=3Dy
>>      # CONFIG_PACKAGE_kmod-nls-cp1250 is not set
>>      # CONFIG_PACKAGE_kmod-nls-cp1251 is not set
>>      # CONFIG_PACKAGE_kmod-nls-cp437 is not set
>>      # CONFIG_PACKAGE_kmod-nls-cp775 is not set
>>      # CONFIG_PACKAGE_kmod-nls-cp850 is not set
>>      # CONFIG_PACKAGE_kmod-nls-cp852 is not set
>>      # CONFIG_PACKAGE_kmod-nls-cp862 is not set
>>      # CONFIG_PACKAGE_kmod-nls-cp864 is not set
>>      # CONFIG_PACKAGE_kmod-nls-cp866 is not set
>>      # CONFIG_PACKAGE_kmod-nls-cp932 is not set
>>      # CONFIG_PACKAGE_kmod-nls-cp936 is not set
>>      # CONFIG_PACKAGE_kmod-nls-cp950 is not set
>>      # CONFIG_PACKAGE_kmod-nls-iso8859-1 is not set
>>      # CONFIG_PACKAGE_kmod-nls-iso8859-13 is not set
>>      # CONFIG_PACKAGE_kmod-nls-iso8859-15 is not set
>>      # CONFIG_PACKAGE_kmod-nls-iso8859-2 is not set
>>      # CONFIG_PACKAGE_kmod-nls-iso8859-6 is not set
>>      # CONFIG_PACKAGE_kmod-nls-iso8859-8 is not set
>>      # CONFIG_PACKAGE_kmod-nls-koi8r is not set
>>      # CONFIG_PACKAGE_kmod-nls-utf8 is not set
>>=20
>>      #
>>      # Netfilter Extensions
>>      #
>>      # CONFIG_PACKAGE_kmod-arptables is not set
>>      # CONFIG_PACKAGE_kmod-ebtables is not set
>>      CONFIG_PACKAGE_kmod-ip6tables=3Dy
>>      # CONFIG_PACKAGE_kmod-ip6tables-extra is not set
>>      # CONFIG_PACKAGE_kmod-ipt-checksum is not set
>>      # CONFIG_PACKAGE_kmod-ipt-cluster is not set
>>      # CONFIG_PACKAGE_kmod-ipt-clusterip is not set
>>      CONFIG_PACKAGE_kmod-ipt-conntrack=3Dy
>>      # CONFIG_PACKAGE_kmod-ipt-conntrack-extra is not set
>>      # CONFIG_PACKAGE_kmod-ipt-conntrack-label is not set
>>      CONFIG_PACKAGE_kmod-ipt-core=3Dy
>>      # CONFIG_PACKAGE_kmod-ipt-debug is not set
>>      # CONFIG_PACKAGE_kmod-ipt-extra is not set
>>      # CONFIG_PACKAGE_kmod-ipt-filter is not set
>>      # CONFIG_PACKAGE_kmod-ipt-hashlimit is not set
>>      # CONFIG_PACKAGE_kmod-ipt-ipopt is not set
>>      # CONFIG_PACKAGE_kmod-ipt-iprange is not set
>>      # CONFIG_PACKAGE_kmod-ipt-ipsec is not set
>>      # CONFIG_PACKAGE_kmod-ipt-ipset is not set
>>      # CONFIG_PACKAGE_kmod-ipt-led is not set
>>      CONFIG_PACKAGE_kmod-ipt-nat=3Dy
>>      # CONFIG_PACKAGE_kmod-ipt-nat-extra is not set
>>      # CONFIG_PACKAGE_kmod-ipt-nat6 is not set
>>      # CONFIG_PACKAGE_kmod-ipt-nflog is not set
>>      # CONFIG_PACKAGE_kmod-ipt-nfqueue is not set
>>      CONFIG_PACKAGE_kmod-ipt-raw=3Dy
>>      # CONFIG_PACKAGE_kmod-ipt-raw6 is not set
>>      # CONFIG_PACKAGE_kmod-ipt-rpfilter is not set
>>      # CONFIG_PACKAGE_kmod-ipt-tee is not set
>>      # CONFIG_PACKAGE_kmod-ipt-tproxy is not set
>>      # CONFIG_PACKAGE_kmod-ipt-u32 is not set
>>      # CONFIG_PACKAGE_kmod-ipt-ulog is not set
>>      CONFIG_PACKAGE_kmod-nf-conntrack=3Dy
>>      # CONFIG_PACKAGE_kmod-nf-conntrack-netlink is not set
>>      CONFIG_PACKAGE_kmod-nf-conntrack6=3Dy
>>      CONFIG_PACKAGE_kmod-nf-ipt=3Dy
>>      CONFIG_PACKAGE_kmod-nf-ipt6=3Dy
>>      CONFIG_PACKAGE_kmod-nf-nat=3Dy
>>      # CONFIG_PACKAGE_kmod-nf-nat6 is not set
>>      # CONFIG_PACKAGE_kmod-nf-nathelper is not set
>>      # CONFIG_PACKAGE_kmod-nf-nathelper-extra is not set
>>      CONFIG_PACKAGE_kmod-nf-reject=3Dy
>>      CONFIG_PACKAGE_kmod-nf-reject6=3Dy
>>      # CONFIG_PACKAGE_kmod-nfnetlink is not set
>>      # CONFIG_PACKAGE_kmod-nfnetlink-log is not set
>>      # CONFIG_PACKAGE_kmod-nfnetlink-queue is not set
>>      # CONFIG_PACKAGE_kmod-nft-arp is not set
>>      # CONFIG_PACKAGE_kmod-nft-bridge is not set
>>      # CONFIG_PACKAGE_kmod-nft-core is not set
>>      # CONFIG_PACKAGE_kmod-nft-nat is not set
>>      # CONFIG_PACKAGE_kmod-nft-nat6 is not set
>>=20
>>      #
>>      # Network Devices
>>      #
>>      # CONFIG_PACKAGE_kmod-dummy is not set
>>      # CONFIG_PACKAGE_kmod-ethoc is not set
>>      # CONFIG_PACKAGE_kmod-gigaset is not set
>>      # CONFIG_PACKAGE_kmod-hfcmulti is not set
>>      # CONFIG_PACKAGE_kmod-hfcpci is not set
>>      # CONFIG_PACKAGE_kmod-ifb is not set
>>      # CONFIG_PACKAGE_kmod-libphy is not set
>>      # CONFIG_PACKAGE_kmod-macvlan is not set
>>      # CONFIG_PACKAGE_kmod-mii is not set
>>      # CONFIG_PACKAGE_kmod-of-mdio is not set
>>      # CONFIG_PACKAGE_kmod-phy-broadcom is not set
>>      # CONFIG_PACKAGE_kmod-spi-ks8995 is not set
>>      # CONFIG_PACKAGE_kmod-swconfig is not set
>>      # CONFIG_PACKAGE_kmod-switch-ip17xx is not set
>>      # CONFIG_PACKAGE_kmod-switch-mvsw61xx is not set
>>      # CONFIG_PACKAGE_kmod-switch-rtl8366-smi is not set
>>      # CONFIG_PACKAGE_kmod-switch-rtl8366rb is not set
>>      # CONFIG_PACKAGE_kmod-switch-rtl8366s is not set
>>      # CONFIG_PACKAGE_kmod-switch-rtl8367b is not set
>>      # CONFIG_PACKAGE_kmod-tg3 is not set
>>=20
>>      #
>>      # Network Support
>>      #
>>      # CONFIG_PACKAGE_kmod-atm is not set
>>      # CONFIG_PACKAGE_kmod-ax25 is not set
>>      # CONFIG_PACKAGE_kmod-bonding is not set
>>      # CONFIG_PACKAGE_kmod-capi is not set
>>      # CONFIG_PACKAGE_kmod-dnsresolver is not set
>>      # CONFIG_PACKAGE_kmod-fou is not set
>>      # CONFIG_PACKAGE_kmod-geneve is not set
>>      # CONFIG_PACKAGE_kmod-gre is not set
>>      # CONFIG_PACKAGE_kmod-gre6 is not set
>>      # CONFIG_PACKAGE_kmod-ip6-tunnel is not set
>>      # CONFIG_PACKAGE_kmod-ipip is not set
>>      # CONFIG_PACKAGE_kmod-ipsec is not set
>>      # CONFIG_PACKAGE_kmod-iptunnel6 is not set
>>      # CONFIG_PACKAGE_kmod-isdn4linux is not set
>>      # CONFIG_PACKAGE_kmod-l2tp is not set
>>      # CONFIG_PACKAGE_kmod-l2tp-eth is not set
>>      # CONFIG_PACKAGE_kmod-l2tp-ip is not set
>>      # CONFIG_PACKAGE_kmod-macsec is not set
>>      # CONFIG_PACKAGE_kmod-misdn is not set
>>      # CONFIG_PACKAGE_kmod-mpls is not set
>>      CONFIG_PACKAGE_kmod-ppp=3Dm
>>      # CONFIG_PACKAGE_kmod-mppe is not set
>>      # CONFIG_PACKAGE_kmod-netem is not set
>>      # CONFIG_PACKAGE_kmod-nlmon is not set
>>      # CONFIG_PACKAGE_kmod-pktgen is not set
>>      # CONFIG_PACKAGE_kmod-ppp-synctty is not set
>>      # CONFIG_PACKAGE_kmod-pppoa is not set
>>      CONFIG_PACKAGE_kmod-pppoe=3Dm
>>      # CONFIG_PACKAGE_kmod-pppol2tp is not set
>>      CONFIG_PACKAGE_kmod-pppox=3Dm
>>      # CONFIG_PACKAGE_kmod-pptp is not set
>>      # CONFIG_PACKAGE_kmod-sched is not set
>>      # CONFIG_PACKAGE_kmod-sched-cake is not set
>>      # CONFIG_PACKAGE_kmod-sched-connmark is not set
>>      # CONFIG_PACKAGE_kmod-sched-core is not set
>>      # CONFIG_PACKAGE_kmod-sctp is not set
>>      # CONFIG_PACKAGE_kmod-sit is not set
>>      CONFIG_PACKAGE_kmod-slhc=3Dm
>>      # CONFIG_PACKAGE_kmod-slip is not set
>>      # CONFIG_PACKAGE_kmod-trelay is not set
>>      # CONFIG_PACKAGE_kmod-tun is not set
>>      # CONFIG_PACKAGE_kmod-veth is not set
>>      # CONFIG_PACKAGE_kmod-vxlan is not set
>>      # CONFIG_PACKAGE_kmod-wireguard is not set
>>=20
>>      #
>>      # Other modules
>>      #
>>      # CONFIG_PACKAGE_kmod-6lowpan is not set
>>      # CONFIG_PACKAGE_kmod-ath3k is not set
>>      # CONFIG_PACKAGE_kmod-bluetooth is not set
>>      # CONFIG_PACKAGE_kmod-bluetooth_6lowpan is not set
>>      # CONFIG_PACKAGE_kmod-bmp085 is not set
>>      # CONFIG_PACKAGE_kmod-bmp085-i2c is not set
>>      # CONFIG_PACKAGE_kmod-bmp085-spi is not set
>>      # CONFIG_PACKAGE_kmod-btmrvl is not set
>>      # CONFIG_PACKAGE_kmod-button-hotplug is not set
>>      # CONFIG_PACKAGE_kmod-dma-ralink is not set
>>      # CONFIG_PACKAGE_kmod-echo is not set
>>      CONFIG_PACKAGE_kmod-eeprom-93cx6=3Dy
>>      # CONFIG_PACKAGE_kmod-eeprom-at24 is not set
>>      # CONFIG_PACKAGE_kmod-eeprom-at25 is not set
>>      # CONFIG_PACKAGE_kmod-gpio-beeper is not set
>>      CONFIG_PACKAGE_kmod-gpio-button-hotplug=3Dy
>>      # CONFIG_PACKAGE_kmod-gpio-dev is not set
>>      # CONFIG_PACKAGE_kmod-gpio-mcp23s08 is not set
>>      # CONFIG_PACKAGE_kmod-gpio-nxp-74hc164 is not set
>>      # CONFIG_PACKAGE_kmod-gpio-pca953x is not set
>>      # CONFIG_PACKAGE_kmod-gpio-pcf857x is not set
>>      # CONFIG_PACKAGE_kmod-ikconfig is not set
>>      # CONFIG_PACKAGE_kmod-it87-wdt is not set
>>      # CONFIG_PACKAGE_kmod-itco-wdt is not set
>>      # CONFIG_PACKAGE_kmod-lp is not set
>>      # CONFIG_PACKAGE_kmod-mmc is not set
>>      # CONFIG_PACKAGE_kmod-mtdoops is not set
>>      # CONFIG_PACKAGE_kmod-mtdram is not set
>>      # CONFIG_PACKAGE_kmod-mtdtests is not set
>>      # CONFIG_PACKAGE_kmod-parport-pc is not set
>>      # CONFIG_PACKAGE_kmod-ppdev is not set
>>      # CONFIG_PACKAGE_kmod-pps is not set
>>      # CONFIG_PACKAGE_kmod-pps-gpio is not set
>>      # CONFIG_PACKAGE_kmod-pps-ldisc is not set
>>      # CONFIG_PACKAGE_kmod-ptp is not set
>>      # CONFIG_PACKAGE_kmod-random-core is not set
>>      # CONFIG_PACKAGE_kmod-regmap is not set
>>      # CONFIG_PACKAGE_kmod-rtc-ds1307 is not set
>>      # CONFIG_PACKAGE_kmod-rtc-ds1374 is not set
>>      # CONFIG_PACKAGE_kmod-rtc-ds1672 is not set
>>      # CONFIG_PACKAGE_kmod-rtc-isl1208 is not set
>>      # CONFIG_PACKAGE_kmod-rtc-pcf2123 is not set
>>      # CONFIG_PACKAGE_kmod-rtc-pcf8563 is not set
>>      # CONFIG_PACKAGE_kmod-rtc-pt7c4338 is not set
>>      # CONFIG_PACKAGE_kmod-rtc-rs5c372a is not set
>>      # CONFIG_PACKAGE_kmod-sdhci is not set
>>      # CONFIG_PACKAGE_kmod-serial-8250 is not set
>>      # CONFIG_PACKAGE_kmod-softdog is not set
>>      # CONFIG_PACKAGE_kmod-tpm is not set
>>      # CONFIG_PACKAGE_kmod-tpm-i2c-atmel is not set
>>      # CONFIG_PACKAGE_kmod-tpm-i2c-infineon is not set
>>      # CONFIG_PACKAGE_kmod-w83627hf-wdt is not set
>>      # CONFIG_PACKAGE_kmod-zram is not set
>>=20
>>      #
>>      # PCMCIA support
>>      #
>>=20
>>      #
>>      # SPI Support
>>      #
>>      # CONFIG_PACKAGE_kmod-mmc-spi is not set
>>      # CONFIG_PACKAGE_kmod-spi-bitbang is not set
>>      # CONFIG_PACKAGE_kmod-spi-dev is not set
>>      # CONFIG_PACKAGE_kmod-spi-gpio is not set
>>      # CONFIG_PACKAGE_kmod-spi-gpio-custom is not set
>>=20
>>      #
>>      # Sound Support
>>      #
>>      # CONFIG_PACKAGE_kmod-sound-core is not set
>>=20
>>      #
>>      # USB Support
>>      #
>>      # CONFIG_PACKAGE_kmod-usb-acm is not set
>>      # CONFIG_PACKAGE_kmod-usb-atm is not set
>>      # CONFIG_PACKAGE_kmod-usb-cm109 is not set
>>      CONFIG_PACKAGE_kmod-usb-core=3Dy
>>      CONFIG_PACKAGE_kmod-usb-dwc2=3Dy
>>      # CONFIG_PACKAGE_kmod-usb-dwc3 is not set
>>      # CONFIG_PACKAGE_kmod-usb-hid is not set
>>      CONFIG_PACKAGE_kmod-usb-ledtrig-usbport=3Dy
>>      # CONFIG_PACKAGE_kmod-usb-net is not set
>>      # CONFIG_PACKAGE_kmod-usb-ohci is not set
>>      # CONFIG_PACKAGE_kmod-usb-printer is not set
>>      # CONFIG_PACKAGE_kmod-usb-serial is not set
>>      # CONFIG_PACKAGE_kmod-usb-storage is not set
>>      # CONFIG_PACKAGE_kmod-usb-storage-extras is not set
>>      # CONFIG_PACKAGE_kmod-usb-storage-uas is not set
>>      # CONFIG_PACKAGE_kmod-usb-uhci is not set
>>      # CONFIG_PACKAGE_kmod-usb-wdm is not set
>>      # CONFIG_PACKAGE_kmod-usb-yealink is not set
>>      # CONFIG_PACKAGE_kmod-usb2 is not set
>>      # CONFIG_PACKAGE_kmod-usb3 is not set
>>      # CONFIG_PACKAGE_kmod-usbip is not set
>>      # CONFIG_PACKAGE_kmod-usbip-client is not set
>>      # CONFIG_PACKAGE_kmod-usbip-server is not set
>>      # CONFIG_PACKAGE_kmod-usbmon is not set
>>=20
>>      #
>>      # Video Support
>>      #
>>      # CONFIG_PACKAGE_kmod-video-core is not set
>>=20
>>      #
>>      # Virtualization
>>      #
>>=20
>>      #
>>      # Voice over IP
>>      #
>>=20
>>      #
>>      # W1 support
>>      #
>>      # CONFIG_PACKAGE_kmod-w1 is not set
>>=20
>>      #
>>      # WPAN 802.15.4 Support
>>      #
>>      # CONFIG_PACKAGE_kmod-at86rf230 is not set
>>      # CONFIG_PACKAGE_kmod-cc2520 is not set
>>      # CONFIG_PACKAGE_kmod-fakelb is not set
>>      # CONFIG_PACKAGE_kmod-ieee802154 is not set
>>      # CONFIG_PACKAGE_kmod-ieee802154_6lowpan is not set
>>      # CONFIG_PACKAGE_kmod-mac802154 is not set
>>      # CONFIG_PACKAGE_kmod-mrf24j40 is not set
>>=20
>>      #
>>      # Wireless Drivers
>>      #
>>      # CONFIG_PACKAGE_kmod-ath is not set
>>      # CONFIG_PACKAGE_kmod-ath10k-ct is not set
>>      # CONFIG_PACKAGE_kmod-ath6kl-sdio is not set
>>      # CONFIG_PACKAGE_kmod-ath6kl-usb is not set
>> --
>> Regards...
>> Kofi Agor
