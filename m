Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.180]:44054 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750727AbYB0DXH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Feb 2008 22:23:07 -0500
Received: by py-out-1112.google.com with SMTP id u52so3892980pyb.10
        for <linux-wireless@vger.kernel.org>; Tue, 26 Feb 2008 19:23:07 -0800 (PST)
Message-ID: <43e72e890802261923g528f4006ofd665edbba335d99@mail.gmail.com> (sfid-20080227_032314_972759_347BBD80)
Date: Tue, 26 Feb 2008 22:23:06 -0500
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
To: "Nick Kossifidis" <mickflemm@gmail.com>
Subject: Re: [ath5k-devel] [PATCH 6/8] ath5k: Fixes for PCI-E cards
Cc: "Bob Copeland" <me@bobcopeland.com>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	bruno@thinktube.com, jirislaby@gmail.com
In-Reply-To: <40f31dec0802241058h5b37a471s5092dd370a4f2a48@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20080224042851.GE4426@makis.domain.invalid>
	 <40f31dec0802232045v2902d76dg8ee1c4a4685862fe@mail.gmail.com>
	 <20080224175933.GA4360@hash.localnet>
	 <40f31dec0802241058h5b37a471s5092dd370a4f2a48@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Feb 24, 2008 at 1:58 PM, Nick Kossifidis <mickflemm@gmail.com> wrote:
> 2008/2/24, Bob Copeland <me@bobcopeland.com>:
>
>
> > On Sun, Feb 24, 2008 at 06:45:33AM +0200, Nick Kossifidis wrote:
>  >  > >  +       /* Identify PCI-E cards */
>  >  > >  +       if((srev >= AR5K_SREV_VER_AR2424 && srev <= AR5K_SREV_VER_AR5424) ||
>  >  > >  +       srev >= AR5K_SREV_VER_AR5416) {
>  >  > >  +               ah->ah_pcie = true;

struct pci_dev now has member,  "is_pcie" which could be used here I
think instead. No need to add to ath5k_hw the ah_pcie then.

  Luis
