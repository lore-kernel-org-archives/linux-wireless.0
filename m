Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:55614 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752629AbdLKN7M (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Dec 2017 08:59:12 -0500
Message-ID: <1513000750.26976.79.camel@sipsolutions.net> (sfid-20171211_145916_749100_94E7B955)
Subject: Re: [PATCH v2 3/5] mac80211_hwsim: add generation count for netlink
 dump operation
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 11 Dec 2017 14:59:10 +0100
In-Reply-To: <8a26e55c-83ce-1395-ff9d-723e5b9fc82b@uni-rostock.de>
References: <20171121121744.23422-1-benjamin.beichler@uni-rostock.de>
         <7ee141a4-8983-4da6-9c0f-f070fa6e5611@MAIL2.uni-rostock.de>
         <1512994493.26976.74.camel@sipsolutions.net>
         <8264ae6e-7db6-53b0-88c0-4ac4e51d0ba3@uni-rostock.de>
         <1512996543.26976.76.camel@sipsolutions.net>
         <5afe6ce9-5d7a-2b8e-f2bc-32088aacb9fe@uni-rostock.de>
         <1512997665.26976.78.camel@sipsolutions.net>
         <8a26e55c-83ce-1395-ff9d-723e5b9fc82b@uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-12-11 at 14:29 +0100, Benjamin Beichler wrote:

> I think we need to send something like an empty message, containing the
> flag. Because there exist the corner case, that while a dump is
> interrupted the complete list is deleted. Currently this could not
> happen because of non-parallel netlink callbacks, but maybe in the
> future parallel callbacks are enabled.

I don't know if we really want parallel, but I guess it's possible
eventually.

> Would it break things, if I simply create an header with
> HWSIM_CMD_GET_RADIO, but put no other information in it? Or how could it
> be done correctly?

I think that's probably OK.

johannes
