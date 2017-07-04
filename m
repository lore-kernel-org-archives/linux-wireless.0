Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f170.google.com ([209.85.192.170]:35797 "EHLO
        mail-pf0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750989AbdGDF1s (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Jul 2017 01:27:48 -0400
Received: by mail-pf0-f170.google.com with SMTP id c73so109773937pfk.2
        for <linux-wireless@vger.kernel.org>; Mon, 03 Jul 2017 22:27:48 -0700 (PDT)
Date: Mon, 3 Jul 2017 22:27:45 -0700
From: Jakub Kicinski <jakub.kicinski@netronome.com>
To: Dison River <pwn2river@gmail.com>
Cc: samuel@sortiz.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qca_merez@qca.qualcomm.com,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        davem@davemloft.net, oss-drivers@netronome.com,
        security@kernel.org, wil6210@qca.qualcomm.com
Subject: Re: 'skb' buffer address information leakage
Message-ID: <20170703222745.5f1bb399@cakuba.netronome.com> (sfid-20170704_072813_743132_1F477C99)
In-Reply-To: <CAJsXRPEZV=ugCAxngtVRt+=GZfnwf1abxu8Q_DSaPeXuTYpsVw@mail.gmail.com>
References: <CAJsXRPEZV=ugCAxngtVRt+=GZfnwf1abxu8Q_DSaPeXuTYpsVw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 4 Jul 2017 13:12:18 +0800, Dison River wrote:
> drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c:167
>          seq_printf(file, " frag=%p", skb);

FWIW that's actually not a skb pointer.  The structure is defined like
this:

struct nfp_net_tx_buf {
        union { 
                struct sk_buff *skb;
                void *frag;
        };
        dma_addr_t dma_addr;
        short int fidx;
        u16 pkt_cnt;
        u32 real_len;
};

So the line in question is actually reading the frag pointer, I just
reused the skb variable, because this has to be read via READ_ONCE()
and NULL-checked so I thought that doing it separately for skb and
frag is a waste of LOC especially in debug code.  I will queue up a
clean up for after the merge window.

Thanks!
