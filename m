Received: from mail-lf1-f44.google.com (mail-lf1-f44.google.com [209.85.167.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A72A3002D8
	for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 12:17:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785154631; cv=pass; b=hfXIWQ3Y5oCo2atNDgWTN1jPwcGFmzB0AAszuJovNH6B0MSuXZNMDbb8Zrpo6Q5VZ5liDqQuvZq1mnqqQMznwf23YZFuK/5RPObT8zRquY7+mefwWutrDV2K9UQ8jhFFIoFNYXVCT5QHPOpVtz8uaL+KjscOCV9jICVyf1nexoc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785154631; c=relaxed/simple;
	bh=Xo8qzj8PXDSzFbhKXXt6QBejb044836ca/XS1e8QOQo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M4h1VqEkd0guD7iGsvq47QLsxbIVM4hgwIu2QLM1HJeaMNyUkJV713GZ1x3s2pTDR9QKbvyjxiM5w/s9a6YEJipUk5BHEJOGzqdyN7kC9EX1cyi+cunjd4K1fRsPe2McPQGXeE07sJ+A8iKYnArH68kRwgt5Dac5anrVf6mS3nI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fsSu1NWe; arc=pass smtp.client-ip=209.85.167.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fsSu1NWe"
Received: by mail-lf1-f44.google.com with SMTP id 2adb3069b0e04-5aeb8c19017so3208254e87.0
        for <linux-wireless@vger.kernel.org>; Mon, 27 Jul 2026 05:17:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785154628; cv=none;
        d=google.com; s=arc-20260327;
        b=NPH9Ia3fe3+VwvkMqjIpm2slZLxH/WYcX2zJgtLiBFItFSNXbZAouq//yAG2snJ4VM
         38iuJRbqDXEf4ZwYuRJlrW/cs5p6q22BZK8FhKZQqI3soYF3fOHz3PLsIZcRnDN/PmnE
         GEialld1kx808ntWfW1nY/y+Tpdu6+kxrRXa0JD3QPK2ACJ2AJgSEMbAfiF0G1sntWrs
         G49I7vayzC8vnAvFKZIyoYmZG8XSFnLfXuzq2RUFYlm28UmTjh0AG2UJ9PxVeRJNBayY
         jMurh85FDeClvoXD6QaLN0opEmAJG8ZBaWwarqOAm7tHNtwrAkGshU1mG3u/7SYFVDFG
         rwQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=bIdl9GB0kR2Bk9InHPTMbRkB9CQQCpEwfOqQb5AYk8s=;
        fh=8vgTz83F28c3MLcManeCpDmjEeuPQugA471F8DyVSOQ=;
        b=lkWJsAIgh0WOM/CGb3iqg/08ZjP6PDjP2TrA8UN5M7iBz4NdyxaGMKJyrnB7Zfw09i
         vaXzo++/wb+Xt1z7TdKX7YfmUPHSty4AnmhyknIfWh05h2vEvmjoapui6LwLghRRMSqh
         L/q0oNO3pyRFSIntBgqi0kAZfKZYIOmNmYswROZhhdV4LNRTALhzqpyaF7BWM7uXwIZP
         39g/BT3MkzvTtoZMTMNtR4Kw4xi/ieT2UPJW0eeVMidnXC4F5ol/0Bo7BA+vL1MX0Ef6
         bRfYk5P1V+VlEgnWJ80f7X5t+sfhnL73a1n+H7IKMMc88YrmKGOEA/ipTG0CP+o1d/rD
         jUww==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785154628; x=1785759428; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bIdl9GB0kR2Bk9InHPTMbRkB9CQQCpEwfOqQb5AYk8s=;
        b=fsSu1NWeAEEoF2qX41XB8C5pRmkozi2e3qDv1sFOOy+AU7TYKPQo6HBWpuy0PzMTag
         72EGzH4wD3Ss0VQ1HZScrLGS86TERgcBVzTzIezh3GBgito4dKaWf2HagQSCms8VyDCt
         5vkjroaZVxMmfrE+kX96yfcBfIO/wwfeK0P9W1wbE2PDXAkBi2m1VDv0DD4tsfQLzZ0Q
         eG/XV8xXwgVsBl/FGU6TLIUpH3aCkm910GCzi36S8jY8lIe+J1wpOk3YB6ybBFDzQCrX
         zjCiLtlK1hO4eeaOs0j2v6VCn0Wub1owuFgX7VlPnjAYhgsHuCtT6Oig7Kn1KGM69js8
         fyqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785154628; x=1785759428;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=bIdl9GB0kR2Bk9InHPTMbRkB9CQQCpEwfOqQb5AYk8s=;
        b=eHeYvDDCyU3Ouui1MzJQaQXk2o9QjBQUYfZC9qgFM5+GsJMlM86EA3NG6BgleRKV8s
         r6RSNthleAi1p04YfgMe9eYyAO6vNegH3HMTk1Nq09g+pm/3fplmJanapJ9Irc/oYEWt
         7TFgAYnBscF0SW3D9dK07HAEG62wiokLw4PrecNl7FRF+8Xh5S8RqFjGVhRL5ANnfllo
         5EyeQK6lXbVFvtcLbF43HfcN/0qKFb8iOOK4S3pXOH7PSH3+QMmFcs3K8VBeBikDBuLn
         8T/D28+EW+2/P0nHHXsUadXL2BDjMxJDEUTCqdX6ZJinCibeaC8Sc2CDDZ4elTv+AsIz
         JFog==
X-Forwarded-Encrypted: i=1; AHgh+RpTu9k9LiVQ5XTnW0elMuUnbLONyJCrT8zIDPHcITgYwQRAetv9uIZQM0faU/JSLsu3EVnKBxt9VoAnLjB8DQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxwWZ1xcdF2G5wOy5/2/tdw/WDtjzpfD7MZZlLgZ6hSzdR+90hr
	5q2iK/JN75BCzsy6gk8gn5ZI4g9veg4W6JoQ9bwrGEzdZOAyQuCDWrUzGJGhi33bFcVyxdx1qZD
	tJUuphrcMecAQOYYsBNVur3OooH+Wcsc=
X-Gm-Gg: AR+sD10TQeyUZfs7j/5Z0RucBw5yqQZj3ZwvzWEjndBvtmqXUZ6RJa5myLkg5lwjU77
	RD/Df64KfUoRPn+gbaHQB0UU9Mk+ZzF/RP6tqWWMzVFzA3dITiaECQ2bkWvYOeRLGlw8JjbFNqK
	8+uQ0qzhIyVmS4GIJC4huxxgP2lYkLQYCgxBF9eBujeJwv0FYO/GxW+7ZN8G83wszye1aQb/gmh
	q1kfS/9XQ0xeLhE9/qhUu5gOS4XqaQ5AM589NPqFHjv0J1hvDtn5pdAWs4AhEZ0vdBacVrANrSx
	qEzDs1emXdg7+VJDL+AvX0E5OG976xxWCjkVzv5E2w==
X-Received: by 2002:a05:6512:3d10:b0:5b0:1e26:771a with SMTP id
 2adb3069b0e04-5b2cc37b71dmr119492e87.45.1785154627362; Mon, 27 Jul 2026
 05:17:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202607150932.F2A0836@keescook> <20260716001728.57799-1-gvalkov@gmail.com>
 <20260716061638.GB9973@francesco-nb> <alh5y74H5bJyDSSP@stanley.mountain>
 <20260716063246.GA17850@francesco-nb> <aliAaHF3NgwAZ60v@stanley.mountain> <CADOrJmYnAph_TgxGTx-36ugkjjsiH=1T6uzmh4FuQ=EOio2m0Q@mail.gmail.com>
In-Reply-To: <CADOrJmYnAph_TgxGTx-36ugkjjsiH=1T6uzmh4FuQ=EOio2m0Q@mail.gmail.com>
From: George Valkov <gvalkov@gmail.com>
Date: Mon, 27 Jul 2026 15:16:54 +0300
X-Gm-Features: AUfX_mxsCxMFKb5cNj5E54XtTWIlbxxoRp1iW8pj0rhIenBRYr6Cjnzn9DE1chc
Message-ID: <CADOrJmaRjN4XEZAyaWR_4g2vTbmmaSeFdzJ7r2ncsZkbvAxQsQ@mail.gmail.com>
Subject: Re: [PATCH v3] wifi: mwifiex: replace one-element arrays with
 flexible array members
To: briannorris@chromium.org
Cc: Francesco Dolcini <francesco@dolcini.it>, Dan Carpenter <error27@gmail.com>, johannes.berg@intel.com, 
	kees@kernel.org, bhelgaas@google.com, s.kerkmann@pengutronix.de, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Any update on the progress? Do I need to do or change anything?

On Thu, 16 Jul 2026 at 11:09, George Valkov <gvalkov@gmail.com> wrote:
>
> On Thu, 16 Jul 2026 at 09:55, Dan Carpenter <error27@gmail.com> wrote:
> >
> > On Thu, Jul 16, 2026 at 08:32:46AM +0200, Francesco Dolcini wrote:
> > > On Thu, Jul 16, 2026 at 09:27:23AM +0300, Dan Carpenter wrote:
> > > > On Thu, Jul 16, 2026 at 08:16:38AM +0200, Francesco Dolcini wrote:
> > > > > On Thu, Jul 16, 2026 at 03:17:28AM +0300, Georgi Valkov wrote:
> > > > > > Replace deprecated one-element arrays with flexible array members.
> > > > > > CONFIG_FORTIFY_SOURCE reports the following warning when
> > > > > > one-element arrays are used as variable-length buffers:
> > > > > >
> > > > > > sta_cmd.c:1033 mwifiex_sta_prepare_cmd
> > > > > > memcpy: detected field-spanning write (size 84) of single field
> > > > > > "domain->triplet" at .../marvell/mwifiex/sta_cmd.c:1033 (size 3)
> > > > > >
> > > > > > Convert affected structs to use flexible array members.
> > > > > > - Preserve existing wire layouts.
> > > > > > - Use DECLARE_FLEX_ARRAY() for structs inside affected unions.
> > > > > >
> > > > > > Tested-on: WRT3200ACM, OpenWrt
> > > > > > Signed-off-by: Georgi Valkov <gvalkov@gmail.com>
> > > > >
> > > > > Cc: stable@vger.kernel.org # 6.12+
> > > > > Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> > > >
> > > > Are we CCing stable for this sort of thing?  How many FORTIFY_SOURCE
> > > > warnings are still remaining?
> > >
> > > Yes, you are right, my mistake.
> > >
> > > Johannes, please be sure to not have the stable tag in once you apply the
> > > patch.
> >
> > Wait...  No no.  It was a serious question.  I guess these warnings
> > are pretty annoying for a real user on WRT so it's fine to CC stable.
> > I just assumed these warnings were more common still.
>
> When I first saw it, I thought it was a kernel panic.
> There was an unrelated bug before the warning. My other PR fixes it:
> wifi: mwifiex: fix freeze for 60 seconds caused by request_firmware
>
> But after fixing the freeze, the warning remained.
> Next I thought it was a driver crash. To confirm, I added:
> mwifiex_dbg(ERROR) right before and after memcpy(),
> and printed all values in both source and destination:
> - memcpy has copied all data to the destination
> - execution is allowed to continue
> - so it is just a scary warning
>
> I wanted to ask both patches to be backported to stable, but
> at the time I sent them, I did not know that I could insert
> free text between the commit message and the patch.
> I will reply to the other PR and ask them.
>
> Full text of the warning fixed here:
>
> [   90.484902] ------------[ cut here ]------------
> [   90.489549] WARNING: CPU: 1 PID: 3059 at
> backports-6.18.26/drivers/net/wireless/marvell/mwifiex/sta_cmd.c:1033
> mwifiex_sta_prepare_cmd+0x1904/0x19b0 [mwifiex]
> [   90.503877] memcpy: detected field-spanning write (size 84) of
> single field "domain->triplet" at
> backports-6.18.26/drivers/net/wireless/marvell/mwifiex/sta_cmd.c:1033
> (size 3)
> [   90.519602] Modules linked in: option cdc_mbim uvcvideo usb_wwan
> rndis_host qmi_wwan nft_fib_inet nf_flow_table_inet ftdi_sio
> ebtable_nat ebtable_filter ebtable_broute cdc_ncm cdc_ether xt_time
> xt_tcpmss xt_statistic xt_state xt_nat xt_multiport xt_mark xt_mac
> xt_limit xt_length xt_iprange xt_hl xt_fuzzy(O) xt_ecn xt_dscp
> xt_conntrack xt_comment xt_TEE xt_TCPMSS xt_REDIRECT xt_MASQUERADE
> xt_LOG xt_IPMARK(O) xt_HL xt_FLOWOFFLOAD xt_DSCP xt_CT xt_CLASSIFY
> xt_DELUDE(O) xt_TARPIT(O) ipt_REJECT xt_tcpudp xt_CHAOS(O)
> videobuf2_v4l2 uvc usbserial usbnet ums_usbat ums_sddr55 ums_sddr09
> ums_karma ums_jumpshot ums_isd200 ums_freecom ums_datafab ums_cypress
> ums_alauda rfcomm nft_reject_ipv6 nft_reject_ipv4 nft_reject_inet
> nft_reject_bridge nft_reject nft_redir nft_quota nft_numgen nft_nat
> nft_meta_bridge nft_masq nft_log nft_limit nft_hash nft_flow_offload
> nft_fib_ipv6 nft_fib_ipv4 nft_fib nft_ct nft_compat nft_chain_nat
> nf_tables nf_reject_ipv4 nf_log_syslog nf_flow_table nf_dup_ipv6
> nf_dup_ipv4 nf_conntrack_bridge
> [   90.519758]  mwifiex_sdio(O) mwifiex(O) libcrc32c iptable_nat
> iptable_mangle iptable_filter ipt_ECN ipheth ip_tables hidp ebtables
> ebt_vlan ebt_stp ebt_snat ebt_redirect ebt_pkttype ebt_mark_m ebt_mark
> ebt_limit ebt_ip6 ebt_ip ebt_dnat ebt_arpreply ebt_arp ebt_among
> ebt_802_3 cdc_wdm cdc_acm btmrvl_sdio btmrvl bnep bluetooth
> arptable_filter arpt_mangle arp_tables fuse ntfs3 videobuf2_vmalloc
> videobuf2_memops videobuf2_common hid videodev mc evdev input_core
> mwlwifi(O) mac80211(O) cfg80211(O) compat(O) cryptodev(O) xt_set
> ip_set_list_set ip_set_hash_netportnet ip_set_hash_netport
> ip_set_hash_netnet ip_set_hash_netiface ip_set_hash_net
> ip_set_hash_mac ip_set_hash_ipportnet ip_set_hash_ipportip
> ip_set_hash_ipport ip_set_hash_ipmark ip_set_hash_ipmac ip_set_hash_ip
> ip_set_bitmap_port ip_set_bitmap_ipmac ip_set_bitmap_ip ip_set
> nfnetlink ip6table_nat nf_nat nf_conntrack nf_defrag_ipv6
> nf_defrag_ipv4 ip6t_NPT ip6t_rt ip6t_mh ip6t_ipv6header ip6t_hbh
> ip6t_frag ip6t_eui64 ip6t_ah ip6table_mangle ip6table_filter
> ip6_tables
> [   90.609354]  ip6t_REJECT x_tables nf_reject_ipv6 msdos tun nls_utf8
> nls_iso8859_2 nls_iso8859_15 nls_iso8859_13 nls_iso8859_1 nls_cp866
> nls_cp437 nls_cp1251 dma_shared_buffer ecdh_generic ecc crypto_user
> algif_skcipher algif_rng algif_hash algif_aead af_alg sha512_generic
> sha256_generic seqiv sha3_generic jitterentropy_rng drbg kpp hmac
> ghash_arm_ce geniv rng cmac uas gpio_button_hotplug(O) vfat fat exfat
> mii
> [   90.736063] CPU: 1 UID: 101 PID: 3059 Comm: hostapd Tainted: G
>      O       6.12.92 #0
> [   90.736073] Tainted: [O]=OOT_MODULE
> [   90.736074] Hardware name: Marvell Armada 380/385 (Device Tree)
> [   90.736077] Call trace:
> [   90.736082]  unwind_backtrace from show_stack+0x10/0x14
> [   90.736094]  show_stack from dump_stack_lvl+0x50/0x64
> [   90.736105]  dump_stack_lvl from __warn+0x7c/0xd4
> [   90.736116]  __warn from warn_slowpath_fmt+0xf8/0x15c
> [   90.736124]  warn_slowpath_fmt from
> mwifiex_sta_prepare_cmd+0x1904/0x19b0 [mwifiex]
> [   90.736217]  mwifiex_sta_prepare_cmd [mwifiex] from
> mwifiex_send_cmd+0x2f4/0x410 [mwifiex]
> [   90.736286]  mwifiex_send_cmd [mwifiex] from
> mwifiex_send_domain_info_cmd_fw+0x150/0x1b4 [mwifiex]
> [   90.736351]  mwifiex_send_domain_info_cmd_fw [mwifiex] from
> mwifiex_uap_set_channel+0x100/0x150 [mwifiex]
> [   90.736416]  mwifiex_uap_set_channel [mwifiex] from
> mwifiex_cfg80211_start_ap+0x12c/0x39c [mwifiex]
> [   90.736480]  mwifiex_cfg80211_start_ap [mwifiex] from
> nl80211_start_ap+0xa24/0x1048 [cfg80211]
> [   90.736607]  nl80211_start_ap [cfg80211] from genl_rcv_msg+0x260/0x3a8
> [   90.736670]  genl_rcv_msg from netlink_rcv_skb+0xb8/0x11c
> [   90.736681]  netlink_rcv_skb from genl_rcv+0x28/0x34
> [   90.736690]  genl_rcv from netlink_unicast+0x22c/0x330
> [   90.736698]  netlink_unicast from netlink_sendmsg+0x198/0x3d0
> [   90.736707]  netlink_sendmsg from ____sys_sendmsg+0x1cc/0x260
> [   90.736717]  ____sys_sendmsg from ___sys_sendmsg+0x6c/0xa4
> [   90.736723]  ___sys_sendmsg from __sys_sendmsg+0x5c/0x94
> [   90.736732]  __sys_sendmsg from ret_fast_syscall+0x0/0x4c
> [   90.736738] Exception stack(0xc4181fa8 to 0xc4181ff0)
> [   90.736743] 1fa0:                   00000000 00000000 0000001f
> bed78be0 00000000 00000000
> [   90.736748] 1fc0: 00000000 00000000 b69d6b90 00000128 00000004
> 00000001 bed78c34 b69c1cd0
> [   90.736751] 1fe0: bed78b90 bed78b80 b6f7a848 b6f79b6c
> [   90.736754] ---[ end trace 0000000000000000 ]---
