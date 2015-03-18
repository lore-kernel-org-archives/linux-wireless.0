Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:33511 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751074AbbCRJgy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 05:36:54 -0400
Received: by ignm3 with SMTP id m3so69768574ign.0
        for <linux-wireless@vger.kernel.org>; Wed, 18 Mar 2015 02:36:54 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1426615118-17516-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1426615118-17516-1-git-send-email-emmanuel.grumbach@intel.com>
Date: Wed, 18 Mar 2015 11:36:54 +0200
Message-ID: <CAB3XZEd7cQwKm_yLztzeTB0S_-uEp4FwzDUV1O8cG6mNtkiY_A@mail.gmail.com> (sfid-20150318_103658_074846_8352CF92)
Subject: Re: [PATCH] mac80211: stop scan before connection
From: Eliad Peller <eliad@wizery.com>
To: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	David Spinadel <david.spinadel@intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 17, 2015 at 7:58 PM, Emmanuel Grumbach
<emmanuel.grumbach@intel.com> wrote:
> From: David Spinadel <david.spinadel@intel.com>
>
> Stop scan before authentication or association to make sure
> that nothing interferes with connection flow.
>
this makes sense

> Currently mac80211 defers RX auth and assoc packets (among other ones)
> until after the scan is complete, so auth during scan is likely to fail
> if scan took too much time.
>
but i don't think deferring the frame handling makes sense in case of
hw_scan (there was a similar case with BA request handling).
i should have such (one-liner) patch pending somewhere...

Eliad.
