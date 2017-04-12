Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14555 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752278AbdDLHId (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 12 Apr 2017 03:08:33 -0400
From: Tamizh Chelvam Raja <c_traja@qti.qualcomm.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "tamizhchelvam@codeaurora.org" <tamizhchelvam@codeaurora.org>,
        "linux-bluetooth@vger.kernel.org" <linux-bluetooth@vger.kernel.org>,
        "Marcel Holtmann" <marcel@holtmann.org>
Subject: RE: [PATCHv4 0/2] cfg80211: mac80211: BTCOEX feature support
Date: Wed, 12 Apr 2017 07:08:25 +0000
Message-ID: <efe890d95d374af7b7a8839811afe0d8@aphydexm01f.ap.qualcomm.com> (sfid-20170412_090920_575423_1AB09C52)
References: <1491905730-16392-1-git-send-email-c_traja@qti.qualcomm.com>
 <50d867d1-740c-85b9-2bab-6ef49c4d87c1@broadcom.com>
In-Reply-To: <50d867d1-740c-85b9-2bab-6ef49c4d87c1@broadcom.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> + linux-bluetooth, Marcel
>=20
> On 11-4-2017 12:15, c_traja@qti.qualcomm.com wrote:
> > From: Tamizh chelvam <c_traja@qti.qualcomm.com>
> >
> > This patchset add support for BTCOEX feature to enable/disable and
> > modifying btcoex priority value via nl80211
>=20
> So you make a distinction between WMM ACs, but what about the different
> types/profiles of BT traffic?
>
[Tamizh] There will be BT high and BT low traffic. It will be decided by BT=
 module. Firmware internally checks BT low traffic with wlan traffic. If we=
 enable some of
wlan frames as high priority, those frames will have more priority than BT =
low traffic.
=20
> Regards,
> Arend
>=20
> > Tamizh chelvam (2):
> >   cfg80211: Add support to enable or disable btcoex and set
> >     btcoex_priority
> >   mac80211: Add support to enable or disable btcoex and set btcoex
> >     priority value
> >
> > v4 :
> >   * Moved btcoex_priority_support_flag enum to nl80211.h and renamed it=
.
> >   * fixed typo.
> >
> > v3 :
> >   * Introduced NL80211_EXT_FEATURE_BTCOEX_PRIORITY to expose
> >     btcoex priority support and removed bool variable.
> >
> > v2 :
> >   * Introduced NL80211_CMD_SET_BTCOEX to enable/disable btcoex and
> >     to set/modify btcoex_priority.
> >   * Added bool variable in wiphy structure to advertise btcoex_priority
> >     feature and removed BITMAP calculation for btcoex_priority value.
> >
> >  include/net/cfg80211.h       |    6 +++++
> >  include/net/mac80211.h       |    5 +++++
> >  include/uapi/linux/nl80211.h |   50
> ++++++++++++++++++++++++++++++++++++++++++
> >  net/mac80211/cfg.c           |    9 ++++++++
> >  net/mac80211/driver-ops.h    |   15 +++++++++++++
> >  net/mac80211/trace.h         |   20 +++++++++++++++++
> >  net/wireless/nl80211.c       |   45
> +++++++++++++++++++++++++++++++++++++
> >  net/wireless/rdev-ops.h      |   13 +++++++++++
> >  net/wireless/trace.h         |   17 ++++++++++++++
> >  9 files changed, 180 insertions(+)
> >
