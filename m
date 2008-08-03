Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.189]:34874 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756881AbYHCV4X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 17:56:23 -0400
Received: by nf-out-0910.google.com with SMTP id d3so634254nfc.21
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2008 14:56:21 -0700 (PDT)
Message-ID: <48962982.1000000@gmail.com> (sfid-20080803_235627_489383_7AEE2CB7)
Date: Mon, 04 Aug 2008 00:56:18 +0300
From: Maxim Levitsky <maximlevitsky@gmail.com>
MIME-Version: 1.0
To: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
Subject: Re: [BUG] IWL3945: Led doesn't blink in monitor mode
References: <48942C35.6020400@gmail.com>
In-Reply-To: <48942C35.6020400@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Maxim Levitsky wrote:
> After fixing super annoying bug about garbage scan results,
> I noticed smaller bug:
> 
> My wireless leds stop blinking if I enable monitor mode
> (Note that this time this doesn't happen if I enable promisc mode)

Ok, now I understand how its leds work.

the STATISTICS_NOTIFICATION reply from microcode drives all the led 
blinking code. on each such notification the handler decides based on
traffic whenever to turn led solid or blink it.

the handler for 3945 actually counts recieved and transmitted packets!:

> static inline u8 get_blink_rate(struct iwl3945_priv *priv)
> {
> 	int index;
> 	u64 current_tpt = priv->rxtxpackets;
> 	s64 tpt = current_tpt - priv->led_tpt;
> 
> 	if (tpt < 0)
> 		tpt = -tpt;
> 	priv->led_tpt = current_tpt;


in iwl3945-led.c

priv->rxtxpackets is updated each time a packet is recieved/transmitted 
by iwl3945_pass_packet_to_mac80211:

> #ifdef CONFIG_IWL3945_LEDS
> 	if (ieee80211_is_data(hdr->frame_control))
> 		priv->rxtxpackets += len;
> #endif


and iwl3945_build_tx_cmd_basic:

> #ifdef CONFIG_IWL3945_LEDS
> 		priv->rxtxpackets += le16_to_cpu(cmd->cmd.tx.len);
> #endif




now the problem is that as soon as the firmware enters the monitor mode
it stops sending STATISTICS_NOTIFICATION.


So ether I need a way to tell firmware to continue sending this message,
or use a timer instead in monitor mode.

How I can tell the firmware to send STATISTICS_NOTIFICATION in monitor mode?
Intel developers, can you comment on this?

Btw, the led code really should be shared between 3945/4965.

Best regards,
	Maxim Levitsky
