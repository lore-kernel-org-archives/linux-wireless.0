Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:33314 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750717AbdCTGjG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 20 Mar 2017 02:39:06 -0400
Received: by mail-pf0-f193.google.com with SMTP id p189so10225574pfp.0
        for <linux-wireless@vger.kernel.org>; Sun, 19 Mar 2017 23:39:05 -0700 (PDT)
Subject: Re: [PATCH 2/2] mac80211: Drop new node with weak power
To: Johannes Berg <johannes@sipsolutions.net>
References: <1489629438-7087-1-git-send-email-masashi.honma@gmail.com>
 <1489629438-7087-2-git-send-email-masashi.honma@gmail.com>
 <1489658630.2370.4.camel@sipsolutions.net>
 <d0eb6984-6ae7-d984-b61a-0c98603294ae@gmail.com>
 <1489753692.2544.9.camel@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <c95cce88-d02f-8ef3-a848-0a8a3de6296b@gmail.com> (sfid-20170320_073909_517832_63D5F8DD)
Date: Mon, 20 Mar 2017 15:39:02 +0900
MIME-Version: 1.0
In-Reply-To: <1489753692.2544.9.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2017/03/17 21:28, Johannes Berg wrote:
> Hmm. If path selection isn't done by mac80211 in this case, wouldn't it
> be more appropriate to put this logic into the (userspace) component
> that does path selection?

Currently, userspace application(wpa_supplicant) does not have mesh
path selection functionality.

> IOW, I'm not convinced that outright not adding the *peer* is a good
> idea either way - it seems much better to me to not use the *path*.

We have already had the code to calculate mesh path metric with RSSI.

But we still needs this patch for a special case on SAE. Some hardware
can use hardware encryption for mesh SAE. Then the hardware has a
limitation of key registration. For example, some hardware could only
save keys for 8 stations. So we need to drop stations itself with weak
signal instead of the pathes to its.

Masashi Honma.
