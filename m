Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:40511 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1ABWKK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Jan 2011 17:10:10 -0500
Received: from localhost (localhost [127.0.0.1])
	by sypressi.dnainternet.net (Postfix) with ESMTP id 88471C6F3B
	for <linux-wireless@vger.kernel.org>; Mon,  3 Jan 2011 00:10:08 +0200 (EET)
Received: from sypressi.dnainternet.net ([83.102.40.135])
	by localhost (sypressi.dnainternet.net [127.0.0.1]) (amavisd-new, port 10041)
	with ESMTP id zwfl8KJKF4zX for <linux-wireless@vger.kernel.org>;
	Mon,  3 Jan 2011 00:10:08 +0200 (EET)
Received: from omenapuu.dnainternet.net (omenapuu.dnainternet.net [83.102.40.212])
	by sypressi.dnainternet.net (Postfix) with ESMTP id 3F151C6ECA
	for <linux-wireless@vger.kernel.org>; Mon,  3 Jan 2011 00:10:08 +0200 (EET)
Received: from localhost (dyn2-85-23-163-107.psoas.suomi.net [85.23.163.107])
	by omenapuu.dnainternet.net (Postfix) with ESMTP id 1CCBD2BAE4
	for <linux-wireless@vger.kernel.org>; Mon,  3 Jan 2011 00:10:07 +0200 (EET)
Message-ID: <20110103001006.13085vt89qfm6pcs@hayate.sektori.org>
Date: Mon, 03 Jan 2011 00:10:06 +0200
From: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
To: linux-wireless@vger.kernel.org
Subject: OOPS at ieee80211_aes_ccm_encrypt()?
MIME-Version: 1.0
Content-Type: text/plain;
 charset=ISO-8859-1;
 DelSp="Yes";
 format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello!

While doing stress testing on zd1211rw AP-mode I run into this problem  
that I don't think has that much to do with zd1211rw:

