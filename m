Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yw-out-2324.google.com ([74.125.46.31]:59334 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754849AbZBQTqE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Feb 2009 14:46:04 -0500
Received: by yw-out-2324.google.com with SMTP id 5so1165361ywh.1
        for <linux-wireless@vger.kernel.org>; Tue, 17 Feb 2009 11:46:03 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1234772707-17796-1-git-send-email-vasanth@atheros.com>
References: <1234772707-17796-1-git-send-email-vasanth@atheros.com>
Date: Tue, 17 Feb 2009 11:46:03 -0800
Message-ID: <43e72e890902171146u42ffc9e8rc274608cdc713812@mail.gmail.com> (sfid-20090217_204616_814271_4EA656DD)
Subject: Re: [ath9k-devel] [PATCH v2] ath9k: Fix panic upon attach failure
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: linville@tuxdriver.com, ath9k-devel@lists.ath9k.org,
	Jouni.Malinen@atheros.com, linux-wireless@vger.kernel.org,
	Luis.Rodriguez@atheros.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 16, 2009 at 12:25 AM, Vasanthakumar Thiagarajan
<vasanth@atheros.com> wrote:
> [246916.338046]
> [246916.338048] Pid: 29265, comm: insmod Not tainted (2.6.29-rc4-wl #64) 9461DUU
> [246916.338051] EIP: 0060:[<c02ca274>] EFLAGS: 00010202 CPU: 0
> [246916.338055] EIP is at rollback_registered+0x24/0x220
> [246916.338057] EAX: 00000001 EBX: 00000000 ECX: 00000000 EDX: f122e8fc
> [246916.338059] ESI: 00000000 EDI: 00000000 EBP: f6595d30 ESP: f6595d1c
> [246916.338062]  DS: 007b ES: 007b FS: 00d8 GS: 0033 SS: 0068
> [246916.338064] Process insmod (pid: 29265, ti=f6594000 task=f7343fe0 task.ti=f6594000)
> [246916.338067] Stack:
> [246916.338068]  c04a2920 22222222 f6595d48 00000000 f122f080 f6595d48 c02ca489 f122e8fc
> [246916.338076]  f122e220 f122f080 f122e220 f6595d5c f8a03156 f122e220 f122f080 f122e220
> [246916.338085]  f6595d80 f87359af f122f080 00002000 f874e129 f122f150 f122f080 f6290000
> [246916.338094] Call Trace:
> [246916.338096]  [<c02ca489>] ? unregister_netdevice+0x19/0x70
> [246916.338100]  [<f8a03156>] ? ieee80211_unregister_hw+0x36/0xd0 [mac80211]
> [246916.338112]  [<f87359af>] ? ath_detach+0xcf/0x250 [ath9k]
> [246916.338127]  [<f8735d9c>] ? ath_attach+0x26c/0x740 [ath9k]
> [246916.338139]  [<f873c33a>] ? ath_pci_probe+0x13a/0x310 [ath9k]
> [246916.338151]  [<c0233e28>] ? _raw_spin_unlock+0x68/0x80
> [246916.338158]  [<c023ab8e>] ? local_pci_probe+0xe/0x10
> [246916.338162]  [<c023b8e0>] ? pci_device_probe+0x60/0x80
> [246916.338169]  [<c029e042>] ? driver_probe_device+0x82/0x1b0
> [246916.338174]  [<c029e1f9>] ? __driver_attach+0x89/0x90
> [246916.338180]  [<c029d97b>] ? bus_for_each_dev+0x4b/0x70
> [246916.338184]  [<c023b820>] ? pci_device_remove+0x0/0x40
> [246916.338190]  [<c029ded9>] ? driver_attach+0x19/0x20
> [246916.338193]  [<c029e170>] ? __driver_attach+0x0/0x90
> [246916.338197]  [<c029d317>] ? bus_add_driver+0x1b7/0x230
> [246916.338203]  [<c023b820>] ? pci_device_remove+0x0/0x40
> [246916.338206]  [<c029e399>] ? driver_register+0x69/0x140
> [246916.338212]  [<f859d000>] ? ath9k_init+0x0/0x54 [ath9k]
> [246916.338221]  [<c023bb4e>] ? __pci_register_driver+0x4e/0x90
> [246916.338225]  [<f859d000>] ? ath9k_init+0x0/0x54 [ath9k]
> [246916.338232]  [<f859d06b>] ? ath_pci_init+0x17/0x19 [ath9k]
> [246916.338238]  [<f859d017>] ? ath9k_init+0x17/0x54 [ath9k]
> [246916.338245]  [<c017148e>] ? tracepoint_update_probe_range+0x7e/0xb0
> [246916.338249]  [<c010111a>] ? do_one_initcall+0x2a/0x170
> [246916.338252]  [<c0149f26>] ? up_read+0x16/0x30
> [246916.338256]  [<c014aa9d>] ? __blocking_notifier_call_chain+0x4d/0x60
> [246916.338265]  [<c0162b1a>] ? sys_init_module+0x8a/0x1c0
> [246916.338269]  [<c022f888>] ? trace_hardirqs_on_thunk+0xc/0x10
> [246916.338272]  [<c0103ebf>] ? sysenter_do_call+0x12/0x43
> [246916.338276] Code: 8d bc 27 00 00 00 00 55 89 e5 56 89 c6 53 83 ec 0c a1 74 27 4a c0 85 c0 0f 85 4b 01 00 00 e8 04 7d 00 00 85 c0 0f 84 c9 01 00 00 <8b> 86 18 03 00 00 85 c0 0f 84 86 01 00 00 83 e8 01 0f 85 71 01
> [246916.338328] EIP: [<c02ca274>] rollback_registered+0x24/0x220 SS:ESP 0068:f6595d1c
> [246916.338335] ---[ end trace 76357c56a75ea34e ]---
>
> Signed-off-by: Vasanthakumar Thiagarajan <vasanth@atheros.com>
> ---
>  drivers/net/wireless/ath9k/main.c |   25 +++++++++++++++++--------
>  1 files changed, 17 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/net/wireless/ath9k/main.c b/drivers/net/wireless/ath9k/main.c
> index 787c6f7..8b2a7b8 100644
> --- a/drivers/net/wireless/ath9k/main.c
> +++ b/drivers/net/wireless/ath9k/main.c
> @@ -1562,6 +1562,7 @@ bad2:
>  bad:
>        if (ah)
>                ath9k_hw_detach(ah);
> +       ath9k_exit_debug(sc);
>
>        return error;
>  }
> @@ -1570,7 +1571,7 @@ int ath_attach(u16 devid, struct ath_softc *sc)
>  {
>        struct ieee80211_hw *hw = sc->hw;
>        const struct ieee80211_regdomain *regd;
> -       int error = 0;
> +       int error = 0, i;

Better to use unsigned int for when in use in loops, I'm told it
performs better on some archs.

This patch breaks compilation though, it missed renaming an old label.
I'll resend a v3 with these fixes.

 Luis
