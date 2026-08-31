Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CFDD1331EB2
	for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 07:08:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788160136; cv=pass; b=LUUydCwJgWxfIVLArXz6RnFlYraH0Xs9O1T4+f8EBjRY3zil2M1ceNp4SRKJ4T9tPrtyHzu3VxLDziHVlR15F2mE9OhxFkZIH3ykMFB4l2KwS4yqdcYmQ6/tg/YwKpbQeDr0rmuwK2HNUQIiWQf6iX0UTj0e9mlLK1koPLl6xrM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788160136; c=relaxed/simple;
	bh=gb3KqlSFbybppNERwIDUGbtRdT8/09q/+jNEPJrI6SY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=RKFiOCPPCs+7Ckmbs7TH/Jq7FzjK2UMa09/lgtnlhy7PNnNg75Els5MWenIU9AS3EjXC1UudcLcNVTxPGKvmMcbMj5VTKA5LsKH4J9io6s9avStKsEZH8lkZ2Go42rdZ4b/kQ4qSCfyEPv6ss7KW+6enkWLDoC9Pbqj8e5wJVCs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qjsPF6Pw; arc=pass smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qjsPF6Pw"
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-52e2d1bdbc0so21512121cf.0
        for <linux-wireless@vger.kernel.org>; Mon, 31 Aug 2026 00:08:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788160134; cv=none;
        d=google.com; s=arc-20260327;
        b=TRA7gDN3haO4+9hhIaB5a+GADEd561tPZDSp1tFwA/ACWl6rmxHexzYhAoKC+EZsAj
         j6EW8KYhR5ct8Z1by5ry2U8ocYkt+b9E3tYqQ11I12MpnZspGZvvZESx53LoS4jRUPAT
         fHGZjIdYLF+SYGP0TsRuKLjfef8ir2HFS5Z3AjPHAjhg3D/xo+lcA7QOFZYeeDPJbatu
         giiuxY7ofLakx3HJrQfmlUcTYLMQA+9YSmiFcAu+52C1Nk6bTuWRvu6whSJatBAumGZZ
         X01YURZcd2kpoefqqm7lJrlEfJtf/xoKdg4QY7IFoCzbk0P52wS8oxb6oLlMI17zqjUe
         DCmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=gb3KqlSFbybppNERwIDUGbtRdT8/09q/+jNEPJrI6SY=;
        fh=8IAy5qup0a2EY8QRGpBSpKR+Jn4fWjWAV5x6xozgXOQ=;
        b=CsWd9BYXhndghsVwwOCAhFpPjzwWAS3/DVlGIPJyFmfAJAyfYRbsCGf9gMk1On9s4q
         ub4+kLkkgvP8bk420flTMdJx7XQgFhJhA8il0KYHxWTENifmOXtTkvDjV7bJ/FKyGvYo
         Sp6eZTZfGPR9Bf60HgOnsyhTSI+hiKV0IP9lb994imVh4hWr9eKoAzmZBLfyAs+foPMw
         CT0aFzPTBcqpF70zw3PC5xXwqxmHYMYVQ29s7ZG9EOt+m487w8PctB+8zfV6J1jahuyC
         RctglbRZPzkfzDzgsQRzGy4kshUusPnmPuVyqo0XvwwFKHyhUutfOL23Umh80ZM760WK
         8plg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788160134; x=1788764934; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=gb3KqlSFbybppNERwIDUGbtRdT8/09q/+jNEPJrI6SY=;
        b=qjsPF6PwYhFnSCKHqAuXTDdWyN9xNgoaVsT3QYlEh9T6Exaj3muIsJihN6hySjFnJl
         mwn9ccuP8y5uqz2GW9rK4UzDx1V/iDeRSJ6uRjeIgFgTTln2xpsO3Iih31GSWv0wx2lq
         VPr6IEYJNfBP+2hUpSWC39JdnGViYkOpERe6DOXrsEoWR4CYbTJ3asJRIaEEwtIOGAul
         WlXt1JXDJVfnGMWfvcoZrSANREWHZ9XxeG4n/bZ52CllsoCf91UrK3CaWWJmkJXmWTBz
         TO/C+oghf0k7C/Sf/VuSld4Ht5dGykJB5f+FO9qfY7CzjLBz2M0AYGuYm/6Tx16xclWz
         kaKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788160134; x=1788764934;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=gb3KqlSFbybppNERwIDUGbtRdT8/09q/+jNEPJrI6SY=;
        b=GqshUVKcWtZN4l6428pF7+KydL9x0XLfR9i6iNEmuVxqlBTTQ7HvPhQcPHUGBj9ipS
         PZCNVMCYe9uGqtH2oCQeifRA621BKlX1dwx5U2fDSD4kGJKWFhAvNDoeLc+SmPup3iXm
         vK0CgSYl7p4nT2bfIyHFLF53xJgHoU6ZrXETDKGrfGXxd9SempZOlWA4ldegnRo8G3K5
         H27d50ZuvE0h4icPTyQr5eYmbkILKnUWtXVfFDEFEFBvvDunEJtm8yg60Url06TppWqt
         GHzcY2obV1NEUOHawSYcVBAjmjdi6RlY+/HAlYl95wf8boz7sbWItkOYsn2jj2KTQHd2
         idyQ==
