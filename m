Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57363 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab1HXRbf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Aug 2011 13:31:35 -0400
Message-ID: <4E553572.2040507@qca.qualcomm.com> (sfid-20110824_193141_095037_B886A6FF)
Date: Wed, 24 Aug 2011 20:31:30 +0300
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 1/3] ath6kl: Add initial debugfs changes
References: <1314195936-25227-1-git-send-email-vthiagar@qca.qualcomm.com> <4E550D34.7020008@qca.qualcomm.com> <20110824144644.GD25267@vasanth-laptop>
In-Reply-To: <20110824144644.GD25267@vasanth-laptop>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 08/24/2011 05:46 PM, Vasanthakumar Thiagarajan wrote:
> On Wed, Aug 24, 2011 at 05:39:48PM +0300, Kalle Valo wrote:
>> On 08/24/2011 05:25 PM, Vasanthakumar Thiagarajan wrote:
>>> +#ifdef CONFIG_ATH6KL_DEBUGFS
>>> +int ath6kl_init_debugfs(struct ath6kl *ar);
>>> +#else
>>> +static inline int ath6kl_init_debugfs(struct ath6kl *ar)
>>> +{
>>> +	return 0;
>>> +}
>>> +#endif
>>
>> I would prefer to call this ath6kl_debug_init(). That way we can put all
>> debug initialisation into that, not just debugfs code. And then the
>> ifdef should check for CONFIG_ATH6KL_DEBUG.
> 
> May be, but I think we can't always enable debugfs based on only
> CONFIG_ATH6KL_DEBUG as the general debug does not depend on
> CONFIG_DEBUG_FS.

I don't see why we need to check for CONFIG_DEBUG_FS.
debugfs_create_file() should handle the case then CONFIG_DEBUG_FS is
disabled as it will just return ERR_PTR(-ENODEV).

Kalle
