Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53907 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752922AbeBKLEH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 11 Feb 2018 06:04:07 -0500
From: Carl Huang <cjhuang@qti.qualcomm.com>
To: "nbd@nbd.name" <nbd@nbd.name>, Carl Huang <cjhuang@codeaurora.org>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] ath10k: fix use-after-free in ath10k_wmi_cmd_send_nowait
Date: Sun, 11 Feb 2018 11:03:48 +0000
Message-ID: <77aae4b4bdd44043b30cd7075537630a@aptaiexm02f.ap.qualcomm.com> (sfid-20180211_120411_537475_2611242A)
References: <1518317805-5796-1-git-send-email-cjhuang@codeaurora.org>
 <3995aa0a-00f0-5ca1-fc49-1fad141fb2ae@nbd.name>
In-Reply-To: <3995aa0a-00f0-5ca1-fc49-1fad141fb2ae@nbd.name>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



> -----Original Message-----
> From: ath10k [mailto:ath10k-bounces@lists.infradead.org] On Behalf Of Fel=
ix
> Fietkau
> Sent: Sunday, February 11, 2018 5:59 PM
> To: Carl Huang <cjhuang@codeaurora.org>; ath10k@lists.infradead.org
> Cc: linux-wireless@vger.kernel.org
> Subject: Re: [PATCH] ath10k: fix use-after-free in
> ath10k_wmi_cmd_send_nowait
>=20
> On 2018-02-11 03:56, Carl Huang wrote:
> > The skb may be freed in tx completion context before
> > trace_ath10k_wmi_cmd is called. This can be easily captured when
> > KASAN(Kernel Address Sanitizer) is enabled. The fix is to add a
> > reference count to the skb and release it after trace_ath10k_wmi_cmd
> > is called.
> >
> > Signed-off-by: Carl Huang <cjhuang@codeaurora.org>
> I think it makes more sense to simply call the trace function before
> ath10k_htc_send. Also, for a trivial change like this it probably does no=
t make
> sense to add a Copyright line either.
>=20
Agree that Moving the trace function before ath10k_htc_send is more simple,=
 but then the parameter ret=20
has no meaning and can't trace the return value of ath10k_htc_send.  Beside=
s that, skb->data and skb->len=20
have different value if putting trace function before ath10k_htc_send, and =
this may be fine since the main
purpose is to trace the wmi information and not htc header information.

For the Copyright line, need Kalle Valo to comment.=20

>=20
> _______________________________________________
> ath10k mailing list
> ath10k@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/ath10k
