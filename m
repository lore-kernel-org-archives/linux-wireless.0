Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:37544 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751580Ab3LAR5Y (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Dec 2013 12:57:24 -0500
Received: by mail-bk0-f52.google.com with SMTP id u14so5037418bkz.11
        for <linux-wireless@vger.kernel.org>; Sun, 01 Dec 2013 09:57:22 -0800 (PST)
Message-ID: <529B7880.2090909@gmail.com> (sfid-20131201_185740_991686_1D39C47C)
Date: Sun, 01 Dec 2013 19:57:20 +0200
From: Emmanuel Grumbach <egrumbach@gmail.com>
MIME-Version: 1.0
To: Antonio Quartulli <antonio@open-mesh.com>,
	Antonio Quartulli <antonio@meshcoding.com>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH mac80211] iwlwifi: don't install GTKs for IBSS vifs on
 resume
References: <1385846658-2294-1-git-send-email-antonio@meshcoding.com> <CANUX_P3tm+Q4R6NNLchtCZCYGxrs-Z8hahp1YrvF_fCbCFavig@mail.gmail.com> <529B03D9.5050402@open-mesh.com>
In-Reply-To: <529B03D9.5050402@open-mesh.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/01/2013 11:39 AM, Antonio Quartulli wrote:
> On 01/12/13 09:39, Emmanuel Grumbach wrote:
>>> +       /* Group keys for IBSS interfaces are not stored in HW
>>> */ +       if (vif->type == NL80211_IFTYPE_ADHOC && +
>>> !(key->flags & IEEE80211_KEY_FLAG_PAIRWISE)) +
>>> return; +
> 
> Well, my knowledge about WoWLAN is really poor (in particular for what
> concern IWLWIFI). I think I should have sent this as RFC first.
> 
> So isn't it possible to reach this point with a key that satisfies
> that condition? If so, we are fine :)
> 

No - because in WoWLAN we will never have IBSS configured.
WoWLAN supports (currently) BSS only - I am not even sure we want to
have P2P Client there.
