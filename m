Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:41203 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757087Ab1JEWU5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 18:20:57 -0400
Received: by qadb15 with SMTP id b15so1625518qad.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 15:20:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E8AE1CC.5060703@openwrt.org>
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>
 <1317637758-11907-5-git-send-email-zefir.kurtisi@neratec.com>
 <CAB=NE6XxW_kMnWLkC4dy4naUKaTk_hZi0_F86LNyuk3RNyqNQA@mail.gmail.com>
 <4E8AD800.9040208@neratec.com> <4E8AE1CC.5060703@openwrt.org>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Wed, 5 Oct 2011 15:20:36 -0700
Message-ID: <CAB=NE6U5W8rxGXa0G13HkqOWFX7tMHAmBtnnSWO-YLLZvKHucg@mail.gmail.com> (sfid-20111006_002101_249854_7B58CEAB)
Subject: Re: [RFC 4/6] ath9k: add DFS build parameter
To: Felix Fietkau <nbd@openwrt.org>
Cc: Zefir Kurtisi <zefir.kurtisi@neratec.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kgiori@qca.qualcomm.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 4, 2011 at 3:37 AM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2011-10-04 11:55 AM, Zefir Kurtisi wrote:
>>
>> On 10/03/2011 08:26 PM, Luis R. Rodriguez wrote:
>>>
>>>  On Mon, Oct 3, 2011 at 3:29 AM, Zefir Kurtisi<zefir.kurtisi@neratec.com>
>>>  wrote:
>>>>
>>>>  Signed-off-by: Zefir Kurtisi<zefir.kurtisi@neratec.com>
>>>>  ---
>>>>  drivers/net/wireless/ath/ath9k/Kconfig  |    7 +++++++
>>>>  drivers/net/wireless/ath/ath9k/Makefile |    2 ++
>>>>  2 files changed, 9 insertions(+), 0 deletions(-)
>>>>
>>>>  diff --git a/drivers/net/wireless/ath/ath9k/Kconfig
>>>> b/drivers/net/wireless/ath/ath9k/Kconfig
>>>>  index d9c08c6..adddcca 100644
>>>>  --- a/drivers/net/wireless/ath/ath9k/Kconfig
>>>>  +++ b/drivers/net/wireless/ath/ath9k/Kconfig
>>>>  @@ -58,6 +58,13 @@ config ATH9K_RATE_CONTROL
>>>>          Say Y, if you want to use the ath9k specific rate control
>>>>          module instead of minstrel_ht.
>>>>
>>>>  +config ATH9K_DFS
>>>>  +       bool "Atheros ath9k DFS support"
>>>>  +       depends on ATH9K
>>>>  +       default y
>>>
>>>  At this point selecting y does nothing. Leave this patch out until
>>>  selecting "y" means something.
>>>
>> What do you mean by 'nothing'? It allows you to select DFS as ath9k
>> feature in your kernel configuration, or? Though, I agree that enabling it
>> by default is not a good idea.
>>
>>>  Default should be n, and in particular Atheros itself can only likely
>>>  commit to supporting DFS for AR9003 when it finds resources to do so
>>>  as well as properly test it, so DFS support kconfig should state this.
>>>  If someone wants to step up to completely support all bugs for older
>>>  families that is their prerogative but we cannot commit to it, due to
>>>  the regulatory considerations though unless this happens this cannot
>>>  and should not be enabled for older families in code.
>>>
>> In fact, AR9003 is the platform we are interested in. Although it
>> seems that older chipsets do also detect pulses with this patches
>> (AR9280 does, IIRC), I agree to limit DFS support to AR9003 (and later).
>> This should be easily possible by setting priv_ops->set_radar_params for
>> AR9003 only. I'll remove it for AR5008 in my v2 RFC.
>
> Please don't remove support code for older hardware. I'm fine with adding a
> SREV check that prevents it from being enabled by default on older hardware,
> but eventually I will need at least AR9280 DFS support for a few devices in
> OpenWrt.

That's fine, leaving it disabled is what I meant, and only once
something has been properly tested do we enable it. I personally only
want to spend my own energy on AR9003 and newer.

  Luis
