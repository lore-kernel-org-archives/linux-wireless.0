Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:36136 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753488AbeAOLqH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 06:46:07 -0500
Message-ID: <1516016765.410.9.camel@sipsolutions.net> (sfid-20180115_124610_816662_9AF446CB)
Subject: Re: [PATCH v3 1/5] mac80211_hwsim: add workqueue to wait for
 deferred radio deletion on mod unload
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <benjamin.beichler@uni-rostock.de>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 15 Jan 2018 12:46:05 +0100
In-Reply-To: <2a021406-db0b-42e9-be2b-7185814139af@MAIL2.uni-rostock.de>
References: <20180110164255.2763-1-benjamin.beichler@uni-rostock.de>
         <2a021406-db0b-42e9-be2b-7185814139af@MAIL2.uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-01-10 at 17:42 +0100, Benjamin Beichler wrote:
> When closing multiple wmediumd instances with many radios and try to
> unload the  mac80211_hwsim module, it may happen that the work items live
> longer than the module. To wait especially for this deletion work items,
> add a work queue, otherwise flush_scheduled_work would be necessary.
> 
Applied this to mac80211, thanks.

johannes
