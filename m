Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.229]:7696 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349AbYE2HFD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 29 May 2008 03:05:03 -0400
Received: by rv-out-0506.google.com with SMTP id l9so3952670rvb.1
        for <linux-wireless@vger.kernel.org>; Thu, 29 May 2008 00:05:01 -0700 (PDT)
Message-ID: <1ba2fa240805290005m171d8957kaedbbb42a7feb2de@mail.gmail.com> (sfid-20080529_090511_316506_6C03F322)
Date: Thu, 29 May 2008 10:05:01 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	"Zhu Yi" <yi.zhu@intel.com>
Subject: Re: [PATCH 2.6.26 1/3] iwlwifi: fix in-column rate scaling
Cc: linux-wireless@vger.kernel.org, "Guy Cohen" <guy.cohen@intel.com>
In-Reply-To: <1212026521.7814.276.camel@debian.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <1211858975-21424-1-git-send-email-yi.zhu@intel.com>
	 <20080528202201.GC25770@tuxdriver.com>
	 <1212026521.7814.276.camel@debian.sh.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 29, 2008 at 5:02 AM, Zhu Yi <yi.zhu@intel.com> wrote:
> On Wed, 2008-05-28 at 16:22 -0400, John W. Linville wrote:
>> On Tue, May 27, 2008 at 11:29:33AM +0800, Zhu Yi wrote:
>> > From: Guy Cohen <guy.cohen@intel.com>
>> >
>> > This patch fixes cases that the code raised or didn't decrease
>> > the rate although the success ratio was not good.
>> >
>> > Signed-off-by: Guy Cohen <guy.cohen@intel.com>
>> > Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
>> > ---
>> >  drivers/net/wireless/iwlwifi/iwl-4965-rs.c |   45 ++++++++++++++-------------
>> >  1 files changed, 23 insertions(+), 22 deletions(-)
>> >
>> > diff --git a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
>> > index 2adc228..fa41ed1 100644
>> > --- a/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
>> > +++ b/drivers/net/wireless/iwlwifi/iwl-4965-rs.c
>> > @@ -1339,7 +1339,7 @@ static int rs_move_legacy_other(struct iwl_priv *priv,
>> >                             lq_sta->search_better_tbl = 1;
>> >                             goto out;
>> >                     }
>> > -
>> > +                   break;
>> >             case IWL_LEGACY_SWITCH_SISO:
>> >                     IWL_DEBUG_RATE("LQ: Legacy switch to SISO\n");
>> >
>> > @@ -1425,9 +1425,9 @@ static int rs_move_siso_to_other(struct iwl_priv *priv,
>> >                             lq_sta->search_better_tbl = 1;
>> >                             goto out;
>> >                     }
>> > -
>> > +                   break;
>> >             case IWL_SISO_SWITCH_MIMO2:
>> > -                   IWL_DEBUG_RATE("LQ: SISO switch to MIMO\n");
>> > +                   IWL_DEBUG_RATE("LQ: SISO switch to MIMO2\n");
>> >                     memcpy(search_tbl, tbl, sz);
>> >                     search_tbl->is_SGI = 0;
>> >                     search_tbl->ant_type = ANT_AB; /*FIXME:RS*/
>>
>> These hunks don't apply to wireless-2.6.
>
> Oops, please ignore these hunks.
>

I think you've missed this one 'iwlwifi: don't switch to SGI if not
supported by AP'
This is actually real connectivity bug fix. Without this client will
fail to talk to AP that doesn't support SGI and there are many of
those.

Thanks
Tomas
