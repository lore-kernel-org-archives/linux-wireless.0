Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.238]:5800 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754800AbYFYFnk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2008 01:43:40 -0400
Received: by rv-out-0506.google.com with SMTP id k40so8022287rvb.1
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2008 22:43:39 -0700 (PDT)
Message-ID: <1ba2fa240806242243n635ef4deuc061f3e46e37a274@mail.gmail.com> (sfid-20080625_074344_028324_03E5513E)
Date: Wed, 25 Jun 2008 08:43:39 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ipw3945-devel] [BUG] iwlwifi 3945 works only with disable_hw_scan=1
Cc: drago01 <drago01@gmail.com>, "Zhu Yi" <yi.zhu@intel.com>,
	linux-wireless@vger.kernel.org, ipw3945-devel@lists.sourceforge.net
In-Reply-To: <20080624194714.GA11664@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <48528CF0.8050204@gmail.com> <48551C62.80904@gmail.com>
	 <1ba2fa240806150647mdc97d98oad0b1b02de1fcf87@mail.gmail.com>
	 <48552344.5090801@gmail.com>
	 <1ba2fa240806150809h13c28937nd064230baca8a15d@mail.gmail.com>
	 <1ba2fa240806150947s1ed9391ao4b1d1a91c871ef8f@mail.gmail.com>
	 <4855FF14.9080506@gmail.com>
	 <1ba2fa240806152252v5fdb4f7dn1028a2a02e8d9cd1@mail.gmail.com>
	 <f6ca9fed0806180128q739a9e3k68708b908e630324@mail.gmail.com>
	 <20080624194714.GA11664@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 24, 2008 at 10:47 PM, John W. Linville
<linville@tuxdriver.com> wrote:
> On Wed, Jun 18, 2008 at 10:28:04AM +0200, drago01 wrote:
>> >>> Please try this one
>> >>>
>> >>> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
>> >>> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
>> >>> @@ -3348,7 +3348,10 @@ static void
>> >>> iwl3945_rx_scan_complete_notif(struct iwl3945_priv *priv,
>> >>>
>> >>>        /* Remove this scanned band from the list
>> >>>         * of pending bands to scan */
>> >>> -       priv->scan_bands--;
>> >>> +       if (priv->cfg->sku & IWL_SKU_A)
>> >>> +               priv->scan_bands--;
>> >>> +       else
>> >>> +               priv->scan_bands = 0;
>> >>>
>> >>>
>> >>
>> >>
>> >> I tested this patch, and it fixes this issue, Thanks a lot.
>> >>
>> > Thanks a lot for helping resolve this. I will post an official patch.
>>
>> seems like a fix thats worth having in .26
>
> Did I miss the official post of this patch?
>
> John

It's queued in Yi's tree.
Tomas.
