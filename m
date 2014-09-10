Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:58259 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751246AbaIJPyF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2014 11:54:05 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: <greearb@candelatech.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Subject: Re: [PATCH] ath10k: Support firmware crash-by-assert.
References: <1409238957-30625-1-git-send-email-greearb@candelatech.com>
Date: Wed, 10 Sep 2014 18:53:39 +0300
In-Reply-To: <1409238957-30625-1-git-send-email-greearb@candelatech.com>
	(greearb@candelatech.com's message of "Thu, 28 Aug 2014 08:15:57
	-0700")
Message-ID: <87wq9b5v5o.fsf@kamboji.qca.qualcomm.com> (sfid-20140910_175410_445881_55BEB1E9)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

greearb@candelatech.com writes:

> From: Ben Greear <greearb@candelatech.com>
>
> 10.1 firmware does not have an official way to
> cause assert on purpose, but it can be done with
> carefully crafted WMI command.  This is a different
> kind of crash from the 'hard' crash, which is
> a bad memory dereference.
>
> Different crashes decode in different manners, so
> this will help the crash-report testing as well as
> offer better ways to test firmware failure and
> recovery.
>
> Signed-off-by: Ben Greear <greearb@candelatech.com>

[...]

> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -3725,6 +3725,26 @@ int ath10k_wmi_vdev_install_key(struct ath10k *ar,
>  				   ar->wmi.cmd->vdev_install_key_cmdid);
>  }
>  
> +int ath10k_wmi_vdev_assert(struct ath10k *ar, u32 crashme)
> +{
> +	struct wmi_vdev_install_key_cmd *cmd;
> +	struct sk_buff *skb;
> +
> +	skb = ath10k_wmi_alloc_skb(ar, sizeof(*cmd) + 16);
> +	if (!skb)
> +		return -ENOMEM;
> +
> +	cmd = (struct wmi_vdev_install_key_cmd *)skb->data;
> +	memset(cmd, 0, sizeof(*cmd));
> +	cmd->vdev_id = __cpu_to_le32(crashme);
> +
> +	ath10k_info(ar,
> +		    "simulating firmware ASSERT with bad install_key vdev-id: 0x%x\n",
> +		    cmd->vdev_id);

cmd->vdev_id is in little endian here.

> +	return ath10k_wmi_cmd_send(ar, skb,
> +				   ar->wmi.cmd->vdev_install_key_cmdid);
> +}

As this is not a real WMI command, I would actually prefer to have this
in debug.c. With my patch "ath10k: make ath10k_wmi_cmd_send() public"
that's possible now.

I can do the changes and will send v2 shortly. Just need to test it
first.

-- 
Kalle Valo
