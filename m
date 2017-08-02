Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:41686 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751154AbdHBEqz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 2 Aug 2017 00:46:55 -0400
Message-ID: <1501649208.2588.55.camel@coelho.fi> (sfid-20170802_064713_247097_20182099)
From: Luca Coelho <luca@coelho.fi>
To: =?ISO-8859-1?Q?Jo=E3o?= Paulo Rechi Vita <jprvita@endlessm.com>
Cc: linuxwifi <linuxwifi@intel.com>,
        "kvalo@codeaurora.org" <kvalo@codeaurora.org>,
        "jprvita@gmail.com" <jprvita@gmail.com>,
        "Berg, Johannes" <johannes.berg@intel.com>,
        "Grumbach, Emmanuel" <emmanuel.grumbach@intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux@endlessm.com" <linux@endlessm.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 02 Aug 2017 07:46:48 +0300
In-Reply-To: <CAOcMMifW4mVPj1TVkzQPdvT0YO6p1DUObNinzWv2_ZtCbfk9Mg@mail.gmail.com>
References: <20170721145147.7572-1-jprvita@endlessm.com>
         <1500894086.20057.12.camel@intel.com>
         <CAOcMMifW4mVPj1TVkzQPdvT0YO6p1DUObNinzWv2_ZtCbfk9Mg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] iwlwifi: Demote messages about fw flags size to info
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi João Paulo,


On Tue, 2017-08-01 at 15:58 -0700, João Paulo Rechi Vita wrote:
> Hello Luca,
> 
> On Mon, Jul 24, 2017 at 4:01 AM, Coelho, Luciano
> <luciano.coelho@intel.com> wrote:
> > On Fri, 2017-07-21 at 07:51 -0700, João Paulo Rechi Vita wrote:
> 
> (...)
> 
> > > Currently these messages are presented to the user during boot if there
> > > is no bootsplash covering the console, sometimes even if the boot splash
> > > is enabled but has not started yet by the time this message is shown.
> > > 
> 
> I should have provided another piece of information here: all of this
> happens even when booting with the 'quiet' kernel parameter.

Oh, okay, that's annoying.


> > This specific case is harmless, but I'd rather keep this message as an
> > error, because in other situations it could lead to unexpected
> > behavioir, so I prefer to keep it very visible.
> > 
> > 
> 
> I see your point, and I understand the purpose of these messages. I'm
> wondering if perhaps having them at the warning level would give them
> enough visibility, while still keeping a clean boot process to the end
> user. If so, I can send an updated patch.
> 
> Thanks for your reply and for pointing to the fix for the root cause
> of that message.

Sure, I agree it's better to make it use IWL_WARN(), which will generate
a dev_warn() instead of a dev_err().


--
Cheers,
Luca.
