Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0227.hostedemail.com ([216.40.44.227]:43617 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726244AbeHXIGQ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 24 Aug 2018 04:06:16 -0400
Message-ID: <d0ee04ea40bfc2aecd71b3ed1e1d388911b7d6cb.camel@perches.com> (sfid-20180824_063354_731777_4BF1E9D3)
Subject: Re: [PATCH] iwlwifi: d3: use struct_size() in kzalloc()
From: Joe Perches <joe@perches.com>
To: Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Thu, 23 Aug 2018 21:33:19 -0700
In-Reply-To: <CAGXu5jJxbFzKsV1=xHiKtcx+61QBsK0LYMrwo1vGNWgALzqakw@mail.gmail.com>
References: <20180824011540.GA25716@embeddedor.com>
         <CAGXu5jJxbFzKsV1=xHiKtcx+61QBsK0LYMrwo1vGNWgALzqakw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2018-08-23 at 20:03 -0700, Kees Cook wrote:
> On Thu, Aug 23, 2018 at 6:15 PM, Gustavo A. R. Silva
> <gustavo@embeddedor.com> wrote:
> > One of the more common cases of allocation size calculations is finding
> > the size of a structure that has a zero-sized array at the end, along
> > with memory for some number of elements for that array. For example:
> > 
> > struct foo {
> >         int stuff;
> >         void *entry[];
> > };

Question for Gustavo.

Did you find any existing instances that are miscalculated?

I believe there are some cases like:

	size = sizeof(struct foo) + count * sizeof(something);
	ptr = kmalloc(size);
	memset(ptr + sizeof(struct foo), 0, size - sizeof(struct foo));

where something could go wrong and not be detected.
