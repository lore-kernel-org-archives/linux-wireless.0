Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:51182 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160Ab1HXOqb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 10:46:31 -0400
Message-ID: <4E550EBD.4040600@qca.qualcomm.com> (sfid-20110824_164634_020960_66A19C97)
Date: Wed, 24 Aug 2011 17:46:21 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath6kl: Add initial debugfs changes
References: <1314195936-25227-1-git-send-email-vthiagar@qca.qualcomm.com>
In-Reply-To: <1314195936-25227-1-git-send-email-vthiagar@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/24/2011 05:25 PM, Vasanthakumar Thiagarajan wrote:
> +#ifdef CONFIG_ATH6KL_DEBUGFS
> +int ath6kl_init_debugfs(struct ath6kl *ar)
> +{
> +	ar->debugfs_phy = debugfs_create_dir("ath6kl",
> +					     ar->wdev->wiphy->debugfsdir);

What if we have multiple devices on same host? Then this won't work,
right? Maybe we should have some kind of subdirectory under ath6kl or
something like that.

Would interface name ("wlan0") be a good choise? Ah, but that can
change. Any better options?

Kalle