X-Gm-Message-State: AFuF++m+UO/bOgOsTozrtgX6J6bZea57eQ/jr04VHRxZS5UuI4ZzLmo+
	wjiHm20jJIPoSNMzCPDH8QYj31HuRSZfptotf1n11wQNnvj7puEIZQ1ya7absx+oBpLGfI7GFE6
	jzkSRm2KNbD5xyaEwbcBf9KAmANwUTlnFten62UO4Eg==
X-Gm-Gg: AR+sD10jkn8Sot7RdBjuUIfmIhgcDcVNASEdRX9x3mN2ok/kUxvoWfRoVEIi+hJugms
	Dch47ym5nnF4Lpg7epVpPLqYZtreaNGJVJl3HKFpQvpKmdwmMBYrRAqxv1eDbNKHMcr+8lEviXI
	9nZMw7CECC83yDPFq00UL7V6HAznnqLQN8EHs5hcdxAWxFBh/QNi9JlS9/68IuvSMyGYFN3DmkY
	tlkBTJ70wXDwgUESwGJ3N9eqDlLLsY85bmEWO7ScNwbkugWWJsIbOpnkGS+gZ0+VpUYJGVbLiVx
	NbpFgiC+ONEjtCh96xzc+/7CfcuPEh0XZGEhDKldmGxMHgeit1XM+gQeReEyb3WS1Dtw+7f/NXK
	9l3qT5mfhtBqxRh5ltsxAzAWvY5o7zG2N8rl+oidA+JPLHpAA
X-Received: by 2002:a05:622a:22a4:b0:52f:b6cf:9143 with SMTP id
 d75a77b69052e-52fb972a984mr290081371cf.40.1788160133449; Mon, 31 Aug 2026
 00:08:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: ZW Tang <tangzw515@gmail.com>
Date: Mon, 31 Aug 2026 15:08:41 +0800
X-Gm-Features: AcwNN1XM7_rdJuW_svwUnK6b2aR6FDT8FcsJjIoke4mi9H1xv3U-85ZmZfcP8P0
Message-ID: <CAA2SOT57R46O--S5nCj73Tu1pJ1cVhrHD=h=ovqPusAAk7Lr6g@mail.gmail.com>
Subject: [BUG] wifi: mac80211: WARNING in __rate_control_send_low during scan
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I am reporting a warning triggered by a syzkaller reproducer on
Linux 7.2.0-rc3. A similar issue appears to have been reported before, but
I can still reproduce it on Linux 7.2.0-rc3 with HEAD commit
1137d8b5df06137fb49513cc923b3b24d94cb809.

The reproducer uses nl80211 to trigger a scan on wlan1 with crafted scan
attributes and flags, including TX_NO_CCK_RATE. During scan work,
mac80211 builds and transmits a probe request. The transmit path reaches
ieee80211_tx_h_rate_ctrl(), rate_control_get_rate(), and then
__rate_control_send_low().

At that point mac80211 reports that there are no supported rates for the
station under the current rate mask and flags, and then triggers a warning
in net/mac80211/rate.c.

This looks like a mac80211 scan/rate-control robustness issue. A crafted
scan request can produce a combination of band, rate mask, station rates
and scan flags for which no usable rate remains. The kernel should avoid
triggering a warning in this case, for example by not applying the normal
rate mask to scan probe requests or by rejecting the scan parameters
cleanly, because panic_on_warn turns this into a kernel panic.

Reproducer:

syz reproducer:

