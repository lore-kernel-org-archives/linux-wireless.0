Received: from mail-lj1-f179.google.com (mail-lj1-f179.google.com [209.85.208.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C743E3CB577
	for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 08:09:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784189389; cv=pass; b=ntz90ARjvYvObeT8hxLN3ACigVz3kAJ7xD4/Jux6nECP7qkn1cHQM/Dx+bceUw7G26nxfYBUGxVhUKOXO41/krxgdYktSGhZNSaYi4v3fMEpzgc3l083W85KuLSoLgugNi+BoF+P//Dux/5Pn4gCIfe2+2kGRyPwGMbBCxZS4g4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784189389; c=relaxed/simple;
	bh=4AVzHNnPLZaPTexVs4h9nZ6v43r5M7q3ZTHYcMyPUW8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LM2GtomzC9VdOuBaZtesVRPOpifB5IXWjiYyeyPMATAOVVVVpEa7PfIid6NiNPBvdnvnfIvGlMgKbBnVsRHsqD9LhK2fSjc2vIoZNeqhScfG7Oel0D2gJDKWOVFcLdCcPSdyERYvCsFviSUo6WvyOPiWBUlLyoBxcz/2Jj8KZfE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nhTZZ7Na; arc=pass smtp.client-ip=209.85.208.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nhTZZ7Na"
Received: by mail-lj1-f179.google.com with SMTP id 38308e7fff4ca-39c62764c7cso98441fa.0
        for <linux-wireless@vger.kernel.org>; Thu, 16 Jul 2026 01:09:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784189386; cv=none;
        d=google.com; s=arc-20260327;
        b=rpzbpL7Pw69fUt4BvRsVKtTUb9ZdTdJhaOJcNXWF9fJQkmozlIwOBtC8OR7QpX17cj
         8qTTB1e5awLDb2cFhrr/GnbQMpn+UZmlajhU7w1J22DZn55wvmFLdr/N9Le8jZL5ZK1c
         EbplD6kv1seEAE47IPJGGQc06aOeKsPQCbzNr55GnIgwxP0mRjtW/fy5aCc40oJ2IYHU
         311+xP808dMQ0H5j1aleJAB2C7lGv3iVzWKLaPiCgBnqETf9xb8u3bpXohXUPFebMWiK
         pBZV0ys+yDBcZyIe0lhd93XskDiZs1KIytD4BjO2S/LaMI20S0sJN/6YG5Az5nug+/yK
         xzPQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Q9COK2RznKbtlvYsjGLgUDtgYINsbebe0kC00rzTdUs=;
        fh=CkE/gmmLUxPX79glIMShCBDCUYhYWL3x8h99bzr85Js=;
        b=RzgWwXTvH2A4yp1ffvGCALHcc+xs833IUocYjIE6HSs9NpEke9oAgvRAy+YeQ7/lHA
         eNoiHU1xQouGrhO4nzP9Hojb7xybfmLp7i131tvENmIXtNdr7QVAYwhzUx2cjJEHqbLm
         tseA0N7GALiOB9BUs1dHyNT0hgDWQmxPkyAQtsGlJAnI5Yho6sTB5CIPjLH0sWf+pB7H
         8x7bAY5chjwc+RKyo4CyXl+zyQqR2fLYg5YL+Fb1CVFW55F1Ul4hHoEKI5P05ZmgK7l0
         jr6pI1dlbyw4WOc2JFdVx83zfBss5OScTpMhfv7mkcIvO6V0MxHvL9p6paJLRM7RHZvw
         XrxA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784189386; x=1784794186; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Q9COK2RznKbtlvYsjGLgUDtgYINsbebe0kC00rzTdUs=;
        b=nhTZZ7Na8mZCn7a1kDNDJRXrYZM2p/t1q4UJdqTgm8v+qMyP6IPJKGrjHfrCeIGYjP
         AIF8u6BHvzI29BjVWRvW915k71ODuPkJhqqvzJwdvkX8uOgW1lnqpTAdP3jxUkNmGmdU
         EDIHTmz5Nn6Q5qVt8deaqUbH/RHyQGAc1k/EoXmQbfU7G7Wz2EOICK9nJiAcQzSKt8Tr
         8osONFqq9VXk8iLG7R7SHOW4XSEFnI5AzoXTdof6CZvV4DCL6RVQ+jdP8SV6DR6jCN7P
         Q15x5uZOoV8qvYTmPrLFVmk3nzt3fSVGTAdFRNIRsruD9r3TX4dLJ/2tB51yZxHSfPYA
         kqhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784189386; x=1784794186;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Q9COK2RznKbtlvYsjGLgUDtgYINsbebe0kC00rzTdUs=;
        b=bx2Ds8VIhfI5nZTkZLTo39ce+0etKPvZWUOXf0JQD9hLgwjZgcoPR8xuJT0VgrY89p
         aCkN4Q4yh+pp8wlR9Pq1aGiSWC7ymS0YVHgals7qm+iPuEuNQCv/sbnlyk+u2y5Uob1T
         udw7I0IL3VY0dxV9jJW9/DI0KilSfY6NCIHt6i+RET+p32KFwxMm4nTpoZfexLvVn3Ii
         +TueoDxZZb5EQkX85uthIoQZrEPAyIp77b8ztCoru8kPLE5n7g9ZVV4xiPeMNt+eCVa9
         HrJ6eJWi5jAwyymwk9f9b7KauUD7ssg/7+KhzE+6MxqVGHBuAPivxkN4DSUe9bK4Gday
         YZmA==
X-Forwarded-Encrypted: i=1; AHgh+Rqo+wnFcx2yOS1MTCLfE/8hSreBCBR84ASG5fnLnb1Ma6Pst/BALrG7eegzbsMij13J9AMMTK4ITP3dw87twg==@vger.kernel.org
X-Gm-Message-State: AOJu0YysR4BsauqoLpP0WIJJUeX9U1KRyFUeeISaT2Pqxx2FCHItQsAe
	9P9bNsPZjTsmFahzIsD6CnqHY9K+DiEMh9mZc8CrleIbDLNJXPzGyN/a/hWImL298FbnLhH45tN
	ZOXw9Z7CxK7iPhtgTFAYiyXqne5HVGtZIaTIcj7BvJE+x
X-Gm-Gg: AfdE7clUEQ4q05Bu+LG7EOyWf3xLT6nY5HXYfrkYJ5MaDTPQiiHlFnO7xaZQc49JORx
	c2meJGsPiD4R3mdCguoFadnwEa9J4ybDSQTqsnUb3ahqmJjW/5GfvU50PtciMyJpNWal3pYDbj5
	qHfa3PQcX8TFeskSuV2tSV+89BfpZq9NcVkt4wdBw4YYzkq0ylbKmbO0q7eTiiOpct+N0y+Idi+
	fg/EYjYN9gJSJKTiWyN0n61k+53ORLs8/sHB84mv/XaaRcxM/e2MnS94YKaTMQQmi/3h5Dz5bpP
	9OVUQbVGph0gJMi8I0/M9Rgi89Rwm/nM27RKgoOF21hCuN43N97Jtkc=
X-Received: by 2002:a05:6512:230e:b0:5ae:acbd:439c with SMTP id
 2adb3069b0e04-5b28a165337mr299042e87.23.1784189385574; Thu, 16 Jul 2026
 01:09:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <202607150932.F2A0836@keescook> <20260716001728.57799-1-gvalkov@gmail.com>
 <20260716061638.GB9973@francesco-nb> <alh5y74H5bJyDSSP@stanley.mountain>
 <20260716063246.GA17850@francesco-nb> <aliAaHF3NgwAZ60v@stanley.mountain>
In-Reply-To: <aliAaHF3NgwAZ60v@stanley.mountain>
From: George Valkov <gvalkov@gmail.com>
Date: Thu, 16 Jul 2026 11:09:33 +0300
X-Gm-Features: AUfX_mwEfXrshxTLm5QILLdpiRZHp2QY9k7GZYc8MW6w78f-2IKjgtTRD9L6EmQ
Message-ID: <CADOrJmYnAph_TgxGTx-36ugkjjsiH=1T6uzmh4FuQ=EOio2m0Q@mail.gmail.com>
Subject: Re: [PATCH v3] wifi: mwifiex: replace one-element arrays with
 flexible array members
To: Dan Carpenter <error27@gmail.com>
Cc: Francesco Dolcini <francesco@dolcini.it>, johannes.berg@intel.com, briannorris@chromium.org, 
	kees@kernel.org, bhelgaas@google.com, s.kerkmann@pengutronix.de, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 16 Jul 2026 at 09:55, Dan Carpenter <error27@gmail.com> wrote:
>
> On Thu, Jul 16, 2026 at 08:32:46AM +0200, Francesco Dolcini wrote:
> > On Thu, Jul 16, 2026 at 09:27:23AM +0300, Dan Carpenter wrote:
> > > On Thu, Jul 16, 2026 at 08:16:38AM +0200, Francesco Dolcini wrote:
> > > > On Thu, Jul 16, 2026 at 03:17:28AM +0300, Georgi Valkov wrote:
> > > > > Replace deprecated one-element arrays with flexible array members.
> > > > > CONFIG_FORTIFY_SOURCE reports the following warning when
> > > > > one-element arrays are used as variable-length buffers:
> > > > >
> > > > > sta_cmd.c:1033 mwifiex_sta_prepare_cmd
> > > > > memcpy: detected field-spanning write (size 84) of single field
> > > > > "domain->triplet" at .../marvell/mwifiex/sta_cmd.c:1033 (size 3)
> > > > >
> > > > > Convert affected structs to use flexible array members.
> > > > > - Preserve existing wire layouts.
> > > > > - Use DECLARE_FLEX_ARRAY() for structs inside affected unions.
> > > > >
> > > > > Tested-on: WRT3200ACM, OpenWrt
> > > > > Signed-off-by: Georgi Valkov <gvalkov@gmail.com>
> > > >
> > > > Cc: stable@vger.kernel.org # 6.12+
> > > > Reviewed-by: Francesco Dolcini <francesco.dolcini@toradex.com>
> > >
> > > Are we CCing stable for this sort of thing?  How many FORTIFY_SOURCE
> > > warnings are still remaining?
> >
> > Yes, you are right, my mistake.
> >
> > Johannes, please be sure to not have the stable tag in once you apply the
> > patch.
>
> Wait...  No no.  It was a serious question.  I guess these warnings
> are pretty annoying for a real user on WRT so it's fine to CC stable.
> I just assumed these warnings were more common still.

When I first saw it, I thought it was a kernel panic.
There was an unrelated bug before the warning. My other PR fixes it:
wifi: mwifiex: fix freeze for 60 seconds caused by request_firmware

But after fixing the freeze, the warning remained.
Next I thought it was a driver crash. To confirm, I added:
mwifiex_dbg(ERROR) right before and after memcpy(),
and printed all values in both source and destination:
- memcpy has copied all data to the destination
- execution is allowed to continue
- so it is just a scary warning

I wanted to ask both patches to be backported to stable, but
at the time I sent them, I did not know that I could insert
free text between the commit message and the patch.
I will reply to the other PR and ask them.

Full text of the warning fixed here:

[   90.484902] ------------[ cut here ]------------
[   90.489549] WARNING: CPU: 1 PID: 3059 at
backports-6.18.26/drivers/net/wireless/marvell/mwifiex/sta_cmd.c:1033
mwifiex_sta_prepare_cmd+0x1904/0x19b0 [mwifiex]
[   90.503877] memcpy: detected field-spanning write (size 84) of
single field "domain->triplet" at
backports-6.18.26/drivers/net/wireless/marvell/mwifiex/sta_cmd.c:1033
(size 3)
[   90.519602] Modules linked in: option cdc_mbim uvcvideo usb_wwan
rndis_host qmi_wwan nft_fib_inet nf_flow_table_inet ftdi_sio
ebtable_nat ebtable_filter ebtable_broute cdc_ncm cdc_ether xt_time
xt_tcpmss xt_statistic xt_state xt_nat xt_multiport xt_mark xt_mac
xt_limit xt_length xt_iprange xt_hl xt_fuzzy(O) xt_ecn xt_dscp
xt_conntrack xt_comment xt_TEE xt_TCPMSS xt_REDIRECT xt_MASQUERADE
xt_LOG xt_IPMARK(O) xt_HL xt_FLOWOFFLOAD xt_DSCP xt_CT xt_CLASSIFY
xt_DELUDE(O) xt_TARPIT(O) ipt_REJECT xt_tcpudp xt_CHAOS(O)
videobuf2_v4l2 uvc usbserial usbnet ums_usbat ums_sddr55 ums_sddr09
ums_karma ums_jumpshot ums_isd200 ums_freecom ums_datafab ums_cypress
ums_alauda rfcomm nft_reject_ipv6 nft_reject_ipv4 nft_reject_inet
nft_reject_bridge nft_reject nft_redir nft_quota nft_numgen nft_nat
nft_meta_bridge nft_masq nft_log nft_limit nft_hash nft_flow_offload
nft_fib_ipv6 nft_fib_ipv4 nft_fib nft_ct nft_compat nft_chain_nat
nf_tables nf_reject_ipv4 nf_log_syslog nf_flow_table nf_dup_ipv6
nf_dup_ipv4 nf_conntrack_bridge
[   90.519758]  mwifiex_sdio(O) mwifiex(O) libcrc32c iptable_nat
iptable_mangle iptable_filter ipt_ECN ipheth ip_tables hidp ebtables
ebt_vlan ebt_stp ebt_snat ebt_redirect ebt_pkttype ebt_mark_m ebt_mark
ebt_limit ebt_ip6 ebt_ip ebt_dnat ebt_arpreply ebt_arp ebt_among
ebt_802_3 cdc_wdm cdc_acm btmrvl_sdio btmrvl bnep bluetooth
arptable_filter arpt_mangle arp_tables fuse ntfs3 videobuf2_vmalloc
videobuf2_memops videobuf2_common hid videodev mc evdev input_core
mwlwifi(O) mac80211(O) cfg80211(O) compat(O) cryptodev(O) xt_set
ip_set_list_set ip_set_hash_netportnet ip_set_hash_netport
ip_set_hash_netnet ip_set_hash_netiface ip_set_hash_net
ip_set_hash_mac ip_set_hash_ipportnet ip_set_hash_ipportip
ip_set_hash_ipport ip_set_hash_ipmark ip_set_hash_ipmac ip_set_hash_ip
ip_set_bitmap_port ip_set_bitmap_ipmac ip_set_bitmap_ip ip_set
nfnetlink ip6table_nat nf_nat nf_conntrack nf_defrag_ipv6
nf_defrag_ipv4 ip6t_NPT ip6t_rt ip6t_mh ip6t_ipv6header ip6t_hbh
ip6t_frag ip6t_eui64 ip6t_ah ip6table_mangle ip6table_filter
ip6_tables
[   90.609354]  ip6t_REJECT x_tables nf_reject_ipv6 msdos tun nls_utf8
nls_iso8859_2 nls_iso8859_15 nls_iso8859_13 nls_iso8859_1 nls_cp866
nls_cp437 nls_cp1251 dma_shared_buffer ecdh_generic ecc crypto_user
algif_skcipher algif_rng algif_hash algif_aead af_alg sha512_generic
sha256_generic seqiv sha3_generic jitterentropy_rng drbg kpp hmac
ghash_arm_ce geniv rng cmac uas gpio_button_hotplug(O) vfat fat exfat
mii
[   90.736063] CPU: 1 UID: 101 PID: 3059 Comm: hostapd Tainted: G
     O       6.12.92 #0
[   90.736073] Tainted: [O]=OOT_MODULE
[   90.736074] Hardware name: Marvell Armada 380/385 (Device Tree)
[   90.736077] Call trace:
[   90.736082]  unwind_backtrace from show_stack+0x10/0x14
[   90.736094]  show_stack from dump_stack_lvl+0x50/0x64
[   90.736105]  dump_stack_lvl from __warn+0x7c/0xd4
[   90.736116]  __warn from warn_slowpath_fmt+0xf8/0x15c
[   90.736124]  warn_slowpath_fmt from
mwifiex_sta_prepare_cmd+0x1904/0x19b0 [mwifiex]
[   90.736217]  mwifiex_sta_prepare_cmd [mwifiex] from
mwifiex_send_cmd+0x2f4/0x410 [mwifiex]
[   90.736286]  mwifiex_send_cmd [mwifiex] from
mwifiex_send_domain_info_cmd_fw+0x150/0x1b4 [mwifiex]
[   90.736351]  mwifiex_send_domain_info_cmd_fw [mwifiex] from
mwifiex_uap_set_channel+0x100/0x150 [mwifiex]
[   90.736416]  mwifiex_uap_set_channel [mwifiex] from
mwifiex_cfg80211_start_ap+0x12c/0x39c [mwifiex]
[   90.736480]  mwifiex_cfg80211_start_ap [mwifiex] from
nl80211_start_ap+0xa24/0x1048 [cfg80211]
[   90.736607]  nl80211_start_ap [cfg80211] from genl_rcv_msg+0x260/0x3a8
[   90.736670]  genl_rcv_msg from netlink_rcv_skb+0xb8/0x11c
[   90.736681]  netlink_rcv_skb from genl_rcv+0x28/0x34
[   90.736690]  genl_rcv from netlink_unicast+0x22c/0x330
[   90.736698]  netlink_unicast from netlink_sendmsg+0x198/0x3d0
[   90.736707]  netlink_sendmsg from ____sys_sendmsg+0x1cc/0x260
[   90.736717]  ____sys_sendmsg from ___sys_sendmsg+0x6c/0xa4
[   90.736723]  ___sys_sendmsg from __sys_sendmsg+0x5c/0x94
[   90.736732]  __sys_sendmsg from ret_fast_syscall+0x0/0x4c
[   90.736738] Exception stack(0xc4181fa8 to 0xc4181ff0)
[   90.736743] 1fa0:                   00000000 00000000 0000001f
bed78be0 00000000 00000000
[   90.736748] 1fc0: 00000000 00000000 b69d6b90 00000128 00000004
00000001 bed78c34 b69c1cd0
[   90.736751] 1fe0: bed78b90 bed78b80 b6f7a848 b6f79b6c
[   90.736754] ---[ end trace 0000000000000000 ]---
