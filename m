Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:43348 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728356AbeHVPXS (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 22 Aug 2018 11:23:18 -0400
Message-ID: <4d9dfd6108c4bdfab1811ac39d692f8e1272c134.camel@coelho.fi> (sfid-20180822_135843_036264_09ABEA50)
From: Luca Coelho <luca@coelho.fi>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org,
        Mordechay Goodstein <mordechay.goodstein@intel.com>
Date: Wed, 22 Aug 2018 14:58:37 +0300
In-Reply-To: <877ekir5f2.fsf@kamboji.qca.qualcomm.com>
References: <20180821063657.30071-1-luca@coelho.fi>
         <20180821063657.30071-8-luca@coelho.fi>
         <877ekir5f2.fsf@kamboji.qca.qualcomm.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH 07/15] iwlwifi: add 80211 hdr offset to trace data
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2018-08-22 at 14:45 +0300, Kalle Valo wrote:
> Luca Coelho <luca@coelho.fi> writes:
> 
> > From: Mordechay Goodstein <mordechay.goodstein@intel.com>
> > 
> > Every rx mpdu cmd is built from cmd_hdr | 80211_hdr.  The problem
> > is
> > that the size of cmd_hdr changes with API changes and we don't know
> > where the 80211_hdr starts.
> > 
> > By adding the size of cmd_hdr dynamically, we can ensure that we
> > always
> > know how to parse mpdu frames, without dependending on the API
> > changes.
> > 
> > Signed-off-by: Mordechay Goodstein <mordechay.goodstein@intel.com>
> > Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> 
> [...]
> 
> > --- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-data.h
> > +++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace-data.h
> > @@ -2,6 +2,7 @@
> >   *
> >   * Copyright(c) 2009 - 2014 Intel Corporation. All rights
> > reserved.
> >   * Copyright(c) 2015        Intel Deutschland GmbH
> > + * Copyright(c) 2018        Intel Corporation
> >   *
> >   * This program is free software; you can redistribute it and/or
> > modify it
> >   * under the terms of version 2 of the GNU General Public License
> > as
> > @@ -12,10 +13,6 @@
> >   * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public
> > License for
> >   * more details.
> >   *
> > - * You should have received a copy of the GNU General Public
> > License along with
> > - * this program; if not, write to the Free Software Foundation,
> > Inc.,
> > - * 51 Franklin Street, Fifth Floor, Boston, MA 02110, USA
> > - *
> >   * The full GNU General Public License is included in this
> > distribution in the
> >   * file called LICENSE.
> >   *
> 
> Ok, you have more of these removals in this patch so I guess it's
> intentional. But IMHO it would be nicer to remove these all in one go
> instead of sprinkle around in different patches.

IMHO it's too much fuzz for mostly useless warning removal... We need
to update the copyright when this hits, so we just do it at the same
time.

But you're the boss, I can submit a patch to remove just that, all at
once.

--
Luca.
