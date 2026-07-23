Received: from sipsolutions.net (s3.sipsolutions.net [168.119.38.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8623F4125
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 08:48:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=168.119.38.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784796490; cv=none; b=jwxtqyd6gth1cq1a8kuGukQV6TcDcxNbYAzCh/QTwXC23xm/UdZTmkbew4HSVNTgyT6AIoHHYo6tg6cejFhXgrrwx+iDVIJ90kBcuOl8MUloOAkzn/Lr2AFghq2R1Sd4xMA+juMlTqXtQt7eT2/lwQefgpLYGO62v6ae58QkNUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784796490; c=relaxed/simple;
	bh=Rcv6063/xXFXA9LR83/l6O1bQUrjLJkL4cmC5OJSVAY=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=bULEi/dOsIBsXKnf7/jI+8s+tF0nzsoXiLzzONU//psFOHDqUXFcamjTetChe4kU80H81bLvuXN/UK4Kjiw0lBzw7G/jCxT6jSCpn/NvcZDVuVbDLkR6sEhq1KAHz82sKtuJzxSWhxszf/ebsK1bgbcEP9dcKSJ8K+6ES2AJRyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net; spf=none smtp.mailfrom=sipsolutions.net; dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b=RRh2uKFc; arc=none smtp.client-ip=168.119.38.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=permerror header.from=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=sipsolutions.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sipsolutions.net header.i=@sipsolutions.net header.b="RRh2uKFc"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
	Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
	:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
	Resent-Cc:Resent-Message-ID; bh=dxsbYgUacGeqZG1FEeMyrUsy2AxuIhU5Kv7XMsP1ws8=;
	t=1784796488; x=1786006088; b=RRh2uKFc5AIO2Q9hq1IjWI2Oox+0olRQCWjOi3tASV1azME
	v9S4O52UMTQFERn3R51ajuNHjziPN2gOmLd+Q8dFVwyAmrnkMWyvH3A+h2GSdksJgRmLyooIUcW9c
	4sLZ/JZk3jwwwzRUbOcP5QqQxIDJ1siwL3hNiUP14YIraxqdWusAOErb1AIdf+DF0U7gHDDYo+RLB
	Qlpmcb4H1YoKR+p8/eOEQRHDh02v9l/ymVKEUhB8/fwr0MKmoEnhGUmfO0XRuP1UcUmG63U3xrxMY
	k3do6Fj9FQ2/d3xmqbL2alGcfNK7RFzU5pg3MBW+PdxMusz5Hg5UwfJFUyAkha1A==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__ECDSA_SECP256R1_SHA256__AES_256_GCM:256)
	(Exim 4.98.2)
	(envelope-from <johannes@sipsolutions.net>)
	id 1wmp64-0000000ARpw-2WuL;
	Thu, 23 Jul 2026 10:48:04 +0200
Message-ID: <007a0362a36d2318ea7a50c6feb8ad2ce1361c0d.camel@sipsolutions.net>
Subject: Re: [RFC PATCH wireless-next v2 0/4] wifi: aic: add AIC8800 SDIO
 FullMAC driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Yanli Yang <yanli.yang@bedmex.com>, linux-wireless@vger.kernel.org
Cc: Zhirun Liu <zhirunliu@aicsemi.com>, Dijia Xu <dijiaxu@aicsemi.com>, 
 Chunqiu Liu <chunqiuliu@aicsemi.com>, Liheng Wei <liheng.wei@bedmex.com>
Date: Thu, 23 Jul 2026 10:48:03 +0200
In-Reply-To: <ef855527f564086a498e95d31a35935762fa60e1.camel@sipsolutions.net>
References: <cover.1784724170.git.yanli.yang@bedmex.com>
	 <ef855527f564086a498e95d31a35935762fa60e1.camel@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-malware-bazaar: not-scanned

On Thu, 2026-07-23 at 10:42 +0200, Johannes Berg wrote:
>=20
> etc. Using "struct task_struct" in a driver, really?!

That caught my eye, but actually it's just excessively so perhaps - some
other wireless drivers _do_ use it. Feels a bit outdated though vs. work
structs (especially wiphy work.)

Since I had the LLM review anyway, I pasted it below. I'm not saying
this is correct or complete, but it may give you a hint as to why I'm
not really taking this submission seriously at all.

-------
Quick review done. Here's a prioritized list of the most obvious
upstream blockers in drivers/net/wireless/aic/ (~66k lines, forked from
the RivieraWaves/rwnx BSP).

Custom/duplicate userspace ABIs (hard blockers)
 * Private generic-netlink interface =E2=80=94 aic8800_fdrv/aicwf_genl.c +
   aicwf_genl.h (AIC8800_GENL). A whole string-parsed genl family for
   "manufacturing and driver debugging." This is the one you mentioned =E2=
=80=94
   must be deleted; use nl80211 + (sparingly) cfg80211 testmode/vendor
   cmds.
 * Android priv_cmd ioctl interpreter =E2=80=94 aic8800_fdrv/aic_priv_cmd.c=
,
   android_priv_cmd()/aic_priv_cmd.c:1731. ~2000 lines of
   android_wifi_priv_cmd string commands over ifr_data. Classic
   downstream vendor ABI, not upstreamable.
 * cfg80211 internals re-implementation / GKI shim =E2=80=94
   aic8800_fdrv/rwnx_gki.c does #include "net/wireless/core.h" (private
   in-tree header), defines its own rwnx_nl80211_fam and reimplements
   cfg80211_rx_spurious_frame() etc. Also has a bogus #include
   <include/linux/types.h>. Reaching into cfg80211 internals is a hard
   no.
 * Legacy Wireless Extensions layer =E2=80=94 aic8800_fdrv/aicwf_wext_linux=
