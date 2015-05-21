Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:25262 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629AbbEUHkV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 May 2015 03:40:21 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>,
	"John W. Linville" <linville@tuxdriver.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] amth10k: fix promisc handling
References: <1431434736-7077-1-git-send-email-michal.kazior@tieto.com>
	<CA+BoTQ=dzJS447Gx+XAXPT6gZDDKZ__6scbxe0QC-iMA47bZmQ@mail.gmail.com>
Date: Thu, 21 May 2015 10:40:04 +0300
In-Reply-To: <CA+BoTQ=dzJS447Gx+XAXPT6gZDDKZ__6scbxe0QC-iMA47bZmQ@mail.gmail.com>
	(Michal Kazior's message of "Thu, 21 May 2015 07:40:38 +0200")
Message-ID: <874mn68jl7.fsf@kamboji.qca.qualcomm.com> (sfid-20150521_094025_534918_BCDAA34D)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Adding John as this involved wireless-testing

Michal Kazior <michal.kazior@tieto.com> writes:

> On 12 May 2015 at 14:45, Michal Kazior <michal.kazior@tieto.com> wrote:
>> Patch df1404650ccb ("mac80211: remove support for
>> IFF_PROMISC") removed promiscuous flag propagation
>> to drivers.
>>
>> However the patch was designed against ath10k
>> without 548462133d98 ("ath10k: fix interrupt
>> storm").
>>
>> After merge the code drifted into being no longer
>> correct and due to monitor vdev being
>> overzealously started caused IBSS to crash on
>> 999.999.0.636 for QCA988X (this firmware revision
>> is known to have issues with monitor vdev).
>>
>> This patch keeps expectations of commit
>> 548462133d98 (i.e. reduce irq storm by not
>> enabling monitor vdev for AP) and doesn't break
>> existing (known) setups that imply promiscuous
>> mode on network interfaces.
>>
>> Contrary to what it looks like 548462133d98
>> functionality is not reverted since the intention
>> was a subset of what df1404650ccb did.
>>
>> Fixes: c17c997d5613 ("Merge git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/wireless-drivers-next")
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> Apparently this also fixes some weird issues with qca6174 hw2.1 notably:
>  - ath10k causing disconnecting of other devices in a BSS
>  - random Fw crashes
>
> Both problems started to happen because c17c997d5613 enabled monitor
> vdev by default on STA interfaces. It seems that qca6174 hw2.1
> firmware has issues similar to those of qca988x 999.999.0.636
> regarding monitor vdev opration.
>
> Also, I've made a typo in the subject.
>
> I'll post v2 with subject fixed and extended commit log later.

Keep in mind that c17c997d5613 is actually from wireless-testing.git
which means that it will never go to wireless-drivers-next.git nor to
net-next.git. So the merge conflict bug is purely in
wireless-testing.git and in master branch of ath.git (but not in
ath-next branch!).

I think John should apply your v2 patch once you send it. But if you
have something which should be fixed in ath-next remember to send that
in a separate patch so that I can apply that directly to ath-next.

-- 
Kalle Valo
