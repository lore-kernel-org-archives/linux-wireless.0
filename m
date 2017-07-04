Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:36809 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751838AbdGDFMT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 4 Jul 2017 01:12:19 -0400
MIME-Version: 1.0
From: Dison River <pwn2river@gmail.com>
Date: Tue, 4 Jul 2017 13:12:18 +0800
Message-ID: <CAJsXRPEZV=ugCAxngtVRt+=GZfnwf1abxu8Q_DSaPeXuTYpsVw@mail.gmail.com> (sfid-20170704_071254_860824_4F635A95)
Subject: 'skb' buffer address information leakage
To: samuel@sortiz.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, qca_merez@qca.qualcomm.com,
        kvalo@codeaurora.org, linux-wireless@vger.kernel.org,
        jakub.kicinski@netronome.com, davem@davemloft.net,
        oss-drivers@netronome.com, security@kernel.org,
        wil6210@qca.qualcomm.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all:
I'd found several address leaks of "skb" buffer.When i have a
arbitrary address write vulnerability in kernel(enabled kASLR),I can
use skb's address find sk_destruct's address and overwrite it. And
then,invoke close(sock_fd) function can trigger the
shellcode(sk_destruct func).

In kernel 4.12-rc7
drivers/net/irda/vlsi_ir.c:326           seq_printf(seq, "skb=%p
data=%p hw=%p\n", rd->skb, rd->buf, rd->hw);
drivers/net/ethernet/netronome/nfp/nfp_net_debugfs.c:167
         seq_printf(file, " frag=%p", skb);
drivers/net/wireless/ath/wil6210/debugfs.c:926           seq_printf(s,
"  SKB = 0x%p\n", skb);

Thanks.
