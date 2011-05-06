Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:45611 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab1EFWJ5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 May 2011 18:09:57 -0400
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p46M9vlc011788
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Fri, 6 May 2011 15:09:57 -0700
Message-ID: <4DC471B5.30609@candelatech.com> (sfid-20110507_001019_596886_83D01497)
Date: Fri, 06 May 2011 15:09:57 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath5k lockdep warning in 39-rc6+
References: <4DC47158.1000401@candelatech.com>
In-Reply-To: <4DC47158.1000401@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/06/2011 03:08 PM, Ben Greear wrote:
> The main problem with this is that it disables lockdep
> after this...
>
> lanforge-D0-20 login: INFO: trying to register non-static key.
> the code is fine but needs lockdep annotation.
> turning off the locking correctness validator.
> Pid: 1934, comm: net.hotplug Not tainted 2.6.39-rc6-wlc3+ #6
> Call Trace:
> [<c0448994>] register_lock_class+0x102/0x277
> [<c044a4d0>] __lock_acquire+0x8e/0xb78
> [<c0625bf3>] ? __ata_qc_complete+0xca/0xcf
> [<c062767a>] ? ata_qc_complete+0x15d/0x163
> [<c06353c8>] ? ata_hsm_qc_complete+0x9c/0xb5
> [<c0635954>] ? ata_sff_hsm_move+0x573/0x592
> [<c044b016>] lock_acquire+0x5c/0x70
> [<f9c2fe71>] ? ath5k_set_current_imask+0x21/0x62 [ath5k]
> [<c075d798>] _raw_spin_lock_irqsave+0x46/0x56
> [<f9c2fe71>] ? ath5k_set_current_imask+0x21/0x62 [ath5k]
> [<f9c2fe71>] ath5k_set_current_imask+0x21/0x62 [ath5k]
> [<f9c30158>] ath5k_intr+0x2a6/0x3e5 [ath5k]
> [<c0468b0f>] handle_irq_event_percpu+0x24/0x123
> [<c0468c3a>] handle_irq_event+0x2c/0x43
> [<c046a37f>] ? handle_edge_irq+0xaa/0xaa
> [<c046a3e9>] handle_fasteoi_irq+0x6a/0x88
> <IRQ> [<c040315f>] ? do_IRQ+0x34/0x95
> [<c0449990>] ? trace_hardirqs_on_caller+0xfe/0x11f
> [<c076202e>] ? common_interrupt+0x2e/0x40
>
>

Hrm, may be worse..maybe this is the cause of the deadlock
I'm seeing.  This printed out shortly after:


BUG: spinlock lockup on CPU#0, net.hotplug/1934, f5acc470
Pid: 1934, comm: net.hotplug Not tainted 2.6.39-rc6-wlc3+ #6
Call Trace:
  [<c057ecf7>] do_raw_spin_lock+0xea/0x108
  [<c075d79f>] _raw_spin_lock_irqsave+0x4d/0x56
  [<f9c2fe71>] ? ath5k_set_current_imask+0x21/0x62 [ath5k]
  [<f9c2fe71>] ath5k_set_current_imask+0x21/0x62 [ath5k]
  [<f9c30158>] ath5k_intr+0x2a6/0x3e5 [ath5k]
  [<c0468b0f>] handle_irq_event_percpu+0x24/0x123
  [<c0468c3a>] handle_irq_event+0x2c/0x43
  [<c046a37f>] ? handle_edge_irq+0xaa/0xaa
  [<c046a3e9>] handle_fasteoi_irq+0x6a/0x88
  <IRQ>  [<c040315f>] ? do_IRQ+0x34/0x95
  [<c0449990>] ? trace_hardirqs_on_caller+0xfe/0x11f
  [<c076202e>] ? common_interrupt+0x2e/0x40


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

