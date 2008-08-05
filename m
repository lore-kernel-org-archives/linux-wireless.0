Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:22752 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761270AbYHESMo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 14:12:44 -0400
Received: by nf-out-0910.google.com with SMTP id d3so971791nfc.21
        for <linux-wireless@vger.kernel.org>; Tue, 05 Aug 2008 11:12:42 -0700 (PDT)
To: "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 8/8] rfkill: add support for wake-on-wireless-packet
Date: Tue, 5 Aug 2008 20:37:20 +0200
Cc: Dan Williams <dcbw@redhat.com>,
	Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
	Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
References: <1217700664-20792-1-git-send-email-hmh@hmh.eng.br> <1217941409.26251.3.camel@localhost.localdomain> <20080805140005.GA5925@tuxdriver.com>
In-Reply-To: <20080805140005.GA5925@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200808052037.20508.IvDoorn@gmail.com> (sfid-20080805_201247_657757_4B23985B)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 05 August 2008, John W. Linville wrote:
> On Tue, Aug 05, 2008 at 09:03:29AM -0400, Dan Williams wrote:
> > On Mon, 2008-08-04 at 20:35 -0300, Henrique de Moraes Holschuh wrote:
> 
> > > And it is already damn clear that what we currently have (rfkill always
> > > blocks on suspend) is not the correct way to go about it.  WHAT I want to
> > > know now is whether there are any drivers out there which need the current
> > > behaviour.
> > 
> > Ah!  I seem to have misunderstood you.  If some drivers _do_ need the
> > current block-on-suspend behavior, I feel like that should be an
> > internal driver decision that rfkill shouldn't need to be aware of.
> > Drivers know how to suspend themselves; we shouldn't expect rfkill to
> > know how certain hardware needs to suspend.
> 
> I agree with Dan.  Blocking and suspending should be separate operations.

Like I said earlier, the main thing rfkill should do is to prevent the callback
function being used while the device is suspended. And I definately agree
on the statement that drivers are in charge to do what should be done for
suspend.

Ivo
