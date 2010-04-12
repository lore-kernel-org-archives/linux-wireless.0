Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f204.google.com ([209.85.222.204]:59418 "EHLO
	mail-pz0-f204.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009Ab0DLTon convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 15:44:43 -0400
Received: by pzk42 with SMTP id 42so4127865pzk.4
        for <linux-wireless@vger.kernel.org>; Mon, 12 Apr 2010 12:44:43 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1270847547.23853.56.camel@mj>
References: <1270754858-26266-1-git-send-email-lrodriguez@atheros.com>
	<1270847547.23853.56.camel@mj>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Mon, 12 Apr 2010 12:44:23 -0700
Message-ID: <n2q43e72e891004121244y2067d3aax7d8a7e2f1f80cc98@mail.gmail.com>
Subject: Re: [PATCH 000/102] ath9k: add AR9003 support
To: Pavel Roskin <proski@gnu.org>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Apr 9, 2010 at 5:12 PM, Pavel Roskin <proski@gnu.org> wrote:
> On Thu, 2010-04-08 at 15:25 -0400, Luis R. Rodriguez wrote:
>> This series adds support for a new chipset family for the ath9k driver,
>> the AR9003 harware family. This family of chipsets will includes 2-stream
>> and 3-stream devices. We start off by supporting only 2-streams on both
>> devices. Both the 2-stream and 3-stream devices are fully functional at
>> this point. We have a few more items which we will iron out as part
>> of future patches but we're sending this out so that we don't stall
>> development on more cleanups/etc. Our delta is already quite large.
>
> I hope everything went through checkpatch.pl and the result was checked
> by sparse.  I tried to do it myself, but some patches need to be
> updated.

Every single patch was tested with sparse v0.4.2, but not checkpatch.
We'll double check that.

> Considering the huge amount of changes, maybe it would be better to send
> the preparatory changes first, which don't refer to AR9003 in any way?
> Those could be tested first.  Then the rest could be posted.

That is what we did, actually. The initial work was a base for
abstraction or different families and only after do we start adding
AR9003 support.

> I like the idea of synchronization with the private HAL, as it means
> that more eyeballs will be looking at the same code.  But I don't think
> we should relax quality requirements.  If the private HAL is worse in
> any aspect, even in a comment wording, the fix should go to the private
> HAL, not to ath9k.

Indeed, the AR9003 code should hopefully the last bit of code out of
synch. The code quality requirements that we have on Linux *will* be
embraced by the private HAL :)

Addressing unification between the private Atheros HAL and ath9k is a
large undertaking and we do expect to work closely with the community
on it. Addressing the unification was just not something we could fit
into our tight schedule for integration with ath9k, so it will be done
later.

  Luis
