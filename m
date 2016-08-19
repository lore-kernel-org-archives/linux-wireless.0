Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:59115 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754580AbcHSDCD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Aug 2016 23:02:03 -0400
From: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
To: "greearb@candelatech.com" <greearb@candelatech.com>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/3] ath10k:  Grab rcu_read_lock before the txqs spinlock.
Date: Fri, 19 Aug 2016 03:01:14 +0000
Message-ID: <1471575674214.65791@qti.qualcomm.com> (sfid-20160819_050210_524850_C92502C0)
References: <1471569995-10028-1-git-send-email-greearb@candelatech.com>,<1471569995-10028-2-git-send-email-greearb@candelatech.com>
In-Reply-To: <1471569995-10028-2-git-send-email-greearb@candelatech.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless=
/ath/ath10k/mac.c=0A=
> index 916119c..d96c06e 100644=0A=
> --- a/drivers/net/wireless/ath/ath10k/mac.c=0A=
> +++ b/drivers/net/wireless/ath/ath10k/mac.c=0A=
> @@ -4307,8 +4307,8 @@ void ath10k_mac_tx_push_pending(struct ath10k *ar)=
=0A=
>         int max;=0A=
>         int loop_max =3D 2000;=0A=
> =0A=
> -       spin_lock_bh(&ar->txqs_lock);=0A=
>         rcu_read_lock();=0A=
> +       spin_lock_bh(&ar->txqs_lock);=0A=
>=0A=
Ben,=0A=
=0A=
It is quite possible that push_pending can be preempted after acquiring rcu=
_lock which=0A=
may lead to deadlock. no? I assume to prevent that spin_lock is taken first=
. =0A=
=0A=
Could you please explain how this reordering is fixing dead lock?=0A=
=0A=
-Rajkumar=
