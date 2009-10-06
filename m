Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:50817 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932626AbZJFP72 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2009 11:59:28 -0400
Received: by iwn8 with SMTP id 8so2316416iwn.33
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2009 08:58:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20091006055222.GA26591@vasanth-laptop>
References: <1254801201-15893-1-git-send-email-lrodriguez@atheros.com>
	<20091006055222.GA26591@vasanth-laptop>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Tue, 6 Oct 2009 11:58:30 -0400
Message-ID: <43e72e890910060858l13c235bau802c89098ce0bade@mail.gmail.com>
Subject: Re: [ath9k-devel] [RFT 0/4] ath9k: fix oops during driver unload
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
Cc: Vasanth Thiagarajan <Vasanth.Thiagarajan@atheros.com>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 6, 2009 at 1:52 AM, Vasanthakumar Thiagarajan
<vasanth@atheros.com> wrote:
> On Tue, Oct 06, 2009 at 09:23:17AM +0530, Luis Rodriguez wrote:
>> This should fix an oops reported by Vasanth.
>> Vasanth my rc3 poos out, can you let me know if this
>> fixes the issue you saw?
>>
>> Luis R. Rodriguez (4):
>>   ath9k: move common->debug_mask setting to ath_init_softc()
>>   ath9k: fix oops during unload -- initialize hw prior to debugfs
>>   ath9k: add helper to un-init the hw properly
>>   ath9k: rename ath_beaconq_setup() to ath9k_hw_beaconq_setup()
>>
>>  drivers/net/wireless/ath/ath.h          |    6 ++++
>>  drivers/net/wireless/ath/ath9k/ath9k.h  |    1 -
>>  drivers/net/wireless/ath/ath9k/beacon.c |   12 -------
>>  drivers/net/wireless/ath/ath9k/debug.c  |    5 ---
>>  drivers/net/wireless/ath/ath9k/hw.c     |   11 ++++++-
>>  drivers/net/wireless/ath/ath9k/mac.c    |   13 ++++++++
>>  drivers/net/wireless/ath/ath9k/mac.h    |    1 +
>>  drivers/net/wireless/ath/ath9k/main.c   |   50 ++++++++++++++++++------------
>>  8 files changed, 60 insertions(+), 39 deletions(-)
>>
>
> The issue is not fixed completely, ah->common is used after ah is
> freed in ath_cleanup() which makes rmmod ath9k stuck in the middle.

Thanks I'll fix that as well.

  Luis
