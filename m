Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39810 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751208AbdJCWqh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Oct 2017 18:46:37 -0400
Date: Tue, 3 Oct 2017 19:46:32 -0300
From: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To: Jia-Ju Bai <baijiaju1990@163.com>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au,
        nhorman@tuxdriver.com, vyasevich@gmail.com, luto@kernel.org,
        kvalo@codeaurora.org, linux-crypto@vger.kernel.org,
        netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH V2] Fix a sleep-in-atomic bug in shash_setkey_unaligned
Message-ID: <20171003224632.GF19750@localhost.localdomain> (sfid-20171004_004651_226484_DCEE7D50)
References: <1506997522-26684-1-git-send-email-baijiaju1990@163.com>
 <20171003223308.GD19750@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171003223308.GD19750@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 03, 2017 at 07:33:08PM -0300, Marcelo Ricardo Leitner wrote:
> On Tue, Oct 03, 2017 at 10:25:22AM +0800, Jia-Ju Bai wrote:
> > The SCTP program may sleep under a spinlock, and the function call path is:
> > sctp_generate_t3_rtx_event (acquire the spinlock)
> >   sctp_do_sm
> >     sctp_side_effects
> >       sctp_cmd_interpreter
> >         sctp_make_init_ack
> >           sctp_pack_cookie
> >             crypto_shash_setkey
> >               shash_setkey_unaligned
> >                 kmalloc(GFP_KERNEL)
> 
> Are you sure this can happen?
> The host is not supposed to store any information when replying to an
> INIT packet (which generated the INIT_ACK listed above). That said,
> it's weird to see the timer function triggering so.
> 
> Checking now, that code is dead actually:
> $ git grep -A 2 SCTP_CMD_GEN_INIT_ACK
> sm_sideeffect.c:                case SCTP_CMD_GEN_INIT_ACK:
> sm_sideeffect.c-                        /* Generate an INIT ACK chunk.
> */
> sm_sideeffect.c-                        new_obj =
> sctp_make_init_ack(asoc, chunk, GFP_ATOMIC,
> 
> Nobody is triggering a call to sctp_cmd_interpreter with
> SCTP_CMD_GEN_INIT_ACK command, which would generate the callstack
> above.

Nevertheless, the issue is real through other call paths.

Thanks,
Marcelo
