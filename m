Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f178.google.com ([74.125.82.178]:46525 "EHLO
	mail-we0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276AbbCFIij (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Mar 2015 03:38:39 -0500
Received: by wevm14 with SMTP id m14so57949984wev.13
        for <linux-wireless@vger.kernel.org>; Fri, 06 Mar 2015 00:38:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAGnRvurPGf1fvYs6fyrc7kttT8g3+ST_3mO5P6+mwdbU4Ay7yA@mail.gmail.com>
References: <CAGnRvurPGf1fvYs6fyrc7kttT8g3+ST_3mO5P6+mwdbU4Ay7yA@mail.gmail.com>
Date: Fri, 6 Mar 2015 09:38:37 +0100
Message-ID: <CALhHN=ofus+Uop7i8Cv7SVhmDSjA9O56xSokTr=PtmddCqczEA@mail.gmail.com> (sfid-20150306_093849_309569_4D79EAE6)
Subject: Re: State of DFS with Mac80211/ath9k
From: Janusz Dziedzic <janusz.dziedzic@tieto.com>
To: Henning Rogge <hrogge@gmail.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 6 March 2015 at 09:04, Henning Rogge <hrogge@gmail.com> wrote:
> Hi,
>
> I am working with a co-worker on DFS-support for the 802.11s
> implementation of the mac80211 stack.
>
> As a test we just removed the test for "DFS not supported" from
> net/mac80211/mesh.c, but we are still facing two problems.
>
> First, we cannot open a Mesh interface on a DFS channel unless we open
> an AP interface first (and closing the AP interface before activating
> the mesh). Are we missing some special initialization?
>
I think this works beacause we didn't integrate patch:
[PATCH v5] cfg80211: fix dfs channel state after stopping AP
and discussion here:
http://comments.gmane.org/gmane.linux.kernel.wireless.general/117095

Anyway I think this is a BUG while for example:
1) we can run AP (CAC) on chanel 36
2) next shut down AP
3) wait few days with loaded cfg80211 and in the same time for example
move to other location (AP in bus/train)
4) we don't need run CAC again - for me this is a cfg80211 bug :)

Anyway, before you can beaconing you should perform CAC, so this
should be added to wpa_supplicant - currently this is not implemented.

> Second, we are seeing a huge amount of radar events on some nodes, but
> not on a node on the same channel in the next room. What is the status
> of the DFS detector in ath9k, is it reliable or is it still
> "experimental".
>
We tested/using ath10k hw, so I don't know ath9k status :)

BR
Janusz
