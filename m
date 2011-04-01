Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51744 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab1DAVrm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 17:47:42 -0400
Received: by iwn34 with SMTP id 34so3933829iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 14:47:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1301689736.3842.4.camel@jlt3.sipsolutions.net>
References: <1301686955-9402-1-git-send-email-lrodriguez@atheros.com>
 <1301687948.3842.0.camel@jlt3.sipsolutions.net> <AANLkTimJ8F-MFcK6raqcSFMsieGCx_gK_Ud1AF7BNPR2@mail.gmail.com>
 <1301689736.3842.4.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 1 Apr 2011 14:47:21 -0700
Message-ID: <AANLkTimHCgmoWvC_Ou7BsiDjwxF=YB0h4-g=_afYxsQF@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] cfg80211: fix regulatory restore upon user hints
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, gregoryx.alagnou@intel.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 1, 2011 at 1:28 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Fri, 2011-04-01 at 13:10 -0700, Luis R. Rodriguez wrote:
>>
>> The order should not matter except that we want the queue to be
>> cleared before processing core hints when doing restoration, otherwise
>> the next user hint in the queue can be bogus and it will prevent a
>> restore.
>
> I'm just thinking this temporary clearing could cause us to reject a
> reply from CRDA that's coming in at the same time that is due to a user
> request.

Ah, I see, hmm well I tested this with:

iw reg set US; iw reg set XA; iw reg set XB; iw reg set CR; iw dev
wlan0 disconnect; iw reg set FR;

and things were still being processed in the order sent. There is a
small race between the unlock of the reg_mutex on
restore_regulatory_settings() down until where we lock the
regulatory_hint_core() and regulatory_hint_user(). The chances of a
user regulatory hint coming in between is very low, I could not do it.
Then there is also a small race of getting a user reg hint on
restore_regulatory_settings() in between the regulatory_hint_user()
and the lock of the reg_mutex again for processing old regulatory
hints, but the worst that can happen in that case is we squeeze in a
user regulatory hint in before the other older regulatory hints, and
this is fine.

I cannot see any other cases here where we'd block a request from userspace.

  Luis
