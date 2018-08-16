Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:37499 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727859AbeHPTaW (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 16 Aug 2018 15:30:22 -0400
Received: by mail-oi0-f65.google.com with SMTP id j205-v6so9103356oib.4
        for <linux-wireless@vger.kernel.org>; Thu, 16 Aug 2018 09:30:51 -0700 (PDT)
Subject: Re: [PATCH v6 1/3] nl80211: Add ATOMIC_KEY_REPLACE API
To: Alexander Wetzel <alexander@wetzel-home.de>,
        johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org
References: <20180814104255.4183-1-alexander@wetzel-home.de>
 <20180814104255.4183-2-alexander@wetzel-home.de>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <6ccc3055-02c4-8756-3926-ed8e247ba751@gmail.com> (sfid-20180816_183059_796669_E5FB5C4D)
Date: Thu, 16 Aug 2018 11:30:49 -0500
MIME-Version: 1.0
In-Reply-To: <20180814104255.4183-2-alexander@wetzel-home.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Alexander,

On 08/14/2018 05:42 AM, Alexander Wetzel wrote:
> Drivers able to correctly replace a in-use key should set
> NL80211_EXT_FEATURE_ATOMIC_KEY_REPLACE to allow the userspace (e.g.
> hostapd or wpa_supplicant) to rekey PTK keys.
> 
> The userspace must detect a PTK rekey attempt and only go ahead with the
> rekey when the driver has set this flag. If the driver is not supporting
> the feature the userspace either must not replace the PTK key or perform
> a full re-association.
> 
> Ignoring this flag and continuing to rekey the connection can still
> work but has to be considered insecure and broken. It can leak cleartext
> packets or freeze the connection and is only supported to allow the
> userspace to be updated.
> 
> Signed-off-by: Alexander Wetzel <alexander@wetzel-home.de>
> ---
>   include/uapi/linux/nl80211.h | 6 ++++++
>   1 file changed, 6 insertions(+)
> 

This looks good to me from a userspace perspective.  I will try to 
implement support for this in iwd soon to give you a prototype to play with.

Reviewed-by: Denis Kenzior <denkenz@gmail.com>

Regards,
-Denis
