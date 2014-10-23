Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:8149 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbaJWOKi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Oct 2014 10:10:38 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
Subject: Re: [PATCH 1/2] ath10k: remove tsf argument from rx_desc tracing
References: <1413899700-10717-1-git-send-email-michal.kazior@tieto.com>
	<1413899700-10717-2-git-send-email-michal.kazior@tieto.com>
	<CA+BoTQmr=uZNeqKxoHM5sG2EU7sBfdETXvzuXkNxDjTJ9ANAbg@mail.gmail.com>
Date: Thu, 23 Oct 2014 17:10:31 +0300
In-Reply-To: <CA+BoTQmr=uZNeqKxoHM5sG2EU7sBfdETXvzuXkNxDjTJ9ANAbg@mail.gmail.com>
	(Michal Kazior's message of "Wed, 22 Oct 2014 10:46:43 +0200")
Message-ID: <878uk6q3l4.fsf@kamboji.qca.qualcomm.com> (sfid-20141023_161041_592978_2FDDB42D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> On 21 October 2014 15:54, Michal Kazior <michal.kazior@tieto.com> wrote:
>> Fundamtenally this was wrong. Tsf is only valid
>> in first MPDU of a PPDU. This means tsf value was
>
> s/first MPDU/last MPDU/
>
> I must've had a brain fart when writing the commit log yesterday.
>
> @Kalle: Should I re-spin or will you fix it before applying?

No need to re-spin, I edited the commit log in ath-next-test. I also
fixed a typo in "fundamentally".

commit d75153c577ddfffa9e7438e8225dfaf564f34552
Author: Michal Kazior <michal.kazior@tieto.com>
Date:   Thu Oct 23 17:04:27 2014 +0300

    ath10k: remove tsf argument from rx_desc tracing
    
    Fundamentally this was wrong. Tsf is only valid
    in last MPDU of a PPDU. This means tsf value was
    wrong most of the time during heavy traffic.
    
    Also I don't see much point in exposing a
    redundant (and broken) tsf value. Userspace can
    already read it from the dumped rx descriptor
    buffer.
    
    Cc: Rajkumar Manoharan <rmanohar@qti.qualcomm.com>
    Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
    Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>


-- 
Kalle Valo
