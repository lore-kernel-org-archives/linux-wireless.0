Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62847 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426Ab0IIGlp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Sep 2010 02:41:45 -0400
Received: by bwz11 with SMTP id 11so850083bwz.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Sep 2010 23:41:44 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <AANLkTikgQHk8OCMqd5VerKwG9J2p5R35=Q_YxoWGQa_v@mail.gmail.com>
References: <1283988329-44549-1-git-send-email-steve@cozybit.com>
 <1283988329-44549-6-git-send-email-steve@cozybit.com> <AANLkTimTgYmdrytn6_wdx_7HVX20nurdsJ=OqiSoGJLs@mail.gmail.com>
 <AANLkTikgQHk8OCMqd5VerKwG9J2p5R35=Q_YxoWGQa_v@mail.gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Thu, 9 Sep 2010 16:41:24 +1000
Message-ID: <AANLkTincUYSKzmn75zGeHu_mTAvWb+4L2E_4LVb_af=a@mail.gmail.com>
Subject: Re: [PATCH 5/9] libertas_tf: Moved firmware loading to probe in order
 to fetch MAC address
To: Steve deRosier <steve@cozybit.com>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	johannes@sipsolutions.net, javier@cozybit.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 9, 2010 at 15:49, Steve deRosier <steve@cozybit.com> wrote:
> On Wed, Sep 8, 2010 at 7:06 PM, Julian Calaby <julian.calaby@gmail.com> wrote:
>> More nits:
>>
>>
>> Are these changes really necessary here? - It'd probably be cleaner to
>> change the initial functions to just take the card struct instead? (as
>> it's always available as priv->card)
>>
>> I'm guessing you're going to do something with the _* versions of
>> these functions later, so should this change be there instead?
>>
>
> Yes, these changes are necessary.  The enable and disable interrupt
> calls are called both from main.c as well as sdio.c.  main.c has
> access to and needs to call with a priv, while at least one of the
> calls from sdio.c happens before priv exists.  I could have changed
> the stuff in main.c to call with priv->card, but alas at the time I
> was still trying to minimize structural changes main.c and avoiding
> changes to the USB driver.

I'm no maintainer, but my opinion is that it's better to make
(sensible) sweeping changes to a code base, then add the changes you
want to make, rather than adding extra functions to access a
particular piece of functionality in different ways.

>>> @@ -187,7 +201,6 @@ static int if_sdio_handle_cmd(struct if_sdio_card *card,
>>>        struct lbtf_private *priv = card->priv;
>>>        int ret;
>>>        unsigned long flags;
>>> -       u8 i;
>>>
>>>        lbtf_deb_enter(LBTF_DEB_SDIO);
>>>
>>
>> Shouldn't this be elsewhere (maybe rolled into patch #1?)
>>
>
> It could be, but I didn't do this cleanup till now, some 20 commits
> later.  Not that easy to pick and choose which lines from an atomic
> commit go to which patch some weeks later.

I know it isn't - I'm doing exactly that for a project I'm working on,
and my MO is to split out such changes, then roll them into more
appropriate patches later. (e.g. if I'm making the foo() function do
bar work, and, in the process of doing this, fix a whole stack of
stupid code in it, I'll commit the latter first, then the former, then
roll the changes into more appropriate patches - even if that means
more work for me. - But then I am pedantic about that.) These changes
are, in a way, why I've run my particular fine tooth comb over your
patches - I'm bored =)

>>> diff --git a/drivers/net/wireless/libertas_tf/main.c b/drivers/net/wireless/libertas_tf/main.c
>>> index 119d625..14ce1bc 100644
>>> --- a/drivers/net/wireless/libertas_tf/main.c
>>> +++ b/drivers/net/wireless/libertas_tf/main.c
>>> @@ -150,14 +150,15 @@ static int lbtf_setup_firmware(struct lbtf_private *priv)
>>>        int ret = -1;
>>>
>>>        lbtf_deb_enter(LBTF_DEB_FW);
>>> +
>>>        /*
>>>         * Read priv address from HW
>>>         */
>>>        memset(priv->current_addr, 0xff, ETH_ALEN);
>>>        ret = lbtf_update_hw_spec(priv);
>>>        if (ret) {
>>> -               ret = -1;
>>> -               goto done;
>>> +                  ret = -1;
>>> +                  goto done;
>>>        }
>>>
>>>        lbtf_set_mac_control(priv);
>>
>> Whitespace change noise.
>
> Well, perhaps.  On the other hand, it made it more readable to me (the
> first one, the newline.  The indentation change is actually incorrect,
> no doubt about it).  Have you ever worked with a codebase for 3 some
> months and not incidentally or accidentally changed some whitespace?
> If this patch was just to change whitespace, then I'd agree with you
> and wouldn't have wasted time bothering to submit it, but the patch as
> a whole adds necessary functionality.

Yes, I have. (and it was over 3 years in my case)

>From what I understand, it's expected that white space changes and
other trivial cleanups get their own patches, mainly so that it's
easier to review separate patches. E.g. If I change the parameters
passed to bar(), and in the process lean up the whitespace in one of
the functions that calls it, those extra changes, whilst not that
significant, can make the patch harder to read. Some of the SCSI
maintainers get particularly pedantic about this, (with occasional
discussions on whether a piece of whitespace should or should not be
changed) but I expect the wireless folks are a little more relaxed. =)

I'm not meaning to lean on you over all of this, just running my eyes
over these patches.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