[ 3957.356752] BUG: unable to handle kernel NULL pointer dereference at (null)
[ 3957.357169] IP: [<(null)>] (null)
[ 3957.357370] *pdpt = 000000002a460001 *pde = 0000000000000000
[ 3957.357673] Oops: 0000 [#1] PREEMPT SMP
[ 3957.357870] last sysfs file:  
/sys/devices/LNXSYSTM:00/LNXSYBUS:00/PNP0C0A:00/power_supply/BAT1/charge_full
[ 3957.358215] Modules linked in: zd1211rw netconsole configfs  
xt_length xt_mark sch_sfq acerhdf acpi_cpufreq mperf microcode  
xt_multiport xt_limit xt_state xt_TCPMSS xt_tcpmss b43 rng_core  
mac80211 cfg80211 rfkill uvcvideo uinput shpchp psmouse pci_hotplug  
[last unloaded: zd1211rw]
[ 3957.359962]
[ 3957.359962] Pid: 0, comm: swapper Not tainted  
2.6.36.2-jk4-ureadahead-schedautogroup #1         /AOA150
[ 3957.359962] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 0
[ 3957.359962] EIP is at 0x0
[ 3957.359962] EAX: ea747c00 EBX: e5549694 ECX: e5549694 EDX: e5549694
[ 3957.359962] ESI: ee3670dc EDI: 00000010 EBP: ee3670dc ESP: c16ddc7c
[ 3957.359962]  DS: 007b ES: 007b FS: 00d8 GS: 0000 SS: 0068
[ 3957.359962] Process swapper (pid: 0, ti=c16dc000 task=c16edde0  
task.ti=c16dc000)
[ 3957.359962] Stack:
[ 3957.359962]  f8c2cd14 00000010 00000001 ea747c00 0000005f e55496d3  
e55496d2 e55496c4
[ 3957.359962] <0> e55496b4 01844e38 00000004 e5844e38 ee3670dc  
e5549600 c16ddd94 f8c1fb1e
[ 3957.359962] <0> 000005e4 ee3670dc ee3676c0 e5549694 00000018  
000005fc c16ddd94 e5844e50
[ 3957.359962] Call Trace:
[ 3957.359962]  [<f8c2cd14>] ? ieee80211_aes_ccm_encrypt+0xb4/0x140 [mac80211]
[ 3957.359962]  [<f8c1fb1e>] ?  
ieee80211_crypto_ccmp_encrypt+0x17e/0x1c0 [mac80211]
[ 3957.359962]  [<f8c33dcf>] ? invoke_tx_handlers+0xcef/0xef0 [mac80211]
[ 3957.359962]  [<c14058ed>] ? skb_queue_tail+0x1d/0x50
[ 3957.359962]  [<c1500c0a>] ? _raw_spin_lock_irqsave+0x1a/0x40
[ 3957.359962]  [<f8c34041>] ? ieee80211_tx+0x71/0x240 [mac80211]
[ 3957.359962]  [<f8d12a21>] ? rx_urb_complete+0x161/0x290 [zd1211rw]
[ 3957.359962]  [<c1400000>] ? sock_recvmsg_nosec+0x0/0x120
[ 3957.359962]  [<c1406441>] ? pskb_expand_head+0xd1/0x150
[ 3957.359962]  [<f8c3429f>] ? ieee80211_xmit+0x8f/0x1c0 [mac80211]
[ 3957.359962]  [<f8c31e8c>] ? ieee80211_skb_resize+0x6c/0xf0 [mac80211]
[ 3957.359962]  [<f8c34754>] ? ieee80211_subif_start_xmit+0x284/0x620  
[mac80211]
[ 3957.359962]  [<c1500000>] ? do_nanosleep+0x50/0xd0
[ 3957.359962]  [<f8c1d2c7>] ? ieee80211_tx_status+0x237/0x7f0 [mac80211]
[ 3957.359962]  [<c1411a3d>] ? dev_hard_start_xmit+0x2cd/0x510
[ 3957.359962]  [<c14261f3>] ? sch_direct_xmit+0xe3/0x1b0
[ 3957.359962]  [<c1426328>] ? __qdisc_run+0x68/0xf0
[ 3957.359962]  [<c1410827>] ? net_tx_action+0xb7/0x110
[ 3957.359962]  [<c1046357>] ? __do_softirq+0x97/0x1e0
[ 3957.359962]  [<c108a65d>] ? handle_IRQ_event+0x3d/0x170
[ 3957.359962]  [<c101eabb>] ? ack_apic_level+0x6b/0x200
[ 3957.359962]  [<c10464cd>] ? do_softirq+0x2d/0x40
[ 3957.359962]  [<c10468b5>] ? irq_exit+0x75/0x80
[ 3957.359962]  [<c1004aa6>] ? do_IRQ+0x56/0xc0
[ 3957.359962]  [<c1003429>] ? common_interrupt+0x29/0x30
[ 3957.359962]  [<c104007b>] ? __set_personality+0x20b/0x2a0
[ 3957.359962]  [<c1267a5e>] ? intel_idle+0xce/0x190
[ 3957.359962]  [<c13b1c89>] ? cpuidle_idle_call+0x69/0x110
[ 3957.359962]  [<c1001ea1>] ? cpu_idle+0x51/0xf0
[ 3957.359962]  [<c174f8ac>] ? start_kernel+0x2d6/0x2dc
[ 3957.359962]  [<c174f412>] ? unknown_bootoption+0x0/0x192
[ 3957.359962] Code:  Bad EIP value.
[ 3957.359962] EIP: [<00000000>] 0x0 SS:ESP 0068:c16ddc7c
[ 3957.359962] CR2: 0000000000000000

Hostapd shows last messages at:

1294001925.104125: IEEE 802.1X: 99 bytes from 00:16:01:09:c4:c4
1294001925.104742:    IEEE 802.1X: version=1 type=3 length=95
1294001925.104816: wlan4: STA 00:16:01:09:c4:c4 WPA: received  
EAPOL-Key 2/2 Group with unexpected replay counter
1294001925.104927: received replay counter - hexdump(len=8): 00 00 00  
00 00 00 00 07
1294001925.946033: wlan4: STA 00:16:01:09:c4:c4 WPA: rekeying PTK
1294001925.946086: WPA: 00:16:01:09:c4:c4 WPA_PTK entering state PTKSTART
1294001925.946135: wlan4: STA 00:16:01:09:c4:c4 WPA: sending 1/4 msg  
of 4-Way Handshake
1294001925.946161: WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1  
install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
1294001925.953682: IEEE 802.1X: 121 bytes from 00:16:01:09:c4:c4
1294001925.953742:    IEEE 802.1X: version=1 type=3 length=117
1294001925.953802: wlan4: STA 00:16:01:09:c4:c4 WPA: received  
EAPOL-Key frame (2/4 Pairwise)
1294001925.953834: WPA: 00:16:01:09:c4:c4 WPA_PTK entering state  
PTKCALCNEGOTIATING
1294001925.953919: WPA: PTK derivation - A1=00:19:cb:32:78:cf  
A2=00:16:01:09:c4:c4
1294001925.953953: WPA: PMK - hexdump(len=32): [REMOVED]
1294001925.953976: WPA: PTK - hexdump(len=48): [REMOVED]
1294001925.954022: WPA: 00:16:01:09:c4:c4 WPA_PTK entering state  
PTKCALCNEGOTIATING2
1294001925.954053: WPA: 00:16:01:09:c4:c4 WPA_PTK entering state  
PTKINITNEGOTIATING
1294001925.954342: wlan4: STA 00:16:01:09:c4:c4 WPA: sending 3/4 msg  
of 4-Way Handshake
1294001925.954379: WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1  
install=1 pairwise=8 kde_len=66 keyidx=2 encr=1)
1294001925.954433: Plaintext EAPOL-Key Key Data - hexdump(len=80): [REMOVED]
1294001926.054936: wlan4: STA 00:16:01:09:c4:c4 WPA: EAPOL-Key timeout
1294001926.055000: WPA: 00:16:01:09:c4:c4 WPA_PTK entering state  
PTKINITNEGOTIATING
1294001926.055298: wlan4: STA 00:16:01:09:c4:c4 WPA: sending 3/4 msg  
of 4-Way Handshake
1294001926.055345: WPA: Send EAPOL(version=2 secure=1 mic=1 ack=1  
install=1 pairwise=8 kde_len=66 keyidx=2 encr=1)
1294001926.055400: Plaintext EAPOL-Key Key Data - hexdump(len=80): [REMOVED]

