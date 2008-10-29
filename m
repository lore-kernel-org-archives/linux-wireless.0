Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.172]:52707 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753037AbYJ2J05 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 05:26:57 -0400
Received: by wf-out-1314.google.com with SMTP id 27so3109864wfd.4
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2008 02:26:56 -0700 (PDT)
Message-ID: <1ba2fa240810290226t23bdda5cjf2c4a2716cffa5bb@mail.gmail.com> (sfid-20081029_102659_844182_CCCB54F2)
Date: Wed, 29 Oct 2008 11:26:56 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: Sujith <Sujith.Manoharan@atheros.com>
Subject: Re: [PATCH 16/16] mac80211: Add a new event in ieee80211_ampdu_mlme_action
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Jouni Malinen" <Jouni.Malinen@atheros.com>,
	"Luis Rodriguez" <Luis.Rodriguez@atheros.com>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
In-Reply-To: <18696.10706.405455.724835@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <18695.60248.383916.563413@gargle.gargle.HOWL>
	 <1ba2fa240810290211s16f5506cgf7c828b5c3d8aea9@mail.gmail.com>
	 <18696.10706.405455.724835@gargle.gargle.HOWL>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 29, 2008 at 11:16 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:
> Tomas Winkler wrote:
>> On Wed, Oct 29, 2008 at 6:49 AM, Sujith <Sujith.Manoharan@atheros.com> wrote:
>> > Send a notification to the driver on succesful
>> > reception of an ADDBA response, add IEEE80211_AMPDU_TX_RESUME
>> > for this purpose.
>>
>> What what is wrong with IEEE80211_AMPDU_TX_START ? I don' t understand
>> why this is needed?
>
> On receiving an IEEE80211_AMPDU_TX_START notification, packets destined to
> that TID are stored in a buffer, and to send them out as aggregates, ath9k
> needs to know whether the ADDBA exchange has completed or not.
>
> If the ADDBA request has been declined, IEEE80211_AMPDU_TX_STOP is sent to
> the driver, but no notification is sent if the ADDBA request has been accepted.

Okay this means that we pushing this buffering to driver after all.
Otherwise mac80211 would just trigger the TX on successful ADDBA
Tomas