.c
   (AIC8800_USE_WIRELESS_EXT). New drivers are nl80211-only.
 * procfs suspend control =E2=80=94 proc_create("suspend", =E2=80=A6) in
   aicwf_sdio.c:105 (AIC8800_WIFI_SUSPEND_FOR_LINUX). Use standard
   PM/cfg80211.
 * Vendor-HAL grab-bag with stubs =E2=80=94 aic8800_fdrv/aic_vendor.c
   (mkeep_alive, APF, ring buffers, wake-reason counters). Several are
   fake/no-op, e.g. aic_dev_start_mkeep_alive() builds a packet then
   just kfrees it.

Kconfig / Makefile
 * Config explosion =E2=80=94 ~50+ options across Kconfig, aic8800_bsp/Kcon=
fig,
   aic8800_fdrv/Kconfig. Many are porting/downstream knobs hidden behind
   depends on BROKEN (*_FOR_OLD_KERNEL, RWNX_TL4, RWNX_OLD_IPC,
   AIC8800_GKI, AIC8800_BR_SUPPORT, AIC8800_SDIO_BT, =E2=80=A6). Upstream w=
ants
   these deleted, not gated behind BROKEN.
 * ccflags-$(CONFIG_x) +=3D -DCONFIG_y anti-pattern =E2=80=94 Makefile laun=
ders
   Kconfig into re-defined CONFIG_* macros to drive #ifdef soup. Use the
   real CONFIG_ symbols / IS_ENABLED().

Structural
 * BSP + fdrv split glued by EXPORT_SYMBOL_GPL =E2=80=94 two modules with a
   private exported ABI (aicbsp_set_subsys, aicbsp_get_feature,
   aicbsp_resv_mem_*, get_sdio_func, set_irq_handler,
   btchr_external_write). Should be one cleanly-layered driver.
 * Bluetooth-over-SDIO reimplemented =E2=80=94 aic8800_fdrv/aic_btsdio.c wi=
th
   its own char device instead of the kernel BT HCI/btsdio framework.
 * Bridge "br_ext" repeater hack =E2=80=94 aic8800_fdrv/aic_br_ext.c
   (AIC8800_BR_SUPPORT).
 * Reinvented in-tree infra =E2=80=94 bundled md5.c in both subdirs (use
   crypto/lib); own 2772-line regdb.c instead of kernel regulatory; own
   rwnx_wakelock.c, aicwf_tcp_ack.c (TCP-ACK filtering is stack policy,
   not a driver's job), Android-style prealloc/reserved-mem pools.

Portability / style
 * Kernel-version + Android compat shims =E2=80=94 aic8800_fdrv/rwnx_compat=
.h
   (LINUX_VERSION_CODE, HIGH_KERNEL_VERSION*, ANDROID_PLATFORM). In-tree
   code targets current kernel only.
 * Private _l typedefs =E2=80=94 aic8800_fdrv/lmac_types.h redefines
   u8_l/u16_l/bool_l. Worse, under CONFIG_RWNX_TL4 it does typedef u16
   u8_l; (an 8-bit type aliased to 16-bit). Use kernel types.
 * Too many module_params =E2=80=94 debug levels, thread priorities, TX/RX
   tuning, plus country_code, ccode_channels, saved_sdk_ver, testmode as
   module params. Runtime config belongs in nl80211/DT, not module
   params.
 * Checked-in generated version headers =E2=80=94 rwnx_version_gen.h ("241c=
091M
   (master)", RELEASE_VERSION "2.0.14"), duplicated across subdirs.
 * Dead/commented code & busy-waits =E2=80=94 commented module_param/mdelay=
,
   mdelay(100) spins in the msg-tx path, msleep(2000) in priv-cmd.

-------

johannes
