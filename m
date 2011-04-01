Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:53483 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755116Ab1DAUKv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 1 Apr 2011 16:10:51 -0400
Received: by iwn34 with SMTP id 34so3858996iwn.19
        for <linux-wireless@vger.kernel.org>; Fri, 01 Apr 2011 13:10:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1301687948.3842.0.camel@jlt3.sipsolutions.net>
References: <1301686955-9402-1-git-send-email-lrodriguez@atheros.com> <1301687948.3842.0.camel@jlt3.sipsolutions.net>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Fri, 1 Apr 2011 13:10:30 -0700
Message-ID: <AANLkTimJ8F-MFcK6raqcSFMsieGCx_gK_Ud1AF7BNPR2@mail.gmail.com>
Subject: Re: [PATCH v3 1/2] cfg80211: fix regulatory restore upon user hints
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linville@tuxdriver.com, gregoryx.alagnou@intel.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 1, 2011 at 12:59 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2011-04-01 at 12:42 -0700, Luis R. Rodriguez wrote:
>> When we restore regulatory settings its possible CRDA
>> will not reply because of a bogus user entry. In this
>> case the bogus entry will prevent any further processing
>> on cfg80211 for regulatory domains even if we restore
>> regulatory settings.
>>
>> To prevent this we suck out all pending requests when
>> restoring regulatory settings and add them back into the
>> queue after we have queued up the reset work.
>
> What if CRDA replies in order, i.e. replies to the user requested one
> first instead of the disassoc requested one?

Are you questioning the order of udev events and how CRDA processes them?

If CRDA is present it should get the udev event for any valid request
and process it accordingly. If the request is bogus it'll prevent any
further processing on cfg80211 given that we simply bail out of
processing requests until last_request->processed is true. The fix for
that lies in the timeout on patch 2. This patch just ensures that we
make sure to clear out any pending requests prior to doing a restore
of regulatory settings.

> Why do we even require crda to reply to the first in list, rather than
> any one?

The order should not matter except that we want the queue to be
cleared before processing core hints when doing restoration, otherwise
the next user hint in the queue can be bogus and it will prevent a
restore.

  Luis