r0 = socket$nl_generic(0x10, 0x3, 0x10)
r1 = syz_genetlink_get_family_id$nl80211(&(0x7f0000000200), r0)
ioctl$sock_SIOCGIFINDEX_80211(r0, 0x8933,
&(0x7f0000000700)={'wlan1\x00', <r2=>0x0})
sendmsg$NL80211_CMD_TRIGGER_SCAN(r0, &(0x7f0000000340)={0x0, 0x0,
&(0x7f0000000300)={&(0x7f0000000740)={0x84, r1, 0x5, 0x48000, 0x0,
{{}, {@val={0x8, 0x3, r2}, @void}}, [@NL80211_ATTR_BSSID={0xa, 0xf5,
@from_mac}, @NL80211_ATTR_SCAN_SSIDS={0x10, 0x2d, 0x0, 0x1, [{0xa,
0x0, @default_ap_ssid}]}, @NL80211_ATTR_SCAN_FLAGS={0x8, 0x9e, 0x202},
@NL80211_ATTR_IE={0x4}, @NL80211_ATTR_SCAN_FLAGS={0x8, 0x9e, 0x1000},
@NL80211_ATTR_MEASUREMENT_DURATION={0x6, 0xeb, 0x2},
@NL80211_ATTR_SCHED_SCAN_RSSI_ADJUST={0x6, 0xf7, {0xf, 0xfe}},
@NL80211_ATTR_MEASUREMENT_DURATION={0x6, 0xeb, 0x2},
@NL80211_ATTR_SCAN_SSIDS={0x1c, 0x2d, 0x0, 0x1, [{0xa, 0x0,
@default_ibss_ssid}, {0xa, 0x0, @default_ap_ssid}]},
@NL80211_ATTR_TX_NO_CCK_RATE={0x4}]}, 0x84}}, 0x0)
r3 = socket$nl_generic(0x10, 0x3, 0x10)
r4 = syz_genetlink_get_family_id$nl80211(&(0x7f0000000080), 0xffffffffffffffff)
sendmsg$NL80211_CMD_REMAIN_ON_CHANNEL(r3, &(0x7f0000000480)={0x0,
0x60, &(0x7f0000000140)={&(0x7f00000002c0)={0x1c, r4,
0x9c3fa077fa966179, 0x0, 0x0, {{0x7e}, {@val={0x8}, @void}}}, 0x1c}},
0x0)

console output: https://pastebin.com/raw/Q3vbBYc1
kernel config: https://pastebin.com/raw/YWdYitkv

Kernel:

HEAD commit: 1137d8b5df06137fb49513cc923b3b24d94cb809
git tree: torvalds/linux
kernel version: 7.2.0-rc3 #1 PREEMPT(full) (QEMU Ubuntu 24.10)

Relevant log:

no supported rates for sta 08:02:11:00:00:00 (0xf, band 0) in
rate_mask 0xffffffff with flags 0x10

------------[ cut here ]------------
WARNING: net/mac80211/rate.c:399 at
__rate_control_send_low.isra.0+0x619/0x770, CPU#1: kworker/u8:3/53

CPU: 1 UID: 0 PID: 53 Comm: kworker/u8:3 Not tainted 7.2.0-rc3 #1 PREEMPT(full)
Hardware name: QEMU Ubuntu 24.10 PC (i440FX + PIIX, 1996)
Workqueue: events_unbound cfg80211_wiphy_work

RIP: 0010:__rate_control_send_low.isra.0+0x62b/0x770

Call Trace:
<TASK>
rate_control_send_low+0x12b/0x870
rate_control_get_rate+0x1bd/0x5b0
ieee80211_tx_h_rate_ctrl+0x7b6/0x19e0
invoke_tx_handlers_late+0x1000/0x2830
ieee80211_tx+0x2f3/0x460
ieee80211_xmit+0x308/0x3e0
__ieee80211_tx_skb_tid_band+0x2e2/0x7c0
ieee80211_scan_state_send_probe+0x36a/0xb10
ieee80211_scan_work+0x834/0x1d80
cfg80211_wiphy_work+0x31f/0x740
process_scheduled_works+0x5ed/0x1c90
worker_thread+0x5be/0xd20
kthread+0x404/0x530
ret_from_fork+0x7c5/0xde0
ret_from_fork_asm+0x1a/0x30
</TASK>

Kernel panic - not syncing: kernel: panic_on_warn set ...
