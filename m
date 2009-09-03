Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f175.google.com ([209.85.223.175]:42423 "EHLO
	mail-iw0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756098AbZICS2e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Sep 2009 14:28:34 -0400
Received: by iwn5 with SMTP id 5so90512iwn.4
        for <linux-wireless@vger.kernel.org>; Thu, 03 Sep 2009 11:28:37 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1251991187.6521.22.camel@mj>
References: <19103.25725.707217.596352@gargle.gargle.HOWL>
	<1251991187.6521.22.camel@mj>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Thu, 3 Sep 2009 11:28:17 -0700
Message-ID: <43e72e890909031128k4ce1f7b5i5c42ebaa73498c70@mail.gmail.com>
Subject: Re: [PATCH 2/2] ath9k: Fix channelFlags for 2GHZ
To: Pavel Roskin <proski@gnu.org>
Cc: Sujith <Sujith.Manoharan@atheros.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Sep 3, 2009 at 8:19 AM, Pavel Roskin<proski@gnu.org> wrote:
> On Thu, 2009-09-03 at 12:08 +0530, Sujith wrote:
>> CHANNEL_G has to be set for 2GHZ channels since
>> IS_CHAN_G() checks for this in channelFlags and not in
>> chanmode. To make things messier, ath9k_hw_process_ini()
>> checks for CHANNEL_G in chanmode and not in channelFlags.
>> The supreme, brain-searing fix is to set the
>> flag in both cases.
>
> My impression is that's a workaround for a bug that lies elsewhere.  I
> don't think we should apply such patches.
>
> chanmode and channelFlags seem to duplicate each other.  I would use an
> enum for distinctive allowed modes and macros to query if the particular
> mode has a specific feature (band, modulation, bandwidth etc).
>
> The enum could use ORed constants for optimization, but such constants
> should be used only through the macros.

I should mention ath9k_update_ichannel() was the last thing I intended
on porting for the new regulatory changes we did on ath9k, when we
ditched the old regulatory code, but I left it as it did involve quite
a lot more changes in the code. When I reviewed this it seemed we
could just rely on the hw->conf.channel->band for many things but in
some cases we needed some defines for hw.

So -- I'd personally welcome this change as a better alternative needs
better planning, and more testing.

  Luis
