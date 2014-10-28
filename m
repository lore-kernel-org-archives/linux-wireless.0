Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:54291 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565AbaJ1JUv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Oct 2014 05:20:51 -0400
MIME-Version: 1.0
In-Reply-To: <1414143811.15751.14.camel@perches.com>
References: <20141024081534.GA11140@mwanda>
	<1414143811.15751.14.camel@perches.com>
Date: Tue, 28 Oct 2014 02:20:50 -0700
Message-ID: <CA++WF2NJ73=mFsb7tpPYL09XpuBLZ65-1UpH_1vBW-Oqxrr4xA@mail.gmail.com> (sfid-20141028_102058_592610_631023A5)
Subject: Re: [patch] ipw2x00: shift wrap bugs setting ->rt_tsf
From: Stanislav Yakovlev <stas.yakovlev@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, Joe,

On 24 October 2014 02:43, Joe Perches <joe@perches.com> wrote:
>
> struct ipw_rt_hdr {
>         struct ieee80211_radiotap_header rt_hdr;
>         u64 rt_tsf;      /* TSF */      /* XXX */
>         u8 rt_flags;    /* radiotap packet flags *
>         u8 rt_rate;     /* rate in 500kb/s */
>         __le16 rt_channel;      /* channel in mhz */
>         __le16 rt_chbitmask;    /* channel bitfield */
>         s8 rt_dbmsignal;        /* signal in dbM, kluged to signed */
>         s8 rt_dbmnoise;
>         u8 rt_antenna;  /* antenna number */
>         u8 payload[0];  /* payload... */
> } __packed;
>
> Maybe rt_tsf (which is otherwise unused in this code),
> should be __le64 so maybe use (u32) ?
>

Yes, you are right, the field definition should be __le64 as you
suggest. All values in radiotap header are specified in little endian
byte order according to the documentation at www.radiotap.org.

>         ipw_rt->rt_txf = cpu_to_le64((u32)(frame->parent_tsf[3] << 24 |
>                                            frame->parent_tsf[2] << 16 |
>                                            frame->parent_tsf[1] << 8  |
>                                            frame->parent_tsf[0]));
>

That looks fine for me. Will you send a patch?

Stanislav.
