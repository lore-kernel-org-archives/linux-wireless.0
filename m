Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0078.hostedemail.com ([216.40.44.78]:40465 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934489AbaFCQpu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jun 2014 12:45:50 -0400
Message-ID: <1401813944.18833.6.camel@joe-AO725> (sfid-20140603_184556_839015_8860277C)
Subject: Re: [RFC 2/4] ath10k:  save firmware debug log messages.
From: Joe Perches <joe@perches.com>
To: greearb@candelatech.com
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org
Date: Tue, 03 Jun 2014 09:45:44 -0700
In-Reply-To: <1401812719-25061-2-git-send-email-greearb@candelatech.com>
References: <1401812719-25061-1-git-send-email-greearb@candelatech.com>
	 <1401812719-25061-2-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-06-03 at 09:25 -0700, greearb@candelatech.com wrote:
> They may be dumped through the firmware dump debugfs
> file.
[]
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
[]
> @@ -1084,11 +1084,14 @@ static void ath10k_wmi_event_echo(struct ath10k *ar, struct sk_buff *skb)
>  
>  static int ath10k_wmi_event_debug_mesg(struct ath10k *ar, struct sk_buff *skb)
>  {
> +	u32 *m = (u32 *)(skb->data);
>  	ath10k_dbg(ATH10K_DBG_WMI, "wmi event debug mesg len %d\n",
>  		   skb->len);
>  
>  	trace_ath10k_wmi_dbglog(skb->data, skb->len);
>  
> +	ath10k_dbg_save_fw_dbg_buffer(ar, (u8 *)(&(m[1])), skb->len - 4);
> +
>  	return 0;
>  }
>  

That last line looks an overly complicated way of writing

	ath10k_dbg_save_fw_dbg_buffer(ar, skb->data + 4, skb->len - 4);

btw: why skip the first 4 bytes?


