Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:35059 "EHLO
	mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750938AbbG3MDt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2015 08:03:49 -0400
Received: by vkhg129 with SMTP id g129so9358798vkh.2
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2015 05:03:48 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1438256465-19540-1-git-send-email-chaehyun.lim@gmail.com>
References: <1438256465-19540-1-git-send-email-chaehyun.lim@gmail.com>
Date: Thu, 30 Jul 2015 21:03:48 +0900
Message-ID: <CAKV=isuiu4GeYxPFpwqSn8io-uq7hz53tiBX9dmh62b4rvRA=g@mail.gmail.com> (sfid-20150730_140352_266707_D5A91123)
Subject: Re: [RESEND V2 0/3] cover letter of wilc1000 patches
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, dean.lee@atmel.com,
	chris.park@atmel.com, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, Chaehyun Lim <chaehyun.lim@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm sorry that I have mistake the number of kmalloc changes. The total
change is 6, not 4.

On Thu, Jul 30, 2015 at 8:41 PM, Chaehyun Lim <chaehyun.lim@gmail.com> wrote:
> Hi, Greg
>
> I'm sorry that I did not say whether GFP_ATOMIC should be used or not.
> This is my review on it. If it's not correct, please give me any comment or direction.
>
> First patch has 4 sites of kmalloc change in coreconfigurator.c
> First one, it is used for gps8ConfigPacket at CoreconfiguratorInit and CoreConfiguratorDeInit.
> I think it should be removed next time because I cannot find anywhere to use it.
> Then, it is okay to change flag as GFP_KERNEL.
>
> Other three changes are used to handle host interface message within a kernel thread.
> The manipulation of host interface message is not called on IRQ context and I could not
> find any spin lock inside function.
>
> If this patches are accepted, I will try to continue to change WILC_MALLOC macro as kmalloc.
> I always appreciate your comment and advice.
>
> Thanks
> Chaehyun Lim
>
>
> Chaehyun Lim (3):
>   staging: wilc1000: coreconfigurator.c: remove WILC_MALLOC
>   staging: wilc1000: coreconfigurator.c: add kmalloc error check
>   staging: wilc1000: coreconfigurator.c: fix kmalloc error check
>
>  drivers/staging/wilc1000/coreconfigurator.c | 38 +++++++++++++++++------------
>  1 file changed, 23 insertions(+), 15 deletions(-)
>
> --
> 1.9.1
>
