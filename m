Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f178.google.com ([209.85.192.178]:46074 "EHLO
        mail-pf0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754046AbeDBBy1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 1 Apr 2018 21:54:27 -0400
Date: Mon, 2 Apr 2018 10:54:22 +0900
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot+3f28bd18291266ec826b@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        syzkaller-bugs@googlegroups.com,
        Samuel Ortiz <sameo@linux.intel.com>,
        David Miller <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev <netdev@vger.kernel.org>
Subject: Re: INFO: rcu detected stall in vprintk_func
Message-ID: <20180402015422.GA3795@jagdpanzerIV> (sfid-20180402_035455_805093_0E2293F2)
References: <001a113fe6c0a6ec650568c7384f@google.com>
 <CACT4Y+YxuvQLZjWau99-7i8dmtxtjnpX6uteabF5rorYMj5v1w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CACT4Y+YxuvQLZjWau99-7i8dmtxtjnpX6uteabF5rorYMj5v1w@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On (04/01/18 12:51), Dmitry Vyukov wrote:
[..]
> > IMPORTANT: if you fix the bug, please add the following tag to the commit:
> > Reported-by: syzbot+3f28bd18291266ec826b@syzkaller.appspotmail.com
> > It will help syzbot understand when the bug is fixed. See footer for
> > details.
> > If you forward the report, please keep this part and the footer.
> >
> > llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> > llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> > llcp: nfc_llcp_send_ui_frame: Could not allocate PDU
> > llcp: nfc_llcp_send_ui_frame: Could not allocate PDU

Yes, this thing

	do {
		remote_miu = sock->remote_miu > LLCP_MAX_MIU ?
				local->remote_miu : sock->remote_miu;

		frag_len = min_t(size_t, remote_miu, remaining_len);

		pr_debug("Fragment %zd bytes remaining %zd",
			 frag_len, remaining_len);

		pdu = nfc_alloc_send_skb(sock->dev, &sock->sk, MSG_DONTWAIT,
					 frag_len + LLCP_HEADER_SIZE, &err);
		if (pdu == NULL) {
			pr_err("Could not allocate PDU\n");
			continue;
			^^^^^^^^
		}

is basically

	do {
		pr_err("Could not allocate PDU\n");
	} while (1)

Can cause problems sometimes. But this loop is a bit worrisome
even without the printk() call.

>From printk() side, we only can do rate limiting here. Would be
great if nfc maintainers could take a look and tweak the loop
maybe.

---

diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index ef4026a23e80..a309a27581da 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -1386,7 +1386,7 @@ static void nfc_llcp_recv_agf(struct nfc_llcp_local *local, struct sk_buff *skb)
 
 		new_skb = nfc_alloc_recv_skb(pdu_len, GFP_KERNEL);
 		if (new_skb == NULL) {
-			pr_err("Could not allocate PDU\n");
+			pr_err_ratelimited("Could not allocate PDU\n");
 			return;
 		}
 
