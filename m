Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:38651 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978AbbCZKDK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2015 06:03:10 -0400
Received: by wibgn9 with SMTP id gn9so77483888wib.1
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2015 03:03:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+BoTQm74JDvMk=G2Hot7h4v4gU4gRh8JH0K=1yhMa_UGQ4e0A@mail.gmail.com>
References: <1426849379-7562-1-git-send-email-marek.puzyniak@tieto.com>
	<1426849379-7562-2-git-send-email-marek.puzyniak@tieto.com>
	<CA+BoTQm74JDvMk=G2Hot7h4v4gU4gRh8JH0K=1yhMa_UGQ4e0A@mail.gmail.com>
Date: Thu, 26 Mar 2015 11:03:08 +0100
Message-ID: <CA+BoTQmk+KzhO1xa3AP9tiDnEVG36OD5WoV+VwRCtvSF1sEtMw@mail.gmail.com> (sfid-20150326_110315_261884_41581B5F)
Subject: Re: [PATCH v4 1/6] ath10k: unify tx mode and dispatch
From: Michal Kazior <michal.kazior@tieto.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>,
	Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 26 March 2015 at 10:27, Michal Kazior <michal.kazior@tieto.com> wrote:
> On 20 March 2015 at 12:02, Marek Puzyniak <marek.puzyniak@tieto.com> wrote:
>> From: Michal Kazior <michal.kazior@tieto.com>
>>
>> There are a few different tx paths depending on
>> firmware and frame itself.
>>
>> Creating a uniform decision will make it possible
>> to switch between different txmode easier, both
>> for testing and for future features as well.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
> [...]
>
> This patch apparently breaks AP operation. I need to investigate this.

Ok - htt.freq missed clearing and in some cases it contained garbage
leading to HTT discarding packets.

@Kalle: I've posted a patch `ath10k: clear htt.freq` which addresses
the problem separately. Please apply it _before_ you apply TDLS
patches (which are fine, including this patch) to avoid breakage
in-between commits.


Michał
