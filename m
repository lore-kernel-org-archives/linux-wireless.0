Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:38065 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbbCFJ1B (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 04:27:01 -0500
Received: by widex7 with SMTP id ex7so1337874wid.3
        for <linux-wireless@vger.kernel.org>; Fri, 06 Mar 2015 01:27:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CALhHN=ofus+Uop7i8Cv7SVhmDSjA9O56xSokTr=PtmddCqczEA@mail.gmail.com>
References: <CAGnRvurPGf1fvYs6fyrc7kttT8g3+ST_3mO5P6+mwdbU4Ay7yA@mail.gmail.com>
 <CALhHN=ofus+Uop7i8Cv7SVhmDSjA9O56xSokTr=PtmddCqczEA@mail.gmail.com>
From: Henning Rogge <hrogge@gmail.com>
Date: Fri, 6 Mar 2015 10:26:39 +0100
Message-ID: <CAGnRvupZGXfaf-PH2aoNYzUziFBwMw2m-Ftvx0VVysmx9NNdvQ@mail.gmail.com> (sfid-20150306_102708_837389_7DDBBD84)
Subject: Re: State of DFS with Mac80211/ath9k
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Mar 6, 2015 at 9:38 AM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
> On 6 March 2015 at 09:04, Henning Rogge <hrogge@gmail.com> wrote:
>> First, we cannot open a Mesh interface on a DFS channel unless we open
>> an AP interface first (and closing the AP interface before activating
>> the mesh). Are we missing some special initialization?
>>
> I think this works beacause we didn't integrate patch:
> [PATCH v5] cfg80211: fix dfs channel state after stopping AP
> and discussion here:
> http://comments.gmane.org/gmane.linux.kernel.wireless.general/117095
>
> Anyway I think this is a BUG while for example:
> 1) we can run AP (CAC) on chanel 36
> 2) next shut down AP
> 3) wait few days with loaded cfg80211 and in the same time for example
> move to other location (AP in bus/train)
> 4) we don't need run CAC again - for me this is a cfg80211 bug :)

Yes, this sounds like a bug... when wpa_supplicant "disconnects" from
the mac80211 stack the flag should revert to "dfs not available". But
I am not sure if you can easily detect that wpa_supplicant is not
there anymore.

> Anyway, before you can beaconing you should perform CAC, so this
> should be added to wpa_supplicant - currently this is not implemented.

Has the "802.11s support" ever been merged to wpa_supplicant?

At the moment we are using neither wpa_supplicant nor hostapd... when
we use encryption, we use the authsae tool from the open802.11s page.

>> Second, we are seeing a huge amount of radar events on some nodes, but
>> not on a node on the same channel in the next room. What is the status
>> of the DFS detector in ath9k, is it reliable or is it still
>> "experimental".
>>
> We tested/using ath10k hw, so I don't know ath9k status :)

Thank you for the information.

Henning Rogge
