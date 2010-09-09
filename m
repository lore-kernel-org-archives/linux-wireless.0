Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42628 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753482Ab0IIGnj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 02:43:39 -0400
Received: by bwz11 with SMTP id 11so850873bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 23:43:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTim_c4MuAbnx1QADezTuXc-15QuqeFT2WHo+j7Bm@mail.gmail.com>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com>
 <1283988329-44549-8-git-send-email-steve@cozybit.com> <AANLkTi=JFgw5Oh3xZcyBGGdQKjd=sSBLRXDtcxud5pBR@mail.gmail.com>
 <AANLkTim_c4MuAbnx1QADezTuXc-15QuqeFT2WHo+j7Bm@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 9 Sep 2010 16:43:18 +1000
Message-ID: <AANLkTi=kjBuLx2XuWt9EL6FWzuVQ2Xdcnpt7kSp_4wBd@mail.gmail.com>
Subject: Re: [PATCH 7/9] libertas_tf: Add tx feedback to libertas_tf_sdio
To: Steve deRosier <steve@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, javier@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 9, 2010 at 15:49, Steve deRosier <steve@cozybit.com> wrote:
> On Wed, Sep 8, 2010 at 7:16 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
>> More nits:
>>
>> On Thu, Sep 9, 2010 at 09:25, Steve deRosier <steve@cozybit.com> wrote:
>>> This patch adds tx-feedback to libertas_tf_sdio so that mac80211 rate
>>> adaptation and other bookkeeping tasks function properly.
>>>
>>> Signed-off-by: Steve deRosier <steve@cozybit.com>
>>> ---
>>>  drivers/net/wireless/libertas_tf/deb_defs.h |    5 ++
>>>  drivers/net/wireless/libertas_tf/if_sdio.c  |   42 +++++++++++------
>>>  drivers/net/wireless/libertas_tf/main.c     |   65 ++++++++++++++++----------
>>>  3 files changed, 72 insertions(+), 40 deletions(-)
>>>
>>> diff --git a/drivers/net/wireless/libertas_tf/deb_defs.h b/drivers/net/wireless/libertas_tf/deb_defs.h
>>> index 99a7478..8e86e11 100644
>>> --- a/drivers/net/wireless/libertas_tf/deb_defs.h
>>> +++ b/drivers/net/wireless/libertas_tf/deb_defs.h
>>> @@ -1063,25 +1077,23 @@ static void if_sdio_interrupt(struct sdio_func *func)
>>>        if (ret)
>>>                goto out;
>>>
>>> -//     lbtf_deb_sdio("interrupt: 0x%X\n", (unsigned)cause);
>>> -
>>>        sdio_writeb(card->func, ~cause, IF_SDIO_H_INT_STATUS, &ret);
>>>        if (ret)
>>>                goto out;
>>
>> Shouldn't this have been removed instead of being commented in the
>> patch that commented it?
>>
>
> Until this time I was using this line intermittently.  I frequently
> uncommented it in order to see some debugging info.  But as it is in
> an interrupt, it creates a lot of noise that I usually didn't want to
> see.  Once I was past a certain point (here) and didn't need it
> anymore, it got deleted.
>
> I could have rolled all the patches into one single patch that was
> nice and neat with a blue bow, but then you wouldn't have seen all the
> fun I had and you would have missed out.  :)

Hehehe. Quite. I guess I'm just more pedantic about such things than
most people. Ah well =)

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
