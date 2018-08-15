Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aserp2120.oracle.com ([141.146.126.78]:45592 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbeHOLV1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 15 Aug 2018 07:21:27 -0400
Date: Wed, 15 Aug 2018 11:29:56 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Kees Cook <keescook@chromium.org>,
        Security Officers <security@kernel.org>,
        Kevin Deus <kdeus@google.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Allen Pais <allen.pais@oracle.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] NFC: Fix possible memory corruption when handling
 SHDLC I-Frame commands
Message-ID: <20180815082956.u6grueiyshwgqt3a@mwanda> (sfid-20180815_103033_742728_54115D85)
References: <20180813223910.26276-1-surenb@google.com>
 <20180814095413.vbjkcjkmytkffyaz@mwanda>
 <CAJuCfpF0Y6wc1z-rbn2wdWROgc_FkD2EX5HzDMcZ1oB5Z=dXSw@mail.gmail.com>
 <CAJuCfpHSZuabLr6+t_n7UDamJCAP6EPTNEZ6kNqWOhk2mpYADg@mail.gmail.com>
 <CAGXu5jKqcpbpG0Ky4-yXV4d5q10HtGwJtdyPKcrwkJUPhA_Mpg@mail.gmail.com>
 <CAJuCfpEX69Sbd=0i0ismP6q2NsZGUF4gMSCr1G5NdXd3n1NyZA@mail.gmail.com>
 <CAGXu5jJB9wMDJnfsurpxsXm6_0WsWWCaTuWBfy+3aMSE_LL9Rw@mail.gmail.com>
 <CAJuCfpEX+F-EPxQYXNdUg-uT9ecwYYdxBsr9y_69zQ0Fq50GeA@mail.gmail.com>
 <CAJuCfpGSPkB-tk4GHaJeStRph-ibVhUZ119Sfd16xgf9x=qUwQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJuCfpGSPkB-tk4GHaJeStRph-ibVhUZ119Sfd16xgf9x=qUwQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 14, 2018 at 03:38:14PM -0700, Suren Baghdasaryan wrote:
> The separate fix for the size of pipes[] array is posted here:
> https://lkml.org/lkml/2018/8/14/1034
> Thanks!
> 

That's great!  Let's add some bounds checking to nfc_hci_msg_rx_work()
and nfc_hci_recv_from_llc() as well and then we can close the chapter on
these bugs.

regards,
dan carpenter
