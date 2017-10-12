Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:39810 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752138AbdJLLow (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 07:44:52 -0400
Date: Thu, 12 Oct 2017 13:44:59 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        Peng Xu <pxu@qti.qualcomm.com>,
        Jouni Malinen <jouni@qca.qualcomm.com>
Subject: Re: [PATCH v4.9] nl80211: Define policy for packet pattern attributes
Message-ID: <20171012114459.GD32149@kroah.com> (sfid-20171012_134454_974477_11BC2AE6)
References: <20171011083209.10969-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171011083209.10969-1-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 11, 2017 at 10:32:09AM +0200, Johannes Berg wrote:
> From: Peng Xu <pxu@qti.qualcomm.com>
> 
> Upstream commit ad670233c9e1d5feb365d870e30083ef1b889177.
> 
> Define a policy for packet pattern attributes in order to fix a
> potential read over the end of the buffer during nla_get_u32()
> of the NL80211_PKTPAT_OFFSET attribute.
> 
> Note that the data there can always be read due to SKB allocation
> (with alignment and struct skb_shared_info at the end), but the
> data might be uninitialized. This could be used to leak some data
> from uninitialized vmalloc() memory, but most drivers don't allow
> an offset (so you'd just get -EINVAL if the data is non-zero) or
> just allow it with a fixed value - 100 or 128 bytes, so anything
> above that would get -EINVAL. With brcmfmac the limit is 1500 so
> (at least) one byte could be obtained.
> 
> Cc: stable@kernel.org
> Signed-off-by: Peng Xu <pxu@qti.qualcomm.com>
> Signed-off-by: Jouni Malinen <jouni@qca.qualcomm.com>
> [rewrite description based on SKB allocation knowledge]
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/wireless/nl80211.c | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)

Thanks for the backports, now queued up.

greg k-h
