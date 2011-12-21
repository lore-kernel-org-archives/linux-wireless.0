Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:35752 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752816Ab1LUX2r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Dec 2011 18:28:47 -0500
Received: by wgbdr13 with SMTP id dr13so14984811wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 21 Dec 2011 15:28:46 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1324484074.13074.313.camel@wwguy-huron>
References: <CAH5vBdJLHkFLQCHHYOczXQt1Hwwe3e-Ct0MUjyTRU0vgodAPOg@mail.gmail.com>
 <1324424765.13074.281.camel@wwguy-huron> <CAH5vBdKotiPqpHV=tx2fv8=-HRBuJnYe8wEAF2Z9xH3zVnwyqg@mail.gmail.com>
 <CA+icZUXWccU-TtwE7b7Mm9Nw7juQwDxvYRZfOdjP3q1O-Mr0Ug@mail.gmail.com>
 <CAH5vBdKtV1Ydb2ffBVDxdynsF9S14Ddy6XezHzXvRC3bRC-huQ@mail.gmail.com>
 <CA+icZUXDOxNo-Y9d2WcdhMZyDJeCT69z340xMwNiN9hbq0XAFA@mail.gmail.com>
 <CAH5vBdLq6zOagjmyM1h9Jon+fYnz5t05Dx7u6VqOWGHna+M3_Q@mail.gmail.com>
 <CA+icZUVixfk0h1ENU-tWMS5hgurbEV4jYpYNWbzaxCUx_b64UQ@mail.gmail.com>
 <CAH5vBdK62juwC_qPPTfmgFkMp9XMy+3j1YLvBSxBc+zr9_oBJQ@mail.gmail.com>
 <CA+icZUUhg91UAPMRGgXYAvo6wkr5ogb+vW8SsB28BeUP_6-g6w@mail.gmail.com> <1324484074.13074.313.camel@wwguy-huron>
From: Cheng Renquan <crquan@gmail.com>
Date: Wed, 21 Dec 2011 15:28:25 -0800
Message-ID: <CAH5vBdJ4-33z3FbOwVG1QRzfFOwFpz1wccbQNDXEC6-NhBa31A@mail.gmail.com> (sfid-20111222_002857_091582_D34ACDF2)
Subject: Re: linux 3.2-rcX iwlwifi driver's problem (wifi link unstable when
 moving between multiple APs)
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>,
	Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I cherry-picked these 3 patches on top to v3.2.0-rc6, and now it's working,
Thank you all everyone's effort;

[archuser@archtop linux-git]$ git cherry-pick 123877b80
[b46 55de35a] iwlwifi: do not set the sequence control bit is not needed
 Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
 1 files changed, 4 insertions(+), 1 deletions(-)
[archuser@archtop linux-git]$ git cherry-pick 81670a49184
[b46 1b0b51d] iwlwifi: tx_sync only on PAN context
 Author: Johannes Berg <johannes.berg@intel.com>
 1 files changed, 6 insertions(+), 0 deletions(-)
[archuser@archtop linux-git]$ git cherry-pick 78feb35b81
[b46 73d79e2] iwlwifi: allow to switch to HT40 if not associated
 Author: Wey-Yi Guy <wey-yi.w.guy@intel.com>
 1 files changed, 2 insertions(+), 2 deletions(-)


When walking to some corner meeting rooms (but still has good
wifi connectivity, verified by another Android phone wifi ;),
the roaming may be from previous AP to none and none to next AP,
the process may need 1 to 2 minutes to be stable again, it's not
ideally swift but acceptable,


Dec 21 14:59:11 archtop NetworkManager[2333]: <info> (wlan0): roamed
from BSSID 24:B6:57:34:CC:5F (blizzard) to 6C:9C:ED:EC:BC:7F
(blizzard)
Dec 21 14:59:41 archtop NetworkManager[2333]: <info> (wlan0): roamed
from BSSID 6C:9C:ED:EC:BC:7F (blizzard) to (none) ((none))
Dec 21 14:59:53 archtop NetworkManager[2333]: <info> (wlan0): roamed
from BSSID (none) ((none)) to 2C:3F:38:F6:A8:AF (blizzard)


Thanks,
