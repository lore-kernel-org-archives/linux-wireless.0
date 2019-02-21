Return-Path: <SRS0=z+ld=Q4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E1D2C4360F
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 07:33:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EBB0A2147A
	for <linux-wireless@archiver.kernel.org>; Thu, 21 Feb 2019 07:33:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbfBUHdh (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 21 Feb 2019 02:33:37 -0500
Received: from mga03.intel.com ([134.134.136.65]:48171 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725648AbfBUHdh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 21 Feb 2019 02:33:37 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Feb 2019 23:33:36 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.58,394,1544515200"; 
   d="scan'208";a="145292413"
Received: from njmartin-mobl2.ger.corp.intel.com ([10.252.28.185])
  by fmsmga002.fm.intel.com with ESMTP; 20 Feb 2019 23:33:33 -0800
Message-ID: <c1a9091503d780a0405b530d06fd941930b0db4e.camel@intel.com>
Subject: Re: [PATCH] iwlwifi: mvm: Use div64_s64 instead of do_div in
 iwl_mvm_debug_range_resp
From:   Luciano Coelho <luciano.coelho@intel.com>
To:     Nathan Chancellor <natechancellor@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 21 Feb 2019 09:33:32 +0200
In-Reply-To: <20190220175615.GA1312@archlinux-ryzen>
References: <20190219182105.19933-1-natechancellor@gmail.com>
         <CAK8P3a1d6Zksdv-Or+paawyn4N0u4EpVw9QgyDGHYvX_1s3JrQ@mail.gmail.com>
         <20190220175615.GA1312@archlinux-ryzen>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 2019-02-20 at 10:56 -0700, Nathan Chancellor wrote:
> On Wed, Feb 20, 2019 at 11:51:34AM +0100, Arnd Bergmann wrote:
> > On Tue, Feb 19, 2019 at 7:22 PM Nathan Chancellor
> > <natechancellor@gmail.com> wrote:
> > > diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-
> > > initiator.c b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-
> > > initiator.c
> > > index e9822a3ec373..92b22250eb7d 100644
> > > --- a/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
> > > +++ b/drivers/net/wireless/intel/iwlwifi/mvm/ftm-initiator.c
> > > @@ -462,7 +462,7 @@ static void iwl_mvm_debug_range_resp(struct
> > > iwl_mvm *mvm, u8 index,
> > >  {
> > >         s64 rtt_avg = res->ftm.rtt_avg * 100;
> > > 
> > > -       do_div(rtt_avg, 6666);
> > > +       div64_s64(rtt_avg, 6666);
> > 
> > This is wrong: div64_s64 does not modify its argument like
> > do_div(), but
> > it returns the result instead. You also don't want to divide by a
> > 64-bit
> > value when the second argument is a small constant.
> > 
> > I think the correct way should be
> > 
> >        s64 rtt_avg = div_s64(res->ftm.rtt_avg * 100, 6666);
> > 
> > If you know that the value is positive, using unsigned types
> > and div_u64() would be slightly faster.
> > 
> >       Arnd
> 
> Thanks for the review and explanation, Arnd.
> 
> Luca, could you drop this version so I can resend it?

Sure, please do! I already applied this internally, but I can just fix
it with your new patch and that will be squashed before being sent
upstream, so it will look like your second patch.

--
Cheers,
Luca.

