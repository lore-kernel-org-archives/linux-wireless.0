Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:22671 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735AbYJTFTU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 01:19:20 -0400
Subject: Re: New Regulatory Domain Api.
From: Zhu Yi <yi.zhu@intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Tomas Winkler <tomasw@gmail.com>,
	Marcel Holtmann <holtmann@linux.intel.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890810192040w567fa4f6j1bf40e80084a857e@mail.gmail.com>
References: <20081015112517.GF6509@tesla>
	 <1ba2fa240810151631t37edc367hfe59c76926c7b82e@mail.gmail.com>
	 <20081015170830.GA15902@tesla>
	 <1ba2fa240810151735t100ceda5s7fe7b495f735c507@mail.gmail.com>
	 <20081015174447.GF15902@tesla>
	 <1ba2fa240810151757r11060dfble6b58c76a7d0d8d1@mail.gmail.com>
	 <20081015185636.GH15902@tesla>
	 <1224126030.24677.78.camel@debian.sh.intel.com>
	 <20081016113848.GB5899@tesla>
	 <1224471102.24677.124.camel@debian.sh.intel.com>
	 <43e72e890810192040w567fa4f6j1bf40e80084a857e@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 13:18:53 +0800
Message-Id: <1224479933.24677.148.camel@debian.sh.intel.com> (sfid-20081020_071925_054364_8AE216EF)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2008-10-19 at 20:40 -0700, Luis R. Rodriguez wrote:
> On Sun, Oct 19, 2008 at 7:51 PM, Zhu Yi <yi.zhu@intel.com> wrote:
> > On Thu, 2008-10-16 at 04:38 -0700, Luis R. Rodriguez wrote:
> >> So.. you didn't look at the code to check where it may have failed...
> >
> > IIRC, below patch changes the previously allowing none 5GHz channels to
> > allowing all 5GHZ channels. It does resolve our problem. But is it the
> > correct behaviour? Or did I miss anything?
> 
> Well if you are using regulatory_hint() and only have rules defined in
> the 2 GHz band then yes it won't ever touch 5 GHz channels... I don't
> like this at all but its what I thought you were asking for.

No, with this patch the 5GHz reg_rules on the second card are bypassed
by regdomain. This is not correct. I do like to see the new regdomain
handles all valid usage models correctly. But I fail to see how it can
be with the current design (the first one wins, or do intersection). We
should do intersection within each band, but do union between bands. 

Thanks,
-yi

