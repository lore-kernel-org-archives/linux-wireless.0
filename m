Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:63635 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933461AbaDJG4k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Apr 2014 02:56:40 -0400
Received: by mail-we0-f173.google.com with SMTP id w61so3556892wes.32
        for <linux-wireless@vger.kernel.org>; Wed, 09 Apr 2014 23:56:39 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <87ob09he5h.fsf@kamboji.qca.qualcomm.com>
References: <1396611464-5940-1-git-send-email-michal.kazior@tieto.com>
	<1397040531-6224-1-git-send-email-michal.kazior@tieto.com>
	<1397040531-6224-4-git-send-email-michal.kazior@tieto.com>
	<87ob09he5h.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 10 Apr 2014 08:56:38 +0200
Message-ID: <CA+BoTQkTvOvjW51R2YmtW_5_5jtKan1u6jRY3_82FRZnZG2jEw@mail.gmail.com> (sfid-20140410_085645_624915_E2EAAFE4)
Subject: Re: [RFTv2 3/5] ath10k: rework peer accounting
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Ben Greear <greearb@candelatech.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 April 2014 08:50, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> It was troublesome to iterate over peers and
>> perform sleepable calls. This will be necessary
>> for some upcomming changes to tx flushing.
>>
>> Make peer allocation and initial setup
>> protected by both ar->conf_mutex and
>> ar->data_lock. This way it's possible to iterate
>> over peers with conf_mutex and call sleepable
>> functions.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> Sorry, but I'm not really getting your idea here of using both
> conf_mutex and data_lock to protect ar->peers. Can you elaborate more,
> please? Why can't we just use conf_mutex then? What am I missing?

Originally ar->peers was protected by data_lock. The reason for that
the list is accessed from a tasklet context for htt peer map/unmap
events. Originally those events allocated/freed peers. This however is
cumbersome to work with when you want to iterate over peers and issue
blocking/sleepable calls (e.g. flush tx via wmi).

Having conf_mutex-only protected conf_mutex would require htt peer
map/unmap event processing to be moved into sleepable context (e.g.
into a worker).

That's why I've made ar->peers being write-protected by both so that
it can be read while holding any of these locks.

I'll try to make the commit message clearer.


Michał
