Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mo4-p00-ob.smtp.rzone.de ([81.169.146.221]:49005 "EHLO
        mo4-p00-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750992AbcJEESf (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 5 Oct 2016 00:18:35 -0400
Subject: Re: [PATCHv3] wireless: check A-MSDU inner frame source address on AP
 interfaces
To: Johannes Berg <johannes@sipsolutions.net>
References: <1475075672-30549-1-git-send-email-michael-dev@fami-braun.de>
 <1475229714.17481.18.camel@sipsolutions.net>
 <f9d33317-f23f-9d5e-8e9e-1e63eff1882a@fem.tu-ilmenau.de>
 <1475569759.5324.22.camel@sipsolutions.net>
 <1475570219.5324.28.camel@sipsolutions.net>
 <b574378a-3710-7660-157f-4dacaa505d23@fami-braun.de>
Cc: kvalo@codeaurora.org, akarwar@marvell.com, nishants@marvell.com,
        Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
        linux-wireless@vger.kernel.org, projekt-wlan@fem.tu-ilmenau.de
From: "M. Braun" <michael-dev@fami-braun.de>
Message-ID: <b8f3ca31-501c-cb4c-c3cb-1d1dc48fa784@fami-braun.de> (sfid-20161005_061839_779292_2D59FA9D)
Date: Wed, 5 Oct 2016 06:17:56 +0200
MIME-Version: 1.0
In-Reply-To: <b574378a-3710-7660-157f-4dacaa505d23@fami-braun.de>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 04.10.2016 um 23:57 schrieb M. Braun:
>>  * pass both for IBSS mode (I think)
> 
> two more aspects for IBSS
> 
> 1. the PSK is shared by all stations, so a passive attacker on any
>    authenticated station in range will be able to derive it, right?
> 2. iff at all the source mac might be used for access control so
>    a TA==SA A-AMSDU filter might still be reasonable.

under the assumption that every station can only know about the keys it
is supposed to know, checking for da is multicast if ra is multicast is
needed as well so that the source address cannot be spoofed using GTK.

I'll send an updated version.

Michael
