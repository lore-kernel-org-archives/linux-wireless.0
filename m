Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:4753 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752766Ab1HXRhT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 13:37:19 -0400
Message-ID: <4E5536A5.9020401@qca.qualcomm.com> (sfid-20110824_193728_685778_1CC64716)
Date: Wed, 24 Aug 2011 20:36:37 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath6kl: Add initial debugfs changes
References: <1314195936-25227-1-git-send-email-vthiagar@qca.qualcomm.com> <4E550EBD.4040600@qca.qualcomm.com> <20110824145226.GE25267@vasanth-laptop>
In-Reply-To: <20110824145226.GE25267@vasanth-laptop>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/24/2011 05:52 PM, Vasanthakumar Thiagarajan wrote:
> On Wed, Aug 24, 2011 at 05:46:21PM +0300, Kalle Valo wrote:
>> On 08/24/2011 05:25 PM, Vasanthakumar Thiagarajan wrote:
>>> +#ifdef CONFIG_ATH6KL_DEBUGFS
>>> +int ath6kl_init_debugfs(struct ath6kl *ar)
>>> +{
>>> +	ar->debugfs_phy = debugfs_create_dir("ath6kl",
>>> +					     ar->wdev->wiphy->debugfsdir);
>>
>> What if we have multiple devices on same host? Then this won't work,
>> right? Maybe we should have some kind of subdirectory under ath6kl or
>> something like that.
> 
> I don't think we need to worry about multiple device case, it is
> entirely different wiphy.

But when were are two devices, both will try create
/sys/kernel/debug/athk6kl and second one is bound to fail. Ah, but now I
see where I'm wrong. The directory will be under wiphy debugfsdir, eg.
/sys/kernel/debug/phy0/, and there's no issue with multiple devices.

Sorry, I missed this. So forget all I said :)

> May be multiple virtual interface needs to be
> taken care? Anyway, currently ath6kl does not support more than
> one virtual interface, can be addressed later.

Yeah, no need to worry that now.

Kalle