Disassembly shows that crash happens at  
'crypto_cipher_encrypt_one(tfm, b, b);' in ieee80211_aes_ccm_encrypt():

00010c60 <ieee80211_aes_ccm_encrypt>:
    10c60:	55                   	push   %ebp
    10c61:	57                   	push   %edi
    10c62:	89 cf                	mov    %ecx,%edi
    10c64:	56                   	push   %esi
    10c65:	53                   	push   %ebx
    10c66:	89 d3                	mov    %edx,%ebx
    10c68:	8d 64 24 d8          	lea    -0x28(%esp),%esp
    10c6c:	89 d9                	mov    %ebx,%ecx
    10c6e:	8b 74 24 3c          	mov    0x3c(%esp),%esi
    10c72:	89 44 24 08          	mov    %eax,0x8(%esp)
    10c76:	8d 42 20             	lea    0x20(%edx),%eax
    10c79:	89 44 24 1c          	mov    %eax,0x1c(%esp)
    10c7d:	8b 44 24 08          	mov    0x8(%esp),%eax
    10c81:	8d 56 0f             	lea    0xf(%esi),%edx
    10c84:	c1 ea 04             	shr    $0x4,%edx
    10c87:	89 54 24 0c          	mov    %edx,0xc(%esp)
    10c8b:	89 da                	mov    %ebx,%edx
    10c8d:	e8 4e ff ff ff       	call   10be0 <aes_ccm_prepare>
    10c92:	8b 44 24 0c          	mov    0xc(%esp),%eax
    10c96:	85 c0                	test   %eax,%eax
    10c98:	0f 84 d4 00 00 00    	je     10d72 <ieee80211_aes_ccm_encrypt+0x112>
    10c9e:	83 e6 0f             	and    $0xf,%esi
    10ca1:	8d 43 30             	lea    0x30(%ebx),%eax
    10ca4:	0f 95 44 24 23       	setne  0x23(%esp)
    10ca9:	89 44 24 18          	mov    %eax,0x18(%esp)
    10cad:	89 74 24 24          	mov    %esi,0x24(%esp)
    10cb1:	8d 53 3e             	lea    0x3e(%ebx),%edx
    10cb4:	8d 43 3f             	lea    0x3f(%ebx),%eax
    10cb7:	89 54 24 14          	mov    %edx,0x14(%esp)
    10cbb:	89 44 24 10          	mov    %eax,0x10(%esp)
    10cbf:	8b 6c 24 40          	mov    0x40(%esp),%ebp
    10cc3:	89 fe                	mov    %edi,%esi
    10cc5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
    10ccc:	00
    10ccd:	8d 76 00             	lea    0x0(%esi),%esi
    10cd0:	8b 54 24 0c          	mov    0xc(%esp),%edx
    10cd4:	39 54 24 04          	cmp    %edx,0x4(%esp)
    10cd8:	75 0e                	jne    10ce8 <ieee80211_aes_ccm_encrypt+0x88>
    10cda:	8b 7c 24 24          	mov    0x24(%esp),%edi
    10cde:	80 7c 24 23 00       	cmpb   $0x0,0x23(%esp)
    10ce3:	89 3c 24             	mov    %edi,(%esp)
    10ce6:	75 07                	jne    10cef <ieee80211_aes_ccm_encrypt+0x8f>
    10ce8:	c7 04 24 10 00 00 00 	movl   $0x10,(%esp)
    10cef:	31 c0                	xor    %eax,%eax
    10cf1:	8b 3c 24             	mov    (%esp),%edi
    10cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    10cf8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
    10cfc:	30 14 03             	xor    %dl,(%ebx,%eax,1)
    10cff:	83 c0 01             	add    $0x1,%eax
    10d02:	39 c7                	cmp    %eax,%edi
    10d04:	7f f2                	jg     10cf8 <ieee80211_aes_ccm_encrypt+0x98>
    10d06:	8b 44 24 08          	mov    0x8(%esp),%eax
    10d0a:	89 d9                	mov    %ebx,%ecx
    10d0c:	89 da                	mov    %ebx,%edx
    10d0e:	89 3c 24             	mov    %edi,(%esp)
    10d11:	ff 50 08             	call   *0x8(%eax)
    10d14:	8b 54 24 14          	mov    0x14(%esp),%edx
    ...

Is key being used after freeing?

-Jussi

