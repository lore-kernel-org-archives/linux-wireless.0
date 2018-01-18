Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:51608 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754098AbeARGrj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 18 Jan 2018 01:47:39 -0500
Message-ID: <1516258057.410.55.camel@sipsolutions.net> (sfid-20180118_074851_777338_54C8F021)
Subject: Re: [PATCH] cfg80211: stop demanding lots of new stuff
From: Johannes Berg <johannes@sipsolutions.net>
To: Hugh Dickins <hughd@google.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 18 Jan 2018 07:47:37 +0100
In-Reply-To: <alpine.LSU.2.11.1801171448510.5433@eggly.anvils> (sfid-20180117_235601_216213_A3BA62CE)
References: <alpine.LSU.2.11.1801171448510.5433@eggly.anvils>
         (sfid-20180117_235601_216213_A3BA62CE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-17 at 14:55 -0800, Hugh Dickins wrote:
> "make oldconfig" from 4.14 (when CONFIG_CFG80211_CERTIFICATION_ONUS
> is not set) to 4.15-rc, gets into asking lots of new questions, and
> configuring in unwanted stuff: I'm unsure of my Kconfig skills, but
> it looks like CFG80211_REQUIRE_SIGNED_REGDB's "default y" needs to
> be toned down when we don't even have CFG80211_CERTIFICATION_ONUS.

No, this is wrong - we want default configurations to be able to load a
signed regulatory database and validate the signature.

johannes
