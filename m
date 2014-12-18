Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:44624 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750720AbaLRF2X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2014 00:28:23 -0500
Received: by mail-ie0-f179.google.com with SMTP id rp18so479921iec.38
        for <linux-wireless@vger.kernel.org>; Wed, 17 Dec 2014 21:28:22 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87a92mr2gi.fsf@kamboji.qca.qualcomm.com>
References: <1418719980-19753-1-git-send-email-janusz.dziedzic@tieto.com>
	<1418719980-19753-2-git-send-email-janusz.dziedzic@tieto.com>
	<87a92mr2gi.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 18 Dec 2014 06:28:22 +0100
Message-ID: <CALhHN=rvAPMPOWyOM207sAiS+YQ2fWKEM0BO6d1KM7a+F6e3zQ@mail.gmail.com> (sfid-20141218_062827_234204_96BE477D)
Subject: Re: [PATCH 2/2] ath10k: send (re)assoc peer command when NSS changed
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 December 2014 at 11:32, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Janusz Dziedzic <janusz.dziedzic@tieto.com> writes:
>
>> Assoc peer command contain information about NSS.
>> When we will get IEEE80211_RC_NSS_CHANGED we should
>> also send (re) assoc peer command to be sure firmware
>> will know about it and RC will work correctly.
>>
>> Signed-off-by: Janusz Dziedzic <janusz.dziedzic@tieto.com>
>
> Does this fix a user visible bug or is this something you just found
> from doing code review?
>
In case we will get only IEEE80211_RC_NSS_CHANGED we will not update
FW configuration correctly. This is not the problem when IBSS, while
we update two flags in one step IEEE80211_RC_SUPP_RATES_CHANGED |
IEEE80211_RC_NSS_CHANGED.
We could have problems when mac80211 will send only NSS_CHANGED flag.
This seems could happen when we will get  WLAN_EID_OPMODE_NOTIF. I
didn't test such case, but I believe some AP could send such
notification. So, this fix potential TP issue.

BR
Janusz
