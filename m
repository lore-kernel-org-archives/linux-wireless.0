Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:46605 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752606Ab3LMML1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Dec 2013 07:11:27 -0500
From: Avinash Patil <patila@marvell.com>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Bing Zhao <bzhao@marvell.com>,
	Nishant Sarmukadam <nishants@marvell.com>,
	Amitkumar Karwar <akarwar@marvell.com>
Date: Fri, 13 Dec 2013 04:11:17 -0800
Subject: RE: [RFC] cfg80211: set regulatory request processed for initiator
 core
Message-ID: <CBACCFA0AEB13A41977475BCF3E896FC22D092D7F3@SC-VEXCH2.marvell.com> (sfid-20131213_131148_148073_B42739CF)
References: <20131207035407.GA19456@pe-lt052.marvell.com>
 <CAB=NE6Xs7mgp6oM4VTXHjKGgPnsPz5v=2O4LwPKu=Cm4V4P7fw@mail.gmail.com>,<CAB=NE6UFYSfrScF-SO-_JA1KOiDsYY58Adaqd5p-QD20pUrYRA@mail.gmail.com>
In-Reply-To: <CAB=NE6UFYSfrScF-SO-_JA1KOiDsYY58Adaqd5p-QD20pUrYRA@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

I am using 3.13rc2 kernel; last commit on this branch is "ad17d104284ea4a301126b475df3bef03258142a".

If we set regulatory domain via "iw reg set US" we see following in dmesg logs:
cfg80211: Pending regulatory request, waiting for it to be processed...
Udevm monitor (via udevadm monitor --environment kernel) also does not print any CRDA domain change messages.

I have pasted dmesg logs at following location:
http://pastebin.com/kkNagpSu

If we apply below mentioned patch, last request is set to processed enabling cfg80211 to send further requests.

Thanks,
Avinash Patil


________________________________________
From: mcgrof@gmail.com [mcgrof@gmail.com] On Behalf Of Luis R. Rodriguez [mcgrof@do-not-panic.com]
Sent: Wednesday, December 11, 2013 11:31 PM
To: Avinash Patil
Cc: Johannes Berg; linux-wireless
Subject: Re: [RFC] cfg80211: set regulatory request processed for initiator core

On Wed, Dec 11, 2013 at 6:38 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> On Sat, Dec 7, 2013 at 4:54 AM, Avinash Patil <patila@marvell.com> wrote:
>> During cfg80211 init, cfg80211 initializes regulatory to set to
>> world domain. Here we dont set last request processed flag.
>> This results into further request set to pending indefinitely.
>>
>> This patch fixes this by setting last request to processed.
>>
>> Signed-off-by: Avinash Patil <patila@marvell.com>
>> ---
>>  net/wireless/reg.c |    2 ++
>>  1 files changed, 2 insertions(+), 0 deletions(-)
>>
>> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
>> index ec54e1a..70a8f0a 100644
>> --- a/net/wireless/reg.c
>> +++ b/net/wireless/reg.c
>> @@ -1670,6 +1670,8 @@ static void reg_process_hint(struct regulatory_request *reg_request)
>>         switch (reg_request->initiator) {
>>         case NL80211_REGDOM_SET_BY_CORE:
>>                 reg_process_hint_core(reg_request);
>> +               nl80211_send_reg_change_event(reg_request);
>> +               reg_set_request_processed();
>>                 return;
>>         case NL80211_REGDOM_SET_BY_USER:
>>                 treatment = reg_process_hint_user(reg_request);
>
> NACK, the reg_process_hint() is supposed to *process* a request, and
> then call the internal regdb if its there and also call CRDA. Later
> whoever sends the regulatory domain and gets cfg80211 to process it
> will have reg_set_request_processed() called.
>
> Can you verify if CRDA is sending the regulatory domains to cfg80211?

Also are you seeing this with wireless-testing ?

  Luis