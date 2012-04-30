Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:33252 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750695Ab2D3F2Z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Apr 2012 01:28:25 -0400
Received: by wgbdr13 with SMTP id dr13so182393wgb.1
        for <linux-wireless@vger.kernel.org>; Sun, 29 Apr 2012 22:28:24 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 30 Apr 2012 08:28:24 +0300
Message-ID: <CANUX_P2r9ifuj6fVmkfgfX21PMa1Cf_NpYXXup1YVdRLX+bH6w@mail.gmail.com> (sfid-20120430_072829_374709_C26E7DE6)
Subject: bss table corruption
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For quite a while now (not sure I can tell exactly for how long) we
see issues in association and scan list.
We send probe before authentication, get the probe response but never
send the authentication.
Moreover a lot of entries in the BSS list are duplicated.

I began to look at it and ended up to understand that these 2 issues
are related: we just can't find an existing BSS in the BSS table.
Obviously this causes the second issue. The reason was it breaks the
association is that ieee80211_probe_auth will never be able to find
the IEs of the probe response since we couldn't fetch the BSS when we
parsed the probe response. In short:

	if (auth_data->bss->proberesp_ies) {
always return false.... and we fall back to send yet another probe request.

As you probably know, the BSS table is implemented with an Red Black
Tree which requires its elements to be comparable. The compare
function compares the BSSID which is not always unique (there can be
several SSIDs on the same BSSID), so all the IEs are also compared.
But is this a good idea ?
It seems that since the IEs of an BSS may change from time to time
this compare function is not consistent...

Just for playing I always return a positive value in cmp_bss (to have
all the nodes serialized and avoid the possibility to miss a existing
node) and don't rebalance the tree after insertion... the bug
disappeared.

Thought ?

Emmanuel Grumbach
egrumbach@gmail.com
