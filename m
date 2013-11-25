Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f173.google.com ([74.125.82.173]:40919 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab3KYKLs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 05:11:48 -0500
Received: by mail-we0-f173.google.com with SMTP id t61so3567471wes.18
        for <linux-wireless@vger.kernel.org>; Mon, 25 Nov 2013 02:11:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87k3fxsycw.fsf@kamboji.qca.qualcomm.com>
References: <1385126819-15311-1-git-send-email-michal.kazior@tieto.com>
	<1385126819-15311-2-git-send-email-michal.kazior@tieto.com>
	<87k3fxsycw.fsf@kamboji.qca.qualcomm.com>
Date: Mon, 25 Nov 2013 11:11:46 +0100
Message-ID: <CA+BoTQnFJzGNK7605M9XUhQK=sxhqHW=9h-ytvgcCci4Knj1ww@mail.gmail.com> (sfid-20131125_111154_040479_30CD0599)
Subject: Re: [PATCH 1/3] ath10k: use nss provided by mac80211
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 24 November 2013 14:50, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> Calculating STA NSS just from the rateset is not
>> the greatest idea. The NSS could be possibly
>> influenced by other things that only mac80211
>> knows about.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> Is there a bug which this patch fixes or what motivated you to do this?

This doesn't fix any bug that I know of. It just seems like probably
should use rx_nss instead of calculating it on our own (in case
something changes in the future).

A station may actually include operation mode change notification in
assoc request declaring it wants to use a different number of streams
than it actually supports as per its mcs map. That's not supported in
mac80211 though yet. Marek has posted some patches a few days ago but
it actually uses a different codepath from what I understand.


Michał
