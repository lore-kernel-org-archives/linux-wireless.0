Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:46562 "EHLO
        mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754036AbeDBCET (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 1 Apr 2018 22:04:19 -0400
Date: Mon, 2 Apr 2018 11:04:13 +0900
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Cc: Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+3f28bd18291266ec826b@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        syzkaller-bugs@googlegroups.com,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: INFO: rcu detected stall in vprintk_func
Message-ID: <20180402020413.GD3795@jagdpanzerIV> (sfid-20180402_040437_097713_AD172461)
References: <001a113fe6c0a6ec650568c7384f@google.com>
 <CACT4Y+YxuvQLZjWau99-7i8dmtxtjnpX6uteabF5rorYMj5v1w@mail.gmail.com>
 <20180402015422.GA3795@jagdpanzerIV>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180402015422.GA3795@jagdpanzerIV>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On (04/02/18 10:54), Sergey Senozhatsky wrote:
> > > If you forward the report, please keep this part and the footer.
> > >
> > > llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> > > llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> > > llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> > > llcp: nfc_llcp_send_ui_frame: Could not allocate PDU

[..]

> diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
> index ef4026a23e80..a309a27581da 100644
> --- a/net/nfc/llcp_core.c
> +++ b/net/nfc/llcp_core.c
> @@ -1386,7 +1386,7 @@ static void nfc_llcp_recv_agf(struct nfc_llcp_local *local, struct sk_buff *skb)
>  
>  		new_skb = nfc_alloc_recv_skb(pdu_len, GFP_KERNEL);
>  		if (new_skb == NULL) {
> -			pr_err("Could not allocate PDU\n");
> +			pr_err_ratelimited("Could not allocate PDU\n");
>  			return;
>  		}

And of course I ended up patching the wrong function...
What I actually meant was:

---

diff --git a/net/nfc/llcp_commands.c b/net/nfc/llcp_commands.c
index 2ceefa183cee..2f3becb709b8 100644
--- a/net/nfc/llcp_commands.c
+++ b/net/nfc/llcp_commands.c
@@ -755,7 +755,7 @@ int nfc_llcp_send_ui_frame(struct nfc_llcp_sock *sock, u8 ssap, u8 dsap,
 		pdu = nfc_alloc_send_skb(sock->dev, &sock->sk, MSG_DONTWAIT,
 					 frag_len + LLCP_HEADER_SIZE, &err);
 		if (pdu == NULL) {
-			pr_err("Could not allocate PDU\n");
+			pr_err_ratelimited("Could not allocate PDU\n");
 			continue;
 		}
 
