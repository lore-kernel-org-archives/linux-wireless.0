Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.179]:41740 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288AbXITMzK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Sep 2007 08:55:10 -0400
Received: by py-out-1112.google.com with SMTP id u77so936976pyb
        for <linux-wireless@vger.kernel.org>; Thu, 20 Sep 2007 05:55:09 -0700 (PDT)
Message-ID: <43e72e890709200555r779aaa50i6bb8ab90195686bc@mail.gmail.com>
Date: Thu, 20 Sep 2007 08:55:09 -0400
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: ath5k and network manager
Cc: linux-wireless@vger.kernel.org, "Jiri Slaby" <jirislaby@gmail.com>
In-Reply-To: <20070919214007.1a6a9b4a@freepuppy.rosehill>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20070919214007.1a6a9b4a@freepuppy.rosehill>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9/20/07, Stephen Hemminger <shemminger@linux-foundation.org> wrote:
> Network manager doesn't seem to detect ath5k. Perhaps it is because
> it is name "ath0".  I think device should follow the convention of using
> name "wifi0" rather than BSD convention of putting driver name in device name.

I couldn't agree anymore. But my ath5k kicks out a wlan%d name as with
any other mac80211 driver. Is yours coming out to ath%d ?

ieee80211_register_hw():

        /* add one default STA interface */
        result = ieee80211_if_add(local->mdev, "wlan%d", NULL,
                                  IEEE80211_IF_TYPE_STA);

  Luis
