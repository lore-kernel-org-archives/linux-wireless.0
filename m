Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:32495 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751564AbdB0Kd5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 27 Feb 2017 05:33:57 -0500
From: "Raja, Tamizh Chelvam" <c_traja@qti.qualcomm.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Subject: RE: [PATCHv2 0/4] cfg80211: mac80211: BTCOEX feature support
Date: Mon, 27 Feb 2017 10:33:50 +0000
Message-ID: <97411eac047e4516b757d432c27cfacd@aphydexm01f.ap.qualcomm.com> (sfid-20170227_113407_681937_2D43D37A)
References: <1488029873-14600-1-git-send-email-c_traja@qti.qualcomm.com>
 <d8f813bb-fd25-9957-360e-7aa4cd117822@broadcom.com>
In-Reply-To: <d8f813bb-fd25-9957-360e-7aa4cd117822@broadcom.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

> >
> > This patchset add support for BTCOEX feature to enable/disable and
> > modifying btcoex priority value via nl80211
> >
> > Tamizh chelvam (4):
> >   ath10k: Add support to enable or disable btcoex via nl80211
> >   ath10k: Add support to update btcoex priority value via nl80211
> >   dt: bindings: add new dt entry for BTCOEX feature in qcom,ath10k.txt
> >   ath10k: Add support to read btcoex related data from DT
>=20
> This cover letter does not seem to reflect the other patches that were se=
nt to
> the wireless list as those are about cfg80211/mac80211; not ath10k?

[Tamizh] ath10k patches are under progress, will send it soon.

>=20
> Regards,
> Arend
>=20
> > v2 :
> >   * Introduced NL80211_CMD_SET_BTCOEX to enable/disable btcoex and
> >     to set/modify btcoex_priority.
> >   * Added bool variable in wiphy structure to advertise btcoex_priority
> >     feature and removed BITMAP calculation for btcoex_priority value.
> >
> >  .../bindings/net/wireless/qcom,ath10k.txt          |    4 +
> >  drivers/net/wireless/ath/ath10k/core.c             |   44 ++++++++-
> >  drivers/net/wireless/ath/ath10k/core.h             |    9 ++
> >  drivers/net/wireless/ath/ath10k/debug.c            |   40 ++-------
> >  drivers/net/wireless/ath/ath10k/mac.c              |   94
> +++++++++++++++++++-
> >  drivers/net/wireless/ath/ath10k/mac.h              |    1 +
> >  drivers/net/wireless/ath/ath10k/wmi-ops.h          |   19 ++++
> >  drivers/net/wireless/ath/ath10k/wmi.c              |   20 +++++
> >  drivers/net/wireless/ath/ath10k/wmi.h              |   20 +++++
> >  9 files changed, 215 insertions(+), 36 deletions(-)
> >
