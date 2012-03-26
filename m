Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4017 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932982Ab2CZQyp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 Mar 2012 12:54:45 -0400
Message-ID: <4F709F3E.1090405@broadcom.com> (sfid-20120326_185448_676889_C7C5B2B5)
Date: Mon, 26 Mar 2012 18:54:22 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Seth Forshee" <seth.forshee@canonical.com>
cc: =?UTF-8?B?Q2FtYWxlw7Nu?= <noelamac@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"sgruszka@redhat.com" <sgruszka@redhat.com>,
	"jrnieder@gmail.com" <jrnieder@gmail.com>
Subject: Re: brcmsmac still woes, possible regression?
References: <CAKprTDELdRWtJWpmn9RMuMUYXxuaR6Cf41+jot4_fZixHQtcMw@mail.gmail.com>
 <4F6D939F.3030206@broadcom.com>
 <CAKprTDHSyh2Sv2wyY0hg4cjzWobV-zA4stY19-vB_hOBVAq5KQ@mail.gmail.com>
 <CAKprTDHpLtPu2+navGzJU9K8XX-h=Purw_q_Qs2mYn4QFEex+w@mail.gmail.com>
 <4F7035AD.1080503@broadcom.com> <20120326143232.GA17126@thinkpad-t410>
In-Reply-To: <20120326143232.GA17126@thinkpad-t410>
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 03/26/2012 04:32 PM, Seth Forshee wrote:
> On Mon, Mar 26, 2012 at 11:23:57AM +0200, Arend van Spriel wrote:
>>
>> The WARNING message is preceded by a cfg80211 message regarding
>> world regulatory domain. I suspect there is a relatio, but not sure
>> what it is. Regarding channels 12 and 13 I will come up with a fix
>> today and send you the patch to try.
>
> The trace is related to handling a disconnection, which will also
> trigger a reprocessing of the regulatory rules. The warning and the
> regulatory message share a common cause, but I don't think there's a
> direct relationship between them.

Thanks, Seth

I agree. That seems a more accurate statement. Without additional 
tracing (from e.g. wpa_supplicant?) it is hard to say what caused the 
disconnect.

> This also seems to indicate that by the time either of these messages
> appears the connection with the AP is already in the process of being
> dropped. I don't think the regulatory messages give any cluse as to why
> the connection was dropped. I suppose the warning might but I don't
> know.

I suspect the warning is caused because mac80211 flush callback is done 
after scanning on channels 12 and/or 13. I have a quick fix. The longer 
and preferred fix would be to cleanup channel.c and incorporate your 
regdom change. I plan to do that in separate patches.

Gr. AvS

