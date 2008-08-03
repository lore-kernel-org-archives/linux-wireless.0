Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.231]:10345 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757269AbYHCWdD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 3 Aug 2008 18:33:03 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1858941rvb.1
        for <linux-wireless@vger.kernel.org>; Sun, 03 Aug 2008 15:33:03 -0700 (PDT)
Message-ID: <1ba2fa240808031533pb2cce5dnb63b76088cb37ba5@mail.gmail.com> (sfid-20080804_003319_459295_E8F9E517)
Date: Mon, 4 Aug 2008 01:33:02 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Maxim Levitsky" <maximlevitsky@gmail.com>
Subject: Re: [ipw3945-devel] [BUG] IWL3945: Led doesn't blink in monitor mode
Cc: ipw3945-devel@lists.sourceforge.net, linux-wireless@vger.kernel.org
In-Reply-To: <48962982.1000000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48942C35.6020400@gmail.com> <48962982.1000000@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 4, 2008 at 12:56 AM, Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> Maxim Levitsky wrote:
>> After fixing super annoying bug about garbage scan results,
>> I noticed smaller bug:
>>
>> My wireless leds stop blinking if I enable monitor mode
>> (Note that this time this doesn't happen if I enable promisc mode)
>
> Ok, now I understand how its leds work.
>
> the STATISTICS_NOTIFICATION reply from microcode drives all the led
> blinking code. on each such notification the handler decides based on
> traffic whenever to turn led solid or blink it.
>
> the handler for 3945 actually counts recieved and transmitted packets!:
>
>> static inline u8 get_blink_rate(struct iwl3945_priv *priv)
>> {
>>       int index;
>>       u64 current_tpt = priv->rxtxpackets;
>>       s64 tpt = current_tpt - priv->led_tpt;
>>
>>       if (tpt < 0)
>>               tpt = -tpt;
>>       priv->led_tpt = current_tpt;
>
>
> in iwl3945-led.c


Right I forgot I didn't change this in 3945.


> priv->rxtxpackets is updated each time a packet is recieved/transmitted
> by iwl3945_pass_packet_to_mac80211:
>
>> #ifdef CONFIG_IWL3945_LEDS
>>       if (ieee80211_is_data(hdr->frame_control))
>>               priv->rxtxpackets += len;
>> #endif
>
>
> and iwl3945_build_tx_cmd_basic:
>
>> #ifdef CONFIG_IWL3945_LEDS
>>               priv->rxtxpackets += le16_to_cpu(cmd->cmd.tx.len);
>> #endif
>
>
>
>
> now the problem is that as soon as the firmware enters the monitor mode
> it stops sending STATISTICS_NOTIFICATION.


> So ether I need a way to tell firmware to continue sending this message,
> or use a timer instead in monitor mode.
>
> How I can tell the firmware to send STATISTICS_NOTIFICATION in monitor mode?
> Intel developers, can you comment on this?
>

Statistic notification is just used as a point where NIC is woken up.
We don't wan to wake up NIC just for LED command.
But in monitor mode  nic have to be run in CAM mode anyway so you can
send the command out from the led timer directly.

>

> Btw, the led code really should be shared between 3945/4965.
Oh, more then LED code :) But that's a lot of infrastructure code that
need to be done. I still have hard heard on guys who split the code at
the first place but that's already a history..
Tomas
