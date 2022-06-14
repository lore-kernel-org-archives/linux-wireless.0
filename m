Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BED3C433EF
	for <linux-wireless@archiver.kernel.org>; Tue, 14 Jun 2022 10:59:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236401AbiFNK7O (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 14 Jun 2022 06:59:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiFNK6q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 14 Jun 2022 06:58:46 -0400
Received: from mail.toke.dk (mail.toke.dk [IPv6:2a0c:4d80:42:2001::664])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5515D286C1;
        Tue, 14 Jun 2022 03:58:43 -0700 (PDT)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=toke.dk; s=20161023;
        t=1655204320; bh=XY227SjZimMDP/m7qB4ABMwXhSX1786bA3oIzbKiaUc=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=xkWqfznOqILQ619kFm+0+grH1kaZ1DDdengTctr4FwFNl0JVXLe02rhbYPGZypOPX
         8oF9YoxH6LAylRdWdyVowW0vcKCs32zdOSLdnElWIBSvG+1YkBnBrrYnzv4b2O+oDS
         0lAxJG3t5BiaHUZimrk3xf2iRHPrd7RwmkNXqSNFRS7uHeALQPSQYbHOQcCZw6MHsC
         S+mPk5hnhgp28Ckrdb9CGZRWRyK/CioJkJsdN+1QL4bXE9bVYQpyjlqZW5cAHY3OB4
         BY4CytX+6ayn+lGVt2OHcgORbXM2q1vHJr4SgNbnM2XUVvTqiOKEcphDblFuYfEMva
         vqBkelVkeSfDA==
To:     Pavel Skripkin <paskripkin@gmail.com>, kvalo@kernel.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Pavel Skripkin <paskripkin@gmail.com>,
        syzbot+03110230a11411024147@syzkaller.appspotmail.com,
        syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail.com
Subject: Re: [PATCH v6 1/2] ath9k: fix use-after-free in ath9k_hif_usb_rx_cb
In-Reply-To: <d57bbedc857950659bfacac0ab48790c1eda00c8.1655145743.git.paskripkin@gmail.com>
References: <d57bbedc857950659bfacac0ab48790c1eda00c8.1655145743.git.paskripkin@gmail.com>
Date:   Tue, 14 Jun 2022 12:58:40 +0200
X-Clacks-Overhead: GNU Terry Pratchett
Message-ID: <87o7yvzf33.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Pavel Skripkin <paskripkin@gmail.com> writes:

> Syzbot reported use-after-free Read in ath9k_hif_usb_rx_cb() [0]. The
> problem was in incorrect htc_handle->drv_priv initialization.
>
> Probable call trace which can trigger use-after-free:
>
> ath9k_htc_probe_device()
>   /* htc_handle->drv_priv =3D priv; */
>   ath9k_htc_wait_for_target()      <--- Failed
>   ieee80211_free_hw()		   <--- priv pointer is freed
>
> <IRQ>
> ...
> ath9k_hif_usb_rx_cb()
>   ath9k_hif_usb_rx_stream()
>    RX_STAT_INC()		<--- htc_handle->drv_priv access
>
> In order to not add fancy protection for drv_priv we can move
> htc_handle->drv_priv initialization at the end of the
> ath9k_htc_probe_device() and add helper macro to make
> all *_STAT_* macros NULL safe, since syzbot has reported related NULL
> deref in that macros [1]
>
> Link: https://syzkaller.appspot.com/bug?id=3D6ead44e37afb6866ac0c7dd121b4=
ce07cb665f60 [0]
> Link: https://syzkaller.appspot.com/bug?id=3Db8101ffcec107c0567a0cd8acbba=
cec91e9ee8de [1]
> Fixes: fb9987d0f748 ("ath9k_htc: Support for AR9271 chipset.")
> Reported-and-tested-by: syzbot+03110230a11411024147@syzkaller.appspotmail=
.com
> Reported-and-tested-by: syzbot+c6dde1f690b60e0b9fbe@syzkaller.appspotmail=
.com
> Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>

Alright, since we've heard no more objections and the status quo is
definitely broken, let's get this merged and we can follow up with any
other fixes as necessary...

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@toke.dk>
