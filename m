Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63133 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501AbaLRGDH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 01:03:07 -0500
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	<linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 2/2] ath10k: send (re)assoc peer command when NSS changed
References: <1418719980-19753-1-git-send-email-janusz.dziedzic@tieto.com>
	<1418719980-19753-2-git-send-email-janusz.dziedzic@tieto.com>
	<87a92mr2gi.fsf@kamboji.qca.qualcomm.com>
	<CALhHN=rvAPMPOWyOM207sAiS+YQ2fWKEM0BO6d1KM7a+F6e3zQ@mail.gmail.com>
Date: Thu, 18 Dec 2014 08:02:59 +0200
In-Reply-To: <CALhHN=rvAPMPOWyOM207sAiS+YQ2fWKEM0BO6d1KM7a+F6e3zQ@mail.gmail.com>
	(Janusz Dziedzic's message of "Thu, 18 Dec 2014 06:28:22 +0100")
Message-ID: <87388dpka4.fsf@kamboji.qca.qualcomm.com> (sfid-20141218_070311_425323_6228F0AA)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:

> On 17 December 2014 at 11:32, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
>> Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:
>>
>>> Assoc peer command contain information about NSS.
>>> When we will get IEEE80211_RC_NSS_CHANGED we should
>>> also send (re) assoc peer command to be sure firmware
>>> will know about it and RC will work correctly.
>>>
>>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>>
>> Does this fix a user visible bug or is this something you just found
>> from doing code review?
>
> In case we will get only IEEE80211_RC_NSS_CHANGED we will not update
> FW configuration correctly. This is not the problem when IBSS, while
> we update two flags in one step IEEE80211_RC_SUPP_RATES_CHANGED |
> IEEE80211_RC_NSS_CHANGED.
>
> We could have problems when mac80211 will send only NSS_CHANGED flag.
> This seems could happen when we will get WLAN_EID_OPMODE_NOTIF. I
> didn't test such case, but I believe some AP could send such
> notification. So, this fix potential TP issue.

Ok, I'll add to the commit log that this was found during code review
(and doesn't fix a reported bug).

-- 
Kalle Valo
