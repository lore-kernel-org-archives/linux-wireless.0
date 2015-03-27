Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:41629 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467AbbC0MmB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2015 08:42:01 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: Marek Puzyniak <marek.puzyniak@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: Re: [PATCH v4 1/6] ath10k: unify tx mode and dispatch
References: <1426849379-7562-1-git-send-email-marek.puzyniak@tieto.com>
	<1426849379-7562-2-git-send-email-marek.puzyniak@tieto.com>
	<CA+BoTQm74JDvMk=G2Hot7h4v4gU4gRh8JH0K=1yhMa_UGQ4e0A@mail.gmail.com>
	<CA+BoTQmk+KzhO1xa3AP9tiDnEVG36OD5WoV+VwRCtvSF1sEtMw@mail.gmail.com>
Date: Fri, 27 Mar 2015 14:41:44 +0200
In-Reply-To: <CA+BoTQmk+KzhO1xa3AP9tiDnEVG36OD5WoV+VwRCtvSF1sEtMw@mail.gmail.com>
	(Michal Kazior's message of "Thu, 26 Mar 2015 11:03:08 +0100")
Message-ID: <87wq227gtz.fsf@kamboji.qca.qualcomm.com> (sfid-20150327_134207_299111_0F6D3153)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 26 March 2015 at 10:27, Michal Kazior <michal.kazior@tieto.com> wrote:
>> On 20 March 2015 at 12:02, Marek Puzyniak <marek.puzyniak@tieto.com> wrote:
>>> From: Michal Kazior <michal.kazior@tieto.com>
>>>
>>> There are a few different tx paths depending on
>>> firmware and frame itself.
>>>
>>> Creating a uniform decision will make it possible
>>> to switch between different txmode easier, both
>>> for testing and for future features as well.
>>>
>>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>>> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
>> [...]
>>
>> This patch apparently breaks AP operation. I need to investigate this.
>
> Ok - htt.freq missed clearing and in some cases it contained garbage
> leading to HTT discarding packets.
>
> @Kalle: I've posted a patch `ath10k: clear htt.freq` which addresses
> the problem separately. Please apply it _before_ you apply TDLS
> patches (which are fine, including this patch) to avoid breakage
> in-between commits.

Ack, I'll do that. Thanks for fixing this.

-- 
Kalle Valo
