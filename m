Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f68.google.com ([209.85.220.68]:33336 "EHLO
	mail-pa0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379AbcFTAvb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jun 2016 20:51:31 -0400
Received: by mail-pa0-f68.google.com with SMTP id ts6so9713330pac.0
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jun 2016 17:51:31 -0700 (PDT)
Subject: Re: [PATCH] mac80211: Encrypt "Group addressed privacy" action frames
To: Jouni Malinen <j@w1.fi>
References: <1465969112-2814-1-git-send-email-masashi.honma@gmail.com>
 <20160618091116.GA2972@w1.fi>
Cc: linux-wireless@vger.kernel.org
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <57673E10.7070706@gmail.com> (sfid-20160620_034224_871538_C10EC263)
Date: Mon, 20 Jun 2016 09:51:28 +0900
MIME-Version: 1.0
In-Reply-To: <20160618091116.GA2972@w1.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016年06月18日 18:11, Jouni Malinen wrote:
> What about RX side? Shouldn't there be a matching change there to
> enforce use of group addressed privacy for the specific Action
> categories?

Thank you. Yes, RX side modification is needed.
I was not aware of it because ping test was OK.
Now I recognize it is because MGTK and IGTK is same as you say.

> This will make devices using fixed implementation not
> interoperate with devices using older version, I'd assume, but it looks
> like the current use of mesh with RSN is pretty hopelessly broken as far
> as no PMF case is concerned at least when using the wpa_supplicant
> implementation (sets IGTK incorrectly and ends up using BIP even when
> PMF was not enabled), so there does not seem to be any convenient way of
> addressing this apart from requiring all devices in the MBSS to get
> updated to the fixed versions.
Yes. This patch breaks backward compatibility.
I do not have smart idea to avoid also.
I will create new define like this.
CONFIG_MAC80211_MESH_GROUP_ADDRESSED_PRIVACY


> And this helper should likely be in some more generic location so that 
> it could be shared for TX and RX.. 

Sure.


