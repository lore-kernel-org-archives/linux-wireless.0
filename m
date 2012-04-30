Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42641 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab2D3Fb6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 01:31:58 -0400
Received: by wibhj6 with SMTP id hj6so2486997wib.1
        for <linux-wireless@vger.kernel.org>; Sun, 29 Apr 2012 22:31:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CANUX_P2r9ifuj6fVmkfgfX21PMa1Cf_NpYXXup1YVdRLX+bH6w@mail.gmail.com>
References: <CANUX_P2r9ifuj6fVmkfgfX21PMa1Cf_NpYXXup1YVdRLX+bH6w@mail.gmail.com>
Date: Mon, 30 Apr 2012 08:31:56 +0300
Message-ID: <CANUX_P164q91DVQHd=Rf_672Q-U93wv0r7rgHRJLc-TMnjFC3A@mail.gmail.com> (sfid-20120430_073201_383073_3ACA0723)
Subject: Re: bss table corruption
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> For quite a while now (not sure I can tell exactly for how long) we
> see issues in association and scan list.
> We send probe before authentication, get the probe response but never
> send the authentication.
> Moreover a lot of entries in the BSS list are duplicated.
>
> I began to look at it and ended up to understand that these 2 issues
> are related: we just can't find an existing BSS in the BSS table.
> Obviously this causes the second issue. The reason was it breaks the
> association is that ieee80211_probe_auth will never be able to find
> the IEs of the probe response since we couldn't fetch the BSS when we
> parsed the probe response. In short:
>
>        if (auth_data->bss->proberesp_ies) {
> always return false.... and we fall back to send yet another probe request.
>
> As you probably know, the BSS table is implemented with an Red Black
> Tree which requires its elements to be comparable. The compare
> function compares the BSSID which is not always unique (there can be
> several SSIDs on the same BSSID), so all the IEs are also compared.
> But is this a good idea ?
> It seems that since the IEs of an BSS may change from time to time
> this compare function is not consistent...

Oops. Stupid me. Just noticed that we compare the SSID only...
So how come ?

>
> Just for playing I always return a positive value in cmp_bss (to have
> all the nodes serialized and avoid the possibility to miss a existing
> node) and don't rebalance the tree after insertion... the bug
> disappeared.
>
> Thought ?
>
> Emmanuel Grumbach
> egrumbach@gmail.com
