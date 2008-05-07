Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:27559 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752269AbYEGX3K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 May 2008 19:29:10 -0400
Received: by rv-out-0506.google.com with SMTP id l9so618973rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 07 May 2008 16:29:10 -0700 (PDT)
Message-ID: <1ba2fa240805071629i6c7336f6y61a7c9690820ef5e@mail.gmail.com> (sfid-20080508_012824_911250_254F858B)
Date: Thu, 8 May 2008 02:29:09 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: iwlwifi and tx info in skb->cb
Cc: "Ron Rindjunsky" <ron.rindjunsky@intel.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1210197711.3547.1.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1210197711.3547.1.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 8, 2008 at 1:01 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> Hi,
>
>  I was just trying to make iwlwifi work again with tx info in skb->cb,
>  but am running into something I don't understand:
>
>  What is a TFD, and why can it have multiple SKBs with a single tx
>  status? I'm referring to:

TFD stands for TX File Descriptor


>  /* One for each TFD */
>  struct iwl3945_tx_info {
>         struct ieee80211_tx_status status;
>         struct sk_buff *skb[MAX_NUM_OF_TBS];
>  };
>
>  I would have expected something like this with 4965 that has aggregation
>  support (and aggregation is reported just once) but here? Confused.

This is for scatter gather. Nothing to do with aggregation. If you get
fragmented frame you can send it out without linearizing in CPU. in
numer of TB - TX buffers (which is limitted bu MAX_NUM_OF_TBS)  But
I'm just over ever explaining :)


Thanks
Tomas

>  johannes
>
