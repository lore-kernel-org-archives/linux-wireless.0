Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:34154 "EHLO
	mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbcFVKx7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jun 2016 06:53:59 -0400
Received: by mail-pf0-f195.google.com with SMTP id 66so3840150pfy.1
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jun 2016 03:53:59 -0700 (PDT)
Subject: Re: [PATCH v2] mac80211: Encrypt "Group addressed privacy" action
 frames
To: Jouni Malinen <j@w1.fi>
References: <20160620212529.GA19076@w1.fi>
 <1466490219-2891-1-git-send-email-masashi.honma@gmail.com>
 <20160621164207.GA7323@w1.fi>
Cc: linux-wireless@vger.kernel.org
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <576A6E43.2000003@gmail.com> (sfid-20160622_125403_301712_FF24103C)
Date: Wed, 22 Jun 2016 19:53:55 +0900
MIME-Version: 1.0
In-Reply-To: <20160621164207.GA7323@w1.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016年06月22日 01:42, Jouni Malinen wrote:
>
> This is somewhat problematic since no indication of the frame length is
> passed in here and we are reading beyond the frame header below.. Maybe
> this should use the same style as ieee80211_is_robust_mgmt_frame()
> instead, i.e., use skb as the argument and define
> _ieee80211_is_group_privacy_action() to take in struct ieee80211_hdr *.
Thank you. I will modify it.


>
> These read the buffer at offset 24, i.e., just after the header. This
> should do same as ieee80211_is_robust_mgmt_frame(), i.e., return false
> if skb->len < 25.
Thank you. I will modify it also.

>
> This looks completely separate item and I don't see why we would even
> delete that empty line.. In any case, it should probably not be in this
> patch.
>    

Sorry. This is just a miss of removal of printk().

