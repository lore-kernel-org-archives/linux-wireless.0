Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.bugwerft.de ([46.23.86.59]:38360 "EHLO mail.bugwerft.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754597AbeFZUel (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Jun 2018 16:34:41 -0400
Subject: Re: Suspend of SDIO function devices
To: Ulf Hansson <ulf.hansson@linaro.org>
Cc: Chris Ball <chris@printf.net>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "libertas-dev@lists.infradead.org" <libertas-dev@lists.infradead.org>,
        linux-wireless@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <b8a41e3a-7100-ae17-1275-d1b40a026201@zonque.org>
 <CAPDyKFrgcFrah34+eFMsBQYWr03bTSMMUuYw61jYfpffSQrQAg@mail.gmail.com>
From: Daniel Mack <daniel@zonque.org>
Message-ID: <fcec2b1b-e2ab-3404-d958-b62d6d91583a@zonque.org> (sfid-20180626_223449_643944_363A4371)
Date: Tue, 26 Jun 2018 22:34:39 +0200
MIME-Version: 1.0
In-Reply-To: <CAPDyKFrgcFrah34+eFMsBQYWr03bTSMMUuYw61jYfpffSQrQAg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ulf,

Thanks for the prompt reply!

On Monday, June 25, 2018 05:00 PM, Ulf Hansson wrote:
> On 24 June 2018 at 22:46, Daniel Mack <daniel@zonque.org> wrote:
>> Please advise, I'm happy to test approaches and send patches.
> 
>  From a top level point of view, I think this needs to be changed:
> 
> 1)
> In cases when the libertas sdio driver's ->suspend() callback, thinks
> of returning -ENOSYS, it should instead call if_sdio_power_off().
> Depending if if_sdio_power_save() has already been called, this shall
> be skipped.
> 
> The important thing here is to disable the SDIO func device and to
> release the SDIO irq.
> 
> 2)
> During resume, depending on whether the earlier ->suspend() callback
> invoked if_sdio_power_off(),  libertas sdio driver's ->resume()
> callback should call if_sdio_power_on().
> 
> This should re-initiate the libertas sdio device and re-program the
> firmware. To complete these actions, the firmware file also needs to
> be fetched, which requires file system accesses also to be resumed.
> 
> We also need to wait for the firmware programming to be completed,
> hence also do a "wait_event(card->pwron_waitq, priv->fw_ready);" from
> somewhere.

Great, thanks, that helped a lot! I have something that does the job ob 
my board. Will send out a patch shortly.


Best regards,
Daniel
