Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:34710 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753048AbcKNXZS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 18:25:18 -0500
Received: by mail-it0-f67.google.com with SMTP id q124so17713761itd.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2016 15:25:17 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <4fd6af4b02474a3eb4acfbe421bd6a24@nldataex02.ad.fugro.com>
References: <20161018083552.28592-1-a@unstable.cc> <87lgxbxl2d.fsf@purkki.adurom.net>
 <20161026141016.GB26376@prodigo.lan> <87bmy65nz8.fsf@kamboji.qca.qualcomm.com>
 <62a2dc74-4a7c-d3d4-4170-4d5759b07ab3@dd-wrt.com> <1477580802.4534.20.camel@sipsolutions.net>
 <4fd6af4b02474a3eb4acfbe421bd6a24@nldataex02.ad.fugro.com>
From: Adrian Chadd <adrian@freebsd.org>
Date: Mon, 14 Nov 2016 15:25:16 -0800
Message-ID: <CAJ-VmonW7jR0vnnZmj8CsvY-6-O--L68LpBxcuXQ8Pk46AOQNQ@mail.gmail.com> (sfid-20161115_002521_385964_FD3B4DC2)
Subject: Re: [ath9k-devel] [NOT FOR MERGE] ath9k: work around key cache corruption
To: "Stam, Michel [FINT]" <m.stam@fugro.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        Sebastian Gottschall <s.gottschall@dd-wrt.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Antonio Quartulli <a@unstable.cc>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Antonio Quartulli <antonio@open-mesh.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hiya,

maybe the right thing to do is to set a flag that says "please
replumb", then do a reset, and have the reset path see if we need to
replumb keys and do so?

To make locking less terrible, maybe we need to cache the keys in the
ath9k driver somewhere so replumbing doesn't require reaching into
mac82011.



-adrian
