Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:42894 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab0AWMSh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 23 Jan 2010 07:18:37 -0500
Received: by fxm21 with SMTP id 21so230147fxm.29
        for <linux-wireless@vger.kernel.org>; Sat, 23 Jan 2010 04:18:36 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20100123105111.GA24790@progeny.tock>
References: <20100123105111.GA24790@progeny.tock>
Date: Sat, 23 Jan 2010 13:18:35 +0100
Message-ID: <fe54d8c01001230418u3de7f4ccuc4fbfdecc7c76ebf@mail.gmail.com>
Subject: Re: ath5k phy0: unsupported jumbo
From: Kacper <kacper@kacper.se>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I also have this problem with that message appearing in my console. As
far as I know it has to do with that Jumbo frame processing  is broken
in the ath5k driver. It's listen under the ath5k todo tasks at
<http://linuxwireless.org/en/users/Drivers/ath5k>.

On Sat, Jan 23, 2010 at 11:51 AM, Jonathan Nieder <jrnieder@gmail.com> wrote:
> Hi,
>
> Every now and then, I get a few messages like the following:
>
> [11316.285087] ath5k phy0: unsupported jumbo
> [14256.975594] ath5k phy0: unsupported jumbo
> [26376.342970] ath5k phy0: unsupported jumbo
>
> drivers/net/wireless/ath/ath5k/base.c tells me this is unlikely (or at
> least the slow path), and that it means that after calling the
> sc->ah->ah_proc_rx_desc(sc->ah, ds, &rs) callback, rs.rs_more was
> nonzero.
>
> What I still don’t know:
>
>  - So, what happened?
>  - Does this indicate some subtle misconfiguration?
>  - Is this a hardware bug?
>  - Is this a driver bug?
>
> The network generally works great, so there is no cause for me to
> worry, but still it would give me some peace of mind to know.
>
> In turn, I would gladly write a Documentation/networking/ath5k.txt or
> a comment near drivers/net/wireless/ath/ath5k/base.c:1817 for others
> to refer to.
>
> Thoughts?
> Jonathan
>
> $ uname -r
> 2.6.33-rc4-next-20100121-04118-gbaa1751
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
