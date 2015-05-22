Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38226 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756570AbbEVMiH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 22 May 2015 08:38:07 -0400
Received: by wichy4 with SMTP id hy4so45882245wic.1
        for <linux-wireless@vger.kernel.org>; Fri, 22 May 2015 05:38:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87r3q84x1j.fsf@kamboji.qca.qualcomm.com>
References: <87k2w26oef.fsf@kamboji.qca.qualcomm.com>
	<CA+BoTQmukTiNFrsLA5rdiQe=Ga45JNuFzSmqQ4h-VJMW97f=_w@mail.gmail.com>
	<87r3q84x1j.fsf@kamboji.qca.qualcomm.com>
Date: Fri, 22 May 2015 14:38:05 +0200
Message-ID: <CA+BoTQneUoKq_Gh=A=-=RLn7TUrfdAm8UwQkUvJGgBDDwaqKpA@mail.gmail.com> (sfid-20150522_143814_374293_0118A1AF)
Subject: Re: pull-request: wireless-drivers-next 2015-05-21
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: David Miller <davem@davemloft.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 22 May 2015 at 14:27, Kalle Valo <kvalo@codeaurora.org> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>> On 21 May 2015 at 15:39, Kalle Valo <kvalo@codeaurora.org> wrote:
[...]
>>> + static int ath10k_vdev_start_restart(struct ath10k_vif *arvif,
>>> +                                    const struct cfg80211_chan_def *chandef,
>>> +                                    bool restart)
>>>   {
>>>         struct ath10k *ar = arvif->ar;
>>> -       struct cfg80211_chan_def *chandef = &ar->chandef;
>>>         struct wmi_vdev_start_request_arg arg = {};
>>>  -      int ret = 0, ret2;
>>>  +      int ret = 0;
>>>
>>>         lockdep_assert_held(&ar->conf_mutex);
>>>
>>
>> Kalle, I'm not seeing this when I merge your pull tag on top of
>> net-next/master. Am I missing something?
>
> You lost me, you are not seeing what?

Your merge resolution diff seems to include stuff regarding
ath10k_vdev_stop(). I didn't see it when I tried the merge and had
only 2 conflicts: the promisc code and at feature flags (XMIT_FAST).


> I think we have a misunderstanding

That's possible.


> here, let me explain how I created that diff:
>
> git clone --reference ~/linux-2.6/ git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
> cd net-next/
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next.git tags/wireless-drivers-next-for-davem-2015-05-21
> emacs drivers/net/wireless/ath/ath10k/mac.c
> git diff > resolution.txt

For what it's worth I did:
 git checkout net-next/master
 git merge wireless-drivers-next-for-davem-2015-05-21
 # fix conflicts
 git commit -a
 git show

Merge should essentially yield the same result as your pull.


Michał
